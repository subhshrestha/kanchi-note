import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/phrase_provider.dart';
import '../widgets/add_phrase_modal.dart';
import '../widgets/phrase_table.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phrasesAsync = ref.watch(filteredPhrasesProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      body: Column(
        children: [
          // Search bar and Add button
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Expanded(child: PhraseSearchBar()),
                const SizedBox(width: 16),
                FilledButton.icon(
                  onPressed: () async {
                    final result = await AddPhraseModal.show(context);
                    if (result == true) {
                      // Refresh the list
                      ref.invalidate(filteredPhrasesProvider);
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
          ),
          // Table
          Expanded(
            child: phrasesAsync.when(
              data: (phrases) => PhraseTable(phrases: phrases),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text('Error loading phrases: $error'),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => ref.invalidate(filteredPhrasesProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Status bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ),
            child: phrasesAsync.when(
              data: (phrases) {
                final count = phrases.length;
                final text = searchQuery.isEmpty
                    ? 'Showing $count phrase${count == 1 ? '' : 's'}'
                    : 'Showing $count result${count == 1 ? '' : 's'} for "$searchQuery"';
                return Text(
                  text,
                  style: Theme.of(context).textTheme.bodySmall,
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
