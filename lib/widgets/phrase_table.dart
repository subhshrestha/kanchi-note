import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../providers/phrase_provider.dart';
import '../providers/tts_provider.dart';
import '../providers/translation_provider.dart';
import '../services/tts_service.dart';
import 'delete_confirm_dialog.dart';
import 'duplicate_warning_dialog.dart';

class PhraseTable extends ConsumerStatefulWidget {
  final List<Phrase> phrases;

  const PhraseTable({super.key, required this.phrases});

  @override
  ConsumerState<PhraseTable> createState() => _PhraseTableState();
}

class _PhraseTableState extends ConsumerState<PhraseTable> {
  int? _editingId;
  String? _editingField; // 'phrase', 'meaning', 'myNote'
  final _editController = TextEditingController();
  final _editFocusNode = FocusNode();
  final _editKeyFocusNode = FocusNode();
  bool _isTranslating = false;

  @override
  void dispose() {
    _editController.dispose();
    _editFocusNode.dispose();
    _editKeyFocusNode.dispose();
    super.dispose();
  }

  void _startEditing(Phrase phrase, String field) {
    setState(() {
      _editingId = phrase.id;
      _editingField = field;
      switch (field) {
        case 'phrase':
          _editController.text = phrase.phrase;
          break;
        case 'meaning':
          _editController.text = phrase.meaning;
          break;
        case 'myNote':
          _editController.text = phrase.myNote ?? '';
          break;
      }
    });
  }

  Future<void> _saveEdit(Phrase phrase) async {
    if (_editingField == null) return;

    final newValue = _editController.text.trim();
    String newPhrase = phrase.phrase;
    String newMeaning = phrase.meaning;
    String? newNote = phrase.myNote;

    switch (_editingField) {
      case 'phrase':
        if (newValue.isEmpty) {
          _cancelEdit();
          return;
        }
        // Check for duplicate
        final isDuplicate = await ref
            .read(phraseNotifierProvider.notifier)
            .checkDuplicate(newValue, excludeId: phrase.id);
        if (isDuplicate && mounted) {
          await DuplicateWarningDialog.show(context, newValue);
          return;
        }
        newPhrase = newValue;
        // Translate new phrase
        if (newPhrase != phrase.phrase) {
          setState(() => _isTranslating = true);
          final translation = await ref
              .read(translationNotifierProvider.notifier)
              .translateImmediate(newPhrase);
          if (translation != null) {
            newMeaning = translation;
          }
          setState(() => _isTranslating = false);
        }
        break;
      case 'meaning':
        if (newValue.isEmpty) {
          _cancelEdit();
          return;
        }
        newMeaning = newValue;
        break;
      case 'myNote':
        newNote = newValue.isEmpty ? null : newValue;
        break;
    }

    final updatedPhrase = phrase.copyWith(
      phrase: newPhrase,
      meaning: newMeaning,
      myNote: Value(newNote),
    );

    final updated =
        await ref.read(phraseNotifierProvider.notifier).updatePhrase(updatedPhrase);
    if (updated) {
      ref.invalidate(filteredPhrasesProvider);
    }
    _cancelEdit();
  }

  void _cancelEdit() {
    setState(() {
      _editingId = null;
      _editingField = null;
      _editController.clear();
    });
  }

  Future<void> _deletePhrase(Phrase phrase) async {
    final confirmed = await DeleteConfirmDialog.show(context, phrase.phrase);
    if (confirmed == true) {
      final deleted =
          await ref.read(phraseNotifierProvider.notifier).deletePhrase(phrase.id);
      if (deleted) {
        ref.invalidate(filteredPhrasesProvider);
      }
    }
  }

