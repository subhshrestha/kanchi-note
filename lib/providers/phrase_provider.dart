import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import 'database_provider.dart';

// Search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

// All phrases stream
final phrasesStreamProvider = StreamProvider<List<Phrase>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllPhrases();
});

// Filtered phrases based on search
final filteredPhrasesProvider = FutureProvider<List<Phrase>>((ref) async {
  final db = ref.watch(databaseProvider);
  final query = ref.watch(searchQueryProvider);

  if (query.isEmpty) {
    return db.getAllPhrases();
  }
  return db.searchPhrases(query);
});

// Phrase operations notifier
class PhraseNotifier extends StateNotifier<AsyncValue<void>> {
  final AppDatabase _db;

  PhraseNotifier(this._db) : super(const AsyncValue.data(null));

  Future<bool> addPhrase({
    required String phrase,
    required String meaning,
    String? myNote,
  }) async {
    state = const AsyncValue.loading();
    try {
      // Check for duplicates
      final exists = await _db.phraseExists(phrase);
      if (exists) {
        state = AsyncValue.error('Phrase already exists', StackTrace.current);
        return false;
      }

      await _db.insertPhrase(PhrasesCompanion(
        phrase: Value(phrase.trim()),
        meaning: Value(meaning.trim()),
        myNote: Value(myNote?.trim()),
      ));
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> updatePhrase(Phrase phrase) async {
    state = const AsyncValue.loading();
    try {
      // Check for duplicates excluding current phrase
      final exists = await _db.phraseExistsExcluding(phrase.phrase, phrase.id);
      if (exists) {
        state = AsyncValue.error('Phrase already exists', StackTrace.current);
        return false;
      }

      await _db.updatePhrase(phrase);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> deletePhrase(int id) async {
    state = const AsyncValue.loading();
    try {
      await _db.deletePhrase(id);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> checkDuplicate(String phrase, {int? excludeId}) async {
    if (excludeId != null) {
      return _db.phraseExistsExcluding(phrase, excludeId);
    }
    return _db.phraseExists(phrase);
  }
}

final phraseNotifierProvider =
    StateNotifierProvider<PhraseNotifier, AsyncValue<void>>((ref) {
  final db = ref.watch(databaseProvider);
  return PhraseNotifier(db);
});
