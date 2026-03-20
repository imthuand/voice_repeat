// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// ignore_for_file: type=lint
class $PersonsTable extends Persons with TableInfo<$PersonsTable, Person> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
      'person_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('de'));
  static const VerificationMeta _lastActiveSleeveIdMeta =
      const VerificationMeta('lastActiveSleeveId');
  @override
  late final GeneratedColumn<String> lastActiveSleeveId =
      GeneratedColumn<String>('last_active_sleeve_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        personId,
        displayName,
        role,
        language,
        lastActiveSleeveId,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'persons';
  @override
  VerificationContext validateIntegrity(Insertable<Person> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    if (data.containsKey('last_active_sleeve_id')) {
      context.handle(
          _lastActiveSleeveIdMeta,
          lastActiveSleeveId.isAcceptableOrUnknown(
              data['last_active_sleeve_id']!, _lastActiveSleeveIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {personId};
  @override
  Person map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Person(
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person_id'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      lastActiveSleeveId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_active_sleeve_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PersonsTable createAlias(String alias) {
    return $PersonsTable(attachedDatabase, alias);
  }
}

class Person extends DataClass implements Insertable<Person> {
  final String personId;
  final String displayName;
  final String role;
  final String language;
  final String? lastActiveSleeveId;
  final int createdAt;
  final int updatedAt;
  const Person(
      {required this.personId,
      required this.displayName,
      required this.role,
      required this.language,
      this.lastActiveSleeveId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['person_id'] = Variable<String>(personId);
    map['display_name'] = Variable<String>(displayName);
    map['role'] = Variable<String>(role);
    map['language'] = Variable<String>(language);
    if (!nullToAbsent || lastActiveSleeveId != null) {
      map['last_active_sleeve_id'] = Variable<String>(lastActiveSleeveId);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  PersonsCompanion toCompanion(bool nullToAbsent) {
    return PersonsCompanion(
      personId: Value(personId),
      displayName: Value(displayName),
      role: Value(role),
      language: Value(language),
      lastActiveSleeveId: lastActiveSleeveId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastActiveSleeveId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Person.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Person(
      personId: serializer.fromJson<String>(json['personId']),
      displayName: serializer.fromJson<String>(json['displayName']),
      role: serializer.fromJson<String>(json['role']),
      language: serializer.fromJson<String>(json['language']),
      lastActiveSleeveId:
          serializer.fromJson<String?>(json['lastActiveSleeveId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'personId': serializer.toJson<String>(personId),
      'displayName': serializer.toJson<String>(displayName),
      'role': serializer.toJson<String>(role),
      'language': serializer.toJson<String>(language),
      'lastActiveSleeveId': serializer.toJson<String?>(lastActiveSleeveId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Person copyWith(
          {String? personId,
          String? displayName,
          String? role,
          String? language,
          Value<String?> lastActiveSleeveId = const Value.absent(),
          int? createdAt,
          int? updatedAt}) =>
      Person(
        personId: personId ?? this.personId,
        displayName: displayName ?? this.displayName,
        role: role ?? this.role,
        language: language ?? this.language,
        lastActiveSleeveId: lastActiveSleeveId.present
            ? lastActiveSleeveId.value
            : this.lastActiveSleeveId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Person copyWithCompanion(PersonsCompanion data) {
    return Person(
      personId: data.personId.present ? data.personId.value : this.personId,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      role: data.role.present ? data.role.value : this.role,
      language: data.language.present ? data.language.value : this.language,
      lastActiveSleeveId: data.lastActiveSleeveId.present
          ? data.lastActiveSleeveId.value
          : this.lastActiveSleeveId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Person(')
          ..write('personId: $personId, ')
          ..write('displayName: $displayName, ')
          ..write('role: $role, ')
          ..write('language: $language, ')
          ..write('lastActiveSleeveId: $lastActiveSleeveId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(personId, displayName, role, language,
      lastActiveSleeveId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Person &&
          other.personId == this.personId &&
          other.displayName == this.displayName &&
          other.role == this.role &&
          other.language == this.language &&
          other.lastActiveSleeveId == this.lastActiveSleeveId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PersonsCompanion extends UpdateCompanion<Person> {
  final Value<String> personId;
  final Value<String> displayName;
  final Value<String> role;
  final Value<String> language;
  final Value<String?> lastActiveSleeveId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const PersonsCompanion({
    this.personId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.role = const Value.absent(),
    this.language = const Value.absent(),
    this.lastActiveSleeveId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonsCompanion.insert({
    required String personId,
    required String displayName,
    required String role,
    this.language = const Value.absent(),
    this.lastActiveSleeveId = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : personId = Value(personId),
        displayName = Value(displayName),
        role = Value(role),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Person> custom({
    Expression<String>? personId,
    Expression<String>? displayName,
    Expression<String>? role,
    Expression<String>? language,
    Expression<String>? lastActiveSleeveId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (personId != null) 'person_id': personId,
      if (displayName != null) 'display_name': displayName,
      if (role != null) 'role': role,
      if (language != null) 'language': language,
      if (lastActiveSleeveId != null)
        'last_active_sleeve_id': lastActiveSleeveId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonsCompanion copyWith(
      {Value<String>? personId,
      Value<String>? displayName,
      Value<String>? role,
      Value<String>? language,
      Value<String?>? lastActiveSleeveId,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return PersonsCompanion(
      personId: personId ?? this.personId,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      language: language ?? this.language,
      lastActiveSleeveId: lastActiveSleeveId ?? this.lastActiveSleeveId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (lastActiveSleeveId.present) {
      map['last_active_sleeve_id'] = Variable<String>(lastActiveSleeveId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonsCompanion(')
          ..write('personId: $personId, ')
          ..write('displayName: $displayName, ')
          ..write('role: $role, ')
          ..write('language: $language, ')
          ..write('lastActiveSleeveId: $lastActiveSleeveId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SleevesTable extends Sleeves with TableInfo<$SleevesTable, Sleeve> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SleevesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sleeveIdMeta =
      const VerificationMeta('sleeveId');
  @override
  late final GeneratedColumn<String> sleeveId = GeneratedColumn<String>(
      'sleeve_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
      'person_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [sleeveId, personId, name, sortOrder, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sleeves';
  @override
  VerificationContext validateIntegrity(Insertable<Sleeve> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sleeve_id')) {
      context.handle(_sleeveIdMeta,
          sleeveId.isAcceptableOrUnknown(data['sleeve_id']!, _sleeveIdMeta));
    } else if (isInserting) {
      context.missing(_sleeveIdMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sleeveId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {personId, name},
      ];
  @override
  Sleeve map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sleeve(
      sleeveId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sleeve_id'])!,
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SleevesTable createAlias(String alias) {
    return $SleevesTable(attachedDatabase, alias);
  }
}

class Sleeve extends DataClass implements Insertable<Sleeve> {
  final String sleeveId;
  final String personId;
  final String name;
  final int sortOrder;
  final int createdAt;
  final int updatedAt;
  const Sleeve(
      {required this.sleeveId,
      required this.personId,
      required this.name,
      required this.sortOrder,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sleeve_id'] = Variable<String>(sleeveId);
    map['person_id'] = Variable<String>(personId);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  SleevesCompanion toCompanion(bool nullToAbsent) {
    return SleevesCompanion(
      sleeveId: Value(sleeveId),
      personId: Value(personId),
      name: Value(name),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Sleeve.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sleeve(
      sleeveId: serializer.fromJson<String>(json['sleeveId']),
      personId: serializer.fromJson<String>(json['personId']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sleeveId': serializer.toJson<String>(sleeveId),
      'personId': serializer.toJson<String>(personId),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Sleeve copyWith(
          {String? sleeveId,
          String? personId,
          String? name,
          int? sortOrder,
          int? createdAt,
          int? updatedAt}) =>
      Sleeve(
        sleeveId: sleeveId ?? this.sleeveId,
        personId: personId ?? this.personId,
        name: name ?? this.name,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Sleeve copyWithCompanion(SleevesCompanion data) {
    return Sleeve(
      sleeveId: data.sleeveId.present ? data.sleeveId.value : this.sleeveId,
      personId: data.personId.present ? data.personId.value : this.personId,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sleeve(')
          ..write('sleeveId: $sleeveId, ')
          ..write('personId: $personId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(sleeveId, personId, name, sortOrder, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sleeve &&
          other.sleeveId == this.sleeveId &&
          other.personId == this.personId &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SleevesCompanion extends UpdateCompanion<Sleeve> {
  final Value<String> sleeveId;
  final Value<String> personId;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const SleevesCompanion({
    this.sleeveId = const Value.absent(),
    this.personId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SleevesCompanion.insert({
    required String sleeveId,
    required String personId,
    required String name,
    this.sortOrder = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : sleeveId = Value(sleeveId),
        personId = Value(personId),
        name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Sleeve> custom({
    Expression<String>? sleeveId,
    Expression<String>? personId,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sleeveId != null) 'sleeve_id': sleeveId,
      if (personId != null) 'person_id': personId,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SleevesCompanion copyWith(
      {Value<String>? sleeveId,
      Value<String>? personId,
      Value<String>? name,
      Value<int>? sortOrder,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return SleevesCompanion(
      sleeveId: sleeveId ?? this.sleeveId,
      personId: personId ?? this.personId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sleeveId.present) {
      map['sleeve_id'] = Variable<String>(sleeveId.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SleevesCompanion(')
          ..write('sleeveId: $sleeveId, ')
          ..write('personId: $personId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RitualItemsTable extends RitualItems
    with TableInfo<$RitualItemsTable, RitualItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RitualItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
      'person_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _slotIndexMeta =
      const VerificationMeta('slotIndex');
  @override
  late final GeneratedColumn<int> slotIndex = GeneratedColumn<int>(
      'slot_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
      'state', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(ItemState.empty));
  static const VerificationMeta _activePathMeta =
      const VerificationMeta('activePath');
  @override
  late final GeneratedColumn<String> activePath = GeneratedColumn<String>(
      'active_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _archivedPathMeta =
      const VerificationMeta('archivedPath');
  @override
  late final GeneratedColumn<String> archivedPath = GeneratedColumn<String>(
      'archived_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sizeBytesMeta =
      const VerificationMeta('sizeBytes');
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
      'size_bytes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _usageCountTotalMeta =
      const VerificationMeta('usageCountTotal');
  @override
  late final GeneratedColumn<int> usageCountTotal = GeneratedColumn<int>(
      'usage_count_total', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastUsedAtMeta =
      const VerificationMeta('lastUsedAt');
  @override
  late final GeneratedColumn<int> lastUsedAt = GeneratedColumn<int>(
      'last_used_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sleeveIdMeta =
      const VerificationMeta('sleeveId');
  @override
  late final GeneratedColumn<String> sleeveId = GeneratedColumn<String>(
      'sleeve_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(SleeveDefaults.defaultId));
  static const VerificationMeta _searchTextMeta =
      const VerificationMeta('searchText');
  @override
  late final GeneratedColumn<String> searchText = GeneratedColumn<String>(
      'search_text', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<int> recordedAt = GeneratedColumn<int>(
      'recorded_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _archivedAtMeta =
      const VerificationMeta('archivedAt');
  @override
  late final GeneratedColumn<int> archivedAt = GeneratedColumn<int>(
      'archived_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _integrityStatusMeta =
      const VerificationMeta('integrityStatus');
  @override
  late final GeneratedColumn<String> integrityStatus = GeneratedColumn<String>(
      'integrity_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(IntegrityStatus.ok));
  static const VerificationMeta _integrityCheckedAtMeta =
      const VerificationMeta('integrityCheckedAt');
  @override
  late final GeneratedColumn<int> integrityCheckedAt = GeneratedColumn<int>(
      'integrity_checked_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        itemId,
        personId,
        slotIndex,
        label,
        state,
        activePath,
        archivedPath,
        sizeBytes,
        usageCountTotal,
        lastUsedAt,
        sleeveId,
        searchText,
        recordedAt,
        archivedAt,
        integrityStatus,
        integrityCheckedAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ritual_items';
  @override
  VerificationContext validateIntegrity(Insertable<RitualItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('slot_index')) {
      context.handle(_slotIndexMeta,
          slotIndex.isAcceptableOrUnknown(data['slot_index']!, _slotIndexMeta));
    } else if (isInserting) {
      context.missing(_slotIndexMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    }
    if (data.containsKey('state')) {
      context.handle(
          _stateMeta, state.isAcceptableOrUnknown(data['state']!, _stateMeta));
    }
    if (data.containsKey('active_path')) {
      context.handle(
          _activePathMeta,
          activePath.isAcceptableOrUnknown(
              data['active_path']!, _activePathMeta));
    }
    if (data.containsKey('archived_path')) {
      context.handle(
          _archivedPathMeta,
          archivedPath.isAcceptableOrUnknown(
              data['archived_path']!, _archivedPathMeta));
    }
    if (data.containsKey('size_bytes')) {
      context.handle(_sizeBytesMeta,
          sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta));
    }
    if (data.containsKey('usage_count_total')) {
      context.handle(
          _usageCountTotalMeta,
          usageCountTotal.isAcceptableOrUnknown(
              data['usage_count_total']!, _usageCountTotalMeta));
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
          _lastUsedAtMeta,
          lastUsedAt.isAcceptableOrUnknown(
              data['last_used_at']!, _lastUsedAtMeta));
    }
    if (data.containsKey('sleeve_id')) {
      context.handle(_sleeveIdMeta,
          sleeveId.isAcceptableOrUnknown(data['sleeve_id']!, _sleeveIdMeta));
    }
    if (data.containsKey('search_text')) {
      context.handle(
          _searchTextMeta,
          searchText.isAcceptableOrUnknown(
              data['search_text']!, _searchTextMeta));
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    }
    if (data.containsKey('archived_at')) {
      context.handle(
          _archivedAtMeta,
          archivedAt.isAcceptableOrUnknown(
              data['archived_at']!, _archivedAtMeta));
    }
    if (data.containsKey('integrity_status')) {
      context.handle(
          _integrityStatusMeta,
          integrityStatus.isAcceptableOrUnknown(
              data['integrity_status']!, _integrityStatusMeta));
    }
    if (data.containsKey('integrity_checked_at')) {
      context.handle(
          _integrityCheckedAtMeta,
          integrityCheckedAt.isAcceptableOrUnknown(
              data['integrity_checked_at']!, _integrityCheckedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {personId, slotIndex},
      ];
  @override
  RitualItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RitualItem(
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person_id'])!,
      slotIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}slot_index'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      state: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}state'])!,
      activePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}active_path']),
      archivedPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}archived_path']),
      sizeBytes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}size_bytes'])!,
      usageCountTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}usage_count_total'])!,
      lastUsedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_used_at']),
      sleeveId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sleeve_id'])!,
      searchText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}search_text'])!,
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recorded_at']),
      archivedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}archived_at']),
      integrityStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}integrity_status'])!,
      integrityCheckedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}integrity_checked_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $RitualItemsTable createAlias(String alias) {
    return $RitualItemsTable(attachedDatabase, alias);
  }
}

class RitualItem extends DataClass implements Insertable<RitualItem> {
  final String itemId;
  final String personId;
  final int slotIndex;
  final String label;
  final String state;
  final String? activePath;
  final String? archivedPath;
  final int sizeBytes;
  final int usageCountTotal;
  final int? lastUsedAt;
  final String sleeveId;
  final String searchText;
  final int? recordedAt;
  final int? archivedAt;
  final String integrityStatus;
  final int? integrityCheckedAt;
  final int createdAt;
  final int updatedAt;
  const RitualItem(
      {required this.itemId,
      required this.personId,
      required this.slotIndex,
      required this.label,
      required this.state,
      this.activePath,
      this.archivedPath,
      required this.sizeBytes,
      required this.usageCountTotal,
      this.lastUsedAt,
      required this.sleeveId,
      required this.searchText,
      this.recordedAt,
      this.archivedAt,
      required this.integrityStatus,
      this.integrityCheckedAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['person_id'] = Variable<String>(personId);
    map['slot_index'] = Variable<int>(slotIndex);
    map['label'] = Variable<String>(label);
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || activePath != null) {
      map['active_path'] = Variable<String>(activePath);
    }
    if (!nullToAbsent || archivedPath != null) {
      map['archived_path'] = Variable<String>(archivedPath);
    }
    map['size_bytes'] = Variable<int>(sizeBytes);
    map['usage_count_total'] = Variable<int>(usageCountTotal);
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<int>(lastUsedAt);
    }
    map['sleeve_id'] = Variable<String>(sleeveId);
    map['search_text'] = Variable<String>(searchText);
    if (!nullToAbsent || recordedAt != null) {
      map['recorded_at'] = Variable<int>(recordedAt);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<int>(archivedAt);
    }
    map['integrity_status'] = Variable<String>(integrityStatus);
    if (!nullToAbsent || integrityCheckedAt != null) {
      map['integrity_checked_at'] = Variable<int>(integrityCheckedAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  RitualItemsCompanion toCompanion(bool nullToAbsent) {
    return RitualItemsCompanion(
      itemId: Value(itemId),
      personId: Value(personId),
      slotIndex: Value(slotIndex),
      label: Value(label),
      state: Value(state),
      activePath: activePath == null && nullToAbsent
          ? const Value.absent()
          : Value(activePath),
      archivedPath: archivedPath == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedPath),
      sizeBytes: Value(sizeBytes),
      usageCountTotal: Value(usageCountTotal),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
      sleeveId: Value(sleeveId),
      searchText: Value(searchText),
      recordedAt: recordedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(recordedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      integrityStatus: Value(integrityStatus),
      integrityCheckedAt: integrityCheckedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(integrityCheckedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RitualItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RitualItem(
      itemId: serializer.fromJson<String>(json['itemId']),
      personId: serializer.fromJson<String>(json['personId']),
      slotIndex: serializer.fromJson<int>(json['slotIndex']),
      label: serializer.fromJson<String>(json['label']),
      state: serializer.fromJson<String>(json['state']),
      activePath: serializer.fromJson<String?>(json['activePath']),
      archivedPath: serializer.fromJson<String?>(json['archivedPath']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      usageCountTotal: serializer.fromJson<int>(json['usageCountTotal']),
      lastUsedAt: serializer.fromJson<int?>(json['lastUsedAt']),
      sleeveId: serializer.fromJson<String>(json['sleeveId']),
      searchText: serializer.fromJson<String>(json['searchText']),
      recordedAt: serializer.fromJson<int?>(json['recordedAt']),
      archivedAt: serializer.fromJson<int?>(json['archivedAt']),
      integrityStatus: serializer.fromJson<String>(json['integrityStatus']),
      integrityCheckedAt: serializer.fromJson<int?>(json['integrityCheckedAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'personId': serializer.toJson<String>(personId),
      'slotIndex': serializer.toJson<int>(slotIndex),
      'label': serializer.toJson<String>(label),
      'state': serializer.toJson<String>(state),
      'activePath': serializer.toJson<String?>(activePath),
      'archivedPath': serializer.toJson<String?>(archivedPath),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'usageCountTotal': serializer.toJson<int>(usageCountTotal),
      'lastUsedAt': serializer.toJson<int?>(lastUsedAt),
      'sleeveId': serializer.toJson<String>(sleeveId),
      'searchText': serializer.toJson<String>(searchText),
      'recordedAt': serializer.toJson<int?>(recordedAt),
      'archivedAt': serializer.toJson<int?>(archivedAt),
      'integrityStatus': serializer.toJson<String>(integrityStatus),
      'integrityCheckedAt': serializer.toJson<int?>(integrityCheckedAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  RitualItem copyWith(
          {String? itemId,
          String? personId,
          int? slotIndex,
          String? label,
          String? state,
          Value<String?> activePath = const Value.absent(),
          Value<String?> archivedPath = const Value.absent(),
          int? sizeBytes,
          int? usageCountTotal,
          Value<int?> lastUsedAt = const Value.absent(),
          String? sleeveId,
          String? searchText,
          Value<int?> recordedAt = const Value.absent(),
          Value<int?> archivedAt = const Value.absent(),
          String? integrityStatus,
          Value<int?> integrityCheckedAt = const Value.absent(),
          int? createdAt,
          int? updatedAt}) =>
      RitualItem(
        itemId: itemId ?? this.itemId,
        personId: personId ?? this.personId,
        slotIndex: slotIndex ?? this.slotIndex,
        label: label ?? this.label,
        state: state ?? this.state,
        activePath: activePath.present ? activePath.value : this.activePath,
        archivedPath:
            archivedPath.present ? archivedPath.value : this.archivedPath,
        sizeBytes: sizeBytes ?? this.sizeBytes,
        usageCountTotal: usageCountTotal ?? this.usageCountTotal,
        lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
        sleeveId: sleeveId ?? this.sleeveId,
        searchText: searchText ?? this.searchText,
        recordedAt: recordedAt.present ? recordedAt.value : this.recordedAt,
        archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
        integrityStatus: integrityStatus ?? this.integrityStatus,
        integrityCheckedAt: integrityCheckedAt.present
            ? integrityCheckedAt.value
            : this.integrityCheckedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  RitualItem copyWithCompanion(RitualItemsCompanion data) {
    return RitualItem(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      personId: data.personId.present ? data.personId.value : this.personId,
      slotIndex: data.slotIndex.present ? data.slotIndex.value : this.slotIndex,
      label: data.label.present ? data.label.value : this.label,
      state: data.state.present ? data.state.value : this.state,
      activePath:
          data.activePath.present ? data.activePath.value : this.activePath,
      archivedPath: data.archivedPath.present
          ? data.archivedPath.value
          : this.archivedPath,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      usageCountTotal: data.usageCountTotal.present
          ? data.usageCountTotal.value
          : this.usageCountTotal,
      lastUsedAt:
          data.lastUsedAt.present ? data.lastUsedAt.value : this.lastUsedAt,
      sleeveId: data.sleeveId.present ? data.sleeveId.value : this.sleeveId,
      searchText:
          data.searchText.present ? data.searchText.value : this.searchText,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
      archivedAt:
          data.archivedAt.present ? data.archivedAt.value : this.archivedAt,
      integrityStatus: data.integrityStatus.present
          ? data.integrityStatus.value
          : this.integrityStatus,
      integrityCheckedAt: data.integrityCheckedAt.present
          ? data.integrityCheckedAt.value
          : this.integrityCheckedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RitualItem(')
          ..write('itemId: $itemId, ')
          ..write('personId: $personId, ')
          ..write('slotIndex: $slotIndex, ')
          ..write('label: $label, ')
          ..write('state: $state, ')
          ..write('activePath: $activePath, ')
          ..write('archivedPath: $archivedPath, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('usageCountTotal: $usageCountTotal, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('sleeveId: $sleeveId, ')
          ..write('searchText: $searchText, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('integrityStatus: $integrityStatus, ')
          ..write('integrityCheckedAt: $integrityCheckedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      itemId,
      personId,
      slotIndex,
      label,
      state,
      activePath,
      archivedPath,
      sizeBytes,
      usageCountTotal,
      lastUsedAt,
      sleeveId,
      searchText,
      recordedAt,
      archivedAt,
      integrityStatus,
      integrityCheckedAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RitualItem &&
          other.itemId == this.itemId &&
          other.personId == this.personId &&
          other.slotIndex == this.slotIndex &&
          other.label == this.label &&
          other.state == this.state &&
          other.activePath == this.activePath &&
          other.archivedPath == this.archivedPath &&
          other.sizeBytes == this.sizeBytes &&
          other.usageCountTotal == this.usageCountTotal &&
          other.lastUsedAt == this.lastUsedAt &&
          other.sleeveId == this.sleeveId &&
          other.searchText == this.searchText &&
          other.recordedAt == this.recordedAt &&
          other.archivedAt == this.archivedAt &&
          other.integrityStatus == this.integrityStatus &&
          other.integrityCheckedAt == this.integrityCheckedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RitualItemsCompanion extends UpdateCompanion<RitualItem> {
  final Value<String> itemId;
  final Value<String> personId;
  final Value<int> slotIndex;
  final Value<String> label;
  final Value<String> state;
  final Value<String?> activePath;
  final Value<String?> archivedPath;
  final Value<int> sizeBytes;
  final Value<int> usageCountTotal;
  final Value<int?> lastUsedAt;
  final Value<String> sleeveId;
  final Value<String> searchText;
  final Value<int?> recordedAt;
  final Value<int?> archivedAt;
  final Value<String> integrityStatus;
  final Value<int?> integrityCheckedAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const RitualItemsCompanion({
    this.itemId = const Value.absent(),
    this.personId = const Value.absent(),
    this.slotIndex = const Value.absent(),
    this.label = const Value.absent(),
    this.state = const Value.absent(),
    this.activePath = const Value.absent(),
    this.archivedPath = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.usageCountTotal = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.sleeveId = const Value.absent(),
    this.searchText = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.integrityStatus = const Value.absent(),
    this.integrityCheckedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RitualItemsCompanion.insert({
    required String itemId,
    required String personId,
    required int slotIndex,
    this.label = const Value.absent(),
    this.state = const Value.absent(),
    this.activePath = const Value.absent(),
    this.archivedPath = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.usageCountTotal = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.sleeveId = const Value.absent(),
    this.searchText = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.integrityStatus = const Value.absent(),
    this.integrityCheckedAt = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : itemId = Value(itemId),
        personId = Value(personId),
        slotIndex = Value(slotIndex),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<RitualItem> custom({
    Expression<String>? itemId,
    Expression<String>? personId,
    Expression<int>? slotIndex,
    Expression<String>? label,
    Expression<String>? state,
    Expression<String>? activePath,
    Expression<String>? archivedPath,
    Expression<int>? sizeBytes,
    Expression<int>? usageCountTotal,
    Expression<int>? lastUsedAt,
    Expression<String>? sleeveId,
    Expression<String>? searchText,
    Expression<int>? recordedAt,
    Expression<int>? archivedAt,
    Expression<String>? integrityStatus,
    Expression<int>? integrityCheckedAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (personId != null) 'person_id': personId,
      if (slotIndex != null) 'slot_index': slotIndex,
      if (label != null) 'label': label,
      if (state != null) 'state': state,
      if (activePath != null) 'active_path': activePath,
      if (archivedPath != null) 'archived_path': archivedPath,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (usageCountTotal != null) 'usage_count_total': usageCountTotal,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (sleeveId != null) 'sleeve_id': sleeveId,
      if (searchText != null) 'search_text': searchText,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (integrityStatus != null) 'integrity_status': integrityStatus,
      if (integrityCheckedAt != null)
        'integrity_checked_at': integrityCheckedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RitualItemsCompanion copyWith(
      {Value<String>? itemId,
      Value<String>? personId,
      Value<int>? slotIndex,
      Value<String>? label,
      Value<String>? state,
      Value<String?>? activePath,
      Value<String?>? archivedPath,
      Value<int>? sizeBytes,
      Value<int>? usageCountTotal,
      Value<int?>? lastUsedAt,
      Value<String>? sleeveId,
      Value<String>? searchText,
      Value<int?>? recordedAt,
      Value<int?>? archivedAt,
      Value<String>? integrityStatus,
      Value<int?>? integrityCheckedAt,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return RitualItemsCompanion(
      itemId: itemId ?? this.itemId,
      personId: personId ?? this.personId,
      slotIndex: slotIndex ?? this.slotIndex,
      label: label ?? this.label,
      state: state ?? this.state,
      activePath: activePath ?? this.activePath,
      archivedPath: archivedPath ?? this.archivedPath,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      usageCountTotal: usageCountTotal ?? this.usageCountTotal,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      sleeveId: sleeveId ?? this.sleeveId,
      searchText: searchText ?? this.searchText,
      recordedAt: recordedAt ?? this.recordedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      integrityStatus: integrityStatus ?? this.integrityStatus,
      integrityCheckedAt: integrityCheckedAt ?? this.integrityCheckedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (slotIndex.present) {
      map['slot_index'] = Variable<int>(slotIndex.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (activePath.present) {
      map['active_path'] = Variable<String>(activePath.value);
    }
    if (archivedPath.present) {
      map['archived_path'] = Variable<String>(archivedPath.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (usageCountTotal.present) {
      map['usage_count_total'] = Variable<int>(usageCountTotal.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<int>(lastUsedAt.value);
    }
    if (sleeveId.present) {
      map['sleeve_id'] = Variable<String>(sleeveId.value);
    }
    if (searchText.present) {
      map['search_text'] = Variable<String>(searchText.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<int>(recordedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<int>(archivedAt.value);
    }
    if (integrityStatus.present) {
      map['integrity_status'] = Variable<String>(integrityStatus.value);
    }
    if (integrityCheckedAt.present) {
      map['integrity_checked_at'] = Variable<int>(integrityCheckedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RitualItemsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('personId: $personId, ')
          ..write('slotIndex: $slotIndex, ')
          ..write('label: $label, ')
          ..write('state: $state, ')
          ..write('activePath: $activePath, ')
          ..write('archivedPath: $archivedPath, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('usageCountTotal: $usageCountTotal, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('sleeveId: $sleeveId, ')
          ..write('searchText: $searchText, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('integrityStatus: $integrityStatus, ')
          ..write('integrityCheckedAt: $integrityCheckedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RitualEventsTable extends RitualEvents
    with TableInfo<$RitualEventsTable, RitualEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RitualEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventIdMeta =
      const VerificationMeta('eventId');
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
      'event_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
      'person_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _eventTypeMeta =
      const VerificationMeta('eventType');
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
      'event_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
      'metadata', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sleeveIdMeta =
      const VerificationMeta('sleeveId');
  @override
  late final GeneratedColumn<String> sleeveId = GeneratedColumn<String>(
      'sleeve_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(SleeveDefaults.defaultId));
  static const VerificationMeta _slotIndexMeta =
      const VerificationMeta('slotIndex');
  @override
  late final GeneratedColumn<int> slotIndex = GeneratedColumn<int>(
      'slot_index', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _itemStateMeta =
      const VerificationMeta('itemState');
  @override
  late final GeneratedColumn<String> itemState = GeneratedColumn<String>(
      'item_state', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _sizeBytesMeta =
      const VerificationMeta('sizeBytes');
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
      'size_bytes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(EventSource.repo));
  static const VerificationMeta _enforcementModeMeta =
      const VerificationMeta('enforcementMode');
  @override
  late final GeneratedColumn<String> enforcementMode = GeneratedColumn<String>(
      'enforcement_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(EnforcementMode.soft));
  @override
  List<GeneratedColumn> get $columns => [
        eventId,
        itemId,
        personId,
        eventType,
        timestamp,
        metadata,
        sleeveId,
        slotIndex,
        itemState,
        path,
        sizeBytes,
        source,
        enforcementMode
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ritual_events';
  @override
  VerificationContext validateIntegrity(Insertable<RitualEvent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_id')) {
      context.handle(_eventIdMeta,
          eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta));
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(_eventTypeMeta,
          eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta));
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('metadata')) {
      context.handle(_metadataMeta,
          metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta));
    }
    if (data.containsKey('sleeve_id')) {
      context.handle(_sleeveIdMeta,
          sleeveId.isAcceptableOrUnknown(data['sleeve_id']!, _sleeveIdMeta));
    }
    if (data.containsKey('slot_index')) {
      context.handle(_slotIndexMeta,
          slotIndex.isAcceptableOrUnknown(data['slot_index']!, _slotIndexMeta));
    }
    if (data.containsKey('item_state')) {
      context.handle(_itemStateMeta,
          itemState.isAcceptableOrUnknown(data['item_state']!, _itemStateMeta));
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    }
    if (data.containsKey('size_bytes')) {
      context.handle(_sizeBytesMeta,
          sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('enforcement_mode')) {
      context.handle(
          _enforcementModeMeta,
          enforcementMode.isAcceptableOrUnknown(
              data['enforcement_mode']!, _enforcementModeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventId};
  @override
  RitualEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RitualEvent(
      eventId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person_id'])!,
      eventType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_type'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      metadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata']),
      sleeveId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sleeve_id'])!,
      slotIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}slot_index']),
      itemState: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_state'])!,
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      sizeBytes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}size_bytes'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      enforcementMode: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}enforcement_mode'])!,
    );
  }

  @override
  $RitualEventsTable createAlias(String alias) {
    return $RitualEventsTable(attachedDatabase, alias);
  }
}

class RitualEvent extends DataClass implements Insertable<RitualEvent> {
  final String eventId;
  final String itemId;
  final String personId;
  final String eventType;
  final int timestamp;
  final String? metadata;
  final String sleeveId;
  final int? slotIndex;
  final String itemState;
  final String path;
  final int sizeBytes;
  final String source;
  final String enforcementMode;
  const RitualEvent(
      {required this.eventId,
      required this.itemId,
      required this.personId,
      required this.eventType,
      required this.timestamp,
      this.metadata,
      required this.sleeveId,
      this.slotIndex,
      required this.itemState,
      required this.path,
      required this.sizeBytes,
      required this.source,
      required this.enforcementMode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_id'] = Variable<String>(eventId);
    map['item_id'] = Variable<String>(itemId);
    map['person_id'] = Variable<String>(personId);
    map['event_type'] = Variable<String>(eventType);
    map['timestamp'] = Variable<int>(timestamp);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['sleeve_id'] = Variable<String>(sleeveId);
    if (!nullToAbsent || slotIndex != null) {
      map['slot_index'] = Variable<int>(slotIndex);
    }
    map['item_state'] = Variable<String>(itemState);
    map['path'] = Variable<String>(path);
    map['size_bytes'] = Variable<int>(sizeBytes);
    map['source'] = Variable<String>(source);
    map['enforcement_mode'] = Variable<String>(enforcementMode);
    return map;
  }

  RitualEventsCompanion toCompanion(bool nullToAbsent) {
    return RitualEventsCompanion(
      eventId: Value(eventId),
      itemId: Value(itemId),
      personId: Value(personId),
      eventType: Value(eventType),
      timestamp: Value(timestamp),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      sleeveId: Value(sleeveId),
      slotIndex: slotIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(slotIndex),
      itemState: Value(itemState),
      path: Value(path),
      sizeBytes: Value(sizeBytes),
      source: Value(source),
      enforcementMode: Value(enforcementMode),
    );
  }

  factory RitualEvent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RitualEvent(
      eventId: serializer.fromJson<String>(json['eventId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      personId: serializer.fromJson<String>(json['personId']),
      eventType: serializer.fromJson<String>(json['eventType']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      sleeveId: serializer.fromJson<String>(json['sleeveId']),
      slotIndex: serializer.fromJson<int?>(json['slotIndex']),
      itemState: serializer.fromJson<String>(json['itemState']),
      path: serializer.fromJson<String>(json['path']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      source: serializer.fromJson<String>(json['source']),
      enforcementMode: serializer.fromJson<String>(json['enforcementMode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventId': serializer.toJson<String>(eventId),
      'itemId': serializer.toJson<String>(itemId),
      'personId': serializer.toJson<String>(personId),
      'eventType': serializer.toJson<String>(eventType),
      'timestamp': serializer.toJson<int>(timestamp),
      'metadata': serializer.toJson<String?>(metadata),
      'sleeveId': serializer.toJson<String>(sleeveId),
      'slotIndex': serializer.toJson<int?>(slotIndex),
      'itemState': serializer.toJson<String>(itemState),
      'path': serializer.toJson<String>(path),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'source': serializer.toJson<String>(source),
      'enforcementMode': serializer.toJson<String>(enforcementMode),
    };
  }

  RitualEvent copyWith(
          {String? eventId,
          String? itemId,
          String? personId,
          String? eventType,
          int? timestamp,
          Value<String?> metadata = const Value.absent(),
          String? sleeveId,
          Value<int?> slotIndex = const Value.absent(),
          String? itemState,
          String? path,
          int? sizeBytes,
          String? source,
          String? enforcementMode}) =>
      RitualEvent(
        eventId: eventId ?? this.eventId,
        itemId: itemId ?? this.itemId,
        personId: personId ?? this.personId,
        eventType: eventType ?? this.eventType,
        timestamp: timestamp ?? this.timestamp,
        metadata: metadata.present ? metadata.value : this.metadata,
        sleeveId: sleeveId ?? this.sleeveId,
        slotIndex: slotIndex.present ? slotIndex.value : this.slotIndex,
        itemState: itemState ?? this.itemState,
        path: path ?? this.path,
        sizeBytes: sizeBytes ?? this.sizeBytes,
        source: source ?? this.source,
        enforcementMode: enforcementMode ?? this.enforcementMode,
      );
  RitualEvent copyWithCompanion(RitualEventsCompanion data) {
    return RitualEvent(
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      personId: data.personId.present ? data.personId.value : this.personId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      sleeveId: data.sleeveId.present ? data.sleeveId.value : this.sleeveId,
      slotIndex: data.slotIndex.present ? data.slotIndex.value : this.slotIndex,
      itemState: data.itemState.present ? data.itemState.value : this.itemState,
      path: data.path.present ? data.path.value : this.path,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      source: data.source.present ? data.source.value : this.source,
      enforcementMode: data.enforcementMode.present
          ? data.enforcementMode.value
          : this.enforcementMode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RitualEvent(')
          ..write('eventId: $eventId, ')
          ..write('itemId: $itemId, ')
          ..write('personId: $personId, ')
          ..write('eventType: $eventType, ')
          ..write('timestamp: $timestamp, ')
          ..write('metadata: $metadata, ')
          ..write('sleeveId: $sleeveId, ')
          ..write('slotIndex: $slotIndex, ')
          ..write('itemState: $itemState, ')
          ..write('path: $path, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('source: $source, ')
          ..write('enforcementMode: $enforcementMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      eventId,
      itemId,
      personId,
      eventType,
      timestamp,
      metadata,
      sleeveId,
      slotIndex,
      itemState,
      path,
      sizeBytes,
      source,
      enforcementMode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RitualEvent &&
          other.eventId == this.eventId &&
          other.itemId == this.itemId &&
          other.personId == this.personId &&
          other.eventType == this.eventType &&
          other.timestamp == this.timestamp &&
          other.metadata == this.metadata &&
          other.sleeveId == this.sleeveId &&
          other.slotIndex == this.slotIndex &&
          other.itemState == this.itemState &&
          other.path == this.path &&
          other.sizeBytes == this.sizeBytes &&
          other.source == this.source &&
          other.enforcementMode == this.enforcementMode);
}

class RitualEventsCompanion extends UpdateCompanion<RitualEvent> {
  final Value<String> eventId;
  final Value<String> itemId;
  final Value<String> personId;
  final Value<String> eventType;
  final Value<int> timestamp;
  final Value<String?> metadata;
  final Value<String> sleeveId;
  final Value<int?> slotIndex;
  final Value<String> itemState;
  final Value<String> path;
  final Value<int> sizeBytes;
  final Value<String> source;
  final Value<String> enforcementMode;
  final Value<int> rowid;
  const RitualEventsCompanion({
    this.eventId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.personId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.metadata = const Value.absent(),
    this.sleeveId = const Value.absent(),
    this.slotIndex = const Value.absent(),
    this.itemState = const Value.absent(),
    this.path = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.source = const Value.absent(),
    this.enforcementMode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RitualEventsCompanion.insert({
    required String eventId,
    required String itemId,
    required String personId,
    required String eventType,
    required int timestamp,
    this.metadata = const Value.absent(),
    this.sleeveId = const Value.absent(),
    this.slotIndex = const Value.absent(),
    this.itemState = const Value.absent(),
    this.path = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.source = const Value.absent(),
    this.enforcementMode = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : eventId = Value(eventId),
        itemId = Value(itemId),
        personId = Value(personId),
        eventType = Value(eventType),
        timestamp = Value(timestamp);
  static Insertable<RitualEvent> custom({
    Expression<String>? eventId,
    Expression<String>? itemId,
    Expression<String>? personId,
    Expression<String>? eventType,
    Expression<int>? timestamp,
    Expression<String>? metadata,
    Expression<String>? sleeveId,
    Expression<int>? slotIndex,
    Expression<String>? itemState,
    Expression<String>? path,
    Expression<int>? sizeBytes,
    Expression<String>? source,
    Expression<String>? enforcementMode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventId != null) 'event_id': eventId,
      if (itemId != null) 'item_id': itemId,
      if (personId != null) 'person_id': personId,
      if (eventType != null) 'event_type': eventType,
      if (timestamp != null) 'timestamp': timestamp,
      if (metadata != null) 'metadata': metadata,
      if (sleeveId != null) 'sleeve_id': sleeveId,
      if (slotIndex != null) 'slot_index': slotIndex,
      if (itemState != null) 'item_state': itemState,
      if (path != null) 'path': path,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (source != null) 'source': source,
      if (enforcementMode != null) 'enforcement_mode': enforcementMode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RitualEventsCompanion copyWith(
      {Value<String>? eventId,
      Value<String>? itemId,
      Value<String>? personId,
      Value<String>? eventType,
      Value<int>? timestamp,
      Value<String?>? metadata,
      Value<String>? sleeveId,
      Value<int?>? slotIndex,
      Value<String>? itemState,
      Value<String>? path,
      Value<int>? sizeBytes,
      Value<String>? source,
      Value<String>? enforcementMode,
      Value<int>? rowid}) {
    return RitualEventsCompanion(
      eventId: eventId ?? this.eventId,
      itemId: itemId ?? this.itemId,
      personId: personId ?? this.personId,
      eventType: eventType ?? this.eventType,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
      sleeveId: sleeveId ?? this.sleeveId,
      slotIndex: slotIndex ?? this.slotIndex,
      itemState: itemState ?? this.itemState,
      path: path ?? this.path,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      source: source ?? this.source,
      enforcementMode: enforcementMode ?? this.enforcementMode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (sleeveId.present) {
      map['sleeve_id'] = Variable<String>(sleeveId.value);
    }
    if (slotIndex.present) {
      map['slot_index'] = Variable<int>(slotIndex.value);
    }
    if (itemState.present) {
      map['item_state'] = Variable<String>(itemState.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (enforcementMode.present) {
      map['enforcement_mode'] = Variable<String>(enforcementMode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RitualEventsCompanion(')
          ..write('eventId: $eventId, ')
          ..write('itemId: $itemId, ')
          ..write('personId: $personId, ')
          ..write('eventType: $eventType, ')
          ..write('timestamp: $timestamp, ')
          ..write('metadata: $metadata, ')
          ..write('sleeveId: $sleeveId, ')
          ..write('slotIndex: $slotIndex, ')
          ..write('itemState: $itemState, ')
          ..write('path: $path, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('source: $source, ')
          ..write('enforcementMode: $enforcementMode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RitualSchedulesTable extends RitualSchedules
    with TableInfo<$RitualSchedulesTable, RitualSchedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RitualSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _scheduleIdMeta =
      const VerificationMeta('scheduleId');
  @override
  late final GeneratedColumn<String> scheduleId = GeneratedColumn<String>(
      'schedule_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
      'person_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
      'kind', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(AlarmScheduleKind.weeklyMask));
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
      'hour', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _minuteMeta = const VerificationMeta('minute');
  @override
  late final GeneratedColumn<int> minute = GeneratedColumn<int>(
      'minute', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _weekdayMaskMeta =
      const VerificationMeta('weekdayMask');
  @override
  late final GeneratedColumn<int> weekdayMask = GeneratedColumn<int>(
      'weekday_mask', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastTriggeredAtMeta =
      const VerificationMeta('lastTriggeredAt');
  @override
  late final GeneratedColumn<int> lastTriggeredAt = GeneratedColumn<int>(
      'last_triggered_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nextTriggerAtMeta =
      const VerificationMeta('nextTriggerAt');
  @override
  late final GeneratedColumn<int> nextTriggerAt = GeneratedColumn<int>(
      'next_trigger_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        scheduleId,
        itemId,
        personId,
        kind,
        label,
        enabled,
        hour,
        minute,
        weekdayMask,
        createdAt,
        updatedAt,
        lastTriggeredAt,
        nextTriggerAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ritual_schedules';
  @override
  VerificationContext validateIntegrity(Insertable<RitualSchedule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('schedule_id')) {
      context.handle(
          _scheduleIdMeta,
          scheduleId.isAcceptableOrUnknown(
              data['schedule_id']!, _scheduleIdMeta));
    } else if (isInserting) {
      context.missing(_scheduleIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
          _kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    if (data.containsKey('hour')) {
      context.handle(
          _hourMeta, hour.isAcceptableOrUnknown(data['hour']!, _hourMeta));
    } else if (isInserting) {
      context.missing(_hourMeta);
    }
    if (data.containsKey('minute')) {
      context.handle(_minuteMeta,
          minute.isAcceptableOrUnknown(data['minute']!, _minuteMeta));
    } else if (isInserting) {
      context.missing(_minuteMeta);
    }
    if (data.containsKey('weekday_mask')) {
      context.handle(
          _weekdayMaskMeta,
          weekdayMask.isAcceptableOrUnknown(
              data['weekday_mask']!, _weekdayMaskMeta));
    } else if (isInserting) {
      context.missing(_weekdayMaskMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_triggered_at')) {
      context.handle(
          _lastTriggeredAtMeta,
          lastTriggeredAt.isAcceptableOrUnknown(
              data['last_triggered_at']!, _lastTriggeredAtMeta));
    }
    if (data.containsKey('next_trigger_at')) {
      context.handle(
          _nextTriggerAtMeta,
          nextTriggerAt.isAcceptableOrUnknown(
              data['next_trigger_at']!, _nextTriggerAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {scheduleId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {itemId},
      ];
  @override
  RitualSchedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RitualSchedule(
      scheduleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person_id'])!,
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      hour: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hour'])!,
      minute: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}minute'])!,
      weekdayMask: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weekday_mask'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      lastTriggeredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_triggered_at']),
      nextTriggerAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}next_trigger_at']),
    );
  }

  @override
  $RitualSchedulesTable createAlias(String alias) {
    return $RitualSchedulesTable(attachedDatabase, alias);
  }
}

class RitualSchedule extends DataClass implements Insertable<RitualSchedule> {
  final String scheduleId;
  final String itemId;
  final String personId;
  final String kind;
  final String label;
  final bool enabled;
  final int hour;
  final int minute;
  final int weekdayMask;
  final int createdAt;
  final int updatedAt;
  final int? lastTriggeredAt;
  final int? nextTriggerAt;
  const RitualSchedule(
      {required this.scheduleId,
      required this.itemId,
      required this.personId,
      required this.kind,
      required this.label,
      required this.enabled,
      required this.hour,
      required this.minute,
      required this.weekdayMask,
      required this.createdAt,
      required this.updatedAt,
      this.lastTriggeredAt,
      this.nextTriggerAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['schedule_id'] = Variable<String>(scheduleId);
    map['item_id'] = Variable<String>(itemId);
    map['person_id'] = Variable<String>(personId);
    map['kind'] = Variable<String>(kind);
    map['label'] = Variable<String>(label);
    map['enabled'] = Variable<bool>(enabled);
    map['hour'] = Variable<int>(hour);
    map['minute'] = Variable<int>(minute);
    map['weekday_mask'] = Variable<int>(weekdayMask);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || lastTriggeredAt != null) {
      map['last_triggered_at'] = Variable<int>(lastTriggeredAt);
    }
    if (!nullToAbsent || nextTriggerAt != null) {
      map['next_trigger_at'] = Variable<int>(nextTriggerAt);
    }
    return map;
  }

  RitualSchedulesCompanion toCompanion(bool nullToAbsent) {
    return RitualSchedulesCompanion(
      scheduleId: Value(scheduleId),
      itemId: Value(itemId),
      personId: Value(personId),
      kind: Value(kind),
      label: Value(label),
      enabled: Value(enabled),
      hour: Value(hour),
      minute: Value(minute),
      weekdayMask: Value(weekdayMask),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastTriggeredAt: lastTriggeredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastTriggeredAt),
      nextTriggerAt: nextTriggerAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextTriggerAt),
    );
  }

  factory RitualSchedule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RitualSchedule(
      scheduleId: serializer.fromJson<String>(json['scheduleId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      personId: serializer.fromJson<String>(json['personId']),
      kind: serializer.fromJson<String>(json['kind']),
      label: serializer.fromJson<String>(json['label']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      hour: serializer.fromJson<int>(json['hour']),
      minute: serializer.fromJson<int>(json['minute']),
      weekdayMask: serializer.fromJson<int>(json['weekdayMask']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      lastTriggeredAt: serializer.fromJson<int?>(json['lastTriggeredAt']),
      nextTriggerAt: serializer.fromJson<int?>(json['nextTriggerAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'scheduleId': serializer.toJson<String>(scheduleId),
      'itemId': serializer.toJson<String>(itemId),
      'personId': serializer.toJson<String>(personId),
      'kind': serializer.toJson<String>(kind),
      'label': serializer.toJson<String>(label),
      'enabled': serializer.toJson<bool>(enabled),
      'hour': serializer.toJson<int>(hour),
      'minute': serializer.toJson<int>(minute),
      'weekdayMask': serializer.toJson<int>(weekdayMask),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'lastTriggeredAt': serializer.toJson<int?>(lastTriggeredAt),
      'nextTriggerAt': serializer.toJson<int?>(nextTriggerAt),
    };
  }

  RitualSchedule copyWith(
          {String? scheduleId,
          String? itemId,
          String? personId,
          String? kind,
          String? label,
          bool? enabled,
          int? hour,
          int? minute,
          int? weekdayMask,
          int? createdAt,
          int? updatedAt,
          Value<int?> lastTriggeredAt = const Value.absent(),
          Value<int?> nextTriggerAt = const Value.absent()}) =>
      RitualSchedule(
        scheduleId: scheduleId ?? this.scheduleId,
        itemId: itemId ?? this.itemId,
        personId: personId ?? this.personId,
        kind: kind ?? this.kind,
        label: label ?? this.label,
        enabled: enabled ?? this.enabled,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        weekdayMask: weekdayMask ?? this.weekdayMask,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastTriggeredAt: lastTriggeredAt.present
            ? lastTriggeredAt.value
            : this.lastTriggeredAt,
        nextTriggerAt:
            nextTriggerAt.present ? nextTriggerAt.value : this.nextTriggerAt,
      );
  RitualSchedule copyWithCompanion(RitualSchedulesCompanion data) {
    return RitualSchedule(
      scheduleId:
          data.scheduleId.present ? data.scheduleId.value : this.scheduleId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      personId: data.personId.present ? data.personId.value : this.personId,
      kind: data.kind.present ? data.kind.value : this.kind,
      label: data.label.present ? data.label.value : this.label,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      hour: data.hour.present ? data.hour.value : this.hour,
      minute: data.minute.present ? data.minute.value : this.minute,
      weekdayMask:
          data.weekdayMask.present ? data.weekdayMask.value : this.weekdayMask,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastTriggeredAt: data.lastTriggeredAt.present
          ? data.lastTriggeredAt.value
          : this.lastTriggeredAt,
      nextTriggerAt: data.nextTriggerAt.present
          ? data.nextTriggerAt.value
          : this.nextTriggerAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RitualSchedule(')
          ..write('scheduleId: $scheduleId, ')
          ..write('itemId: $itemId, ')
          ..write('personId: $personId, ')
          ..write('kind: $kind, ')
          ..write('label: $label, ')
          ..write('enabled: $enabled, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('weekdayMask: $weekdayMask, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastTriggeredAt: $lastTriggeredAt, ')
          ..write('nextTriggerAt: $nextTriggerAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      scheduleId,
      itemId,
      personId,
      kind,
      label,
      enabled,
      hour,
      minute,
      weekdayMask,
      createdAt,
      updatedAt,
      lastTriggeredAt,
      nextTriggerAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RitualSchedule &&
          other.scheduleId == this.scheduleId &&
          other.itemId == this.itemId &&
          other.personId == this.personId &&
          other.kind == this.kind &&
          other.label == this.label &&
          other.enabled == this.enabled &&
          other.hour == this.hour &&
          other.minute == this.minute &&
          other.weekdayMask == this.weekdayMask &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastTriggeredAt == this.lastTriggeredAt &&
          other.nextTriggerAt == this.nextTriggerAt);
}

class RitualSchedulesCompanion extends UpdateCompanion<RitualSchedule> {
  final Value<String> scheduleId;
  final Value<String> itemId;
  final Value<String> personId;
  final Value<String> kind;
  final Value<String> label;
  final Value<bool> enabled;
  final Value<int> hour;
  final Value<int> minute;
  final Value<int> weekdayMask;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> lastTriggeredAt;
  final Value<int?> nextTriggerAt;
  final Value<int> rowid;
  const RitualSchedulesCompanion({
    this.scheduleId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.personId = const Value.absent(),
    this.kind = const Value.absent(),
    this.label = const Value.absent(),
    this.enabled = const Value.absent(),
    this.hour = const Value.absent(),
    this.minute = const Value.absent(),
    this.weekdayMask = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastTriggeredAt = const Value.absent(),
    this.nextTriggerAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RitualSchedulesCompanion.insert({
    required String scheduleId,
    required String itemId,
    required String personId,
    this.kind = const Value.absent(),
    this.label = const Value.absent(),
    this.enabled = const Value.absent(),
    required int hour,
    required int minute,
    required int weekdayMask,
    required int createdAt,
    required int updatedAt,
    this.lastTriggeredAt = const Value.absent(),
    this.nextTriggerAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : scheduleId = Value(scheduleId),
        itemId = Value(itemId),
        personId = Value(personId),
        hour = Value(hour),
        minute = Value(minute),
        weekdayMask = Value(weekdayMask),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<RitualSchedule> custom({
    Expression<String>? scheduleId,
    Expression<String>? itemId,
    Expression<String>? personId,
    Expression<String>? kind,
    Expression<String>? label,
    Expression<bool>? enabled,
    Expression<int>? hour,
    Expression<int>? minute,
    Expression<int>? weekdayMask,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? lastTriggeredAt,
    Expression<int>? nextTriggerAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (itemId != null) 'item_id': itemId,
      if (personId != null) 'person_id': personId,
      if (kind != null) 'kind': kind,
      if (label != null) 'label': label,
      if (enabled != null) 'enabled': enabled,
      if (hour != null) 'hour': hour,
      if (minute != null) 'minute': minute,
      if (weekdayMask != null) 'weekday_mask': weekdayMask,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastTriggeredAt != null) 'last_triggered_at': lastTriggeredAt,
      if (nextTriggerAt != null) 'next_trigger_at': nextTriggerAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RitualSchedulesCompanion copyWith(
      {Value<String>? scheduleId,
      Value<String>? itemId,
      Value<String>? personId,
      Value<String>? kind,
      Value<String>? label,
      Value<bool>? enabled,
      Value<int>? hour,
      Value<int>? minute,
      Value<int>? weekdayMask,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? lastTriggeredAt,
      Value<int?>? nextTriggerAt,
      Value<int>? rowid}) {
    return RitualSchedulesCompanion(
      scheduleId: scheduleId ?? this.scheduleId,
      itemId: itemId ?? this.itemId,
      personId: personId ?? this.personId,
      kind: kind ?? this.kind,
      label: label ?? this.label,
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      weekdayMask: weekdayMask ?? this.weekdayMask,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastTriggeredAt: lastTriggeredAt ?? this.lastTriggeredAt,
      nextTriggerAt: nextTriggerAt ?? this.nextTriggerAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (scheduleId.present) {
      map['schedule_id'] = Variable<String>(scheduleId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (minute.present) {
      map['minute'] = Variable<int>(minute.value);
    }
    if (weekdayMask.present) {
      map['weekday_mask'] = Variable<int>(weekdayMask.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (lastTriggeredAt.present) {
      map['last_triggered_at'] = Variable<int>(lastTriggeredAt.value);
    }
    if (nextTriggerAt.present) {
      map['next_trigger_at'] = Variable<int>(nextTriggerAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RitualSchedulesCompanion(')
          ..write('scheduleId: $scheduleId, ')
          ..write('itemId: $itemId, ')
          ..write('personId: $personId, ')
          ..write('kind: $kind, ')
          ..write('label: $label, ')
          ..write('enabled: $enabled, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('weekdayMask: $weekdayMask, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastTriggeredAt: $lastTriggeredAt, ')
          ..write('nextTriggerAt: $nextTriggerAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $PersonsTable persons = $PersonsTable(this);
  late final $SleevesTable sleeves = $SleevesTable(this);
  late final $RitualItemsTable ritualItems = $RitualItemsTable(this);
  late final $RitualEventsTable ritualEvents = $RitualEventsTable(this);
  late final $RitualSchedulesTable ritualSchedules =
      $RitualSchedulesTable(this);
  late final Index idxSleevesPersonSort = Index('idx_sleeves_person_sort',
      'CREATE INDEX idx_sleeves_person_sort ON sleeves (person_id, sort_order)');
  late final Index idxRitualItemsPersonState = Index(
      'idx_ritual_items_person_state',
      'CREATE INDEX idx_ritual_items_person_state ON ritual_items (person_id, state)');
  late final Index idxRitualItemsPersonArchivedAt = Index(
      'idx_ritual_items_person_archived_at',
      'CREATE INDEX idx_ritual_items_person_archived_at ON ritual_items (person_id, archived_at)');
  late final Index idxRitualItemsPersonSleeveState = Index(
      'idx_ritual_items_person_sleeve_state',
      'CREATE INDEX idx_ritual_items_person_sleeve_state ON ritual_items (person_id, sleeve_id, state)');
  late final Index idxRitualEventsPersonTime = Index(
      'idx_ritual_events_person_time',
      'CREATE INDEX idx_ritual_events_person_time ON ritual_events (person_id, timestamp)');
  late final Index idxRitualEventsItemTime = Index(
      'idx_ritual_events_item_time',
      'CREATE INDEX idx_ritual_events_item_time ON ritual_events (item_id, timestamp)');
  late final Index idxRitualEventsPersonSleeveTime = Index(
      'idx_ritual_events_person_sleeve_time',
      'CREATE INDEX idx_ritual_events_person_sleeve_time ON ritual_events (person_id, sleeve_id, timestamp)');
  late final Index idxRitualSchedulesPersonEnabledTime = Index(
      'idx_ritual_schedules_person_enabled_time',
      'CREATE INDEX idx_ritual_schedules_person_enabled_time ON ritual_schedules (person_id, enabled, hour, minute)');
  late final Index idxRitualSchedulesItem = Index('idx_ritual_schedules_item',
      'CREATE INDEX idx_ritual_schedules_item ON ritual_schedules (item_id)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        persons,
        sleeves,
        ritualItems,
        ritualEvents,
        ritualSchedules,
        idxSleevesPersonSort,
        idxRitualItemsPersonState,
        idxRitualItemsPersonArchivedAt,
        idxRitualItemsPersonSleeveState,
        idxRitualEventsPersonTime,
        idxRitualEventsItemTime,
        idxRitualEventsPersonSleeveTime,
        idxRitualSchedulesPersonEnabledTime,
        idxRitualSchedulesItem
      ];
}

typedef $$PersonsTableCreateCompanionBuilder = PersonsCompanion Function({
  required String personId,
  required String displayName,
  required String role,
  Value<String> language,
  Value<String?> lastActiveSleeveId,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$PersonsTableUpdateCompanionBuilder = PersonsCompanion Function({
  Value<String> personId,
  Value<String> displayName,
  Value<String> role,
  Value<String> language,
  Value<String?> lastActiveSleeveId,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$PersonsTableFilterComposer extends Composer<_$AppDb, $PersonsTable> {
  $$PersonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastActiveSleeveId => $composableBuilder(
      column: $table.lastActiveSleeveId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PersonsTableOrderingComposer extends Composer<_$AppDb, $PersonsTable> {
  $$PersonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastActiveSleeveId => $composableBuilder(
      column: $table.lastActiveSleeveId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PersonsTableAnnotationComposer
    extends Composer<_$AppDb, $PersonsTable> {
  $$PersonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get lastActiveSleeveId => $composableBuilder(
      column: $table.lastActiveSleeveId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PersonsTableTableManager extends RootTableManager<
    _$AppDb,
    $PersonsTable,
    Person,
    $$PersonsTableFilterComposer,
    $$PersonsTableOrderingComposer,
    $$PersonsTableAnnotationComposer,
    $$PersonsTableCreateCompanionBuilder,
    $$PersonsTableUpdateCompanionBuilder,
    (Person, BaseReferences<_$AppDb, $PersonsTable, Person>),
    Person,
    PrefetchHooks Function()> {
  $$PersonsTableTableManager(_$AppDb db, $PersonsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> personId = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<String?> lastActiveSleeveId = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonsCompanion(
            personId: personId,
            displayName: displayName,
            role: role,
            language: language,
            lastActiveSleeveId: lastActiveSleeveId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String personId,
            required String displayName,
            required String role,
            Value<String> language = const Value.absent(),
            Value<String?> lastActiveSleeveId = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonsCompanion.insert(
            personId: personId,
            displayName: displayName,
            role: role,
            language: language,
            lastActiveSleeveId: lastActiveSleeveId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PersonsTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $PersonsTable,
    Person,
    $$PersonsTableFilterComposer,
    $$PersonsTableOrderingComposer,
    $$PersonsTableAnnotationComposer,
    $$PersonsTableCreateCompanionBuilder,
    $$PersonsTableUpdateCompanionBuilder,
    (Person, BaseReferences<_$AppDb, $PersonsTable, Person>),
    Person,
    PrefetchHooks Function()>;
typedef $$SleevesTableCreateCompanionBuilder = SleevesCompanion Function({
  required String sleeveId,
  required String personId,
  required String name,
  Value<int> sortOrder,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$SleevesTableUpdateCompanionBuilder = SleevesCompanion Function({
  Value<String> sleeveId,
  Value<String> personId,
  Value<String> name,
  Value<int> sortOrder,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$SleevesTableFilterComposer extends Composer<_$AppDb, $SleevesTable> {
  $$SleevesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sleeveId => $composableBuilder(
      column: $table.sleeveId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SleevesTableOrderingComposer extends Composer<_$AppDb, $SleevesTable> {
  $$SleevesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sleeveId => $composableBuilder(
      column: $table.sleeveId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SleevesTableAnnotationComposer
    extends Composer<_$AppDb, $SleevesTable> {
  $$SleevesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sleeveId =>
      $composableBuilder(column: $table.sleeveId, builder: (column) => column);

  GeneratedColumn<String> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SleevesTableTableManager extends RootTableManager<
    _$AppDb,
    $SleevesTable,
    Sleeve,
    $$SleevesTableFilterComposer,
    $$SleevesTableOrderingComposer,
    $$SleevesTableAnnotationComposer,
    $$SleevesTableCreateCompanionBuilder,
    $$SleevesTableUpdateCompanionBuilder,
    (Sleeve, BaseReferences<_$AppDb, $SleevesTable, Sleeve>),
    Sleeve,
    PrefetchHooks Function()> {
  $$SleevesTableTableManager(_$AppDb db, $SleevesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SleevesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SleevesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SleevesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> sleeveId = const Value.absent(),
            Value<String> personId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SleevesCompanion(
            sleeveId: sleeveId,
            personId: personId,
            name: name,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String sleeveId,
            required String personId,
            required String name,
            Value<int> sortOrder = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SleevesCompanion.insert(
            sleeveId: sleeveId,
            personId: personId,
            name: name,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SleevesTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $SleevesTable,
    Sleeve,
    $$SleevesTableFilterComposer,
    $$SleevesTableOrderingComposer,
    $$SleevesTableAnnotationComposer,
    $$SleevesTableCreateCompanionBuilder,
    $$SleevesTableUpdateCompanionBuilder,
    (Sleeve, BaseReferences<_$AppDb, $SleevesTable, Sleeve>),
    Sleeve,
    PrefetchHooks Function()>;
typedef $$RitualItemsTableCreateCompanionBuilder = RitualItemsCompanion
    Function({
  required String itemId,
  required String personId,
  required int slotIndex,
  Value<String> label,
  Value<String> state,
  Value<String?> activePath,
  Value<String?> archivedPath,
  Value<int> sizeBytes,
  Value<int> usageCountTotal,
  Value<int?> lastUsedAt,
  Value<String> sleeveId,
  Value<String> searchText,
  Value<int?> recordedAt,
  Value<int?> archivedAt,
  Value<String> integrityStatus,
  Value<int?> integrityCheckedAt,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$RitualItemsTableUpdateCompanionBuilder = RitualItemsCompanion
    Function({
  Value<String> itemId,
  Value<String> personId,
  Value<int> slotIndex,
  Value<String> label,
  Value<String> state,
  Value<String?> activePath,
  Value<String?> archivedPath,
  Value<int> sizeBytes,
  Value<int> usageCountTotal,
  Value<int?> lastUsedAt,
  Value<String> sleeveId,
  Value<String> searchText,
  Value<int?> recordedAt,
  Value<int?> archivedAt,
  Value<String> integrityStatus,
  Value<int?> integrityCheckedAt,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$RitualItemsTableFilterComposer
    extends Composer<_$AppDb, $RitualItemsTable> {
  $$RitualItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get slotIndex => $composableBuilder(
      column: $table.slotIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get activePath => $composableBuilder(
      column: $table.activePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get archivedPath => $composableBuilder(
      column: $table.archivedPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sizeBytes => $composableBuilder(
      column: $table.sizeBytes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get usageCountTotal => $composableBuilder(
      column: $table.usageCountTotal,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sleeveId => $composableBuilder(
      column: $table.sleeveId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get searchText => $composableBuilder(
      column: $table.searchText, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get integrityStatus => $composableBuilder(
      column: $table.integrityStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get integrityCheckedAt => $composableBuilder(
      column: $table.integrityCheckedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$RitualItemsTableOrderingComposer
    extends Composer<_$AppDb, $RitualItemsTable> {
  $$RitualItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get slotIndex => $composableBuilder(
      column: $table.slotIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get activePath => $composableBuilder(
      column: $table.activePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get archivedPath => $composableBuilder(
      column: $table.archivedPath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
      column: $table.sizeBytes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get usageCountTotal => $composableBuilder(
      column: $table.usageCountTotal,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sleeveId => $composableBuilder(
      column: $table.sleeveId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get searchText => $composableBuilder(
      column: $table.searchText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get integrityStatus => $composableBuilder(
      column: $table.integrityStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get integrityCheckedAt => $composableBuilder(
      column: $table.integrityCheckedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$RitualItemsTableAnnotationComposer
    extends Composer<_$AppDb, $RitualItemsTable> {
  $$RitualItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);

  GeneratedColumn<int> get slotIndex =>
      $composableBuilder(column: $table.slotIndex, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get activePath => $composableBuilder(
      column: $table.activePath, builder: (column) => column);

  GeneratedColumn<String> get archivedPath => $composableBuilder(
      column: $table.archivedPath, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<int> get usageCountTotal => $composableBuilder(
      column: $table.usageCountTotal, builder: (column) => column);

  GeneratedColumn<int> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => column);

  GeneratedColumn<String> get sleeveId =>
      $composableBuilder(column: $table.sleeveId, builder: (column) => column);

  GeneratedColumn<String> get searchText => $composableBuilder(
      column: $table.searchText, builder: (column) => column);

  GeneratedColumn<int> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => column);

  GeneratedColumn<int> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => column);

  GeneratedColumn<String> get integrityStatus => $composableBuilder(
      column: $table.integrityStatus, builder: (column) => column);

  GeneratedColumn<int> get integrityCheckedAt => $composableBuilder(
      column: $table.integrityCheckedAt, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RitualItemsTableTableManager extends RootTableManager<
    _$AppDb,
    $RitualItemsTable,
    RitualItem,
    $$RitualItemsTableFilterComposer,
    $$RitualItemsTableOrderingComposer,
    $$RitualItemsTableAnnotationComposer,
    $$RitualItemsTableCreateCompanionBuilder,
    $$RitualItemsTableUpdateCompanionBuilder,
    (RitualItem, BaseReferences<_$AppDb, $RitualItemsTable, RitualItem>),
    RitualItem,
    PrefetchHooks Function()> {
  $$RitualItemsTableTableManager(_$AppDb db, $RitualItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RitualItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RitualItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RitualItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> itemId = const Value.absent(),
            Value<String> personId = const Value.absent(),
            Value<int> slotIndex = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<String> state = const Value.absent(),
            Value<String?> activePath = const Value.absent(),
            Value<String?> archivedPath = const Value.absent(),
            Value<int> sizeBytes = const Value.absent(),
            Value<int> usageCountTotal = const Value.absent(),
            Value<int?> lastUsedAt = const Value.absent(),
            Value<String> sleeveId = const Value.absent(),
            Value<String> searchText = const Value.absent(),
            Value<int?> recordedAt = const Value.absent(),
            Value<int?> archivedAt = const Value.absent(),
            Value<String> integrityStatus = const Value.absent(),
            Value<int?> integrityCheckedAt = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RitualItemsCompanion(
            itemId: itemId,
            personId: personId,
            slotIndex: slotIndex,
            label: label,
            state: state,
            activePath: activePath,
            archivedPath: archivedPath,
            sizeBytes: sizeBytes,
            usageCountTotal: usageCountTotal,
            lastUsedAt: lastUsedAt,
            sleeveId: sleeveId,
            searchText: searchText,
            recordedAt: recordedAt,
            archivedAt: archivedAt,
            integrityStatus: integrityStatus,
            integrityCheckedAt: integrityCheckedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String itemId,
            required String personId,
            required int slotIndex,
            Value<String> label = const Value.absent(),
            Value<String> state = const Value.absent(),
            Value<String?> activePath = const Value.absent(),
            Value<String?> archivedPath = const Value.absent(),
            Value<int> sizeBytes = const Value.absent(),
            Value<int> usageCountTotal = const Value.absent(),
            Value<int?> lastUsedAt = const Value.absent(),
            Value<String> sleeveId = const Value.absent(),
            Value<String> searchText = const Value.absent(),
            Value<int?> recordedAt = const Value.absent(),
            Value<int?> archivedAt = const Value.absent(),
            Value<String> integrityStatus = const Value.absent(),
            Value<int?> integrityCheckedAt = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RitualItemsCompanion.insert(
            itemId: itemId,
            personId: personId,
            slotIndex: slotIndex,
            label: label,
            state: state,
            activePath: activePath,
            archivedPath: archivedPath,
            sizeBytes: sizeBytes,
            usageCountTotal: usageCountTotal,
            lastUsedAt: lastUsedAt,
            sleeveId: sleeveId,
            searchText: searchText,
            recordedAt: recordedAt,
            archivedAt: archivedAt,
            integrityStatus: integrityStatus,
            integrityCheckedAt: integrityCheckedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RitualItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $RitualItemsTable,
    RitualItem,
    $$RitualItemsTableFilterComposer,
    $$RitualItemsTableOrderingComposer,
    $$RitualItemsTableAnnotationComposer,
    $$RitualItemsTableCreateCompanionBuilder,
    $$RitualItemsTableUpdateCompanionBuilder,
    (RitualItem, BaseReferences<_$AppDb, $RitualItemsTable, RitualItem>),
    RitualItem,
    PrefetchHooks Function()>;
typedef $$RitualEventsTableCreateCompanionBuilder = RitualEventsCompanion
    Function({
  required String eventId,
  required String itemId,
  required String personId,
  required String eventType,
  required int timestamp,
  Value<String?> metadata,
  Value<String> sleeveId,
  Value<int?> slotIndex,
  Value<String> itemState,
  Value<String> path,
  Value<int> sizeBytes,
  Value<String> source,
  Value<String> enforcementMode,
  Value<int> rowid,
});
typedef $$RitualEventsTableUpdateCompanionBuilder = RitualEventsCompanion
    Function({
  Value<String> eventId,
  Value<String> itemId,
  Value<String> personId,
  Value<String> eventType,
  Value<int> timestamp,
  Value<String?> metadata,
  Value<String> sleeveId,
  Value<int?> slotIndex,
  Value<String> itemState,
  Value<String> path,
  Value<int> sizeBytes,
  Value<String> source,
  Value<String> enforcementMode,
  Value<int> rowid,
});

class $$RitualEventsTableFilterComposer
    extends Composer<_$AppDb, $RitualEventsTable> {
  $$RitualEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get eventId => $composableBuilder(
      column: $table.eventId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sleeveId => $composableBuilder(
      column: $table.sleeveId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get slotIndex => $composableBuilder(
      column: $table.slotIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemState => $composableBuilder(
      column: $table.itemState, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sizeBytes => $composableBuilder(
      column: $table.sizeBytes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get enforcementMode => $composableBuilder(
      column: $table.enforcementMode,
      builder: (column) => ColumnFilters(column));
}

class $$RitualEventsTableOrderingComposer
    extends Composer<_$AppDb, $RitualEventsTable> {
  $$RitualEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get eventId => $composableBuilder(
      column: $table.eventId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sleeveId => $composableBuilder(
      column: $table.sleeveId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get slotIndex => $composableBuilder(
      column: $table.slotIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemState => $composableBuilder(
      column: $table.itemState, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
      column: $table.sizeBytes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get enforcementMode => $composableBuilder(
      column: $table.enforcementMode,
      builder: (column) => ColumnOrderings(column));
}

class $$RitualEventsTableAnnotationComposer
    extends Composer<_$AppDb, $RitualEventsTable> {
  $$RitualEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<String> get sleeveId =>
      $composableBuilder(column: $table.sleeveId, builder: (column) => column);

  GeneratedColumn<int> get slotIndex =>
      $composableBuilder(column: $table.slotIndex, builder: (column) => column);

  GeneratedColumn<String> get itemState =>
      $composableBuilder(column: $table.itemState, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get enforcementMode => $composableBuilder(
      column: $table.enforcementMode, builder: (column) => column);
}

class $$RitualEventsTableTableManager extends RootTableManager<
    _$AppDb,
    $RitualEventsTable,
    RitualEvent,
    $$RitualEventsTableFilterComposer,
    $$RitualEventsTableOrderingComposer,
    $$RitualEventsTableAnnotationComposer,
    $$RitualEventsTableCreateCompanionBuilder,
    $$RitualEventsTableUpdateCompanionBuilder,
    (RitualEvent, BaseReferences<_$AppDb, $RitualEventsTable, RitualEvent>),
    RitualEvent,
    PrefetchHooks Function()> {
  $$RitualEventsTableTableManager(_$AppDb db, $RitualEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RitualEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RitualEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RitualEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> eventId = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<String> personId = const Value.absent(),
            Value<String> eventType = const Value.absent(),
            Value<int> timestamp = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<String> sleeveId = const Value.absent(),
            Value<int?> slotIndex = const Value.absent(),
            Value<String> itemState = const Value.absent(),
            Value<String> path = const Value.absent(),
            Value<int> sizeBytes = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String> enforcementMode = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RitualEventsCompanion(
            eventId: eventId,
            itemId: itemId,
            personId: personId,
            eventType: eventType,
            timestamp: timestamp,
            metadata: metadata,
            sleeveId: sleeveId,
            slotIndex: slotIndex,
            itemState: itemState,
            path: path,
            sizeBytes: sizeBytes,
            source: source,
            enforcementMode: enforcementMode,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String eventId,
            required String itemId,
            required String personId,
            required String eventType,
            required int timestamp,
            Value<String?> metadata = const Value.absent(),
            Value<String> sleeveId = const Value.absent(),
            Value<int?> slotIndex = const Value.absent(),
            Value<String> itemState = const Value.absent(),
            Value<String> path = const Value.absent(),
            Value<int> sizeBytes = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String> enforcementMode = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RitualEventsCompanion.insert(
            eventId: eventId,
            itemId: itemId,
            personId: personId,
            eventType: eventType,
            timestamp: timestamp,
            metadata: metadata,
            sleeveId: sleeveId,
            slotIndex: slotIndex,
            itemState: itemState,
            path: path,
            sizeBytes: sizeBytes,
            source: source,
            enforcementMode: enforcementMode,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RitualEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $RitualEventsTable,
    RitualEvent,
    $$RitualEventsTableFilterComposer,
    $$RitualEventsTableOrderingComposer,
    $$RitualEventsTableAnnotationComposer,
    $$RitualEventsTableCreateCompanionBuilder,
    $$RitualEventsTableUpdateCompanionBuilder,
    (RitualEvent, BaseReferences<_$AppDb, $RitualEventsTable, RitualEvent>),
    RitualEvent,
    PrefetchHooks Function()>;
typedef $$RitualSchedulesTableCreateCompanionBuilder = RitualSchedulesCompanion
    Function({
  required String scheduleId,
  required String itemId,
  required String personId,
  Value<String> kind,
  Value<String> label,
  Value<bool> enabled,
  required int hour,
  required int minute,
  required int weekdayMask,
  required int createdAt,
  required int updatedAt,
  Value<int?> lastTriggeredAt,
  Value<int?> nextTriggerAt,
  Value<int> rowid,
});
typedef $$RitualSchedulesTableUpdateCompanionBuilder = RitualSchedulesCompanion
    Function({
  Value<String> scheduleId,
  Value<String> itemId,
  Value<String> personId,
  Value<String> kind,
  Value<String> label,
  Value<bool> enabled,
  Value<int> hour,
  Value<int> minute,
  Value<int> weekdayMask,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> lastTriggeredAt,
  Value<int?> nextTriggerAt,
  Value<int> rowid,
});

class $$RitualSchedulesTableFilterComposer
    extends Composer<_$AppDb, $RitualSchedulesTable> {
  $$RitualSchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get scheduleId => $composableBuilder(
      column: $table.scheduleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hour => $composableBuilder(
      column: $table.hour, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minute => $composableBuilder(
      column: $table.minute, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weekdayMask => $composableBuilder(
      column: $table.weekdayMask, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastTriggeredAt => $composableBuilder(
      column: $table.lastTriggeredAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get nextTriggerAt => $composableBuilder(
      column: $table.nextTriggerAt, builder: (column) => ColumnFilters(column));
}

class $$RitualSchedulesTableOrderingComposer
    extends Composer<_$AppDb, $RitualSchedulesTable> {
  $$RitualSchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get scheduleId => $composableBuilder(
      column: $table.scheduleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hour => $composableBuilder(
      column: $table.hour, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minute => $composableBuilder(
      column: $table.minute, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weekdayMask => $composableBuilder(
      column: $table.weekdayMask, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastTriggeredAt => $composableBuilder(
      column: $table.lastTriggeredAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get nextTriggerAt => $composableBuilder(
      column: $table.nextTriggerAt,
      builder: (column) => ColumnOrderings(column));
}

class $$RitualSchedulesTableAnnotationComposer
    extends Composer<_$AppDb, $RitualSchedulesTable> {
  $$RitualSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get scheduleId => $composableBuilder(
      column: $table.scheduleId, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<int> get minute =>
      $composableBuilder(column: $table.minute, builder: (column) => column);

  GeneratedColumn<int> get weekdayMask => $composableBuilder(
      column: $table.weekdayMask, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get lastTriggeredAt => $composableBuilder(
      column: $table.lastTriggeredAt, builder: (column) => column);

  GeneratedColumn<int> get nextTriggerAt => $composableBuilder(
      column: $table.nextTriggerAt, builder: (column) => column);
}

class $$RitualSchedulesTableTableManager extends RootTableManager<
    _$AppDb,
    $RitualSchedulesTable,
    RitualSchedule,
    $$RitualSchedulesTableFilterComposer,
    $$RitualSchedulesTableOrderingComposer,
    $$RitualSchedulesTableAnnotationComposer,
    $$RitualSchedulesTableCreateCompanionBuilder,
    $$RitualSchedulesTableUpdateCompanionBuilder,
    (
      RitualSchedule,
      BaseReferences<_$AppDb, $RitualSchedulesTable, RitualSchedule>
    ),
    RitualSchedule,
    PrefetchHooks Function()> {
  $$RitualSchedulesTableTableManager(_$AppDb db, $RitualSchedulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RitualSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RitualSchedulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RitualSchedulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> scheduleId = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<String> personId = const Value.absent(),
            Value<String> kind = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<int> hour = const Value.absent(),
            Value<int> minute = const Value.absent(),
            Value<int> weekdayMask = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> lastTriggeredAt = const Value.absent(),
            Value<int?> nextTriggerAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RitualSchedulesCompanion(
            scheduleId: scheduleId,
            itemId: itemId,
            personId: personId,
            kind: kind,
            label: label,
            enabled: enabled,
            hour: hour,
            minute: minute,
            weekdayMask: weekdayMask,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastTriggeredAt: lastTriggeredAt,
            nextTriggerAt: nextTriggerAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String scheduleId,
            required String itemId,
            required String personId,
            Value<String> kind = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            required int hour,
            required int minute,
            required int weekdayMask,
            required int createdAt,
            required int updatedAt,
            Value<int?> lastTriggeredAt = const Value.absent(),
            Value<int?> nextTriggerAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RitualSchedulesCompanion.insert(
            scheduleId: scheduleId,
            itemId: itemId,
            personId: personId,
            kind: kind,
            label: label,
            enabled: enabled,
            hour: hour,
            minute: minute,
            weekdayMask: weekdayMask,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastTriggeredAt: lastTriggeredAt,
            nextTriggerAt: nextTriggerAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RitualSchedulesTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $RitualSchedulesTable,
    RitualSchedule,
    $$RitualSchedulesTableFilterComposer,
    $$RitualSchedulesTableOrderingComposer,
    $$RitualSchedulesTableAnnotationComposer,
    $$RitualSchedulesTableCreateCompanionBuilder,
    $$RitualSchedulesTableUpdateCompanionBuilder,
    (
      RitualSchedule,
      BaseReferences<_$AppDb, $RitualSchedulesTable, RitualSchedule>
    ),
    RitualSchedule,
    PrefetchHooks Function()>;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$PersonsTableTableManager get persons =>
      $$PersonsTableTableManager(_db, _db.persons);
  $$SleevesTableTableManager get sleeves =>
      $$SleevesTableTableManager(_db, _db.sleeves);
  $$RitualItemsTableTableManager get ritualItems =>
      $$RitualItemsTableTableManager(_db, _db.ritualItems);
  $$RitualEventsTableTableManager get ritualEvents =>
      $$RitualEventsTableTableManager(_db, _db.ritualEvents);
  $$RitualSchedulesTableTableManager get ritualSchedules =>
      $$RitualSchedulesTableTableManager(_db, _db.ritualSchedules);
}
