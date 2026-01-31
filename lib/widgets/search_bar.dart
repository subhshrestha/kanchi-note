import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/phrase_provider.dart';

class PhraseSearchBar extends ConsumerStatefulWidget {
  const PhraseSearchBar({super.key});

  @override
  ConsumerState<PhraseSearchBar> createState() => _PhraseSearchBarState();
}

class _PhraseSearchBarState extends ConsumerState<PhraseSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Search phrases...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  ref.read(searchQueryProvider.notifier).state = '';
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
      onChanged: (value) {
        ref.read(searchQueryProvider.notifier).state = value;
        setState(() {}); // Rebuild to show/hide clear button
      },
    );
  }
}