  Widget _buildAudioIcon(Phrase phrase) {
    final audioState = ref.watch(phraseAudioStateProvider(phrase.phrase));
    final ttsNotifier = ref.read(ttsNotifierProvider.notifier);

    IconData icon;
    Color? color;
    String tooltip;

    switch (audioState) {
      case TtsState.idle:
        icon = Icons.volume_up;
        tooltip = 'Play pronunciation';
        break;
      case TtsState.playing:
        icon = Icons.stop;
        color = Theme.of(context).colorScheme.primary;
        tooltip = 'Stop';
        break;
      case TtsState.loading:
        icon = Icons.hourglass_empty;
        tooltip = 'Loading...';
        break;
      case TtsState.error:
        icon = Icons.error_outline;
        color = Theme.of(context).colorScheme.error;
        tooltip = ttsNotifier.errorMessage ?? 'Error';
        break;
    }

    // Show error icon if TTS is not available
    if (!ttsNotifier.isAvailable) {
      icon = Icons.volume_off;
      color = Theme.of(context).colorScheme.outline;
      tooltip = ttsNotifier.errorMessage ?? 'TTS not available';
    }

    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, size: 20),
        color: color,
        onPressed: audioState == TtsState.loading
            ? null
            : () {
                if (!ttsNotifier.isAvailable) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(ttsNotifier.errorMessage ?? 'TTS not available on this platform'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                } else {
                  ttsNotifier.toggleSpeak(phrase.phrase);
                }
              },
      ),
    );
  }

  Widget _buildCell({
    required Phrase phrase,
    required String field,
    required String value,
    bool isEditing = false,
  }) {
    if (isEditing && _editingId == phrase.id && _editingField == field) {
      return Focus(
        focusNode: _editKeyFocusNode,
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            _cancelEdit();
          }
        },
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.escape) {
              _cancelEdit();
              return KeyEventResult.handled;
            }
            if (event.logicalKey == LogicalKeyboardKey.enter &&
                !HardwareKeyboard.instance.isShiftPressed) {
              _saveEdit(phrase);
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: TextField(
          controller: _editController,
          focusNode: _editFocusNode,
          autofocus: true,
          maxLines: field == 'phrase' ? 1 : 3,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            suffixIcon: _isTranslating && field == 'phrase'
                ? const Padding(
                    padding: EdgeInsets.all(8),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
          ),
          onSubmitted: (_) => _saveEdit(phrase),
        ),
      );
    }

    return InkWell(
      onTap: () => _startEditing(phrase, field),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Tooltip(
          message: value,
          waitDuration: const Duration(milliseconds: 500),
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.phrases.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_books_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No phrases yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Click "+ Add" to add your first Danish phrase',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header
        Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Row(
            children: [
              SizedBox(width: 48), // Space for audio icon
              Expanded(
                flex: 25,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'PHRASE',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                flex: 40,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'MEANING',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                flex: 30,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'MY NOTE',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(width: 48), // Space for delete button
            ],
          ),
        ),
        const Divider(height: 1),
        // Table body with infinite scroll
        Expanded(
          child: ListView.separated(
            itemCount: widget.phrases.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final phrase = widget.phrases[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Audio icon
                  SizedBox(
                    width: 48,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: _buildAudioIcon(phrase),
                    ),
                  ),
                  // Phrase column (read-only)
                  Expanded(
                    flex: 25,
                    child: _buildCell(
                      phrase: phrase,
                      field: 'phrase',
                      value: phrase.phrase,
                      isEditing: false,
                    ),
                  ),
                  // Meaning column (read-only)
                  Expanded(
                    flex: 40,
                    child: _buildCell(
                      phrase: phrase,
                      field: 'meaning',
                      value: phrase.meaning,
                      isEditing: false,
                    ),
                  ),
                  // My Note column
                  Expanded(
                    flex: 30,
                    child: _buildCell(
                      phrase: phrase,
                      field: 'myNote',
                      value: phrase.myNote ?? '',
                      isEditing: true,
                    ),
                  ),
                  // Delete button
                  SizedBox(
                    width: 48,
                    child: IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () => _deletePhrase(phrase),
                      tooltip: 'Delete',
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
