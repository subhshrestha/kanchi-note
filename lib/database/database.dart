import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class Phrases extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get phrase => text()();
  TextColumn get meaning => text()();
  TextColumn get myNote => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class TranslationCache extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sourceText => text().collate(Collate.noCase)();
  TextColumn get translatedText => text()();
  TextColumn get sourceLang => text().withDefault(const Constant('da'))();
  TextColumn get targetLang => text().withDefault(const Constant('en'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {sourceText, sourceLang, targetLang}
      ];
}

class DefinitionCache extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get danishPhrase => text().collate(Collate.noCase)();
  TextColumn get definition => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {danishPhrase}
      ];
}

@DriftDatabase(tables: [Phrases, TranslationCache, DefinitionCache])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(translationCache);
        }
        if (from < 3) {
          await m.createTable(definitionCache);
        }
        if (from < 4) {
          // Recreate cache tables with COLLATE NOCASE
          await m.deleteTable('translation_cache');
          await m.deleteTable('definition_cache');
          await m.createTable(translationCache);
          await m.createTable(definitionCache);
        }
      },
    );
  }

  // Get all phrases sorted alphabetically
  Future<List<Phrase>> getAllPhrases() {
    return (select(phrases)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.phrase.lower(),
                  mode: OrderingMode.asc,
                )
          ]))
        .get();
  }

  // Watch all phrases (for reactive updates)
  Stream<List<Phrase>> watchAllPhrases() {
    return (select(phrases)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.phrase.lower(),
                  mode: OrderingMode.asc,
                )
          ]))
        .watch();
  }

  // Search phrases
  Future<List<Phrase>> searchPhrases(String query) {
    final lowerQuery = '%${query.toLowerCase()}%';
    return (select(phrases)
          ..where((t) =>
              t.phrase.lower().like(lowerQuery) |
              t.meaning.lower().like(lowerQuery) |
              t.myNote.lower().like(lowerQuery))
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.phrase.lower(),
                  mode: OrderingMode.asc,
                )
          ]))
        .get();
  }

  // Check if phrase exists (for duplicate detection)
  Future<bool> phraseExists(String phraseText) async {
    final result = await (select(phrases)
          ..where((t) => t.phrase.lower().equals(phraseText.toLowerCase())))
        .get();
    return result.isNotEmpty;
  }

  // Check if phrase exists excluding a specific ID (for edit duplicate check)
  Future<bool> phraseExistsExcluding(String phraseText, int excludeId) async {
    final result = await (select(phrases)
          ..where((t) =>
              t.phrase.lower().equals(phraseText.toLowerCase()) &
              t.id.equals(excludeId).not()))
        .get();
    return result.isNotEmpty;
  }

  // Insert a new phrase
  Future<int> insertPhrase(PhrasesCompanion entry) {
    return into(phrases).insert(entry);
  }

  // Update a phrase
  Future<bool> updatePhrase(Phrase entry) {
    return update(phrases).replace(entry.copyWith(updatedAt: DateTime.now()));
  }

  // Delete a phrase
  Future<int> deletePhrase(int id) {
    return (delete(phrases)..where((t) => t.id.equals(id))).go();
  }

  // Get phrase by ID
  Future<Phrase?> getPhraseById(int id) {
    return (select(phrases)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // Translation Cache methods

  // Get cached translation
  Future<String?> getCachedTranslation(
    String sourceText, {
    String sourceLang = 'da',
    String targetLang = 'en',
  }) async {
    final result = await (select(translationCache)
          ..where((t) =>
              t.sourceText.lower().equals(sourceText.toLowerCase()) &
              t.sourceLang.equals(sourceLang) &
              t.targetLang.equals(targetLang)))
        .getSingleOrNull();
    return result?.translatedText;
  }

  // Save translation to cache
  Future<void> cacheTranslation(
    String sourceText,
    String translatedText, {
    String sourceLang = 'da',
    String targetLang = 'en',
  }) async {
    await into(translationCache).insertOnConflictUpdate(
      TranslationCacheCompanion.insert(
        sourceText: sourceText.toLowerCase(),
        translatedText: translatedText,
        sourceLang: Value(sourceLang),
        targetLang: Value(targetLang),
      ),
    );
  }

  // Definition Cache methods

  // Get cached definition
  Future<String?> getCachedDefinition(String danishPhrase) async {
    final result = await (select(definitionCache)
          ..where((t) => t.danishPhrase.lower().equals(danishPhrase.toLowerCase())))
        .getSingleOrNull();
    return result?.definition;
  }

  // Save definition to cache
  Future<void> cacheDefinition(String danishPhrase, String definition) async {
    await into(definitionCache).insertOnConflictUpdate(
      DefinitionCacheCompanion.insert(
        danishPhrase: danishPhrase.toLowerCase(),
        definition: definition,
      ),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'kanchi_note.db'));
    return NativeDatabase.createInBackground(file);
  });
}
