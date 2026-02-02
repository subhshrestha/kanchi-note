// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PhrasesTable extends Phrases with TableInfo<$PhrasesTable, Phrase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhrasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _phraseMeta = const VerificationMeta('phrase');
  @override
  late final GeneratedColumn<String> phrase = GeneratedColumn<String>(
      'phrase', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _meaningMeta =
      const VerificationMeta('meaning');
  @override
  late final GeneratedColumn<String> meaning = GeneratedColumn<String>(
      'meaning', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _myNoteMeta = const VerificationMeta('myNote');
  @override
  late final GeneratedColumn<String> myNote = GeneratedColumn<String>(
      'my_note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, phrase, meaning, myNote, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'phrases';
  @override
  VerificationContext validateIntegrity(Insertable<Phrase> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('phrase')) {
      context.handle(_phraseMeta,
          phrase.isAcceptableOrUnknown(data['phrase']!, _phraseMeta));
    } else if (isInserting) {
      context.missing(_phraseMeta);
    }
    if (data.containsKey('meaning')) {
      context.handle(_meaningMeta,
          meaning.isAcceptableOrUnknown(data['meaning']!, _meaningMeta));
    } else if (isInserting) {
      context.missing(_meaningMeta);
    }
    if (data.containsKey('my_note')) {
      context.handle(_myNoteMeta,
          myNote.isAcceptableOrUnknown(data['my_note']!, _myNoteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Phrase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Phrase(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      phrase: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phrase'])!,
      meaning: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meaning'])!,
      myNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}my_note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PhrasesTable createAlias(String alias) {
    return $PhrasesTable(attachedDatabase, alias);
  }
}

class Phrase extends DataClass implements Insertable<Phrase> {
  final int id;
  final String phrase;
  final String meaning;
  final String? myNote;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Phrase(
      {required this.id,
      required this.phrase,
      required this.meaning,
      this.myNote,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['phrase'] = Variable<String>(phrase);
    map['meaning'] = Variable<String>(meaning);
    if (!nullToAbsent || myNote != null) {
      map['my_note'] = Variable<String>(myNote);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PhrasesCompanion toCompanion(bool nullToAbsent) {
    return PhrasesCompanion(
      id: Value(id),
      phrase: Value(phrase),
      meaning: Value(meaning),
      myNote:
          myNote == null && nullToAbsent ? const Value.absent() : Value(myNote),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Phrase.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Phrase(
      id: serializer.fromJson<int>(json['id']),
      phrase: serializer.fromJson<String>(json['phrase']),
      meaning: serializer.fromJson<String>(json['meaning']),
      myNote: serializer.fromJson<String?>(json['myNote']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'phrase': serializer.toJson<String>(phrase),
      'meaning': serializer.toJson<String>(meaning),
      'myNote': serializer.toJson<String?>(myNote),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Phrase copyWith(
          {int? id,
          String? phrase,
          String? meaning,
          Value<String?> myNote = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Phrase(
        id: id ?? this.id,
        phrase: phrase ?? this.phrase,
        meaning: meaning ?? this.meaning,
        myNote: myNote.present ? myNote.value : this.myNote,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Phrase copyWithCompanion(PhrasesCompanion data) {
    return Phrase(
      id: data.id.present ? data.id.value : this.id,
      phrase: data.phrase.present ? data.phrase.value : this.phrase,
      meaning: data.meaning.present ? data.meaning.value : this.meaning,
      myNote: data.myNote.present ? data.myNote.value : this.myNote,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Phrase(')
          ..write('id: $id, ')
          ..write('phrase: $phrase, ')
          ..write('meaning: $meaning, ')
          ..write('myNote: $myNote, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, phrase, meaning, myNote, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Phrase &&
          other.id == this.id &&
          other.phrase == this.phrase &&
          other.meaning == this.meaning &&
          other.myNote == this.myNote &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PhrasesCompanion extends UpdateCompanion<Phrase> {
  final Value<int> id;
  final Value<String> phrase;
  final Value<String> meaning;
  final Value<String?> myNote;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PhrasesCompanion({
    this.id = const Value.absent(),
    this.phrase = const Value.absent(),
    this.meaning = const Value.absent(),
    this.myNote = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PhrasesCompanion.insert({
    this.id = const Value.absent(),
    required String phrase,
    required String meaning,
    this.myNote = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : phrase = Value(phrase),
        meaning = Value(meaning);
  static Insertable<Phrase> custom({
    Expression<int>? id,
    Expression<String>? phrase,
    Expression<String>? meaning,
    Expression<String>? myNote,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phrase != null) 'phrase': phrase,
      if (meaning != null) 'meaning': meaning,
      if (myNote != null) 'my_note': myNote,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PhrasesCompanion copyWith(
      {Value<int>? id,
      Value<String>? phrase,
      Value<String>? meaning,
      Value<String?>? myNote,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return PhrasesCompanion(
      id: id ?? this.id,
      phrase: phrase ?? this.phrase,
      meaning: meaning ?? this.meaning,
      myNote: myNote ?? this.myNote,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (phrase.present) {
      map['phrase'] = Variable<String>(phrase.value);
    }
    if (meaning.present) {
      map['meaning'] = Variable<String>(meaning.value);
    }
    if (myNote.present) {
      map['my_note'] = Variable<String>(myNote.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhrasesCompanion(')
          ..write('id: $id, ')
          ..write('phrase: $phrase, ')
          ..write('meaning: $meaning, ')
          ..write('myNote: $myNote, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TranslationCacheTable extends TranslationCache
    with TableInfo<$TranslationCacheTable, TranslationCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TranslationCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sourceTextMeta =
      const VerificationMeta('sourceText');
  @override
  late final GeneratedColumn<String> sourceText = GeneratedColumn<String>(
      'source_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _translatedTextMeta =
      const VerificationMeta('translatedText');
  @override
  late final GeneratedColumn<String> translatedText = GeneratedColumn<String>(
      'translated_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceLangMeta =
      const VerificationMeta('sourceLang');
  @override
  late final GeneratedColumn<String> sourceLang = GeneratedColumn<String>(
      'source_lang', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('da'));
  static const VerificationMeta _targetLangMeta =
      const VerificationMeta('targetLang');
  @override
  late final GeneratedColumn<String> targetLang = GeneratedColumn<String>(
      'target_lang', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('en'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, sourceText, translatedText, sourceLang, targetLang, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'translation_cache';
  @override
  VerificationContext validateIntegrity(
      Insertable<TranslationCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source_text')) {
      context.handle(
          _sourceTextMeta,
          sourceText.isAcceptableOrUnknown(
              data['source_text']!, _sourceTextMeta));
    } else if (isInserting) {
      context.missing(_sourceTextMeta);
    }
    if (data.containsKey('translated_text')) {
      context.handle(
          _translatedTextMeta,
          translatedText.isAcceptableOrUnknown(
              data['translated_text']!, _translatedTextMeta));
    } else if (isInserting) {
      context.missing(_translatedTextMeta);
    }
    if (data.containsKey('source_lang')) {
      context.handle(
          _sourceLangMeta,
          sourceLang.isAcceptableOrUnknown(
              data['source_lang']!, _sourceLangMeta));
    }
    if (data.containsKey('target_lang')) {
      context.handle(
          _targetLangMeta,
          targetLang.isAcceptableOrUnknown(
              data['target_lang']!, _targetLangMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {sourceText, sourceLang, targetLang},
      ];
  @override
  TranslationCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TranslationCacheData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sourceText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_text'])!,
      translatedText: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}translated_text'])!,
      sourceLang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_lang'])!,
      targetLang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_lang'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TranslationCacheTable createAlias(String alias) {
    return $TranslationCacheTable(attachedDatabase, alias);
  }
}

class TranslationCacheData extends DataClass
    implements Insertable<TranslationCacheData> {
  final int id;
  final String sourceText;
  final String translatedText;
  final String sourceLang;
  final String targetLang;
  final DateTime createdAt;
  const TranslationCacheData(
      {required this.id,
      required this.sourceText,
      required this.translatedText,
      required this.sourceLang,
      required this.targetLang,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source_text'] = Variable<String>(sourceText);
    map['translated_text'] = Variable<String>(translatedText);
    map['source_lang'] = Variable<String>(sourceLang);
    map['target_lang'] = Variable<String>(targetLang);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TranslationCacheCompanion toCompanion(bool nullToAbsent) {
    return TranslationCacheCompanion(
      id: Value(id),
      sourceText: Value(sourceText),
      translatedText: Value(translatedText),
      sourceLang: Value(sourceLang),
      targetLang: Value(targetLang),
      createdAt: Value(createdAt),
    );
  }

  factory TranslationCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TranslationCacheData(
      id: serializer.fromJson<int>(json['id']),
      sourceText: serializer.fromJson<String>(json['sourceText']),
      translatedText: serializer.fromJson<String>(json['translatedText']),
      sourceLang: serializer.fromJson<String>(json['sourceLang']),
      targetLang: serializer.fromJson<String>(json['targetLang']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sourceText': serializer.toJson<String>(sourceText),
      'translatedText': serializer.toJson<String>(translatedText),
      'sourceLang': serializer.toJson<String>(sourceLang),
      'targetLang': serializer.toJson<String>(targetLang),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TranslationCacheData copyWith(
          {int? id,
          String? sourceText,
          String? translatedText,
          String? sourceLang,
          String? targetLang,
          DateTime? createdAt}) =>
      TranslationCacheData(
        id: id ?? this.id,
        sourceText: sourceText ?? this.sourceText,
        translatedText: translatedText ?? this.translatedText,
        sourceLang: sourceLang ?? this.sourceLang,
        targetLang: targetLang ?? this.targetLang,
        createdAt: createdAt ?? this.createdAt,
      );
  TranslationCacheData copyWithCompanion(TranslationCacheCompanion data) {
    return TranslationCacheData(
      id: data.id.present ? data.id.value : this.id,
      sourceText:
          data.sourceText.present ? data.sourceText.value : this.sourceText,
      translatedText: data.translatedText.present
          ? data.translatedText.value
          : this.translatedText,
      sourceLang:
          data.sourceLang.present ? data.sourceLang.value : this.sourceLang,
      targetLang:
          data.targetLang.present ? data.targetLang.value : this.targetLang,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TranslationCacheData(')
          ..write('id: $id, ')
          ..write('sourceText: $sourceText, ')
          ..write('translatedText: $translatedText, ')
          ..write('sourceLang: $sourceLang, ')
          ..write('targetLang: $targetLang, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, sourceText, translatedText, sourceLang, targetLang, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TranslationCacheData &&
          other.id == this.id &&
          other.sourceText == this.sourceText &&
          other.translatedText == this.translatedText &&
          other.sourceLang == this.sourceLang &&
          other.targetLang == this.targetLang &&
          other.createdAt == this.createdAt);
}

class TranslationCacheCompanion extends UpdateCompanion<TranslationCacheData> {
  final Value<int> id;
  final Value<String> sourceText;
  final Value<String> translatedText;
  final Value<String> sourceLang;
  final Value<String> targetLang;
  final Value<DateTime> createdAt;
  const TranslationCacheCompanion({
    this.id = const Value.absent(),
    this.sourceText = const Value.absent(),
    this.translatedText = const Value.absent(),
    this.sourceLang = const Value.absent(),
    this.targetLang = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TranslationCacheCompanion.insert({
    this.id = const Value.absent(),
    required String sourceText,
    required String translatedText,
    this.sourceLang = const Value.absent(),
    this.targetLang = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : sourceText = Value(sourceText),
        translatedText = Value(translatedText);
  static Insertable<TranslationCacheData> custom({
    Expression<int>? id,
    Expression<String>? sourceText,
    Expression<String>? translatedText,
    Expression<String>? sourceLang,
    Expression<String>? targetLang,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceText != null) 'source_text': sourceText,
      if (translatedText != null) 'translated_text': translatedText,
      if (sourceLang != null) 'source_lang': sourceLang,
      if (targetLang != null) 'target_lang': targetLang,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TranslationCacheCompanion copyWith(
      {Value<int>? id,
      Value<String>? sourceText,
      Value<String>? translatedText,
      Value<String>? sourceLang,
      Value<String>? targetLang,
      Value<DateTime>? createdAt}) {
    return TranslationCacheCompanion(
      id: id ?? this.id,
      sourceText: sourceText ?? this.sourceText,
      translatedText: translatedText ?? this.translatedText,
      sourceLang: sourceLang ?? this.sourceLang,
      targetLang: targetLang ?? this.targetLang,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sourceText.present) {
      map['source_text'] = Variable<String>(sourceText.value);
    }
    if (translatedText.present) {
      map['translated_text'] = Variable<String>(translatedText.value);
    }
    if (sourceLang.present) {
      map['source_lang'] = Variable<String>(sourceLang.value);
    }
    if (targetLang.present) {
      map['target_lang'] = Variable<String>(targetLang.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TranslationCacheCompanion(')
          ..write('id: $id, ')
          ..write('sourceText: $sourceText, ')
          ..write('translatedText: $translatedText, ')
          ..write('sourceLang: $sourceLang, ')
          ..write('targetLang: $targetLang, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DefinitionCacheTable extends DefinitionCache
    with TableInfo<$DefinitionCacheTable, DefinitionCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DefinitionCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _danishPhraseMeta =
      const VerificationMeta('danishPhrase');
  @override
  late final GeneratedColumn<String> danishPhrase = GeneratedColumn<String>(
      'danish_phrase', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _definitionMeta =
      const VerificationMeta('definition');
  @override
  late final GeneratedColumn<String> definition = GeneratedColumn<String>(
      'definition', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, danishPhrase, definition, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'definition_cache';
  @override
  VerificationContext validateIntegrity(
      Insertable<DefinitionCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('danish_phrase')) {
      context.handle(
          _danishPhraseMeta,
          danishPhrase.isAcceptableOrUnknown(
              data['danish_phrase']!, _danishPhraseMeta));
    } else if (isInserting) {
      context.missing(_danishPhraseMeta);
    }
    if (data.containsKey('definition')) {
      context.handle(
          _definitionMeta,
          definition.isAcceptableOrUnknown(
              data['definition']!, _definitionMeta));
    } else if (isInserting) {
      context.missing(_definitionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {danishPhrase},
      ];
  @override
  DefinitionCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DefinitionCacheData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      danishPhrase: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}danish_phrase'])!,
      definition: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}definition'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DefinitionCacheTable createAlias(String alias) {
    return $DefinitionCacheTable(attachedDatabase, alias);
  }
}

class DefinitionCacheData extends DataClass
    implements Insertable<DefinitionCacheData> {
  final int id;
  final String danishPhrase;
  final String definition;
  final DateTime createdAt;
  const DefinitionCacheData(
      {required this.id,
      required this.danishPhrase,
      required this.definition,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['danish_phrase'] = Variable<String>(danishPhrase);
    map['definition'] = Variable<String>(definition);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DefinitionCacheCompanion toCompanion(bool nullToAbsent) {
    return DefinitionCacheCompanion(
      id: Value(id),
      danishPhrase: Value(danishPhrase),
      definition: Value(definition),
      createdAt: Value(createdAt),
    );
  }

  factory DefinitionCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DefinitionCacheData(
      id: serializer.fromJson<int>(json['id']),
      danishPhrase: serializer.fromJson<String>(json['danishPhrase']),
      definition: serializer.fromJson<String>(json['definition']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'danishPhrase': serializer.toJson<String>(danishPhrase),
      'definition': serializer.toJson<String>(definition),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DefinitionCacheData copyWith(
          {int? id,
          String? danishPhrase,
          String? definition,
          DateTime? createdAt}) =>
      DefinitionCacheData(
        id: id ?? this.id,
        danishPhrase: danishPhrase ?? this.danishPhrase,
        definition: definition ?? this.definition,
        createdAt: createdAt ?? this.createdAt,
      );
  DefinitionCacheData copyWithCompanion(DefinitionCacheCompanion data) {
    return DefinitionCacheData(
      id: data.id.present ? data.id.value : this.id,
      danishPhrase: data.danishPhrase.present
          ? data.danishPhrase.value
          : this.danishPhrase,
      definition:
          data.definition.present ? data.definition.value : this.definition,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DefinitionCacheData(')
          ..write('id: $id, ')
          ..write('danishPhrase: $danishPhrase, ')
          ..write('definition: $definition, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, danishPhrase, definition, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DefinitionCacheData &&
          other.id == this.id &&
          other.danishPhrase == this.danishPhrase &&
          other.definition == this.definition &&
          other.createdAt == this.createdAt);
}

class DefinitionCacheCompanion extends UpdateCompanion<DefinitionCacheData> {
  final Value<int> id;
  final Value<String> danishPhrase;
  final Value<String> definition;
  final Value<DateTime> createdAt;
  const DefinitionCacheCompanion({
    this.id = const Value.absent(),
    this.danishPhrase = const Value.absent(),
    this.definition = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DefinitionCacheCompanion.insert({
    this.id = const Value.absent(),
    required String danishPhrase,
    required String definition,
    this.createdAt = const Value.absent(),
  })  : danishPhrase = Value(danishPhrase),
        definition = Value(definition);
  static Insertable<DefinitionCacheData> custom({
    Expression<int>? id,
    Expression<String>? danishPhrase,
    Expression<String>? definition,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (danishPhrase != null) 'danish_phrase': danishPhrase,
      if (definition != null) 'definition': definition,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DefinitionCacheCompanion copyWith(
      {Value<int>? id,
      Value<String>? danishPhrase,
      Value<String>? definition,
      Value<DateTime>? createdAt}) {
    return DefinitionCacheCompanion(
      id: id ?? this.id,
      danishPhrase: danishPhrase ?? this.danishPhrase,
      definition: definition ?? this.definition,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (danishPhrase.present) {
      map['danish_phrase'] = Variable<String>(danishPhrase.value);
    }
    if (definition.present) {
      map['definition'] = Variable<String>(definition.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DefinitionCacheCompanion(')
          ..write('id: $id, ')
          ..write('danishPhrase: $danishPhrase, ')
          ..write('definition: $definition, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PhrasesTable phrases = $PhrasesTable(this);
  late final $TranslationCacheTable translationCache =
      $TranslationCacheTable(this);
  late final $DefinitionCacheTable definitionCache =
      $DefinitionCacheTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [phrases, translationCache, definitionCache];
}

typedef $$PhrasesTableCreateCompanionBuilder = PhrasesCompanion Function({
  Value<int> id,
  required String phrase,
  required String meaning,
  Value<String?> myNote,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$PhrasesTableUpdateCompanionBuilder = PhrasesCompanion Function({
  Value<int> id,
  Value<String> phrase,
  Value<String> meaning,
  Value<String?> myNote,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$PhrasesTableFilterComposer
    extends Composer<_$AppDatabase, $PhrasesTable> {
  $$PhrasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phrase => $composableBuilder(
      column: $table.phrase, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get meaning => $composableBuilder(
      column: $table.meaning, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get myNote => $composableBuilder(
      column: $table.myNote, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PhrasesTableOrderingComposer
    extends Composer<_$AppDatabase, $PhrasesTable> {
  $$PhrasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phrase => $composableBuilder(
      column: $table.phrase, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get meaning => $composableBuilder(
      column: $table.meaning, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get myNote => $composableBuilder(
      column: $table.myNote, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PhrasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PhrasesTable> {
  $$PhrasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phrase =>
      $composableBuilder(column: $table.phrase, builder: (column) => column);

  GeneratedColumn<String> get meaning =>
      $composableBuilder(column: $table.meaning, builder: (column) => column);

  GeneratedColumn<String> get myNote =>
      $composableBuilder(column: $table.myNote, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PhrasesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PhrasesTable,
    Phrase,
    $$PhrasesTableFilterComposer,
    $$PhrasesTableOrderingComposer,
    $$PhrasesTableAnnotationComposer,
    $$PhrasesTableCreateCompanionBuilder,
    $$PhrasesTableUpdateCompanionBuilder,
    (Phrase, BaseReferences<_$AppDatabase, $PhrasesTable, Phrase>),
    Phrase,
    PrefetchHooks Function()> {
  $$PhrasesTableTableManager(_$AppDatabase db, $PhrasesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhrasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhrasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhrasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> phrase = const Value.absent(),
            Value<String> meaning = const Value.absent(),
            Value<String?> myNote = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              PhrasesCompanion(
            id: id,
            phrase: phrase,
            meaning: meaning,
            myNote: myNote,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String phrase,
            required String meaning,
            Value<String?> myNote = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              PhrasesCompanion.insert(
            id: id,
            phrase: phrase,
            meaning: meaning,
            myNote: myNote,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PhrasesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PhrasesTable,
    Phrase,
    $$PhrasesTableFilterComposer,
    $$PhrasesTableOrderingComposer,
    $$PhrasesTableAnnotationComposer,
    $$PhrasesTableCreateCompanionBuilder,
    $$PhrasesTableUpdateCompanionBuilder,
    (Phrase, BaseReferences<_$AppDatabase, $PhrasesTable, Phrase>),
    Phrase,
    PrefetchHooks Function()>;
typedef $$TranslationCacheTableCreateCompanionBuilder
    = TranslationCacheCompanion Function({
  Value<int> id,
  required String sourceText,
  required String translatedText,
  Value<String> sourceLang,
  Value<String> targetLang,
  Value<DateTime> createdAt,
});
typedef $$TranslationCacheTableUpdateCompanionBuilder
    = TranslationCacheCompanion Function({
  Value<int> id,
  Value<String> sourceText,
  Value<String> translatedText,
  Value<String> sourceLang,
  Value<String> targetLang,
  Value<DateTime> createdAt,
});

class $$TranslationCacheTableFilterComposer
    extends Composer<_$AppDatabase, $TranslationCacheTable> {
  $$TranslationCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceText => $composableBuilder(
      column: $table.sourceText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get translatedText => $composableBuilder(
      column: $table.translatedText,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceLang => $composableBuilder(
      column: $table.sourceLang, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetLang => $composableBuilder(
      column: $table.targetLang, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$TranslationCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $TranslationCacheTable> {
  $$TranslationCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceText => $composableBuilder(
      column: $table.sourceText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get translatedText => $composableBuilder(
      column: $table.translatedText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceLang => $composableBuilder(
      column: $table.sourceLang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetLang => $composableBuilder(
      column: $table.targetLang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$TranslationCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $TranslationCacheTable> {
  $$TranslationCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceText => $composableBuilder(
      column: $table.sourceText, builder: (column) => column);

  GeneratedColumn<String> get translatedText => $composableBuilder(
      column: $table.translatedText, builder: (column) => column);

  GeneratedColumn<String> get sourceLang => $composableBuilder(
      column: $table.sourceLang, builder: (column) => column);

  GeneratedColumn<String> get targetLang => $composableBuilder(
      column: $table.targetLang, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TranslationCacheTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TranslationCacheTable,
    TranslationCacheData,
    $$TranslationCacheTableFilterComposer,
    $$TranslationCacheTableOrderingComposer,
    $$TranslationCacheTableAnnotationComposer,
    $$TranslationCacheTableCreateCompanionBuilder,
    $$TranslationCacheTableUpdateCompanionBuilder,
    (
      TranslationCacheData,
      BaseReferences<_$AppDatabase, $TranslationCacheTable,
          TranslationCacheData>
    ),
    TranslationCacheData,
    PrefetchHooks Function()> {
  $$TranslationCacheTableTableManager(
      _$AppDatabase db, $TranslationCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TranslationCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TranslationCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TranslationCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> sourceText = const Value.absent(),
            Value<String> translatedText = const Value.absent(),
            Value<String> sourceLang = const Value.absent(),
            Value<String> targetLang = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TranslationCacheCompanion(
            id: id,
            sourceText: sourceText,
            translatedText: translatedText,
            sourceLang: sourceLang,
            targetLang: targetLang,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String sourceText,
            required String translatedText,
            Value<String> sourceLang = const Value.absent(),
            Value<String> targetLang = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TranslationCacheCompanion.insert(
            id: id,
            sourceText: sourceText,
            translatedText: translatedText,
            sourceLang: sourceLang,
            targetLang: targetLang,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TranslationCacheTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TranslationCacheTable,
    TranslationCacheData,
    $$TranslationCacheTableFilterComposer,
    $$TranslationCacheTableOrderingComposer,
    $$TranslationCacheTableAnnotationComposer,
    $$TranslationCacheTableCreateCompanionBuilder,
    $$TranslationCacheTableUpdateCompanionBuilder,
    (
      TranslationCacheData,
      BaseReferences<_$AppDatabase, $TranslationCacheTable,
          TranslationCacheData>
    ),
    TranslationCacheData,
    PrefetchHooks Function()>;
typedef $$DefinitionCacheTableCreateCompanionBuilder = DefinitionCacheCompanion
    Function({
  Value<int> id,
  required String danishPhrase,
  required String definition,
  Value<DateTime> createdAt,
});
typedef $$DefinitionCacheTableUpdateCompanionBuilder = DefinitionCacheCompanion
    Function({
  Value<int> id,
  Value<String> danishPhrase,
  Value<String> definition,
  Value<DateTime> createdAt,
});

class $$DefinitionCacheTableFilterComposer
    extends Composer<_$AppDatabase, $DefinitionCacheTable> {
  $$DefinitionCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get danishPhrase => $composableBuilder(
      column: $table.danishPhrase, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get definition => $composableBuilder(
      column: $table.definition, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$DefinitionCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $DefinitionCacheTable> {
  $$DefinitionCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get danishPhrase => $composableBuilder(
      column: $table.danishPhrase,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get definition => $composableBuilder(
      column: $table.definition, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DefinitionCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $DefinitionCacheTable> {
  $$DefinitionCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get danishPhrase => $composableBuilder(
      column: $table.danishPhrase, builder: (column) => column);

  GeneratedColumn<String> get definition => $composableBuilder(
      column: $table.definition, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DefinitionCacheTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DefinitionCacheTable,
    DefinitionCacheData,
    $$DefinitionCacheTableFilterComposer,
    $$DefinitionCacheTableOrderingComposer,
    $$DefinitionCacheTableAnnotationComposer,
    $$DefinitionCacheTableCreateCompanionBuilder,
    $$DefinitionCacheTableUpdateCompanionBuilder,
    (
      DefinitionCacheData,
      BaseReferences<_$AppDatabase, $DefinitionCacheTable, DefinitionCacheData>
    ),
    DefinitionCacheData,
    PrefetchHooks Function()> {
  $$DefinitionCacheTableTableManager(
      _$AppDatabase db, $DefinitionCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DefinitionCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DefinitionCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DefinitionCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> danishPhrase = const Value.absent(),
            Value<String> definition = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DefinitionCacheCompanion(
            id: id,
            danishPhrase: danishPhrase,
            definition: definition,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String danishPhrase,
            required String definition,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DefinitionCacheCompanion.insert(
            id: id,
            danishPhrase: danishPhrase,
            definition: definition,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DefinitionCacheTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DefinitionCacheTable,
    DefinitionCacheData,
    $$DefinitionCacheTableFilterComposer,
    $$DefinitionCacheTableOrderingComposer,
    $$DefinitionCacheTableAnnotationComposer,
    $$DefinitionCacheTableCreateCompanionBuilder,
    $$DefinitionCacheTableUpdateCompanionBuilder,
    (
      DefinitionCacheData,
      BaseReferences<_$AppDatabase, $DefinitionCacheTable, DefinitionCacheData>
    ),
    DefinitionCacheData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PhrasesTableTableManager get phrases =>
      $$PhrasesTableTableManager(_db, _db.phrases);
  $$TranslationCacheTableTableManager get translationCache =>
      $$TranslationCacheTableTableManager(_db, _db.translationCache);
  $$DefinitionCacheTableTableManager get definitionCache =>
      $$DefinitionCacheTableTableManager(_db, _db.definitionCache);
}
