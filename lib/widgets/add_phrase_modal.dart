import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/phrase_provider.dart';
import '../providers/translation_provider.dart';
import 'duplicate_warning_dialog.dart';

class AddPhraseModal extends ConsumerStatefulWidget {
  const AddPhraseModal({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => const AddPhraseModal(),
    );
  }

  @override
  ConsumerState<AddPhraseModal> createState() => _AddPhraseModalState();
}

class _AddPhraseModalState extends ConsumerState<AddPhraseModal> {
  final _formKey = GlobalKey<FormState>();
  final _phraseController = TextEditingController();
  final _meaningController = TextEditingController();
  final _noteController = TextEditingController();
  final _phraseFocusNode = FocusNode();
  bool _isSubmitting = false;
  bool _meaningWasAutoFilled = false;
  String? _lastTranslatedPhrase;

  @override
  void initState() {
    super.initState();
    _phraseFocusNode.addListener(_onPhraseFocusChange);
  }

  @override
  void dispose() {
    _phraseFocusNode.removeListener(_onPhraseFocusChange);
    _phraseFocusNode.dispose();
    _phraseController.dispose();
    _meaningController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onPhraseFocusChange() {
    // Translate when phrase field loses focus
    if (!_phraseFocusNode.hasFocus) {
      _translatePhrase();
    }
  }

  void _translatePhrase() {
    final phrase = _phraseController.text.trim();

    // Only translate if phrase changed and is not empty
    if (phrase.isNotEmpty && phrase != _lastTranslatedPhrase) {
      _lastTranslatedPhrase = phrase;
      _meaningWasAutoFilled = false; // Reset so new translation can auto-fill
      ref.read(translationNotifierProvider.notifier).translateWithDebounce(phrase);
    } else if (phrase.isEmpty) {
      ref.read(translationNotifierProvider.notifier).clear();
      _lastTranslatedPhrase = null;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final phrase = _phraseController.text.trim();
    final meaning = _meaningController.text.trim();
    final note = _noteController.text.trim();

    // Check for duplicate
    final isDuplicate = await ref
        .read(phraseNotifierProvider.notifier)
        .checkDuplicate(phrase);

    if (isDuplicate && mounted) {
      setState(() => _isSubmitting = false);
      await DuplicateWarningDialog.show(context, phrase);
      return;
    }

    final success = await ref.read(phraseNotifierProvider.notifier).addPhrase(
          phrase: phrase,
          meaning: meaning,
          myNote: note.isEmpty ? null : note,
        );

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final translationState = ref.watch(translationNotifierProvider);

    // Auto-fill meaning when translation completes (update even if field has value)
    if (translationState.translation != null && !_meaningWasAutoFilled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _meaningController.text = translationState.translation!;
          _meaningWasAutoFilled = true;
        }
      });
    }

    // Clear meaning field when translation fails (old meaning doesn't match new phrase)
    if (translationState.error != null && !_meaningWasAutoFilled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _meaningController.clear();
          _meaningWasAutoFilled = true; // Prevent repeated clearing
        }
      });
    }

    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add New Phrase',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Phrase field
              TextFormField(
                controller: _phraseController,
                focusNode: _phraseFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Phrase (Danish) *',
                  border: OutlineInputBorder(),
                  hintText: 'Type here',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a Danish phrase';
                  }
                  return null;
                },
                autofocus: true,
              ),
              const SizedBox(height: 16),

              // Meaning field
              TextFormField(
                controller: _meaningController,
                enabled: !translationState.isLoading,
                decoration: InputDecoration(
                  labelText: 'Meaning (English) *',
                  border: const OutlineInputBorder(),
                  hintText: translationState.isLoading ? 'Translating...' : null,
                  suffixIcon: translationState.isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : null,
                ),
                maxLines: 3,
                onChanged: (_) {
                  // User edited meaning, mark as not auto-filled
                  _meaningWasAutoFilled = false;
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the English meaning';
                  }
                  return null;
                },
              ),
              if (translationState.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          translationState.error!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),

              // My Note field
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'My Note (optional)',
                  border: OutlineInputBorder(),
                  hintText: 'Add personal notes or mnemonics...',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:
                        _isSubmitting ? null : () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
