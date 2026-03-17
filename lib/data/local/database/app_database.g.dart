// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _institutionNameMeta = const VerificationMeta(
    'institutionName',
  );
  @override
  late final GeneratedColumn<String> institutionName = GeneratedColumn<String>(
    'institution_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountTypeMeta = const VerificationMeta(
    'accountType',
  );
  @override
  late final GeneratedColumn<String> accountType = GeneratedColumn<String>(
    'account_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountSubtypeMeta = const VerificationMeta(
    'accountSubtype',
  );
  @override
  late final GeneratedColumn<String> accountSubtype = GeneratedColumn<String>(
    'account_subtype',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _balanceCentsMeta = const VerificationMeta(
    'balanceCents',
  );
  @override
  late final GeneratedColumn<int> balanceCents = GeneratedColumn<int>(
    'balance_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _isAssetMeta = const VerificationMeta(
    'isAsset',
  );
  @override
  late final GeneratedColumn<bool> isAsset = GeneratedColumn<bool>(
    'is_asset',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_asset" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isHiddenMeta = const VerificationMeta(
    'isHidden',
  );
  @override
  late final GeneratedColumn<bool> isHidden = GeneratedColumn<bool>(
    'is_hidden',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_hidden" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bankConnectionIdMeta = const VerificationMeta(
    'bankConnectionId',
  );
  @override
  late final GeneratedColumn<String> bankConnectionId = GeneratedColumn<String>(
    'bank_connection_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<int> lastSyncedAt = GeneratedColumn<int>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _invertSignMeta = const VerificationMeta(
    'invertSign',
  );
  @override
  late final GeneratedColumn<bool> invertSign = GeneratedColumn<bool>(
    'invert_sign',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("invert_sign" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    institutionName,
    accountType,
    accountSubtype,
    balanceCents,
    currencyCode,
    isAsset,
    isHidden,
    displayOrder,
    color,
    icon,
    bankConnectionId,
    externalId,
    lastSyncedAt,
    createdAt,
    updatedAt,
    version,
    invertSign,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('institution_name')) {
      context.handle(
        _institutionNameMeta,
        institutionName.isAcceptableOrUnknown(
          data['institution_name']!,
          _institutionNameMeta,
        ),
      );
    }
    if (data.containsKey('account_type')) {
      context.handle(
        _accountTypeMeta,
        accountType.isAcceptableOrUnknown(
          data['account_type']!,
          _accountTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountTypeMeta);
    }
    if (data.containsKey('account_subtype')) {
      context.handle(
        _accountSubtypeMeta,
        accountSubtype.isAcceptableOrUnknown(
          data['account_subtype']!,
          _accountSubtypeMeta,
        ),
      );
    }
    if (data.containsKey('balance_cents')) {
      context.handle(
        _balanceCentsMeta,
        balanceCents.isAcceptableOrUnknown(
          data['balance_cents']!,
          _balanceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_balanceCentsMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('is_asset')) {
      context.handle(
        _isAssetMeta,
        isAsset.isAcceptableOrUnknown(data['is_asset']!, _isAssetMeta),
      );
    } else if (isInserting) {
      context.missing(_isAssetMeta);
    }
    if (data.containsKey('is_hidden')) {
      context.handle(
        _isHiddenMeta,
        isHidden.isAcceptableOrUnknown(data['is_hidden']!, _isHiddenMeta),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayOrderMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('bank_connection_id')) {
      context.handle(
        _bankConnectionIdMeta,
        bankConnectionId.isAcceptableOrUnknown(
          data['bank_connection_id']!,
          _bankConnectionIdMeta,
        ),
      );
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('invert_sign')) {
      context.handle(
        _invertSignMeta,
        invertSign.isAcceptableOrUnknown(data['invert_sign']!, _invertSignMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      institutionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}institution_name'],
      ),
      accountType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_type'],
      )!,
      accountSubtype: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_subtype'],
      ),
      balanceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_cents'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      isAsset: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_asset'],
      )!,
      isHidden: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_hidden'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      bankConnectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_connection_id'],
      ),
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      ),
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_synced_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      invertSign: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}invert_sign'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final String id;
  final String name;
  final String? institutionName;
  final String accountType;
  final String? accountSubtype;
  final int balanceCents;
  final String currencyCode;
  final bool isAsset;
  final bool isHidden;
  final int displayOrder;
  final int? color;
  final String? icon;
  final String? bankConnectionId;
  final String? externalId;
  final int? lastSyncedAt;
  final int createdAt;
  final int updatedAt;
  final int version;
  final bool invertSign;
  final int syncStatus;
  const Account({
    required this.id,
    required this.name,
    this.institutionName,
    required this.accountType,
    this.accountSubtype,
    required this.balanceCents,
    required this.currencyCode,
    required this.isAsset,
    required this.isHidden,
    required this.displayOrder,
    this.color,
    this.icon,
    this.bankConnectionId,
    this.externalId,
    this.lastSyncedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.invertSign,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || institutionName != null) {
      map['institution_name'] = Variable<String>(institutionName);
    }
    map['account_type'] = Variable<String>(accountType);
    if (!nullToAbsent || accountSubtype != null) {
      map['account_subtype'] = Variable<String>(accountSubtype);
    }
    map['balance_cents'] = Variable<int>(balanceCents);
    map['currency_code'] = Variable<String>(currencyCode);
    map['is_asset'] = Variable<bool>(isAsset);
    map['is_hidden'] = Variable<bool>(isHidden);
    map['display_order'] = Variable<int>(displayOrder);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || bankConnectionId != null) {
      map['bank_connection_id'] = Variable<String>(bankConnectionId);
    }
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<int>(lastSyncedAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['version'] = Variable<int>(version);
    map['invert_sign'] = Variable<bool>(invertSign);
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      institutionName: institutionName == null && nullToAbsent
          ? const Value.absent()
          : Value(institutionName),
      accountType: Value(accountType),
      accountSubtype: accountSubtype == null && nullToAbsent
          ? const Value.absent()
          : Value(accountSubtype),
      balanceCents: Value(balanceCents),
      currencyCode: Value(currencyCode),
      isAsset: Value(isAsset),
      isHidden: Value(isHidden),
      displayOrder: Value(displayOrder),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      bankConnectionId: bankConnectionId == null && nullToAbsent
          ? const Value.absent()
          : Value(bankConnectionId),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      invertSign: Value(invertSign),
      syncStatus: Value(syncStatus),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      institutionName: serializer.fromJson<String?>(json['institutionName']),
      accountType: serializer.fromJson<String>(json['accountType']),
      accountSubtype: serializer.fromJson<String?>(json['accountSubtype']),
      balanceCents: serializer.fromJson<int>(json['balanceCents']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      isAsset: serializer.fromJson<bool>(json['isAsset']),
      isHidden: serializer.fromJson<bool>(json['isHidden']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      color: serializer.fromJson<int?>(json['color']),
      icon: serializer.fromJson<String?>(json['icon']),
      bankConnectionId: serializer.fromJson<String?>(json['bankConnectionId']),
      externalId: serializer.fromJson<String?>(json['externalId']),
      lastSyncedAt: serializer.fromJson<int?>(json['lastSyncedAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      invertSign: serializer.fromJson<bool>(json['invertSign']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'institutionName': serializer.toJson<String?>(institutionName),
      'accountType': serializer.toJson<String>(accountType),
      'accountSubtype': serializer.toJson<String?>(accountSubtype),
      'balanceCents': serializer.toJson<int>(balanceCents),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'isAsset': serializer.toJson<bool>(isAsset),
      'isHidden': serializer.toJson<bool>(isHidden),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'color': serializer.toJson<int?>(color),
      'icon': serializer.toJson<String?>(icon),
      'bankConnectionId': serializer.toJson<String?>(bankConnectionId),
      'externalId': serializer.toJson<String?>(externalId),
      'lastSyncedAt': serializer.toJson<int?>(lastSyncedAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'version': serializer.toJson<int>(version),
      'invertSign': serializer.toJson<bool>(invertSign),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  Account copyWith({
    String? id,
    String? name,
    Value<String?> institutionName = const Value.absent(),
    String? accountType,
    Value<String?> accountSubtype = const Value.absent(),
    int? balanceCents,
    String? currencyCode,
    bool? isAsset,
    bool? isHidden,
    int? displayOrder,
    Value<int?> color = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    Value<String?> bankConnectionId = const Value.absent(),
    Value<String?> externalId = const Value.absent(),
    Value<int?> lastSyncedAt = const Value.absent(),
    int? createdAt,
    int? updatedAt,
    int? version,
    bool? invertSign,
    int? syncStatus,
  }) => Account(
    id: id ?? this.id,
    name: name ?? this.name,
    institutionName: institutionName.present
        ? institutionName.value
        : this.institutionName,
    accountType: accountType ?? this.accountType,
    accountSubtype: accountSubtype.present
        ? accountSubtype.value
        : this.accountSubtype,
    balanceCents: balanceCents ?? this.balanceCents,
    currencyCode: currencyCode ?? this.currencyCode,
    isAsset: isAsset ?? this.isAsset,
    isHidden: isHidden ?? this.isHidden,
    displayOrder: displayOrder ?? this.displayOrder,
    color: color.present ? color.value : this.color,
    icon: icon.present ? icon.value : this.icon,
    bankConnectionId: bankConnectionId.present
        ? bankConnectionId.value
        : this.bankConnectionId,
    externalId: externalId.present ? externalId.value : this.externalId,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    invertSign: invertSign ?? this.invertSign,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      institutionName: data.institutionName.present
          ? data.institutionName.value
          : this.institutionName,
      accountType: data.accountType.present
          ? data.accountType.value
          : this.accountType,
      accountSubtype: data.accountSubtype.present
          ? data.accountSubtype.value
          : this.accountSubtype,
      balanceCents: data.balanceCents.present
          ? data.balanceCents.value
          : this.balanceCents,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      isAsset: data.isAsset.present ? data.isAsset.value : this.isAsset,
      isHidden: data.isHidden.present ? data.isHidden.value : this.isHidden,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      bankConnectionId: data.bankConnectionId.present
          ? data.bankConnectionId.value
          : this.bankConnectionId,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      invertSign: data.invertSign.present
          ? data.invertSign.value
          : this.invertSign,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('institutionName: $institutionName, ')
          ..write('accountType: $accountType, ')
          ..write('accountSubtype: $accountSubtype, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('isAsset: $isAsset, ')
          ..write('isHidden: $isHidden, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('bankConnectionId: $bankConnectionId, ')
          ..write('externalId: $externalId, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('invertSign: $invertSign, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    institutionName,
    accountType,
    accountSubtype,
    balanceCents,
    currencyCode,
    isAsset,
    isHidden,
    displayOrder,
    color,
    icon,
    bankConnectionId,
    externalId,
    lastSyncedAt,
    createdAt,
    updatedAt,
    version,
    invertSign,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.name == this.name &&
          other.institutionName == this.institutionName &&
          other.accountType == this.accountType &&
          other.accountSubtype == this.accountSubtype &&
          other.balanceCents == this.balanceCents &&
          other.currencyCode == this.currencyCode &&
          other.isAsset == this.isAsset &&
          other.isHidden == this.isHidden &&
          other.displayOrder == this.displayOrder &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.bankConnectionId == this.bankConnectionId &&
          other.externalId == this.externalId &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.invertSign == this.invertSign &&
          other.syncStatus == this.syncStatus);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> institutionName;
  final Value<String> accountType;
  final Value<String?> accountSubtype;
  final Value<int> balanceCents;
  final Value<String> currencyCode;
  final Value<bool> isAsset;
  final Value<bool> isHidden;
  final Value<int> displayOrder;
  final Value<int?> color;
  final Value<String?> icon;
  final Value<String?> bankConnectionId;
  final Value<String?> externalId;
  final Value<int?> lastSyncedAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> version;
  final Value<bool> invertSign;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.institutionName = const Value.absent(),
    this.accountType = const Value.absent(),
    this.accountSubtype = const Value.absent(),
    this.balanceCents = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.isAsset = const Value.absent(),
    this.isHidden = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.bankConnectionId = const Value.absent(),
    this.externalId = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.invertSign = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required String name,
    this.institutionName = const Value.absent(),
    required String accountType,
    this.accountSubtype = const Value.absent(),
    required int balanceCents,
    this.currencyCode = const Value.absent(),
    required bool isAsset,
    this.isHidden = const Value.absent(),
    required int displayOrder,
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.bankConnectionId = const Value.absent(),
    this.externalId = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.version = const Value.absent(),
    this.invertSign = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       accountType = Value(accountType),
       balanceCents = Value(balanceCents),
       isAsset = Value(isAsset),
       displayOrder = Value(displayOrder),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Account> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? institutionName,
    Expression<String>? accountType,
    Expression<String>? accountSubtype,
    Expression<int>? balanceCents,
    Expression<String>? currencyCode,
    Expression<bool>? isAsset,
    Expression<bool>? isHidden,
    Expression<int>? displayOrder,
    Expression<int>? color,
    Expression<String>? icon,
    Expression<String>? bankConnectionId,
    Expression<String>? externalId,
    Expression<int>? lastSyncedAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? version,
    Expression<bool>? invertSign,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (institutionName != null) 'institution_name': institutionName,
      if (accountType != null) 'account_type': accountType,
      if (accountSubtype != null) 'account_subtype': accountSubtype,
      if (balanceCents != null) 'balance_cents': balanceCents,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (isAsset != null) 'is_asset': isAsset,
      if (isHidden != null) 'is_hidden': isHidden,
      if (displayOrder != null) 'display_order': displayOrder,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (bankConnectionId != null) 'bank_connection_id': bankConnectionId,
      if (externalId != null) 'external_id': externalId,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (invertSign != null) 'invert_sign': invertSign,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? institutionName,
    Value<String>? accountType,
    Value<String?>? accountSubtype,
    Value<int>? balanceCents,
    Value<String>? currencyCode,
    Value<bool>? isAsset,
    Value<bool>? isHidden,
    Value<int>? displayOrder,
    Value<int?>? color,
    Value<String?>? icon,
    Value<String?>? bankConnectionId,
    Value<String?>? externalId,
    Value<int?>? lastSyncedAt,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? version,
    Value<bool>? invertSign,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      institutionName: institutionName ?? this.institutionName,
      accountType: accountType ?? this.accountType,
      accountSubtype: accountSubtype ?? this.accountSubtype,
      balanceCents: balanceCents ?? this.balanceCents,
      currencyCode: currencyCode ?? this.currencyCode,
      isAsset: isAsset ?? this.isAsset,
      isHidden: isHidden ?? this.isHidden,
      displayOrder: displayOrder ?? this.displayOrder,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      bankConnectionId: bankConnectionId ?? this.bankConnectionId,
      externalId: externalId ?? this.externalId,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      invertSign: invertSign ?? this.invertSign,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (institutionName.present) {
      map['institution_name'] = Variable<String>(institutionName.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<String>(accountType.value);
    }
    if (accountSubtype.present) {
      map['account_subtype'] = Variable<String>(accountSubtype.value);
    }
    if (balanceCents.present) {
      map['balance_cents'] = Variable<int>(balanceCents.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (isAsset.present) {
      map['is_asset'] = Variable<bool>(isAsset.value);
    }
    if (isHidden.present) {
      map['is_hidden'] = Variable<bool>(isHidden.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (bankConnectionId.present) {
      map['bank_connection_id'] = Variable<String>(bankConnectionId.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<int>(lastSyncedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (invertSign.present) {
      map['invert_sign'] = Variable<bool>(invertSign.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('institutionName: $institutionName, ')
          ..write('accountType: $accountType, ')
          ..write('accountSubtype: $accountSubtype, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('isAsset: $isAsset, ')
          ..write('isHidden: $isHidden, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('bankConnectionId: $bankConnectionId, ')
          ..write('externalId: $externalId, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('invertSign: $invertSign, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payeeMeta = const VerificationMeta('payee');
  @override
  late final GeneratedColumn<String> payee = GeneratedColumn<String>(
    'payee',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isReviewedMeta = const VerificationMeta(
    'isReviewed',
  );
  @override
  late final GeneratedColumn<bool> isReviewed = GeneratedColumn<bool>(
    'is_reviewed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_reviewed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isPendingMeta = const VerificationMeta(
    'isPending',
  );
  @override
  late final GeneratedColumn<bool> isPending = GeneratedColumn<bool>(
    'is_pending',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pending" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _transferAccountIdMeta = const VerificationMeta(
    'transferAccountId',
  );
  @override
  late final GeneratedColumn<String> transferAccountId =
      GeneratedColumn<String>(
        'transfer_account_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _transferTransactionIdMeta =
      const VerificationMeta('transferTransactionId');
  @override
  late final GeneratedColumn<String> transferTransactionId =
      GeneratedColumn<String>(
        'transfer_transaction_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    amountCents,
    date,
    payee,
    notes,
    categoryId,
    isReviewed,
    isPending,
    transferAccountId,
    transferTransactionId,
    externalId,
    tags,
    createdAt,
    updatedAt,
    version,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('payee')) {
      context.handle(
        _payeeMeta,
        payee.isAcceptableOrUnknown(data['payee']!, _payeeMeta),
      );
    } else if (isInserting) {
      context.missing(_payeeMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('is_reviewed')) {
      context.handle(
        _isReviewedMeta,
        isReviewed.isAcceptableOrUnknown(data['is_reviewed']!, _isReviewedMeta),
      );
    }
    if (data.containsKey('is_pending')) {
      context.handle(
        _isPendingMeta,
        isPending.isAcceptableOrUnknown(data['is_pending']!, _isPendingMeta),
      );
    }
    if (data.containsKey('transfer_account_id')) {
      context.handle(
        _transferAccountIdMeta,
        transferAccountId.isAcceptableOrUnknown(
          data['transfer_account_id']!,
          _transferAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('transfer_transaction_id')) {
      context.handle(
        _transferTransactionIdMeta,
        transferTransactionId.isAcceptableOrUnknown(
          data['transfer_transaction_id']!,
          _transferTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      payee: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payee'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      isReviewed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_reviewed'],
      )!,
      isPending: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pending'],
      )!,
      transferAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transfer_account_id'],
      ),
      transferTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transfer_transaction_id'],
      ),
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final String id;
  final String accountId;
  final int amountCents;
  final int date;
  final String payee;
  final String? notes;
  final String? categoryId;
  final bool isReviewed;
  final bool isPending;
  final String? transferAccountId;
  final String? transferTransactionId;
  final String? externalId;
  final String? tags;
  final int createdAt;
  final int updatedAt;
  final int version;
  final int syncStatus;
  const Transaction({
    required this.id,
    required this.accountId,
    required this.amountCents,
    required this.date,
    required this.payee,
    this.notes,
    this.categoryId,
    required this.isReviewed,
    required this.isPending,
    this.transferAccountId,
    this.transferTransactionId,
    this.externalId,
    this.tags,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['amount_cents'] = Variable<int>(amountCents);
    map['date'] = Variable<int>(date);
    map['payee'] = Variable<String>(payee);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['is_reviewed'] = Variable<bool>(isReviewed);
    map['is_pending'] = Variable<bool>(isPending);
    if (!nullToAbsent || transferAccountId != null) {
      map['transfer_account_id'] = Variable<String>(transferAccountId);
    }
    if (!nullToAbsent || transferTransactionId != null) {
      map['transfer_transaction_id'] = Variable<String>(transferTransactionId);
    }
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['version'] = Variable<int>(version);
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      amountCents: Value(amountCents),
      date: Value(date),
      payee: Value(payee),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      isReviewed: Value(isReviewed),
      isPending: Value(isPending),
      transferAccountId: transferAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferAccountId),
      transferTransactionId: transferTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferTransactionId),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      syncStatus: Value(syncStatus),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      date: serializer.fromJson<int>(json['date']),
      payee: serializer.fromJson<String>(json['payee']),
      notes: serializer.fromJson<String?>(json['notes']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      isReviewed: serializer.fromJson<bool>(json['isReviewed']),
      isPending: serializer.fromJson<bool>(json['isPending']),
      transferAccountId: serializer.fromJson<String?>(
        json['transferAccountId'],
      ),
      transferTransactionId: serializer.fromJson<String?>(
        json['transferTransactionId'],
      ),
      externalId: serializer.fromJson<String?>(json['externalId']),
      tags: serializer.fromJson<String?>(json['tags']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'amountCents': serializer.toJson<int>(amountCents),
      'date': serializer.toJson<int>(date),
      'payee': serializer.toJson<String>(payee),
      'notes': serializer.toJson<String?>(notes),
      'categoryId': serializer.toJson<String?>(categoryId),
      'isReviewed': serializer.toJson<bool>(isReviewed),
      'isPending': serializer.toJson<bool>(isPending),
      'transferAccountId': serializer.toJson<String?>(transferAccountId),
      'transferTransactionId': serializer.toJson<String?>(
        transferTransactionId,
      ),
      'externalId': serializer.toJson<String?>(externalId),
      'tags': serializer.toJson<String?>(tags),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'version': serializer.toJson<int>(version),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  Transaction copyWith({
    String? id,
    String? accountId,
    int? amountCents,
    int? date,
    String? payee,
    Value<String?> notes = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    bool? isReviewed,
    bool? isPending,
    Value<String?> transferAccountId = const Value.absent(),
    Value<String?> transferTransactionId = const Value.absent(),
    Value<String?> externalId = const Value.absent(),
    Value<String?> tags = const Value.absent(),
    int? createdAt,
    int? updatedAt,
    int? version,
    int? syncStatus,
  }) => Transaction(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    amountCents: amountCents ?? this.amountCents,
    date: date ?? this.date,
    payee: payee ?? this.payee,
    notes: notes.present ? notes.value : this.notes,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    isReviewed: isReviewed ?? this.isReviewed,
    isPending: isPending ?? this.isPending,
    transferAccountId: transferAccountId.present
        ? transferAccountId.value
        : this.transferAccountId,
    transferTransactionId: transferTransactionId.present
        ? transferTransactionId.value
        : this.transferTransactionId,
    externalId: externalId.present ? externalId.value : this.externalId,
    tags: tags.present ? tags.value : this.tags,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      date: data.date.present ? data.date.value : this.date,
      payee: data.payee.present ? data.payee.value : this.payee,
      notes: data.notes.present ? data.notes.value : this.notes,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      isReviewed: data.isReviewed.present
          ? data.isReviewed.value
          : this.isReviewed,
      isPending: data.isPending.present ? data.isPending.value : this.isPending,
      transferAccountId: data.transferAccountId.present
          ? data.transferAccountId.value
          : this.transferAccountId,
      transferTransactionId: data.transferTransactionId.present
          ? data.transferTransactionId.value
          : this.transferTransactionId,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      tags: data.tags.present ? data.tags.value : this.tags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('amountCents: $amountCents, ')
          ..write('date: $date, ')
          ..write('payee: $payee, ')
          ..write('notes: $notes, ')
          ..write('categoryId: $categoryId, ')
          ..write('isReviewed: $isReviewed, ')
          ..write('isPending: $isPending, ')
          ..write('transferAccountId: $transferAccountId, ')
          ..write('transferTransactionId: $transferTransactionId, ')
          ..write('externalId: $externalId, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    amountCents,
    date,
    payee,
    notes,
    categoryId,
    isReviewed,
    isPending,
    transferAccountId,
    transferTransactionId,
    externalId,
    tags,
    createdAt,
    updatedAt,
    version,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.amountCents == this.amountCents &&
          other.date == this.date &&
          other.payee == this.payee &&
          other.notes == this.notes &&
          other.categoryId == this.categoryId &&
          other.isReviewed == this.isReviewed &&
          other.isPending == this.isPending &&
          other.transferAccountId == this.transferAccountId &&
          other.transferTransactionId == this.transferTransactionId &&
          other.externalId == this.externalId &&
          other.tags == this.tags &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.syncStatus == this.syncStatus);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<int> amountCents;
  final Value<int> date;
  final Value<String> payee;
  final Value<String?> notes;
  final Value<String?> categoryId;
  final Value<bool> isReviewed;
  final Value<bool> isPending;
  final Value<String?> transferAccountId;
  final Value<String?> transferTransactionId;
  final Value<String?> externalId;
  final Value<String?> tags;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> version;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.date = const Value.absent(),
    this.payee = const Value.absent(),
    this.notes = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.isReviewed = const Value.absent(),
    this.isPending = const Value.absent(),
    this.transferAccountId = const Value.absent(),
    this.transferTransactionId = const Value.absent(),
    this.externalId = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required String accountId,
    required int amountCents,
    required int date,
    required String payee,
    this.notes = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.isReviewed = const Value.absent(),
    this.isPending = const Value.absent(),
    this.transferAccountId = const Value.absent(),
    this.transferTransactionId = const Value.absent(),
    this.externalId = const Value.absent(),
    this.tags = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.version = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       amountCents = Value(amountCents),
       date = Value(date),
       payee = Value(payee),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Transaction> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<int>? amountCents,
    Expression<int>? date,
    Expression<String>? payee,
    Expression<String>? notes,
    Expression<String>? categoryId,
    Expression<bool>? isReviewed,
    Expression<bool>? isPending,
    Expression<String>? transferAccountId,
    Expression<String>? transferTransactionId,
    Expression<String>? externalId,
    Expression<String>? tags,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? version,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (amountCents != null) 'amount_cents': amountCents,
      if (date != null) 'date': date,
      if (payee != null) 'payee': payee,
      if (notes != null) 'notes': notes,
      if (categoryId != null) 'category_id': categoryId,
      if (isReviewed != null) 'is_reviewed': isReviewed,
      if (isPending != null) 'is_pending': isPending,
      if (transferAccountId != null) 'transfer_account_id': transferAccountId,
      if (transferTransactionId != null)
        'transfer_transaction_id': transferTransactionId,
      if (externalId != null) 'external_id': externalId,
      if (tags != null) 'tags': tags,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<int>? amountCents,
    Value<int>? date,
    Value<String>? payee,
    Value<String?>? notes,
    Value<String?>? categoryId,
    Value<bool>? isReviewed,
    Value<bool>? isPending,
    Value<String?>? transferAccountId,
    Value<String?>? transferTransactionId,
    Value<String?>? externalId,
    Value<String?>? tags,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? version,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      amountCents: amountCents ?? this.amountCents,
      date: date ?? this.date,
      payee: payee ?? this.payee,
      notes: notes ?? this.notes,
      categoryId: categoryId ?? this.categoryId,
      isReviewed: isReviewed ?? this.isReviewed,
      isPending: isPending ?? this.isPending,
      transferAccountId: transferAccountId ?? this.transferAccountId,
      transferTransactionId:
          transferTransactionId ?? this.transferTransactionId,
      externalId: externalId ?? this.externalId,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (payee.present) {
      map['payee'] = Variable<String>(payee.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (isReviewed.present) {
      map['is_reviewed'] = Variable<bool>(isReviewed.value);
    }
    if (isPending.present) {
      map['is_pending'] = Variable<bool>(isPending.value);
    }
    if (transferAccountId.present) {
      map['transfer_account_id'] = Variable<String>(transferAccountId.value);
    }
    if (transferTransactionId.present) {
      map['transfer_transaction_id'] = Variable<String>(
        transferTransactionId.value,
      );
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('amountCents: $amountCents, ')
          ..write('date: $date, ')
          ..write('payee: $payee, ')
          ..write('notes: $notes, ')
          ..write('categoryId: $categoryId, ')
          ..write('isReviewed: $isReviewed, ')
          ..write('isPending: $isPending, ')
          ..write('transferAccountId: $transferAccountId, ')
          ..write('transferTransactionId: $transferTransactionId, ')
          ..write('externalId: $externalId, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    parentId,
    type,
    icon,
    color,
    displayOrder,
    isSystem,
    createdAt,
    updatedAt,
    version,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayOrderMeta);
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String name;
  final String? parentId;
  final String type;
  final String icon;
  final int color;
  final int displayOrder;
  final bool isSystem;
  final int createdAt;
  final int updatedAt;
  final int version;
  final int syncStatus;
  const Category({
    required this.id,
    required this.name,
    this.parentId,
    required this.type,
    required this.icon,
    required this.color,
    required this.displayOrder,
    required this.isSystem,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['type'] = Variable<String>(type);
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<int>(color);
    map['display_order'] = Variable<int>(displayOrder);
    map['is_system'] = Variable<bool>(isSystem);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['version'] = Variable<int>(version);
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      type: Value(type),
      icon: Value(icon),
      color: Value(color),
      displayOrder: Value(displayOrder),
      isSystem: Value(isSystem),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      syncStatus: Value(syncStatus),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      type: serializer.fromJson<String>(json['type']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<int>(json['color']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<String?>(parentId),
      'type': serializer.toJson<String>(type),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<int>(color),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'isSystem': serializer.toJson<bool>(isSystem),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'version': serializer.toJson<int>(version),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  Category copyWith({
    String? id,
    String? name,
    Value<String?> parentId = const Value.absent(),
    String? type,
    String? icon,
    int? color,
    int? displayOrder,
    bool? isSystem,
    int? createdAt,
    int? updatedAt,
    int? version,
    int? syncStatus,
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    parentId: parentId.present ? parentId.value : this.parentId,
    type: type ?? this.type,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    displayOrder: displayOrder ?? this.displayOrder,
    isSystem: isSystem ?? this.isSystem,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      type: data.type.present ? data.type.value : this.type,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('type: $type, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isSystem: $isSystem, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    parentId,
    type,
    icon,
    color,
    displayOrder,
    isSystem,
    createdAt,
    updatedAt,
    version,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.type == this.type &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.displayOrder == this.displayOrder &&
          other.isSystem == this.isSystem &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.syncStatus == this.syncStatus);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> parentId;
  final Value<String> type;
  final Value<String> icon;
  final Value<int> color;
  final Value<int> displayOrder;
  final Value<bool> isSystem;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> version;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.type = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    this.parentId = const Value.absent(),
    required String type,
    required String icon,
    required int color,
    required int displayOrder,
    this.isSystem = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.version = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       icon = Value(icon),
       color = Value(color),
       displayOrder = Value(displayOrder),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? parentId,
    Expression<String>? type,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<int>? displayOrder,
    Expression<bool>? isSystem,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? version,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (type != null) 'type': type,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (displayOrder != null) 'display_order': displayOrder,
      if (isSystem != null) 'is_system': isSystem,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? parentId,
    Value<String>? type,
    Value<String>? icon,
    Value<int>? color,
    Value<int>? displayOrder,
    Value<bool>? isSystem,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? version,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      displayOrder: displayOrder ?? this.displayOrder,
      isSystem: isSystem ?? this.isSystem,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('type: $type, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isSystem: $isSystem, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodTypeMeta = const VerificationMeta(
    'periodType',
  );
  @override
  late final GeneratedColumn<String> periodType = GeneratedColumn<String>(
    'period_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<int> startDate = GeneratedColumn<int>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<int> endDate = GeneratedColumn<int>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rolloverMeta = const VerificationMeta(
    'rollover',
  );
  @override
  late final GeneratedColumn<bool> rollover = GeneratedColumn<bool>(
    'rollover',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("rollover" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _rolloverAmountCentsMeta =
      const VerificationMeta('rolloverAmountCents');
  @override
  late final GeneratedColumn<int> rolloverAmountCents = GeneratedColumn<int>(
    'rollover_amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _alertThresholdMeta = const VerificationMeta(
    'alertThreshold',
  );
  @override
  late final GeneratedColumn<double> alertThreshold = GeneratedColumn<double>(
    'alert_threshold',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.9),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    amountCents,
    periodType,
    startDate,
    endDate,
    rollover,
    rolloverAmountCents,
    alertThreshold,
    createdAt,
    updatedAt,
    version,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Budget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('period_type')) {
      context.handle(
        _periodTypeMeta,
        periodType.isAcceptableOrUnknown(data['period_type']!, _periodTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_periodTypeMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('rollover')) {
      context.handle(
        _rolloverMeta,
        rollover.isAcceptableOrUnknown(data['rollover']!, _rolloverMeta),
      );
    }
    if (data.containsKey('rollover_amount_cents')) {
      context.handle(
        _rolloverAmountCentsMeta,
        rolloverAmountCents.isAcceptableOrUnknown(
          data['rollover_amount_cents']!,
          _rolloverAmountCentsMeta,
        ),
      );
    }
    if (data.containsKey('alert_threshold')) {
      context.handle(
        _alertThresholdMeta,
        alertThreshold.isAcceptableOrUnknown(
          data['alert_threshold']!,
          _alertThresholdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      periodType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period_type'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_date'],
      ),
      rollover: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}rollover'],
      )!,
      rolloverAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rollover_amount_cents'],
      )!,
      alertThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}alert_threshold'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class Budget extends DataClass implements Insertable<Budget> {
  final String id;
  final String categoryId;
  final int amountCents;
  final String periodType;
  final int startDate;
  final int? endDate;
  final bool rollover;
  final int rolloverAmountCents;
  final double alertThreshold;
  final int createdAt;
  final int updatedAt;
  final int version;
  final int syncStatus;
  const Budget({
    required this.id,
    required this.categoryId,
    required this.amountCents,
    required this.periodType,
    required this.startDate,
    this.endDate,
    required this.rollover,
    required this.rolloverAmountCents,
    required this.alertThreshold,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category_id'] = Variable<String>(categoryId);
    map['amount_cents'] = Variable<int>(amountCents);
    map['period_type'] = Variable<String>(periodType);
    map['start_date'] = Variable<int>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<int>(endDate);
    }
    map['rollover'] = Variable<bool>(rollover);
    map['rollover_amount_cents'] = Variable<int>(rolloverAmountCents);
    map['alert_threshold'] = Variable<double>(alertThreshold);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['version'] = Variable<int>(version);
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      amountCents: Value(amountCents),
      periodType: Value(periodType),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      rollover: Value(rollover),
      rolloverAmountCents: Value(rolloverAmountCents),
      alertThreshold: Value(alertThreshold),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      syncStatus: Value(syncStatus),
    );
  }

  factory Budget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      id: serializer.fromJson<String>(json['id']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      periodType: serializer.fromJson<String>(json['periodType']),
      startDate: serializer.fromJson<int>(json['startDate']),
      endDate: serializer.fromJson<int?>(json['endDate']),
      rollover: serializer.fromJson<bool>(json['rollover']),
      rolloverAmountCents: serializer.fromJson<int>(
        json['rolloverAmountCents'],
      ),
      alertThreshold: serializer.fromJson<double>(json['alertThreshold']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoryId': serializer.toJson<String>(categoryId),
      'amountCents': serializer.toJson<int>(amountCents),
      'periodType': serializer.toJson<String>(periodType),
      'startDate': serializer.toJson<int>(startDate),
      'endDate': serializer.toJson<int?>(endDate),
      'rollover': serializer.toJson<bool>(rollover),
      'rolloverAmountCents': serializer.toJson<int>(rolloverAmountCents),
      'alertThreshold': serializer.toJson<double>(alertThreshold),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'version': serializer.toJson<int>(version),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  Budget copyWith({
    String? id,
    String? categoryId,
    int? amountCents,
    String? periodType,
    int? startDate,
    Value<int?> endDate = const Value.absent(),
    bool? rollover,
    int? rolloverAmountCents,
    double? alertThreshold,
    int? createdAt,
    int? updatedAt,
    int? version,
    int? syncStatus,
  }) => Budget(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    amountCents: amountCents ?? this.amountCents,
    periodType: periodType ?? this.periodType,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    rollover: rollover ?? this.rollover,
    rolloverAmountCents: rolloverAmountCents ?? this.rolloverAmountCents,
    alertThreshold: alertThreshold ?? this.alertThreshold,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  Budget copyWithCompanion(BudgetsCompanion data) {
    return Budget(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      periodType: data.periodType.present
          ? data.periodType.value
          : this.periodType,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      rollover: data.rollover.present ? data.rollover.value : this.rollover,
      rolloverAmountCents: data.rolloverAmountCents.present
          ? data.rolloverAmountCents.value
          : this.rolloverAmountCents,
      alertThreshold: data.alertThreshold.present
          ? data.alertThreshold.value
          : this.alertThreshold,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('amountCents: $amountCents, ')
          ..write('periodType: $periodType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('rollover: $rollover, ')
          ..write('rolloverAmountCents: $rolloverAmountCents, ')
          ..write('alertThreshold: $alertThreshold, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryId,
    amountCents,
    periodType,
    startDate,
    endDate,
    rollover,
    rolloverAmountCents,
    alertThreshold,
    createdAt,
    updatedAt,
    version,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.amountCents == this.amountCents &&
          other.periodType == this.periodType &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.rollover == this.rollover &&
          other.rolloverAmountCents == this.rolloverAmountCents &&
          other.alertThreshold == this.alertThreshold &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.syncStatus == this.syncStatus);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
  final Value<String> id;
  final Value<String> categoryId;
  final Value<int> amountCents;
  final Value<String> periodType;
  final Value<int> startDate;
  final Value<int?> endDate;
  final Value<bool> rollover;
  final Value<int> rolloverAmountCents;
  final Value<double> alertThreshold;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> version;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.periodType = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.rollover = const Value.absent(),
    this.rolloverAmountCents = const Value.absent(),
    this.alertThreshold = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsCompanion.insert({
    required String id,
    required String categoryId,
    required int amountCents,
    required String periodType,
    required int startDate,
    this.endDate = const Value.absent(),
    this.rollover = const Value.absent(),
    this.rolloverAmountCents = const Value.absent(),
    this.alertThreshold = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.version = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       categoryId = Value(categoryId),
       amountCents = Value(amountCents),
       periodType = Value(periodType),
       startDate = Value(startDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Budget> custom({
    Expression<String>? id,
    Expression<String>? categoryId,
    Expression<int>? amountCents,
    Expression<String>? periodType,
    Expression<int>? startDate,
    Expression<int>? endDate,
    Expression<bool>? rollover,
    Expression<int>? rolloverAmountCents,
    Expression<double>? alertThreshold,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? version,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (amountCents != null) 'amount_cents': amountCents,
      if (periodType != null) 'period_type': periodType,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (rollover != null) 'rollover': rollover,
      if (rolloverAmountCents != null)
        'rollover_amount_cents': rolloverAmountCents,
      if (alertThreshold != null) 'alert_threshold': alertThreshold,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsCompanion copyWith({
    Value<String>? id,
    Value<String>? categoryId,
    Value<int>? amountCents,
    Value<String>? periodType,
    Value<int>? startDate,
    Value<int?>? endDate,
    Value<bool>? rollover,
    Value<int>? rolloverAmountCents,
    Value<double>? alertThreshold,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? version,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      amountCents: amountCents ?? this.amountCents,
      periodType: periodType ?? this.periodType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      rollover: rollover ?? this.rollover,
      rolloverAmountCents: rolloverAmountCents ?? this.rolloverAmountCents,
      alertThreshold: alertThreshold ?? this.alertThreshold,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (periodType.present) {
      map['period_type'] = Variable<String>(periodType.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<int>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<int>(endDate.value);
    }
    if (rollover.present) {
      map['rollover'] = Variable<bool>(rollover.value);
    }
    if (rolloverAmountCents.present) {
      map['rollover_amount_cents'] = Variable<int>(rolloverAmountCents.value);
    }
    if (alertThreshold.present) {
      map['alert_threshold'] = Variable<double>(alertThreshold.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('amountCents: $amountCents, ')
          ..write('periodType: $periodType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('rollover: $rollover, ')
          ..write('rolloverAmountCents: $rolloverAmountCents, ')
          ..write('alertThreshold: $alertThreshold, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AutoCategorizeRulesTable extends AutoCategorizeRules
    with TableInfo<$AutoCategorizeRulesTable, AutoCategorizeRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AutoCategorizeRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payeeContainsMeta = const VerificationMeta(
    'payeeContains',
  );
  @override
  late final GeneratedColumn<String> payeeContains = GeneratedColumn<String>(
    'payee_contains',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payeeExactMeta = const VerificationMeta(
    'payeeExact',
  );
  @override
  late final GeneratedColumn<String> payeeExact = GeneratedColumn<String>(
    'payee_exact',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMinCentsMeta = const VerificationMeta(
    'amountMinCents',
  );
  @override
  late final GeneratedColumn<int> amountMinCents = GeneratedColumn<int>(
    'amount_min_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMaxCentsMeta = const VerificationMeta(
    'amountMaxCents',
  );
  @override
  late final GeneratedColumn<int> amountMaxCents = GeneratedColumn<int>(
    'amount_max_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountTypeMeta = const VerificationMeta(
    'accountType',
  );
  @override
  late final GeneratedColumn<String> accountType = GeneratedColumn<String>(
    'account_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    priority,
    payeeContains,
    payeeExact,
    amountMinCents,
    amountMaxCents,
    accountId,
    categoryId,
    accountType,
    isEnabled,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auto_categorize_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<AutoCategorizeRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('payee_contains')) {
      context.handle(
        _payeeContainsMeta,
        payeeContains.isAcceptableOrUnknown(
          data['payee_contains']!,
          _payeeContainsMeta,
        ),
      );
    }
    if (data.containsKey('payee_exact')) {
      context.handle(
        _payeeExactMeta,
        payeeExact.isAcceptableOrUnknown(data['payee_exact']!, _payeeExactMeta),
      );
    }
    if (data.containsKey('amount_min_cents')) {
      context.handle(
        _amountMinCentsMeta,
        amountMinCents.isAcceptableOrUnknown(
          data['amount_min_cents']!,
          _amountMinCentsMeta,
        ),
      );
    }
    if (data.containsKey('amount_max_cents')) {
      context.handle(
        _amountMaxCentsMeta,
        amountMaxCents.isAcceptableOrUnknown(
          data['amount_max_cents']!,
          _amountMaxCentsMeta,
        ),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('account_type')) {
      context.handle(
        _accountTypeMeta,
        accountType.isAcceptableOrUnknown(
          data['account_type']!,
          _accountTypeMeta,
        ),
      );
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AutoCategorizeRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AutoCategorizeRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      payeeContains: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payee_contains'],
      ),
      payeeExact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payee_exact'],
      ),
      amountMinCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_min_cents'],
      ),
      amountMaxCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_max_cents'],
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      accountType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_type'],
      ),
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AutoCategorizeRulesTable createAlias(String alias) {
    return $AutoCategorizeRulesTable(attachedDatabase, alias);
  }
}

class AutoCategorizeRule extends DataClass
    implements Insertable<AutoCategorizeRule> {
  final String id;
  final String name;
  final int priority;
  final String? payeeContains;
  final String? payeeExact;
  final int? amountMinCents;
  final int? amountMaxCents;
  final String? accountId;
  final String categoryId;
  final String? accountType;
  final bool isEnabled;
  final int createdAt;
  final int updatedAt;
  const AutoCategorizeRule({
    required this.id,
    required this.name,
    required this.priority,
    this.payeeContains,
    this.payeeExact,
    this.amountMinCents,
    this.amountMaxCents,
    this.accountId,
    required this.categoryId,
    this.accountType,
    required this.isEnabled,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['priority'] = Variable<int>(priority);
    if (!nullToAbsent || payeeContains != null) {
      map['payee_contains'] = Variable<String>(payeeContains);
    }
    if (!nullToAbsent || payeeExact != null) {
      map['payee_exact'] = Variable<String>(payeeExact);
    }
    if (!nullToAbsent || amountMinCents != null) {
      map['amount_min_cents'] = Variable<int>(amountMinCents);
    }
    if (!nullToAbsent || amountMaxCents != null) {
      map['amount_max_cents'] = Variable<int>(amountMaxCents);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    map['category_id'] = Variable<String>(categoryId);
    if (!nullToAbsent || accountType != null) {
      map['account_type'] = Variable<String>(accountType);
    }
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  AutoCategorizeRulesCompanion toCompanion(bool nullToAbsent) {
    return AutoCategorizeRulesCompanion(
      id: Value(id),
      name: Value(name),
      priority: Value(priority),
      payeeContains: payeeContains == null && nullToAbsent
          ? const Value.absent()
          : Value(payeeContains),
      payeeExact: payeeExact == null && nullToAbsent
          ? const Value.absent()
          : Value(payeeExact),
      amountMinCents: amountMinCents == null && nullToAbsent
          ? const Value.absent()
          : Value(amountMinCents),
      amountMaxCents: amountMaxCents == null && nullToAbsent
          ? const Value.absent()
          : Value(amountMaxCents),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      categoryId: Value(categoryId),
      accountType: accountType == null && nullToAbsent
          ? const Value.absent()
          : Value(accountType),
      isEnabled: Value(isEnabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AutoCategorizeRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AutoCategorizeRule(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      priority: serializer.fromJson<int>(json['priority']),
      payeeContains: serializer.fromJson<String?>(json['payeeContains']),
      payeeExact: serializer.fromJson<String?>(json['payeeExact']),
      amountMinCents: serializer.fromJson<int?>(json['amountMinCents']),
      amountMaxCents: serializer.fromJson<int?>(json['amountMaxCents']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      accountType: serializer.fromJson<String?>(json['accountType']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'priority': serializer.toJson<int>(priority),
      'payeeContains': serializer.toJson<String?>(payeeContains),
      'payeeExact': serializer.toJson<String?>(payeeExact),
      'amountMinCents': serializer.toJson<int?>(amountMinCents),
      'amountMaxCents': serializer.toJson<int?>(amountMaxCents),
      'accountId': serializer.toJson<String?>(accountId),
      'categoryId': serializer.toJson<String>(categoryId),
      'accountType': serializer.toJson<String?>(accountType),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  AutoCategorizeRule copyWith({
    String? id,
    String? name,
    int? priority,
    Value<String?> payeeContains = const Value.absent(),
    Value<String?> payeeExact = const Value.absent(),
    Value<int?> amountMinCents = const Value.absent(),
    Value<int?> amountMaxCents = const Value.absent(),
    Value<String?> accountId = const Value.absent(),
    String? categoryId,
    Value<String?> accountType = const Value.absent(),
    bool? isEnabled,
    int? createdAt,
    int? updatedAt,
  }) => AutoCategorizeRule(
    id: id ?? this.id,
    name: name ?? this.name,
    priority: priority ?? this.priority,
    payeeContains: payeeContains.present
        ? payeeContains.value
        : this.payeeContains,
    payeeExact: payeeExact.present ? payeeExact.value : this.payeeExact,
    amountMinCents: amountMinCents.present
        ? amountMinCents.value
        : this.amountMinCents,
    amountMaxCents: amountMaxCents.present
        ? amountMaxCents.value
        : this.amountMaxCents,
    accountId: accountId.present ? accountId.value : this.accountId,
    categoryId: categoryId ?? this.categoryId,
    accountType: accountType.present ? accountType.value : this.accountType,
    isEnabled: isEnabled ?? this.isEnabled,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AutoCategorizeRule copyWithCompanion(AutoCategorizeRulesCompanion data) {
    return AutoCategorizeRule(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      priority: data.priority.present ? data.priority.value : this.priority,
      payeeContains: data.payeeContains.present
          ? data.payeeContains.value
          : this.payeeContains,
      payeeExact: data.payeeExact.present
          ? data.payeeExact.value
          : this.payeeExact,
      amountMinCents: data.amountMinCents.present
          ? data.amountMinCents.value
          : this.amountMinCents,
      amountMaxCents: data.amountMaxCents.present
          ? data.amountMaxCents.value
          : this.amountMaxCents,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      accountType: data.accountType.present
          ? data.accountType.value
          : this.accountType,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AutoCategorizeRule(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('priority: $priority, ')
          ..write('payeeContains: $payeeContains, ')
          ..write('payeeExact: $payeeExact, ')
          ..write('amountMinCents: $amountMinCents, ')
          ..write('amountMaxCents: $amountMaxCents, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountType: $accountType, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    priority,
    payeeContains,
    payeeExact,
    amountMinCents,
    amountMaxCents,
    accountId,
    categoryId,
    accountType,
    isEnabled,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AutoCategorizeRule &&
          other.id == this.id &&
          other.name == this.name &&
          other.priority == this.priority &&
          other.payeeContains == this.payeeContains &&
          other.payeeExact == this.payeeExact &&
          other.amountMinCents == this.amountMinCents &&
          other.amountMaxCents == this.amountMaxCents &&
          other.accountId == this.accountId &&
          other.categoryId == this.categoryId &&
          other.accountType == this.accountType &&
          other.isEnabled == this.isEnabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AutoCategorizeRulesCompanion extends UpdateCompanion<AutoCategorizeRule> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> priority;
  final Value<String?> payeeContains;
  final Value<String?> payeeExact;
  final Value<int?> amountMinCents;
  final Value<int?> amountMaxCents;
  final Value<String?> accountId;
  final Value<String> categoryId;
  final Value<String?> accountType;
  final Value<bool> isEnabled;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const AutoCategorizeRulesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.priority = const Value.absent(),
    this.payeeContains = const Value.absent(),
    this.payeeExact = const Value.absent(),
    this.amountMinCents = const Value.absent(),
    this.amountMaxCents = const Value.absent(),
    this.accountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.accountType = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AutoCategorizeRulesCompanion.insert({
    required String id,
    required String name,
    required int priority,
    this.payeeContains = const Value.absent(),
    this.payeeExact = const Value.absent(),
    this.amountMinCents = const Value.absent(),
    this.amountMaxCents = const Value.absent(),
    this.accountId = const Value.absent(),
    required String categoryId,
    this.accountType = const Value.absent(),
    this.isEnabled = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       priority = Value(priority),
       categoryId = Value(categoryId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AutoCategorizeRule> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? priority,
    Expression<String>? payeeContains,
    Expression<String>? payeeExact,
    Expression<int>? amountMinCents,
    Expression<int>? amountMaxCents,
    Expression<String>? accountId,
    Expression<String>? categoryId,
    Expression<String>? accountType,
    Expression<bool>? isEnabled,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (priority != null) 'priority': priority,
      if (payeeContains != null) 'payee_contains': payeeContains,
      if (payeeExact != null) 'payee_exact': payeeExact,
      if (amountMinCents != null) 'amount_min_cents': amountMinCents,
      if (amountMaxCents != null) 'amount_max_cents': amountMaxCents,
      if (accountId != null) 'account_id': accountId,
      if (categoryId != null) 'category_id': categoryId,
      if (accountType != null) 'account_type': accountType,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AutoCategorizeRulesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? priority,
    Value<String?>? payeeContains,
    Value<String?>? payeeExact,
    Value<int?>? amountMinCents,
    Value<int?>? amountMaxCents,
    Value<String?>? accountId,
    Value<String>? categoryId,
    Value<String?>? accountType,
    Value<bool>? isEnabled,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return AutoCategorizeRulesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      priority: priority ?? this.priority,
      payeeContains: payeeContains ?? this.payeeContains,
      payeeExact: payeeExact ?? this.payeeExact,
      amountMinCents: amountMinCents ?? this.amountMinCents,
      amountMaxCents: amountMaxCents ?? this.amountMaxCents,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      accountType: accountType ?? this.accountType,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (payeeContains.present) {
      map['payee_contains'] = Variable<String>(payeeContains.value);
    }
    if (payeeExact.present) {
      map['payee_exact'] = Variable<String>(payeeExact.value);
    }
    if (amountMinCents.present) {
      map['amount_min_cents'] = Variable<int>(amountMinCents.value);
    }
    if (amountMaxCents.present) {
      map['amount_max_cents'] = Variable<int>(amountMaxCents.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<String>(accountType.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
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
    return (StringBuffer('AutoCategorizeRulesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('priority: $priority, ')
          ..write('payeeContains: $payeeContains, ')
          ..write('payeeExact: $payeeExact, ')
          ..write('amountMinCents: $amountMinCents, ')
          ..write('amountMaxCents: $amountMaxCents, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountType: $accountType, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalTypeMeta = const VerificationMeta(
    'goalType',
  );
  @override
  late final GeneratedColumn<String> goalType = GeneratedColumn<String>(
    'goal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetAmountCentsMeta = const VerificationMeta(
    'targetAmountCents',
  );
  @override
  late final GeneratedColumn<int> targetAmountCents = GeneratedColumn<int>(
    'target_amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentAmountCentsMeta =
      const VerificationMeta('currentAmountCents');
  @override
  late final GeneratedColumn<int> currentAmountCents = GeneratedColumn<int>(
    'current_amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<int> targetDate = GeneratedColumn<int>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkedAccountIdMeta = const VerificationMeta(
    'linkedAccountId',
  );
  @override
  late final GeneratedColumn<String> linkedAccountId = GeneratedColumn<String>(
    'linked_account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<int> completedAt = GeneratedColumn<int>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _monthlyContributionCentsMeta =
      const VerificationMeta('monthlyContributionCents');
  @override
  late final GeneratedColumn<int> monthlyContributionCents =
      GeneratedColumn<int>(
        'monthly_contribution_cents',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _annualReturnBpsMeta = const VerificationMeta(
    'annualReturnBps',
  );
  @override
  late final GeneratedColumn<int> annualReturnBps = GeneratedColumn<int>(
    'annual_return_bps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _annualVolatilityBpsMeta =
      const VerificationMeta('annualVolatilityBps');
  @override
  late final GeneratedColumn<int> annualVolatilityBps = GeneratedColumn<int>(
    'annual_volatility_bps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _retirementYearMeta = const VerificationMeta(
    'retirementYear',
  );
  @override
  late final GeneratedColumn<int> retirementYear = GeneratedColumn<int>(
    'retirement_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _desiredMonthlyIncomeCentsMeta =
      const VerificationMeta('desiredMonthlyIncomeCents');
  @override
  late final GeneratedColumn<int> desiredMonthlyIncomeCents =
      GeneratedColumn<int>(
        'desired_monthly_income_cents',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    goalType,
    targetAmountCents,
    currentAmountCents,
    targetDate,
    linkedAccountId,
    icon,
    color,
    isCompleted,
    completedAt,
    monthlyContributionCents,
    annualReturnBps,
    annualVolatilityBps,
    retirementYear,
    desiredMonthlyIncomeCents,
    createdAt,
    updatedAt,
    version,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Goal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('goal_type')) {
      context.handle(
        _goalTypeMeta,
        goalType.isAcceptableOrUnknown(data['goal_type']!, _goalTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_goalTypeMeta);
    }
    if (data.containsKey('target_amount_cents')) {
      context.handle(
        _targetAmountCentsMeta,
        targetAmountCents.isAcceptableOrUnknown(
          data['target_amount_cents']!,
          _targetAmountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetAmountCentsMeta);
    }
    if (data.containsKey('current_amount_cents')) {
      context.handle(
        _currentAmountCentsMeta,
        currentAmountCents.isAcceptableOrUnknown(
          data['current_amount_cents']!,
          _currentAmountCentsMeta,
        ),
      );
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    }
    if (data.containsKey('linked_account_id')) {
      context.handle(
        _linkedAccountIdMeta,
        linkedAccountId.isAcceptableOrUnknown(
          data['linked_account_id']!,
          _linkedAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('monthly_contribution_cents')) {
      context.handle(
        _monthlyContributionCentsMeta,
        monthlyContributionCents.isAcceptableOrUnknown(
          data['monthly_contribution_cents']!,
          _monthlyContributionCentsMeta,
        ),
      );
    }
    if (data.containsKey('annual_return_bps')) {
      context.handle(
        _annualReturnBpsMeta,
        annualReturnBps.isAcceptableOrUnknown(
          data['annual_return_bps']!,
          _annualReturnBpsMeta,
        ),
      );
    }
    if (data.containsKey('annual_volatility_bps')) {
      context.handle(
        _annualVolatilityBpsMeta,
        annualVolatilityBps.isAcceptableOrUnknown(
          data['annual_volatility_bps']!,
          _annualVolatilityBpsMeta,
        ),
      );
    }
    if (data.containsKey('retirement_year')) {
      context.handle(
        _retirementYearMeta,
        retirementYear.isAcceptableOrUnknown(
          data['retirement_year']!,
          _retirementYearMeta,
        ),
      );
    }
    if (data.containsKey('desired_monthly_income_cents')) {
      context.handle(
        _desiredMonthlyIncomeCentsMeta,
        desiredMonthlyIncomeCents.isAcceptableOrUnknown(
          data['desired_monthly_income_cents']!,
          _desiredMonthlyIncomeCentsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      goalType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_type'],
      )!,
      targetAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_amount_cents'],
      )!,
      currentAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_amount_cents'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_date'],
      ),
      linkedAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_account_id'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at'],
      ),
      monthlyContributionCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_contribution_cents'],
      ),
      annualReturnBps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}annual_return_bps'],
      ),
      annualVolatilityBps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}annual_volatility_bps'],
      ),
      retirementYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retirement_year'],
      ),
      desiredMonthlyIncomeCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}desired_monthly_income_cents'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class Goal extends DataClass implements Insertable<Goal> {
  final String id;
  final String name;
  final String goalType;
  final int targetAmountCents;
  final int currentAmountCents;
  final int? targetDate;
  final String? linkedAccountId;
  final String icon;
  final int color;
  final bool isCompleted;
  final int? completedAt;
  final int? monthlyContributionCents;
  final int? annualReturnBps;
  final int? annualVolatilityBps;
  final int? retirementYear;
  final int? desiredMonthlyIncomeCents;
  final int createdAt;
  final int updatedAt;
  final int version;
  final int syncStatus;
  const Goal({
    required this.id,
    required this.name,
    required this.goalType,
    required this.targetAmountCents,
    required this.currentAmountCents,
    this.targetDate,
    this.linkedAccountId,
    required this.icon,
    required this.color,
    required this.isCompleted,
    this.completedAt,
    this.monthlyContributionCents,
    this.annualReturnBps,
    this.annualVolatilityBps,
    this.retirementYear,
    this.desiredMonthlyIncomeCents,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['goal_type'] = Variable<String>(goalType);
    map['target_amount_cents'] = Variable<int>(targetAmountCents);
    map['current_amount_cents'] = Variable<int>(currentAmountCents);
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<int>(targetDate);
    }
    if (!nullToAbsent || linkedAccountId != null) {
      map['linked_account_id'] = Variable<String>(linkedAccountId);
    }
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<int>(color);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<int>(completedAt);
    }
    if (!nullToAbsent || monthlyContributionCents != null) {
      map['monthly_contribution_cents'] = Variable<int>(
        monthlyContributionCents,
      );
    }
    if (!nullToAbsent || annualReturnBps != null) {
      map['annual_return_bps'] = Variable<int>(annualReturnBps);
    }
    if (!nullToAbsent || annualVolatilityBps != null) {
      map['annual_volatility_bps'] = Variable<int>(annualVolatilityBps);
    }
    if (!nullToAbsent || retirementYear != null) {
      map['retirement_year'] = Variable<int>(retirementYear);
    }
    if (!nullToAbsent || desiredMonthlyIncomeCents != null) {
      map['desired_monthly_income_cents'] = Variable<int>(
        desiredMonthlyIncomeCents,
      );
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['version'] = Variable<int>(version);
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      name: Value(name),
      goalType: Value(goalType),
      targetAmountCents: Value(targetAmountCents),
      currentAmountCents: Value(currentAmountCents),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      linkedAccountId: linkedAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedAccountId),
      icon: Value(icon),
      color: Value(color),
      isCompleted: Value(isCompleted),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      monthlyContributionCents: monthlyContributionCents == null && nullToAbsent
          ? const Value.absent()
          : Value(monthlyContributionCents),
      annualReturnBps: annualReturnBps == null && nullToAbsent
          ? const Value.absent()
          : Value(annualReturnBps),
      annualVolatilityBps: annualVolatilityBps == null && nullToAbsent
          ? const Value.absent()
          : Value(annualVolatilityBps),
      retirementYear: retirementYear == null && nullToAbsent
          ? const Value.absent()
          : Value(retirementYear),
      desiredMonthlyIncomeCents:
          desiredMonthlyIncomeCents == null && nullToAbsent
          ? const Value.absent()
          : Value(desiredMonthlyIncomeCents),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      syncStatus: Value(syncStatus),
    );
  }

  factory Goal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      goalType: serializer.fromJson<String>(json['goalType']),
      targetAmountCents: serializer.fromJson<int>(json['targetAmountCents']),
      currentAmountCents: serializer.fromJson<int>(json['currentAmountCents']),
      targetDate: serializer.fromJson<int?>(json['targetDate']),
      linkedAccountId: serializer.fromJson<String?>(json['linkedAccountId']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<int>(json['color']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      completedAt: serializer.fromJson<int?>(json['completedAt']),
      monthlyContributionCents: serializer.fromJson<int?>(
        json['monthlyContributionCents'],
      ),
      annualReturnBps: serializer.fromJson<int?>(json['annualReturnBps']),
      annualVolatilityBps: serializer.fromJson<int?>(
        json['annualVolatilityBps'],
      ),
      retirementYear: serializer.fromJson<int?>(json['retirementYear']),
      desiredMonthlyIncomeCents: serializer.fromJson<int?>(
        json['desiredMonthlyIncomeCents'],
      ),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'goalType': serializer.toJson<String>(goalType),
      'targetAmountCents': serializer.toJson<int>(targetAmountCents),
      'currentAmountCents': serializer.toJson<int>(currentAmountCents),
      'targetDate': serializer.toJson<int?>(targetDate),
      'linkedAccountId': serializer.toJson<String?>(linkedAccountId),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<int>(color),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'completedAt': serializer.toJson<int?>(completedAt),
      'monthlyContributionCents': serializer.toJson<int?>(
        monthlyContributionCents,
      ),
      'annualReturnBps': serializer.toJson<int?>(annualReturnBps),
      'annualVolatilityBps': serializer.toJson<int?>(annualVolatilityBps),
      'retirementYear': serializer.toJson<int?>(retirementYear),
      'desiredMonthlyIncomeCents': serializer.toJson<int?>(
        desiredMonthlyIncomeCents,
      ),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'version': serializer.toJson<int>(version),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  Goal copyWith({
    String? id,
    String? name,
    String? goalType,
    int? targetAmountCents,
    int? currentAmountCents,
    Value<int?> targetDate = const Value.absent(),
    Value<String?> linkedAccountId = const Value.absent(),
    String? icon,
    int? color,
    bool? isCompleted,
    Value<int?> completedAt = const Value.absent(),
    Value<int?> monthlyContributionCents = const Value.absent(),
    Value<int?> annualReturnBps = const Value.absent(),
    Value<int?> annualVolatilityBps = const Value.absent(),
    Value<int?> retirementYear = const Value.absent(),
    Value<int?> desiredMonthlyIncomeCents = const Value.absent(),
    int? createdAt,
    int? updatedAt,
    int? version,
    int? syncStatus,
  }) => Goal(
    id: id ?? this.id,
    name: name ?? this.name,
    goalType: goalType ?? this.goalType,
    targetAmountCents: targetAmountCents ?? this.targetAmountCents,
    currentAmountCents: currentAmountCents ?? this.currentAmountCents,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
    linkedAccountId: linkedAccountId.present
        ? linkedAccountId.value
        : this.linkedAccountId,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    isCompleted: isCompleted ?? this.isCompleted,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    monthlyContributionCents: monthlyContributionCents.present
        ? monthlyContributionCents.value
        : this.monthlyContributionCents,
    annualReturnBps: annualReturnBps.present
        ? annualReturnBps.value
        : this.annualReturnBps,
    annualVolatilityBps: annualVolatilityBps.present
        ? annualVolatilityBps.value
        : this.annualVolatilityBps,
    retirementYear: retirementYear.present
        ? retirementYear.value
        : this.retirementYear,
    desiredMonthlyIncomeCents: desiredMonthlyIncomeCents.present
        ? desiredMonthlyIncomeCents.value
        : this.desiredMonthlyIncomeCents,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  Goal copyWithCompanion(GoalsCompanion data) {
    return Goal(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      goalType: data.goalType.present ? data.goalType.value : this.goalType,
      targetAmountCents: data.targetAmountCents.present
          ? data.targetAmountCents.value
          : this.targetAmountCents,
      currentAmountCents: data.currentAmountCents.present
          ? data.currentAmountCents.value
          : this.currentAmountCents,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      linkedAccountId: data.linkedAccountId.present
          ? data.linkedAccountId.value
          : this.linkedAccountId,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      monthlyContributionCents: data.monthlyContributionCents.present
          ? data.monthlyContributionCents.value
          : this.monthlyContributionCents,
      annualReturnBps: data.annualReturnBps.present
          ? data.annualReturnBps.value
          : this.annualReturnBps,
      annualVolatilityBps: data.annualVolatilityBps.present
          ? data.annualVolatilityBps.value
          : this.annualVolatilityBps,
      retirementYear: data.retirementYear.present
          ? data.retirementYear.value
          : this.retirementYear,
      desiredMonthlyIncomeCents: data.desiredMonthlyIncomeCents.present
          ? data.desiredMonthlyIncomeCents.value
          : this.desiredMonthlyIncomeCents,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('goalType: $goalType, ')
          ..write('targetAmountCents: $targetAmountCents, ')
          ..write('currentAmountCents: $currentAmountCents, ')
          ..write('targetDate: $targetDate, ')
          ..write('linkedAccountId: $linkedAccountId, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('monthlyContributionCents: $monthlyContributionCents, ')
          ..write('annualReturnBps: $annualReturnBps, ')
          ..write('annualVolatilityBps: $annualVolatilityBps, ')
          ..write('retirementYear: $retirementYear, ')
          ..write('desiredMonthlyIncomeCents: $desiredMonthlyIncomeCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    goalType,
    targetAmountCents,
    currentAmountCents,
    targetDate,
    linkedAccountId,
    icon,
    color,
    isCompleted,
    completedAt,
    monthlyContributionCents,
    annualReturnBps,
    annualVolatilityBps,
    retirementYear,
    desiredMonthlyIncomeCents,
    createdAt,
    updatedAt,
    version,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.id == this.id &&
          other.name == this.name &&
          other.goalType == this.goalType &&
          other.targetAmountCents == this.targetAmountCents &&
          other.currentAmountCents == this.currentAmountCents &&
          other.targetDate == this.targetDate &&
          other.linkedAccountId == this.linkedAccountId &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.isCompleted == this.isCompleted &&
          other.completedAt == this.completedAt &&
          other.monthlyContributionCents == this.monthlyContributionCents &&
          other.annualReturnBps == this.annualReturnBps &&
          other.annualVolatilityBps == this.annualVolatilityBps &&
          other.retirementYear == this.retirementYear &&
          other.desiredMonthlyIncomeCents == this.desiredMonthlyIncomeCents &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.syncStatus == this.syncStatus);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> goalType;
  final Value<int> targetAmountCents;
  final Value<int> currentAmountCents;
  final Value<int?> targetDate;
  final Value<String?> linkedAccountId;
  final Value<String> icon;
  final Value<int> color;
  final Value<bool> isCompleted;
  final Value<int?> completedAt;
  final Value<int?> monthlyContributionCents;
  final Value<int?> annualReturnBps;
  final Value<int?> annualVolatilityBps;
  final Value<int?> retirementYear;
  final Value<int?> desiredMonthlyIncomeCents;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> version;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.goalType = const Value.absent(),
    this.targetAmountCents = const Value.absent(),
    this.currentAmountCents = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.linkedAccountId = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.monthlyContributionCents = const Value.absent(),
    this.annualReturnBps = const Value.absent(),
    this.annualVolatilityBps = const Value.absent(),
    this.retirementYear = const Value.absent(),
    this.desiredMonthlyIncomeCents = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String id,
    required String name,
    required String goalType,
    required int targetAmountCents,
    this.currentAmountCents = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.linkedAccountId = const Value.absent(),
    required String icon,
    required int color,
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.monthlyContributionCents = const Value.absent(),
    this.annualReturnBps = const Value.absent(),
    this.annualVolatilityBps = const Value.absent(),
    this.retirementYear = const Value.absent(),
    this.desiredMonthlyIncomeCents = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.version = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       goalType = Value(goalType),
       targetAmountCents = Value(targetAmountCents),
       icon = Value(icon),
       color = Value(color),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Goal> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? goalType,
    Expression<int>? targetAmountCents,
    Expression<int>? currentAmountCents,
    Expression<int>? targetDate,
    Expression<String>? linkedAccountId,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<bool>? isCompleted,
    Expression<int>? completedAt,
    Expression<int>? monthlyContributionCents,
    Expression<int>? annualReturnBps,
    Expression<int>? annualVolatilityBps,
    Expression<int>? retirementYear,
    Expression<int>? desiredMonthlyIncomeCents,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? version,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (goalType != null) 'goal_type': goalType,
      if (targetAmountCents != null) 'target_amount_cents': targetAmountCents,
      if (currentAmountCents != null)
        'current_amount_cents': currentAmountCents,
      if (targetDate != null) 'target_date': targetDate,
      if (linkedAccountId != null) 'linked_account_id': linkedAccountId,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (completedAt != null) 'completed_at': completedAt,
      if (monthlyContributionCents != null)
        'monthly_contribution_cents': monthlyContributionCents,
      if (annualReturnBps != null) 'annual_return_bps': annualReturnBps,
      if (annualVolatilityBps != null)
        'annual_volatility_bps': annualVolatilityBps,
      if (retirementYear != null) 'retirement_year': retirementYear,
      if (desiredMonthlyIncomeCents != null)
        'desired_monthly_income_cents': desiredMonthlyIncomeCents,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? goalType,
    Value<int>? targetAmountCents,
    Value<int>? currentAmountCents,
    Value<int?>? targetDate,
    Value<String?>? linkedAccountId,
    Value<String>? icon,
    Value<int>? color,
    Value<bool>? isCompleted,
    Value<int?>? completedAt,
    Value<int?>? monthlyContributionCents,
    Value<int?>? annualReturnBps,
    Value<int?>? annualVolatilityBps,
    Value<int?>? retirementYear,
    Value<int?>? desiredMonthlyIncomeCents,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? version,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return GoalsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      goalType: goalType ?? this.goalType,
      targetAmountCents: targetAmountCents ?? this.targetAmountCents,
      currentAmountCents: currentAmountCents ?? this.currentAmountCents,
      targetDate: targetDate ?? this.targetDate,
      linkedAccountId: linkedAccountId ?? this.linkedAccountId,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      monthlyContributionCents:
          monthlyContributionCents ?? this.monthlyContributionCents,
      annualReturnBps: annualReturnBps ?? this.annualReturnBps,
      annualVolatilityBps: annualVolatilityBps ?? this.annualVolatilityBps,
      retirementYear: retirementYear ?? this.retirementYear,
      desiredMonthlyIncomeCents:
          desiredMonthlyIncomeCents ?? this.desiredMonthlyIncomeCents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (goalType.present) {
      map['goal_type'] = Variable<String>(goalType.value);
    }
    if (targetAmountCents.present) {
      map['target_amount_cents'] = Variable<int>(targetAmountCents.value);
    }
    if (currentAmountCents.present) {
      map['current_amount_cents'] = Variable<int>(currentAmountCents.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<int>(targetDate.value);
    }
    if (linkedAccountId.present) {
      map['linked_account_id'] = Variable<String>(linkedAccountId.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<int>(completedAt.value);
    }
    if (monthlyContributionCents.present) {
      map['monthly_contribution_cents'] = Variable<int>(
        monthlyContributionCents.value,
      );
    }
    if (annualReturnBps.present) {
      map['annual_return_bps'] = Variable<int>(annualReturnBps.value);
    }
    if (annualVolatilityBps.present) {
      map['annual_volatility_bps'] = Variable<int>(annualVolatilityBps.value);
    }
    if (retirementYear.present) {
      map['retirement_year'] = Variable<int>(retirementYear.value);
    }
    if (desiredMonthlyIncomeCents.present) {
      map['desired_monthly_income_cents'] = Variable<int>(
        desiredMonthlyIncomeCents.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('goalType: $goalType, ')
          ..write('targetAmountCents: $targetAmountCents, ')
          ..write('currentAmountCents: $currentAmountCents, ')
          ..write('targetDate: $targetDate, ')
          ..write('linkedAccountId: $linkedAccountId, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('monthlyContributionCents: $monthlyContributionCents, ')
          ..write('annualReturnBps: $annualReturnBps, ')
          ..write('annualVolatilityBps: $annualVolatilityBps, ')
          ..write('retirementYear: $retirementYear, ')
          ..write('desiredMonthlyIncomeCents: $desiredMonthlyIncomeCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvestmentHoldingsTable extends InvestmentHoldings
    with TableInfo<$InvestmentHoldingsTable, InvestmentHolding> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvestmentHoldingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
    'symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costBasisCentsMeta = const VerificationMeta(
    'costBasisCents',
  );
  @override
  late final GeneratedColumn<int> costBasisCents = GeneratedColumn<int>(
    'cost_basis_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentPriceCentsMeta = const VerificationMeta(
    'currentPriceCents',
  );
  @override
  late final GeneratedColumn<int> currentPriceCents = GeneratedColumn<int>(
    'current_price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentValueCentsMeta = const VerificationMeta(
    'currentValueCents',
  );
  @override
  late final GeneratedColumn<int> currentValueCents = GeneratedColumn<int>(
    'current_value_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetClassMeta = const VerificationMeta(
    'assetClass',
  );
  @override
  late final GeneratedColumn<String> assetClass = GeneratedColumn<String>(
    'asset_class',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastPriceUpdateMeta = const VerificationMeta(
    'lastPriceUpdate',
  );
  @override
  late final GeneratedColumn<int> lastPriceUpdate = GeneratedColumn<int>(
    'last_price_update',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    symbol,
    name,
    quantity,
    costBasisCents,
    currentPriceCents,
    currentValueCents,
    assetClass,
    lastPriceUpdate,
    createdAt,
    updatedAt,
    version,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'investment_holdings';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvestmentHolding> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(
        _symbolMeta,
        symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta),
      );
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('cost_basis_cents')) {
      context.handle(
        _costBasisCentsMeta,
        costBasisCents.isAcceptableOrUnknown(
          data['cost_basis_cents']!,
          _costBasisCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costBasisCentsMeta);
    }
    if (data.containsKey('current_price_cents')) {
      context.handle(
        _currentPriceCentsMeta,
        currentPriceCents.isAcceptableOrUnknown(
          data['current_price_cents']!,
          _currentPriceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentPriceCentsMeta);
    }
    if (data.containsKey('current_value_cents')) {
      context.handle(
        _currentValueCentsMeta,
        currentValueCents.isAcceptableOrUnknown(
          data['current_value_cents']!,
          _currentValueCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentValueCentsMeta);
    }
    if (data.containsKey('asset_class')) {
      context.handle(
        _assetClassMeta,
        assetClass.isAcceptableOrUnknown(data['asset_class']!, _assetClassMeta),
      );
    } else if (isInserting) {
      context.missing(_assetClassMeta);
    }
    if (data.containsKey('last_price_update')) {
      context.handle(
        _lastPriceUpdateMeta,
        lastPriceUpdate.isAcceptableOrUnknown(
          data['last_price_update']!,
          _lastPriceUpdateMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvestmentHolding map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvestmentHolding(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      symbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symbol'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      costBasisCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_basis_cents'],
      )!,
      currentPriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_price_cents'],
      )!,
      currentValueCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_value_cents'],
      )!,
      assetClass: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_class'],
      )!,
      lastPriceUpdate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_price_update'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $InvestmentHoldingsTable createAlias(String alias) {
    return $InvestmentHoldingsTable(attachedDatabase, alias);
  }
}

class InvestmentHolding extends DataClass
    implements Insertable<InvestmentHolding> {
  final String id;
  final String accountId;
  final String symbol;
  final String name;
  final double quantity;
  final int costBasisCents;
  final int currentPriceCents;
  final int currentValueCents;
  final String assetClass;
  final int? lastPriceUpdate;
  final int createdAt;
  final int updatedAt;
  final int version;
  final int syncStatus;
  const InvestmentHolding({
    required this.id,
    required this.accountId,
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.costBasisCents,
    required this.currentPriceCents,
    required this.currentValueCents,
    required this.assetClass,
    this.lastPriceUpdate,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['symbol'] = Variable<String>(symbol);
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<double>(quantity);
    map['cost_basis_cents'] = Variable<int>(costBasisCents);
    map['current_price_cents'] = Variable<int>(currentPriceCents);
    map['current_value_cents'] = Variable<int>(currentValueCents);
    map['asset_class'] = Variable<String>(assetClass);
    if (!nullToAbsent || lastPriceUpdate != null) {
      map['last_price_update'] = Variable<int>(lastPriceUpdate);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['version'] = Variable<int>(version);
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  InvestmentHoldingsCompanion toCompanion(bool nullToAbsent) {
    return InvestmentHoldingsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      symbol: Value(symbol),
      name: Value(name),
      quantity: Value(quantity),
      costBasisCents: Value(costBasisCents),
      currentPriceCents: Value(currentPriceCents),
      currentValueCents: Value(currentValueCents),
      assetClass: Value(assetClass),
      lastPriceUpdate: lastPriceUpdate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPriceUpdate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      syncStatus: Value(syncStatus),
    );
  }

  factory InvestmentHolding.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvestmentHolding(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      symbol: serializer.fromJson<String>(json['symbol']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<double>(json['quantity']),
      costBasisCents: serializer.fromJson<int>(json['costBasisCents']),
      currentPriceCents: serializer.fromJson<int>(json['currentPriceCents']),
      currentValueCents: serializer.fromJson<int>(json['currentValueCents']),
      assetClass: serializer.fromJson<String>(json['assetClass']),
      lastPriceUpdate: serializer.fromJson<int?>(json['lastPriceUpdate']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'symbol': serializer.toJson<String>(symbol),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<double>(quantity),
      'costBasisCents': serializer.toJson<int>(costBasisCents),
      'currentPriceCents': serializer.toJson<int>(currentPriceCents),
      'currentValueCents': serializer.toJson<int>(currentValueCents),
      'assetClass': serializer.toJson<String>(assetClass),
      'lastPriceUpdate': serializer.toJson<int?>(lastPriceUpdate),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'version': serializer.toJson<int>(version),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  InvestmentHolding copyWith({
    String? id,
    String? accountId,
    String? symbol,
    String? name,
    double? quantity,
    int? costBasisCents,
    int? currentPriceCents,
    int? currentValueCents,
    String? assetClass,
    Value<int?> lastPriceUpdate = const Value.absent(),
    int? createdAt,
    int? updatedAt,
    int? version,
    int? syncStatus,
  }) => InvestmentHolding(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    symbol: symbol ?? this.symbol,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    costBasisCents: costBasisCents ?? this.costBasisCents,
    currentPriceCents: currentPriceCents ?? this.currentPriceCents,
    currentValueCents: currentValueCents ?? this.currentValueCents,
    assetClass: assetClass ?? this.assetClass,
    lastPriceUpdate: lastPriceUpdate.present
        ? lastPriceUpdate.value
        : this.lastPriceUpdate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  InvestmentHolding copyWithCompanion(InvestmentHoldingsCompanion data) {
    return InvestmentHolding(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      costBasisCents: data.costBasisCents.present
          ? data.costBasisCents.value
          : this.costBasisCents,
      currentPriceCents: data.currentPriceCents.present
          ? data.currentPriceCents.value
          : this.currentPriceCents,
      currentValueCents: data.currentValueCents.present
          ? data.currentValueCents.value
          : this.currentValueCents,
      assetClass: data.assetClass.present
          ? data.assetClass.value
          : this.assetClass,
      lastPriceUpdate: data.lastPriceUpdate.present
          ? data.lastPriceUpdate.value
          : this.lastPriceUpdate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvestmentHolding(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('symbol: $symbol, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('costBasisCents: $costBasisCents, ')
          ..write('currentPriceCents: $currentPriceCents, ')
          ..write('currentValueCents: $currentValueCents, ')
          ..write('assetClass: $assetClass, ')
          ..write('lastPriceUpdate: $lastPriceUpdate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    symbol,
    name,
    quantity,
    costBasisCents,
    currentPriceCents,
    currentValueCents,
    assetClass,
    lastPriceUpdate,
    createdAt,
    updatedAt,
    version,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvestmentHolding &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.symbol == this.symbol &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.costBasisCents == this.costBasisCents &&
          other.currentPriceCents == this.currentPriceCents &&
          other.currentValueCents == this.currentValueCents &&
          other.assetClass == this.assetClass &&
          other.lastPriceUpdate == this.lastPriceUpdate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.syncStatus == this.syncStatus);
}

class InvestmentHoldingsCompanion extends UpdateCompanion<InvestmentHolding> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> symbol;
  final Value<String> name;
  final Value<double> quantity;
  final Value<int> costBasisCents;
  final Value<int> currentPriceCents;
  final Value<int> currentValueCents;
  final Value<String> assetClass;
  final Value<int?> lastPriceUpdate;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> version;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const InvestmentHoldingsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.symbol = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.costBasisCents = const Value.absent(),
    this.currentPriceCents = const Value.absent(),
    this.currentValueCents = const Value.absent(),
    this.assetClass = const Value.absent(),
    this.lastPriceUpdate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvestmentHoldingsCompanion.insert({
    required String id,
    required String accountId,
    required String symbol,
    required String name,
    required double quantity,
    required int costBasisCents,
    required int currentPriceCents,
    required int currentValueCents,
    required String assetClass,
    this.lastPriceUpdate = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.version = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       symbol = Value(symbol),
       name = Value(name),
       quantity = Value(quantity),
       costBasisCents = Value(costBasisCents),
       currentPriceCents = Value(currentPriceCents),
       currentValueCents = Value(currentValueCents),
       assetClass = Value(assetClass),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<InvestmentHolding> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? symbol,
    Expression<String>? name,
    Expression<double>? quantity,
    Expression<int>? costBasisCents,
    Expression<int>? currentPriceCents,
    Expression<int>? currentValueCents,
    Expression<String>? assetClass,
    Expression<int>? lastPriceUpdate,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? version,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (symbol != null) 'symbol': symbol,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (costBasisCents != null) 'cost_basis_cents': costBasisCents,
      if (currentPriceCents != null) 'current_price_cents': currentPriceCents,
      if (currentValueCents != null) 'current_value_cents': currentValueCents,
      if (assetClass != null) 'asset_class': assetClass,
      if (lastPriceUpdate != null) 'last_price_update': lastPriceUpdate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvestmentHoldingsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? symbol,
    Value<String>? name,
    Value<double>? quantity,
    Value<int>? costBasisCents,
    Value<int>? currentPriceCents,
    Value<int>? currentValueCents,
    Value<String>? assetClass,
    Value<int?>? lastPriceUpdate,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? version,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return InvestmentHoldingsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      costBasisCents: costBasisCents ?? this.costBasisCents,
      currentPriceCents: currentPriceCents ?? this.currentPriceCents,
      currentValueCents: currentValueCents ?? this.currentValueCents,
      assetClass: assetClass ?? this.assetClass,
      lastPriceUpdate: lastPriceUpdate ?? this.lastPriceUpdate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (costBasisCents.present) {
      map['cost_basis_cents'] = Variable<int>(costBasisCents.value);
    }
    if (currentPriceCents.present) {
      map['current_price_cents'] = Variable<int>(currentPriceCents.value);
    }
    if (currentValueCents.present) {
      map['current_value_cents'] = Variable<int>(currentValueCents.value);
    }
    if (assetClass.present) {
      map['asset_class'] = Variable<String>(assetClass.value);
    }
    if (lastPriceUpdate.present) {
      map['last_price_update'] = Variable<int>(lastPriceUpdate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvestmentHoldingsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('symbol: $symbol, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('costBasisCents: $costBasisCents, ')
          ..write('currentPriceCents: $currentPriceCents, ')
          ..write('currentValueCents: $currentValueCents, ')
          ..write('assetClass: $assetClass, ')
          ..write('lastPriceUpdate: $lastPriceUpdate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BankConnectionsTable extends BankConnections
    with TableInfo<$BankConnectionsTable, BankConnection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BankConnectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _institutionNameMeta = const VerificationMeta(
    'institutionName',
  );
  @override
  late final GeneratedColumn<String> institutionName = GeneratedColumn<String>(
    'institution_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<int> lastSyncedAt = GeneratedColumn<int>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _consecutiveFailuresMeta =
      const VerificationMeta('consecutiveFailures');
  @override
  late final GeneratedColumn<int> consecutiveFailures = GeneratedColumn<int>(
    'consecutive_failures',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastFailureTimeMeta = const VerificationMeta(
    'lastFailureTime',
  );
  @override
  late final GeneratedColumn<int> lastFailureTime = GeneratedColumn<int>(
    'last_failure_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncingMeta = const VerificationMeta(
    'isSyncing',
  );
  @override
  late final GeneratedColumn<bool> isSyncing = GeneratedColumn<bool>(
    'is_syncing',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_syncing" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    provider,
    institutionName,
    status,
    lastSyncedAt,
    errorMessage,
    consecutiveFailures,
    lastFailureTime,
    isSyncing,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bank_connections';
  @override
  VerificationContext validateIntegrity(
    Insertable<BankConnection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('institution_name')) {
      context.handle(
        _institutionNameMeta,
        institutionName.isAcceptableOrUnknown(
          data['institution_name']!,
          _institutionNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_institutionNameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('consecutive_failures')) {
      context.handle(
        _consecutiveFailuresMeta,
        consecutiveFailures.isAcceptableOrUnknown(
          data['consecutive_failures']!,
          _consecutiveFailuresMeta,
        ),
      );
    }
    if (data.containsKey('last_failure_time')) {
      context.handle(
        _lastFailureTimeMeta,
        lastFailureTime.isAcceptableOrUnknown(
          data['last_failure_time']!,
          _lastFailureTimeMeta,
        ),
      );
    }
    if (data.containsKey('is_syncing')) {
      context.handle(
        _isSyncingMeta,
        isSyncing.isAcceptableOrUnknown(data['is_syncing']!, _isSyncingMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BankConnection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BankConnection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      institutionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}institution_name'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_synced_at'],
      ),
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      consecutiveFailures: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}consecutive_failures'],
      )!,
      lastFailureTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_failure_time'],
      ),
      isSyncing: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_syncing'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BankConnectionsTable createAlias(String alias) {
    return $BankConnectionsTable(attachedDatabase, alias);
  }
}

class BankConnection extends DataClass implements Insertable<BankConnection> {
  final String id;
  final String provider;
  final String institutionName;
  final String status;
  final int? lastSyncedAt;
  final String? errorMessage;
  final int consecutiveFailures;
  final int? lastFailureTime;
  final bool isSyncing;
  final int createdAt;
  final int updatedAt;
  const BankConnection({
    required this.id,
    required this.provider,
    required this.institutionName,
    required this.status,
    this.lastSyncedAt,
    this.errorMessage,
    required this.consecutiveFailures,
    this.lastFailureTime,
    required this.isSyncing,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['provider'] = Variable<String>(provider);
    map['institution_name'] = Variable<String>(institutionName);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<int>(lastSyncedAt);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['consecutive_failures'] = Variable<int>(consecutiveFailures);
    if (!nullToAbsent || lastFailureTime != null) {
      map['last_failure_time'] = Variable<int>(lastFailureTime);
    }
    map['is_syncing'] = Variable<bool>(isSyncing);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  BankConnectionsCompanion toCompanion(bool nullToAbsent) {
    return BankConnectionsCompanion(
      id: Value(id),
      provider: Value(provider),
      institutionName: Value(institutionName),
      status: Value(status),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      consecutiveFailures: Value(consecutiveFailures),
      lastFailureTime: lastFailureTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFailureTime),
      isSyncing: Value(isSyncing),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BankConnection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BankConnection(
      id: serializer.fromJson<String>(json['id']),
      provider: serializer.fromJson<String>(json['provider']),
      institutionName: serializer.fromJson<String>(json['institutionName']),
      status: serializer.fromJson<String>(json['status']),
      lastSyncedAt: serializer.fromJson<int?>(json['lastSyncedAt']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      consecutiveFailures: serializer.fromJson<int>(
        json['consecutiveFailures'],
      ),
      lastFailureTime: serializer.fromJson<int?>(json['lastFailureTime']),
      isSyncing: serializer.fromJson<bool>(json['isSyncing']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'provider': serializer.toJson<String>(provider),
      'institutionName': serializer.toJson<String>(institutionName),
      'status': serializer.toJson<String>(status),
      'lastSyncedAt': serializer.toJson<int?>(lastSyncedAt),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'consecutiveFailures': serializer.toJson<int>(consecutiveFailures),
      'lastFailureTime': serializer.toJson<int?>(lastFailureTime),
      'isSyncing': serializer.toJson<bool>(isSyncing),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  BankConnection copyWith({
    String? id,
    String? provider,
    String? institutionName,
    String? status,
    Value<int?> lastSyncedAt = const Value.absent(),
    Value<String?> errorMessage = const Value.absent(),
    int? consecutiveFailures,
    Value<int?> lastFailureTime = const Value.absent(),
    bool? isSyncing,
    int? createdAt,
    int? updatedAt,
  }) => BankConnection(
    id: id ?? this.id,
    provider: provider ?? this.provider,
    institutionName: institutionName ?? this.institutionName,
    status: status ?? this.status,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    consecutiveFailures: consecutiveFailures ?? this.consecutiveFailures,
    lastFailureTime: lastFailureTime.present
        ? lastFailureTime.value
        : this.lastFailureTime,
    isSyncing: isSyncing ?? this.isSyncing,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BankConnection copyWithCompanion(BankConnectionsCompanion data) {
    return BankConnection(
      id: data.id.present ? data.id.value : this.id,
      provider: data.provider.present ? data.provider.value : this.provider,
      institutionName: data.institutionName.present
          ? data.institutionName.value
          : this.institutionName,
      status: data.status.present ? data.status.value : this.status,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      consecutiveFailures: data.consecutiveFailures.present
          ? data.consecutiveFailures.value
          : this.consecutiveFailures,
      lastFailureTime: data.lastFailureTime.present
          ? data.lastFailureTime.value
          : this.lastFailureTime,
      isSyncing: data.isSyncing.present ? data.isSyncing.value : this.isSyncing,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BankConnection(')
          ..write('id: $id, ')
          ..write('provider: $provider, ')
          ..write('institutionName: $institutionName, ')
          ..write('status: $status, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('consecutiveFailures: $consecutiveFailures, ')
          ..write('lastFailureTime: $lastFailureTime, ')
          ..write('isSyncing: $isSyncing, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    provider,
    institutionName,
    status,
    lastSyncedAt,
    errorMessage,
    consecutiveFailures,
    lastFailureTime,
    isSyncing,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BankConnection &&
          other.id == this.id &&
          other.provider == this.provider &&
          other.institutionName == this.institutionName &&
          other.status == this.status &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.errorMessage == this.errorMessage &&
          other.consecutiveFailures == this.consecutiveFailures &&
          other.lastFailureTime == this.lastFailureTime &&
          other.isSyncing == this.isSyncing &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BankConnectionsCompanion extends UpdateCompanion<BankConnection> {
  final Value<String> id;
  final Value<String> provider;
  final Value<String> institutionName;
  final Value<String> status;
  final Value<int?> lastSyncedAt;
  final Value<String?> errorMessage;
  final Value<int> consecutiveFailures;
  final Value<int?> lastFailureTime;
  final Value<bool> isSyncing;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const BankConnectionsCompanion({
    this.id = const Value.absent(),
    this.provider = const Value.absent(),
    this.institutionName = const Value.absent(),
    this.status = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.consecutiveFailures = const Value.absent(),
    this.lastFailureTime = const Value.absent(),
    this.isSyncing = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BankConnectionsCompanion.insert({
    required String id,
    required String provider,
    required String institutionName,
    required String status,
    this.lastSyncedAt = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.consecutiveFailures = const Value.absent(),
    this.lastFailureTime = const Value.absent(),
    this.isSyncing = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       provider = Value(provider),
       institutionName = Value(institutionName),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BankConnection> custom({
    Expression<String>? id,
    Expression<String>? provider,
    Expression<String>? institutionName,
    Expression<String>? status,
    Expression<int>? lastSyncedAt,
    Expression<String>? errorMessage,
    Expression<int>? consecutiveFailures,
    Expression<int>? lastFailureTime,
    Expression<bool>? isSyncing,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (provider != null) 'provider': provider,
      if (institutionName != null) 'institution_name': institutionName,
      if (status != null) 'status': status,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (errorMessage != null) 'error_message': errorMessage,
      if (consecutiveFailures != null)
        'consecutive_failures': consecutiveFailures,
      if (lastFailureTime != null) 'last_failure_time': lastFailureTime,
      if (isSyncing != null) 'is_syncing': isSyncing,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BankConnectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? provider,
    Value<String>? institutionName,
    Value<String>? status,
    Value<int?>? lastSyncedAt,
    Value<String?>? errorMessage,
    Value<int>? consecutiveFailures,
    Value<int?>? lastFailureTime,
    Value<bool>? isSyncing,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return BankConnectionsCompanion(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      institutionName: institutionName ?? this.institutionName,
      status: status ?? this.status,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      errorMessage: errorMessage ?? this.errorMessage,
      consecutiveFailures: consecutiveFailures ?? this.consecutiveFailures,
      lastFailureTime: lastFailureTime ?? this.lastFailureTime,
      isSyncing: isSyncing ?? this.isSyncing,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (institutionName.present) {
      map['institution_name'] = Variable<String>(institutionName.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<int>(lastSyncedAt.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (consecutiveFailures.present) {
      map['consecutive_failures'] = Variable<int>(consecutiveFailures.value);
    }
    if (lastFailureTime.present) {
      map['last_failure_time'] = Variable<int>(lastFailureTime.value);
    }
    if (isSyncing.present) {
      map['is_syncing'] = Variable<bool>(isSyncing.value);
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
    return (StringBuffer('BankConnectionsCompanion(')
          ..write('id: $id, ')
          ..write('provider: $provider, ')
          ..write('institutionName: $institutionName, ')
          ..write('status: $status, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('consecutiveFailures: $consecutiveFailures, ')
          ..write('lastFailureTime: $lastFailureTime, ')
          ..write('isSyncing: $isSyncing, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringTransactionsTable extends RecurringTransactions
    with TableInfo<$RecurringTransactionsTable, RecurringTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payeeMeta = const VerificationMeta('payee');
  @override
  late final GeneratedColumn<String> payee = GeneratedColumn<String>(
    'payee',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextExpectedDateMeta = const VerificationMeta(
    'nextExpectedDate',
  );
  @override
  late final GeneratedColumn<int> nextExpectedDate = GeneratedColumn<int>(
    'next_expected_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastOccurrenceDateMeta =
      const VerificationMeta('lastOccurrenceDate');
  @override
  late final GeneratedColumn<int> lastOccurrenceDate = GeneratedColumn<int>(
    'last_occurrence_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSubscriptionMeta = const VerificationMeta(
    'isSubscription',
  );
  @override
  late final GeneratedColumn<bool> isSubscription = GeneratedColumn<bool>(
    'is_subscription',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_subscription" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    payee,
    amountCents,
    categoryId,
    accountId,
    frequency,
    nextExpectedDate,
    lastOccurrenceDate,
    isSubscription,
    isActive,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurringTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('payee')) {
      context.handle(
        _payeeMeta,
        payee.isAcceptableOrUnknown(data['payee']!, _payeeMeta),
      );
    } else if (isInserting) {
      context.missing(_payeeMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('next_expected_date')) {
      context.handle(
        _nextExpectedDateMeta,
        nextExpectedDate.isAcceptableOrUnknown(
          data['next_expected_date']!,
          _nextExpectedDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextExpectedDateMeta);
    }
    if (data.containsKey('last_occurrence_date')) {
      context.handle(
        _lastOccurrenceDateMeta,
        lastOccurrenceDate.isAcceptableOrUnknown(
          data['last_occurrence_date']!,
          _lastOccurrenceDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastOccurrenceDateMeta);
    }
    if (data.containsKey('is_subscription')) {
      context.handle(
        _isSubscriptionMeta,
        isSubscription.isAcceptableOrUnknown(
          data['is_subscription']!,
          _isSubscriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      payee: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payee'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      nextExpectedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_expected_date'],
      )!,
      lastOccurrenceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_occurrence_date'],
      )!,
      isSubscription: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_subscription'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RecurringTransactionsTable createAlias(String alias) {
    return $RecurringTransactionsTable(attachedDatabase, alias);
  }
}

class RecurringTransaction extends DataClass
    implements Insertable<RecurringTransaction> {
  final String id;
  final String payee;
  final int amountCents;
  final String? categoryId;
  final String accountId;
  final String frequency;
  final int nextExpectedDate;
  final int lastOccurrenceDate;
  final bool isSubscription;
  final bool isActive;
  final String? notes;
  final int createdAt;
  final int updatedAt;
  const RecurringTransaction({
    required this.id,
    required this.payee,
    required this.amountCents,
    this.categoryId,
    required this.accountId,
    required this.frequency,
    required this.nextExpectedDate,
    required this.lastOccurrenceDate,
    required this.isSubscription,
    required this.isActive,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['payee'] = Variable<String>(payee);
    map['amount_cents'] = Variable<int>(amountCents);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['account_id'] = Variable<String>(accountId);
    map['frequency'] = Variable<String>(frequency);
    map['next_expected_date'] = Variable<int>(nextExpectedDate);
    map['last_occurrence_date'] = Variable<int>(lastOccurrenceDate);
    map['is_subscription'] = Variable<bool>(isSubscription);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  RecurringTransactionsCompanion toCompanion(bool nullToAbsent) {
    return RecurringTransactionsCompanion(
      id: Value(id),
      payee: Value(payee),
      amountCents: Value(amountCents),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      accountId: Value(accountId),
      frequency: Value(frequency),
      nextExpectedDate: Value(nextExpectedDate),
      lastOccurrenceDate: Value(lastOccurrenceDate),
      isSubscription: Value(isSubscription),
      isActive: Value(isActive),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RecurringTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringTransaction(
      id: serializer.fromJson<String>(json['id']),
      payee: serializer.fromJson<String>(json['payee']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      accountId: serializer.fromJson<String>(json['accountId']),
      frequency: serializer.fromJson<String>(json['frequency']),
      nextExpectedDate: serializer.fromJson<int>(json['nextExpectedDate']),
      lastOccurrenceDate: serializer.fromJson<int>(json['lastOccurrenceDate']),
      isSubscription: serializer.fromJson<bool>(json['isSubscription']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'payee': serializer.toJson<String>(payee),
      'amountCents': serializer.toJson<int>(amountCents),
      'categoryId': serializer.toJson<String?>(categoryId),
      'accountId': serializer.toJson<String>(accountId),
      'frequency': serializer.toJson<String>(frequency),
      'nextExpectedDate': serializer.toJson<int>(nextExpectedDate),
      'lastOccurrenceDate': serializer.toJson<int>(lastOccurrenceDate),
      'isSubscription': serializer.toJson<bool>(isSubscription),
      'isActive': serializer.toJson<bool>(isActive),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  RecurringTransaction copyWith({
    String? id,
    String? payee,
    int? amountCents,
    Value<String?> categoryId = const Value.absent(),
    String? accountId,
    String? frequency,
    int? nextExpectedDate,
    int? lastOccurrenceDate,
    bool? isSubscription,
    bool? isActive,
    Value<String?> notes = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => RecurringTransaction(
    id: id ?? this.id,
    payee: payee ?? this.payee,
    amountCents: amountCents ?? this.amountCents,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    accountId: accountId ?? this.accountId,
    frequency: frequency ?? this.frequency,
    nextExpectedDate: nextExpectedDate ?? this.nextExpectedDate,
    lastOccurrenceDate: lastOccurrenceDate ?? this.lastOccurrenceDate,
    isSubscription: isSubscription ?? this.isSubscription,
    isActive: isActive ?? this.isActive,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RecurringTransaction copyWithCompanion(RecurringTransactionsCompanion data) {
    return RecurringTransaction(
      id: data.id.present ? data.id.value : this.id,
      payee: data.payee.present ? data.payee.value : this.payee,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      nextExpectedDate: data.nextExpectedDate.present
          ? data.nextExpectedDate.value
          : this.nextExpectedDate,
      lastOccurrenceDate: data.lastOccurrenceDate.present
          ? data.lastOccurrenceDate.value
          : this.lastOccurrenceDate,
      isSubscription: data.isSubscription.present
          ? data.isSubscription.value
          : this.isSubscription,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringTransaction(')
          ..write('id: $id, ')
          ..write('payee: $payee, ')
          ..write('amountCents: $amountCents, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('frequency: $frequency, ')
          ..write('nextExpectedDate: $nextExpectedDate, ')
          ..write('lastOccurrenceDate: $lastOccurrenceDate, ')
          ..write('isSubscription: $isSubscription, ')
          ..write('isActive: $isActive, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    payee,
    amountCents,
    categoryId,
    accountId,
    frequency,
    nextExpectedDate,
    lastOccurrenceDate,
    isSubscription,
    isActive,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringTransaction &&
          other.id == this.id &&
          other.payee == this.payee &&
          other.amountCents == this.amountCents &&
          other.categoryId == this.categoryId &&
          other.accountId == this.accountId &&
          other.frequency == this.frequency &&
          other.nextExpectedDate == this.nextExpectedDate &&
          other.lastOccurrenceDate == this.lastOccurrenceDate &&
          other.isSubscription == this.isSubscription &&
          other.isActive == this.isActive &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RecurringTransactionsCompanion
    extends UpdateCompanion<RecurringTransaction> {
  final Value<String> id;
  final Value<String> payee;
  final Value<int> amountCents;
  final Value<String?> categoryId;
  final Value<String> accountId;
  final Value<String> frequency;
  final Value<int> nextExpectedDate;
  final Value<int> lastOccurrenceDate;
  final Value<bool> isSubscription;
  final Value<bool> isActive;
  final Value<String?> notes;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const RecurringTransactionsCompanion({
    this.id = const Value.absent(),
    this.payee = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.frequency = const Value.absent(),
    this.nextExpectedDate = const Value.absent(),
    this.lastOccurrenceDate = const Value.absent(),
    this.isSubscription = const Value.absent(),
    this.isActive = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringTransactionsCompanion.insert({
    required String id,
    required String payee,
    required int amountCents,
    this.categoryId = const Value.absent(),
    required String accountId,
    required String frequency,
    required int nextExpectedDate,
    required int lastOccurrenceDate,
    this.isSubscription = const Value.absent(),
    this.isActive = const Value.absent(),
    this.notes = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       payee = Value(payee),
       amountCents = Value(amountCents),
       accountId = Value(accountId),
       frequency = Value(frequency),
       nextExpectedDate = Value(nextExpectedDate),
       lastOccurrenceDate = Value(lastOccurrenceDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RecurringTransaction> custom({
    Expression<String>? id,
    Expression<String>? payee,
    Expression<int>? amountCents,
    Expression<String>? categoryId,
    Expression<String>? accountId,
    Expression<String>? frequency,
    Expression<int>? nextExpectedDate,
    Expression<int>? lastOccurrenceDate,
    Expression<bool>? isSubscription,
    Expression<bool>? isActive,
    Expression<String>? notes,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (payee != null) 'payee': payee,
      if (amountCents != null) 'amount_cents': amountCents,
      if (categoryId != null) 'category_id': categoryId,
      if (accountId != null) 'account_id': accountId,
      if (frequency != null) 'frequency': frequency,
      if (nextExpectedDate != null) 'next_expected_date': nextExpectedDate,
      if (lastOccurrenceDate != null)
        'last_occurrence_date': lastOccurrenceDate,
      if (isSubscription != null) 'is_subscription': isSubscription,
      if (isActive != null) 'is_active': isActive,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringTransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? payee,
    Value<int>? amountCents,
    Value<String?>? categoryId,
    Value<String>? accountId,
    Value<String>? frequency,
    Value<int>? nextExpectedDate,
    Value<int>? lastOccurrenceDate,
    Value<bool>? isSubscription,
    Value<bool>? isActive,
    Value<String?>? notes,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return RecurringTransactionsCompanion(
      id: id ?? this.id,
      payee: payee ?? this.payee,
      amountCents: amountCents ?? this.amountCents,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      frequency: frequency ?? this.frequency,
      nextExpectedDate: nextExpectedDate ?? this.nextExpectedDate,
      lastOccurrenceDate: lastOccurrenceDate ?? this.lastOccurrenceDate,
      isSubscription: isSubscription ?? this.isSubscription,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (payee.present) {
      map['payee'] = Variable<String>(payee.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (nextExpectedDate.present) {
      map['next_expected_date'] = Variable<int>(nextExpectedDate.value);
    }
    if (lastOccurrenceDate.present) {
      map['last_occurrence_date'] = Variable<int>(lastOccurrenceDate.value);
    }
    if (isSubscription.present) {
      map['is_subscription'] = Variable<bool>(isSubscription.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
    return (StringBuffer('RecurringTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('payee: $payee, ')
          ..write('amountCents: $amountCents, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('frequency: $frequency, ')
          ..write('nextExpectedDate: $nextExpectedDate, ')
          ..write('lastOccurrenceDate: $lastOccurrenceDate, ')
          ..write('isSubscription: $isSubscription, ')
          ..write('isActive: $isActive, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PayeeCategoryCacheTable extends PayeeCategoryCache
    with TableInfo<$PayeeCategoryCacheTable, PayeeCategoryCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PayeeCategoryCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _payeeNormalizedMeta = const VerificationMeta(
    'payeeNormalized',
  );
  @override
  late final GeneratedColumn<String> payeeNormalized = GeneratedColumn<String>(
    'payee_normalized',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _useCountMeta = const VerificationMeta(
    'useCount',
  );
  @override
  late final GeneratedColumn<int> useCount = GeneratedColumn<int>(
    'use_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    payeeNormalized,
    categoryId,
    confidence,
    source,
    useCount,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payee_category_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<PayeeCategoryCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('payee_normalized')) {
      context.handle(
        _payeeNormalizedMeta,
        payeeNormalized.isAcceptableOrUnknown(
          data['payee_normalized']!,
          _payeeNormalizedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payeeNormalizedMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('use_count')) {
      context.handle(
        _useCountMeta,
        useCount.isAcceptableOrUnknown(data['use_count']!, _useCountMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {payeeNormalized};
  @override
  PayeeCategoryCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PayeeCategoryCacheData(
      payeeNormalized: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payee_normalized'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      useCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}use_count'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PayeeCategoryCacheTable createAlias(String alias) {
    return $PayeeCategoryCacheTable(attachedDatabase, alias);
  }
}

class PayeeCategoryCacheData extends DataClass
    implements Insertable<PayeeCategoryCacheData> {
  final String payeeNormalized;
  final String categoryId;
  final double confidence;
  final String source;
  final int useCount;
  final int updatedAt;
  const PayeeCategoryCacheData({
    required this.payeeNormalized,
    required this.categoryId,
    required this.confidence,
    required this.source,
    required this.useCount,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['payee_normalized'] = Variable<String>(payeeNormalized);
    map['category_id'] = Variable<String>(categoryId);
    map['confidence'] = Variable<double>(confidence);
    map['source'] = Variable<String>(source);
    map['use_count'] = Variable<int>(useCount);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  PayeeCategoryCacheCompanion toCompanion(bool nullToAbsent) {
    return PayeeCategoryCacheCompanion(
      payeeNormalized: Value(payeeNormalized),
      categoryId: Value(categoryId),
      confidence: Value(confidence),
      source: Value(source),
      useCount: Value(useCount),
      updatedAt: Value(updatedAt),
    );
  }

  factory PayeeCategoryCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PayeeCategoryCacheData(
      payeeNormalized: serializer.fromJson<String>(json['payeeNormalized']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      confidence: serializer.fromJson<double>(json['confidence']),
      source: serializer.fromJson<String>(json['source']),
      useCount: serializer.fromJson<int>(json['useCount']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'payeeNormalized': serializer.toJson<String>(payeeNormalized),
      'categoryId': serializer.toJson<String>(categoryId),
      'confidence': serializer.toJson<double>(confidence),
      'source': serializer.toJson<String>(source),
      'useCount': serializer.toJson<int>(useCount),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  PayeeCategoryCacheData copyWith({
    String? payeeNormalized,
    String? categoryId,
    double? confidence,
    String? source,
    int? useCount,
    int? updatedAt,
  }) => PayeeCategoryCacheData(
    payeeNormalized: payeeNormalized ?? this.payeeNormalized,
    categoryId: categoryId ?? this.categoryId,
    confidence: confidence ?? this.confidence,
    source: source ?? this.source,
    useCount: useCount ?? this.useCount,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PayeeCategoryCacheData copyWithCompanion(PayeeCategoryCacheCompanion data) {
    return PayeeCategoryCacheData(
      payeeNormalized: data.payeeNormalized.present
          ? data.payeeNormalized.value
          : this.payeeNormalized,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      source: data.source.present ? data.source.value : this.source,
      useCount: data.useCount.present ? data.useCount.value : this.useCount,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PayeeCategoryCacheData(')
          ..write('payeeNormalized: $payeeNormalized, ')
          ..write('categoryId: $categoryId, ')
          ..write('confidence: $confidence, ')
          ..write('source: $source, ')
          ..write('useCount: $useCount, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    payeeNormalized,
    categoryId,
    confidence,
    source,
    useCount,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PayeeCategoryCacheData &&
          other.payeeNormalized == this.payeeNormalized &&
          other.categoryId == this.categoryId &&
          other.confidence == this.confidence &&
          other.source == this.source &&
          other.useCount == this.useCount &&
          other.updatedAt == this.updatedAt);
}

class PayeeCategoryCacheCompanion
    extends UpdateCompanion<PayeeCategoryCacheData> {
  final Value<String> payeeNormalized;
  final Value<String> categoryId;
  final Value<double> confidence;
  final Value<String> source;
  final Value<int> useCount;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const PayeeCategoryCacheCompanion({
    this.payeeNormalized = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.confidence = const Value.absent(),
    this.source = const Value.absent(),
    this.useCount = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PayeeCategoryCacheCompanion.insert({
    required String payeeNormalized,
    required String categoryId,
    required double confidence,
    required String source,
    this.useCount = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : payeeNormalized = Value(payeeNormalized),
       categoryId = Value(categoryId),
       confidence = Value(confidence),
       source = Value(source),
       updatedAt = Value(updatedAt);
  static Insertable<PayeeCategoryCacheData> custom({
    Expression<String>? payeeNormalized,
    Expression<String>? categoryId,
    Expression<double>? confidence,
    Expression<String>? source,
    Expression<int>? useCount,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (payeeNormalized != null) 'payee_normalized': payeeNormalized,
      if (categoryId != null) 'category_id': categoryId,
      if (confidence != null) 'confidence': confidence,
      if (source != null) 'source': source,
      if (useCount != null) 'use_count': useCount,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PayeeCategoryCacheCompanion copyWith({
    Value<String>? payeeNormalized,
    Value<String>? categoryId,
    Value<double>? confidence,
    Value<String>? source,
    Value<int>? useCount,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return PayeeCategoryCacheCompanion(
      payeeNormalized: payeeNormalized ?? this.payeeNormalized,
      categoryId: categoryId ?? this.categoryId,
      confidence: confidence ?? this.confidence,
      source: source ?? this.source,
      useCount: useCount ?? this.useCount,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (payeeNormalized.present) {
      map['payee_normalized'] = Variable<String>(payeeNormalized.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (useCount.present) {
      map['use_count'] = Variable<int>(useCount.value);
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
    return (StringBuffer('PayeeCategoryCacheCompanion(')
          ..write('payeeNormalized: $payeeNormalized, ')
          ..write('categoryId: $categoryId, ')
          ..write('confidence: $confidence, ')
          ..write('source: $source, ')
          ..write('useCount: $useCount, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategorizationCorrectionsTable extends CategorizationCorrections
    with TableInfo<$CategorizationCorrectionsTable, CategorizationCorrection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategorizationCorrectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _oldCategoryIdMeta = const VerificationMeta(
    'oldCategoryId',
  );
  @override
  late final GeneratedColumn<String> oldCategoryId = GeneratedColumn<String>(
    'old_category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _newCategoryIdMeta = const VerificationMeta(
    'newCategoryId',
  );
  @override
  late final GeneratedColumn<String> newCategoryId = GeneratedColumn<String>(
    'new_category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payeeMeta = const VerificationMeta('payee');
  @override
  late final GeneratedColumn<String> payee = GeneratedColumn<String>(
    'payee',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionId,
    oldCategoryId,
    newCategoryId,
    payee,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categorization_corrections';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategorizationCorrection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('old_category_id')) {
      context.handle(
        _oldCategoryIdMeta,
        oldCategoryId.isAcceptableOrUnknown(
          data['old_category_id']!,
          _oldCategoryIdMeta,
        ),
      );
    }
    if (data.containsKey('new_category_id')) {
      context.handle(
        _newCategoryIdMeta,
        newCategoryId.isAcceptableOrUnknown(
          data['new_category_id']!,
          _newCategoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_newCategoryIdMeta);
    }
    if (data.containsKey('payee')) {
      context.handle(
        _payeeMeta,
        payee.isAcceptableOrUnknown(data['payee']!, _payeeMeta),
      );
    } else if (isInserting) {
      context.missing(_payeeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategorizationCorrection map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategorizationCorrection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      )!,
      oldCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}old_category_id'],
      ),
      newCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}new_category_id'],
      )!,
      payee: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payee'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CategorizationCorrectionsTable createAlias(String alias) {
    return $CategorizationCorrectionsTable(attachedDatabase, alias);
  }
}

class CategorizationCorrection extends DataClass
    implements Insertable<CategorizationCorrection> {
  final String id;
  final String transactionId;
  final String? oldCategoryId;
  final String newCategoryId;
  final String payee;
  final int createdAt;
  const CategorizationCorrection({
    required this.id,
    required this.transactionId,
    this.oldCategoryId,
    required this.newCategoryId,
    required this.payee,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transaction_id'] = Variable<String>(transactionId);
    if (!nullToAbsent || oldCategoryId != null) {
      map['old_category_id'] = Variable<String>(oldCategoryId);
    }
    map['new_category_id'] = Variable<String>(newCategoryId);
    map['payee'] = Variable<String>(payee);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  CategorizationCorrectionsCompanion toCompanion(bool nullToAbsent) {
    return CategorizationCorrectionsCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      oldCategoryId: oldCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(oldCategoryId),
      newCategoryId: Value(newCategoryId),
      payee: Value(payee),
      createdAt: Value(createdAt),
    );
  }

  factory CategorizationCorrection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategorizationCorrection(
      id: serializer.fromJson<String>(json['id']),
      transactionId: serializer.fromJson<String>(json['transactionId']),
      oldCategoryId: serializer.fromJson<String?>(json['oldCategoryId']),
      newCategoryId: serializer.fromJson<String>(json['newCategoryId']),
      payee: serializer.fromJson<String>(json['payee']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transactionId': serializer.toJson<String>(transactionId),
      'oldCategoryId': serializer.toJson<String?>(oldCategoryId),
      'newCategoryId': serializer.toJson<String>(newCategoryId),
      'payee': serializer.toJson<String>(payee),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  CategorizationCorrection copyWith({
    String? id,
    String? transactionId,
    Value<String?> oldCategoryId = const Value.absent(),
    String? newCategoryId,
    String? payee,
    int? createdAt,
  }) => CategorizationCorrection(
    id: id ?? this.id,
    transactionId: transactionId ?? this.transactionId,
    oldCategoryId: oldCategoryId.present
        ? oldCategoryId.value
        : this.oldCategoryId,
    newCategoryId: newCategoryId ?? this.newCategoryId,
    payee: payee ?? this.payee,
    createdAt: createdAt ?? this.createdAt,
  );
  CategorizationCorrection copyWithCompanion(
    CategorizationCorrectionsCompanion data,
  ) {
    return CategorizationCorrection(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      oldCategoryId: data.oldCategoryId.present
          ? data.oldCategoryId.value
          : this.oldCategoryId,
      newCategoryId: data.newCategoryId.present
          ? data.newCategoryId.value
          : this.newCategoryId,
      payee: data.payee.present ? data.payee.value : this.payee,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategorizationCorrection(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('oldCategoryId: $oldCategoryId, ')
          ..write('newCategoryId: $newCategoryId, ')
          ..write('payee: $payee, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transactionId,
    oldCategoryId,
    newCategoryId,
    payee,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategorizationCorrection &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.oldCategoryId == this.oldCategoryId &&
          other.newCategoryId == this.newCategoryId &&
          other.payee == this.payee &&
          other.createdAt == this.createdAt);
}

class CategorizationCorrectionsCompanion
    extends UpdateCompanion<CategorizationCorrection> {
  final Value<String> id;
  final Value<String> transactionId;
  final Value<String?> oldCategoryId;
  final Value<String> newCategoryId;
  final Value<String> payee;
  final Value<int> createdAt;
  final Value<int> rowid;
  const CategorizationCorrectionsCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.oldCategoryId = const Value.absent(),
    this.newCategoryId = const Value.absent(),
    this.payee = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategorizationCorrectionsCompanion.insert({
    required String id,
    required String transactionId,
    this.oldCategoryId = const Value.absent(),
    required String newCategoryId,
    required String payee,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       transactionId = Value(transactionId),
       newCategoryId = Value(newCategoryId),
       payee = Value(payee),
       createdAt = Value(createdAt);
  static Insertable<CategorizationCorrection> custom({
    Expression<String>? id,
    Expression<String>? transactionId,
    Expression<String>? oldCategoryId,
    Expression<String>? newCategoryId,
    Expression<String>? payee,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (oldCategoryId != null) 'old_category_id': oldCategoryId,
      if (newCategoryId != null) 'new_category_id': newCategoryId,
      if (payee != null) 'payee': payee,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategorizationCorrectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? transactionId,
    Value<String?>? oldCategoryId,
    Value<String>? newCategoryId,
    Value<String>? payee,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return CategorizationCorrectionsCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      oldCategoryId: oldCategoryId ?? this.oldCategoryId,
      newCategoryId: newCategoryId ?? this.newCategoryId,
      payee: payee ?? this.payee,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (oldCategoryId.present) {
      map['old_category_id'] = Variable<String>(oldCategoryId.value);
    }
    if (newCategoryId.present) {
      map['new_category_id'] = Variable<String>(newCategoryId.value);
    }
    if (payee.present) {
      map['payee'] = Variable<String>(payee.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategorizationCorrectionsCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('oldCategoryId: $oldCategoryId, ')
          ..write('newCategoryId: $newCategoryId, ')
          ..write('payee: $payee, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConversationsTable extends Conversations
    with TableInfo<$ConversationsTable, Conversation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purposeMeta = const VerificationMeta(
    'purpose',
  );
  @override
  late final GeneratedColumn<String> purpose = GeneratedColumn<String>(
    'purpose',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('general'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    provider,
    model,
    purpose,
    createdAt,
    updatedAt,
    version,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Conversation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('purpose')) {
      context.handle(
        _purposeMeta,
        purpose.isAcceptableOrUnknown(data['purpose']!, _purposeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Conversation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Conversation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      purpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purpose'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $ConversationsTable createAlias(String alias) {
    return $ConversationsTable(attachedDatabase, alias);
  }
}

class Conversation extends DataClass implements Insertable<Conversation> {
  final String id;
  final String? title;
  final String provider;
  final String model;
  final String purpose;
  final int createdAt;
  final int updatedAt;
  final int version;
  final int syncStatus;
  const Conversation({
    required this.id,
    this.title,
    required this.provider,
    required this.model,
    required this.purpose,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['provider'] = Variable<String>(provider);
    map['model'] = Variable<String>(model);
    map['purpose'] = Variable<String>(purpose);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['version'] = Variable<int>(version);
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  ConversationsCompanion toCompanion(bool nullToAbsent) {
    return ConversationsCompanion(
      id: Value(id),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      provider: Value(provider),
      model: Value(model),
      purpose: Value(purpose),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      syncStatus: Value(syncStatus),
    );
  }

  factory Conversation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Conversation(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String?>(json['title']),
      provider: serializer.fromJson<String>(json['provider']),
      model: serializer.fromJson<String>(json['model']),
      purpose: serializer.fromJson<String>(json['purpose']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String?>(title),
      'provider': serializer.toJson<String>(provider),
      'model': serializer.toJson<String>(model),
      'purpose': serializer.toJson<String>(purpose),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'version': serializer.toJson<int>(version),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  Conversation copyWith({
    String? id,
    Value<String?> title = const Value.absent(),
    String? provider,
    String? model,
    String? purpose,
    int? createdAt,
    int? updatedAt,
    int? version,
    int? syncStatus,
  }) => Conversation(
    id: id ?? this.id,
    title: title.present ? title.value : this.title,
    provider: provider ?? this.provider,
    model: model ?? this.model,
    purpose: purpose ?? this.purpose,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  Conversation copyWithCompanion(ConversationsCompanion data) {
    return Conversation(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      provider: data.provider.present ? data.provider.value : this.provider,
      model: data.model.present ? data.model.value : this.model,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Conversation(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('provider: $provider, ')
          ..write('model: $model, ')
          ..write('purpose: $purpose, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    provider,
    model,
    purpose,
    createdAt,
    updatedAt,
    version,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Conversation &&
          other.id == this.id &&
          other.title == this.title &&
          other.provider == this.provider &&
          other.model == this.model &&
          other.purpose == this.purpose &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.syncStatus == this.syncStatus);
}

class ConversationsCompanion extends UpdateCompanion<Conversation> {
  final Value<String> id;
  final Value<String?> title;
  final Value<String> provider;
  final Value<String> model;
  final Value<String> purpose;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> version;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const ConversationsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.provider = const Value.absent(),
    this.model = const Value.absent(),
    this.purpose = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversationsCompanion.insert({
    required String id,
    this.title = const Value.absent(),
    required String provider,
    required String model,
    this.purpose = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.version = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       provider = Value(provider),
       model = Value(model),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Conversation> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? provider,
    Expression<String>? model,
    Expression<String>? purpose,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? version,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (provider != null) 'provider': provider,
      if (model != null) 'model': model,
      if (purpose != null) 'purpose': purpose,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversationsCompanion copyWith({
    Value<String>? id,
    Value<String?>? title,
    Value<String>? provider,
    Value<String>? model,
    Value<String>? purpose,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? version,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return ConversationsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      provider: provider ?? this.provider,
      model: model ?? this.model,
      purpose: purpose ?? this.purpose,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(purpose.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversationsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('provider: $provider, ')
          ..write('model: $model, ')
          ..write('purpose: $purpose, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages with TableInfo<$MessagesTable, Message> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokenCountMeta = const VerificationMeta(
    'tokenCount',
  );
  @override
  late final GeneratedColumn<int> tokenCount = GeneratedColumn<int>(
    'token_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conversationId,
    role,
    content,
    tokenCount,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<Message> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('token_count')) {
      context.handle(
        _tokenCountMeta,
        tokenCount.isAcceptableOrUnknown(data['token_count']!, _tokenCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Message map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Message(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      tokenCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}token_count'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class Message extends DataClass implements Insertable<Message> {
  final String id;
  final String conversationId;
  final String role;
  final String content;
  final int? tokenCount;
  final int createdAt;
  const Message({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    this.tokenCount,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || tokenCount != null) {
      map['token_count'] = Variable<int>(tokenCount);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      role: Value(role),
      content: Value(content),
      tokenCount: tokenCount == null && nullToAbsent
          ? const Value.absent()
          : Value(tokenCount),
      createdAt: Value(createdAt),
    );
  }

  factory Message.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Message(
      id: serializer.fromJson<String>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      tokenCount: serializer.fromJson<int?>(json['tokenCount']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'tokenCount': serializer.toJson<int?>(tokenCount),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  Message copyWith({
    String? id,
    String? conversationId,
    String? role,
    String? content,
    Value<int?> tokenCount = const Value.absent(),
    int? createdAt,
  }) => Message(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    role: role ?? this.role,
    content: content ?? this.content,
    tokenCount: tokenCount.present ? tokenCount.value : this.tokenCount,
    createdAt: createdAt ?? this.createdAt,
  );
  Message copyWithCompanion(MessagesCompanion data) {
    return Message(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      tokenCount: data.tokenCount.present
          ? data.tokenCount.value
          : this.tokenCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Message(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('tokenCount: $tokenCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, conversationId, role, content, tokenCount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.role == this.role &&
          other.content == this.content &&
          other.tokenCount == this.tokenCount &&
          other.createdAt == this.createdAt);
}

class MessagesCompanion extends UpdateCompanion<Message> {
  final Value<String> id;
  final Value<String> conversationId;
  final Value<String> role;
  final Value<String> content;
  final Value<int?> tokenCount;
  final Value<int> createdAt;
  final Value<int> rowid;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.tokenCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesCompanion.insert({
    required String id,
    required String conversationId,
    required String role,
    required String content,
    this.tokenCount = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       conversationId = Value(conversationId),
       role = Value(role),
       content = Value(content),
       createdAt = Value(createdAt);
  static Insertable<Message> custom({
    Expression<String>? id,
    Expression<String>? conversationId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<int>? tokenCount,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (tokenCount != null) 'token_count': tokenCount,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? conversationId,
    Value<String>? role,
    Value<String>? content,
    Value<int?>? tokenCount,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return MessagesCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      role: role ?? this.role,
      content: content ?? this.content,
      tokenCount: tokenCount ?? this.tokenCount,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (tokenCount.present) {
      map['token_count'] = Variable<int>(tokenCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('tokenCount: $tokenCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InsightsTable extends Insights with TableInfo<$InsightsTable, Insight> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InsightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _insightTypeMeta = const VerificationMeta(
    'insightType',
  );
  @override
  late final GeneratedColumn<String> insightType = GeneratedColumn<String>(
    'insight_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionTypeMeta = const VerificationMeta(
    'actionType',
  );
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
    'action_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actionDataMeta = const VerificationMeta(
    'actionData',
  );
  @override
  late final GeneratedColumn<String> actionData = GeneratedColumn<String>(
    'action_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDismissedMeta = const VerificationMeta(
    'isDismissed',
  );
  @override
  late final GeneratedColumn<bool> isDismissed = GeneratedColumn<bool>(
    'is_dismissed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_dismissed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<int> expiresAt = GeneratedColumn<int>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    insightType,
    severity,
    actionType,
    actionData,
    isRead,
    isDismissed,
    expiresAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'insights';
  @override
  VerificationContext validateIntegrity(
    Insertable<Insight> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('insight_type')) {
      context.handle(
        _insightTypeMeta,
        insightType.isAcceptableOrUnknown(
          data['insight_type']!,
          _insightTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_insightTypeMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('action_type')) {
      context.handle(
        _actionTypeMeta,
        actionType.isAcceptableOrUnknown(data['action_type']!, _actionTypeMeta),
      );
    }
    if (data.containsKey('action_data')) {
      context.handle(
        _actionDataMeta,
        actionData.isAcceptableOrUnknown(data['action_data']!, _actionDataMeta),
      );
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    if (data.containsKey('is_dismissed')) {
      context.handle(
        _isDismissedMeta,
        isDismissed.isAcceptableOrUnknown(
          data['is_dismissed']!,
          _isDismissedMeta,
        ),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Insight map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Insight(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      insightType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}insight_type'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity'],
      )!,
      actionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_type'],
      ),
      actionData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_data'],
      ),
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
      isDismissed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_dismissed'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expires_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $InsightsTable createAlias(String alias) {
    return $InsightsTable(attachedDatabase, alias);
  }
}

class Insight extends DataClass implements Insertable<Insight> {
  final String id;
  final String title;
  final String description;
  final String insightType;
  final String severity;
  final String? actionType;
  final String? actionData;
  final bool isRead;
  final bool isDismissed;
  final int? expiresAt;
  final int createdAt;
  const Insight({
    required this.id,
    required this.title,
    required this.description,
    required this.insightType,
    required this.severity,
    this.actionType,
    this.actionData,
    required this.isRead,
    required this.isDismissed,
    this.expiresAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['insight_type'] = Variable<String>(insightType);
    map['severity'] = Variable<String>(severity);
    if (!nullToAbsent || actionType != null) {
      map['action_type'] = Variable<String>(actionType);
    }
    if (!nullToAbsent || actionData != null) {
      map['action_data'] = Variable<String>(actionData);
    }
    map['is_read'] = Variable<bool>(isRead);
    map['is_dismissed'] = Variable<bool>(isDismissed);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<int>(expiresAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  InsightsCompanion toCompanion(bool nullToAbsent) {
    return InsightsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      insightType: Value(insightType),
      severity: Value(severity),
      actionType: actionType == null && nullToAbsent
          ? const Value.absent()
          : Value(actionType),
      actionData: actionData == null && nullToAbsent
          ? const Value.absent()
          : Value(actionData),
      isRead: Value(isRead),
      isDismissed: Value(isDismissed),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      createdAt: Value(createdAt),
    );
  }

  factory Insight.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Insight(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      insightType: serializer.fromJson<String>(json['insightType']),
      severity: serializer.fromJson<String>(json['severity']),
      actionType: serializer.fromJson<String?>(json['actionType']),
      actionData: serializer.fromJson<String?>(json['actionData']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      isDismissed: serializer.fromJson<bool>(json['isDismissed']),
      expiresAt: serializer.fromJson<int?>(json['expiresAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'insightType': serializer.toJson<String>(insightType),
      'severity': serializer.toJson<String>(severity),
      'actionType': serializer.toJson<String?>(actionType),
      'actionData': serializer.toJson<String?>(actionData),
      'isRead': serializer.toJson<bool>(isRead),
      'isDismissed': serializer.toJson<bool>(isDismissed),
      'expiresAt': serializer.toJson<int?>(expiresAt),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  Insight copyWith({
    String? id,
    String? title,
    String? description,
    String? insightType,
    String? severity,
    Value<String?> actionType = const Value.absent(),
    Value<String?> actionData = const Value.absent(),
    bool? isRead,
    bool? isDismissed,
    Value<int?> expiresAt = const Value.absent(),
    int? createdAt,
  }) => Insight(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    insightType: insightType ?? this.insightType,
    severity: severity ?? this.severity,
    actionType: actionType.present ? actionType.value : this.actionType,
    actionData: actionData.present ? actionData.value : this.actionData,
    isRead: isRead ?? this.isRead,
    isDismissed: isDismissed ?? this.isDismissed,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
    createdAt: createdAt ?? this.createdAt,
  );
  Insight copyWithCompanion(InsightsCompanion data) {
    return Insight(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      insightType: data.insightType.present
          ? data.insightType.value
          : this.insightType,
      severity: data.severity.present ? data.severity.value : this.severity,
      actionType: data.actionType.present
          ? data.actionType.value
          : this.actionType,
      actionData: data.actionData.present
          ? data.actionData.value
          : this.actionData,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      isDismissed: data.isDismissed.present
          ? data.isDismissed.value
          : this.isDismissed,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Insight(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('insightType: $insightType, ')
          ..write('severity: $severity, ')
          ..write('actionType: $actionType, ')
          ..write('actionData: $actionData, ')
          ..write('isRead: $isRead, ')
          ..write('isDismissed: $isDismissed, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    insightType,
    severity,
    actionType,
    actionData,
    isRead,
    isDismissed,
    expiresAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Insight &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.insightType == this.insightType &&
          other.severity == this.severity &&
          other.actionType == this.actionType &&
          other.actionData == this.actionData &&
          other.isRead == this.isRead &&
          other.isDismissed == this.isDismissed &&
          other.expiresAt == this.expiresAt &&
          other.createdAt == this.createdAt);
}

class InsightsCompanion extends UpdateCompanion<Insight> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> insightType;
  final Value<String> severity;
  final Value<String?> actionType;
  final Value<String?> actionData;
  final Value<bool> isRead;
  final Value<bool> isDismissed;
  final Value<int?> expiresAt;
  final Value<int> createdAt;
  final Value<int> rowid;
  const InsightsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.insightType = const Value.absent(),
    this.severity = const Value.absent(),
    this.actionType = const Value.absent(),
    this.actionData = const Value.absent(),
    this.isRead = const Value.absent(),
    this.isDismissed = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InsightsCompanion.insert({
    required String id,
    required String title,
    required String description,
    required String insightType,
    required String severity,
    this.actionType = const Value.absent(),
    this.actionData = const Value.absent(),
    this.isRead = const Value.absent(),
    this.isDismissed = const Value.absent(),
    this.expiresAt = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       description = Value(description),
       insightType = Value(insightType),
       severity = Value(severity),
       createdAt = Value(createdAt);
  static Insertable<Insight> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? insightType,
    Expression<String>? severity,
    Expression<String>? actionType,
    Expression<String>? actionData,
    Expression<bool>? isRead,
    Expression<bool>? isDismissed,
    Expression<int>? expiresAt,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (insightType != null) 'insight_type': insightType,
      if (severity != null) 'severity': severity,
      if (actionType != null) 'action_type': actionType,
      if (actionData != null) 'action_data': actionData,
      if (isRead != null) 'is_read': isRead,
      if (isDismissed != null) 'is_dismissed': isDismissed,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InsightsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<String>? insightType,
    Value<String>? severity,
    Value<String?>? actionType,
    Value<String?>? actionData,
    Value<bool>? isRead,
    Value<bool>? isDismissed,
    Value<int?>? expiresAt,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return InsightsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      insightType: insightType ?? this.insightType,
      severity: severity ?? this.severity,
      actionType: actionType ?? this.actionType,
      actionData: actionData ?? this.actionData,
      isRead: isRead ?? this.isRead,
      isDismissed: isDismissed ?? this.isDismissed,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (insightType.present) {
      map['insight_type'] = Variable<String>(insightType.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (actionData.present) {
      map['action_data'] = Variable<String>(actionData.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (isDismissed.present) {
      map['is_dismissed'] = Variable<bool>(isDismissed.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<int>(expiresAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InsightsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('insightType: $insightType, ')
          ..write('severity: $severity, ')
          ..write('actionType: $actionType, ')
          ..write('actionData: $actionData, ')
          ..write('isRead: $isRead, ')
          ..write('isDismissed: $isDismissed, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiMemoryCoreTable extends AiMemoryCore
    with TableInfo<$AiMemoryCoreTable, AiMemoryCoreData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiMemoryCoreTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_memory_core';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiMemoryCoreData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiMemoryCoreData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiMemoryCoreData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AiMemoryCoreTable createAlias(String alias) {
    return $AiMemoryCoreTable(attachedDatabase, alias);
  }
}

class AiMemoryCoreData extends DataClass
    implements Insertable<AiMemoryCoreData> {
  final String id;
  final String key;
  final String value;
  final int updatedAt;
  const AiMemoryCoreData({
    required this.id,
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  AiMemoryCoreCompanion toCompanion(bool nullToAbsent) {
    return AiMemoryCoreCompanion(
      id: Value(id),
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AiMemoryCoreData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiMemoryCoreData(
      id: serializer.fromJson<String>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  AiMemoryCoreData copyWith({
    String? id,
    String? key,
    String? value,
    int? updatedAt,
  }) => AiMemoryCoreData(
    id: id ?? this.id,
    key: key ?? this.key,
    value: value ?? this.value,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AiMemoryCoreData copyWithCompanion(AiMemoryCoreCompanion data) {
    return AiMemoryCoreData(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiMemoryCoreData(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiMemoryCoreData &&
          other.id == this.id &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AiMemoryCoreCompanion extends UpdateCompanion<AiMemoryCoreData> {
  final Value<String> id;
  final Value<String> key;
  final Value<String> value;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const AiMemoryCoreCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiMemoryCoreCompanion.insert({
    required String id,
    required String key,
    required String value,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<AiMemoryCoreData> custom({
    Expression<String>? id,
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiMemoryCoreCompanion copyWith({
    Value<String>? id,
    Value<String>? key,
    Value<String>? value,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return AiMemoryCoreCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
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
    return (StringBuffer('AiMemoryCoreCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiMemorySemanticTable extends AiMemorySemantic
    with TableInfo<$AiMemorySemanticTable, AiMemorySemanticData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiMemorySemanticTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
    'topic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    topic,
    summary,
    conversationId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_memory_semantic';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiMemorySemanticData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('topic')) {
      context.handle(
        _topicMeta,
        topic.isAcceptableOrUnknown(data['topic']!, _topicMeta),
      );
    } else if (isInserting) {
      context.missing(_topicMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiMemorySemanticData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiMemorySemanticData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      topic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AiMemorySemanticTable createAlias(String alias) {
    return $AiMemorySemanticTable(attachedDatabase, alias);
  }
}

class AiMemorySemanticData extends DataClass
    implements Insertable<AiMemorySemanticData> {
  final String id;
  final String topic;
  final String summary;
  final String? conversationId;
  final int createdAt;
  const AiMemorySemanticData({
    required this.id,
    required this.topic,
    required this.summary,
    this.conversationId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['topic'] = Variable<String>(topic);
    map['summary'] = Variable<String>(summary);
    if (!nullToAbsent || conversationId != null) {
      map['conversation_id'] = Variable<String>(conversationId);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  AiMemorySemanticCompanion toCompanion(bool nullToAbsent) {
    return AiMemorySemanticCompanion(
      id: Value(id),
      topic: Value(topic),
      summary: Value(summary),
      conversationId: conversationId == null && nullToAbsent
          ? const Value.absent()
          : Value(conversationId),
      createdAt: Value(createdAt),
    );
  }

  factory AiMemorySemanticData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiMemorySemanticData(
      id: serializer.fromJson<String>(json['id']),
      topic: serializer.fromJson<String>(json['topic']),
      summary: serializer.fromJson<String>(json['summary']),
      conversationId: serializer.fromJson<String?>(json['conversationId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'topic': serializer.toJson<String>(topic),
      'summary': serializer.toJson<String>(summary),
      'conversationId': serializer.toJson<String?>(conversationId),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  AiMemorySemanticData copyWith({
    String? id,
    String? topic,
    String? summary,
    Value<String?> conversationId = const Value.absent(),
    int? createdAt,
  }) => AiMemorySemanticData(
    id: id ?? this.id,
    topic: topic ?? this.topic,
    summary: summary ?? this.summary,
    conversationId: conversationId.present
        ? conversationId.value
        : this.conversationId,
    createdAt: createdAt ?? this.createdAt,
  );
  AiMemorySemanticData copyWithCompanion(AiMemorySemanticCompanion data) {
    return AiMemorySemanticData(
      id: data.id.present ? data.id.value : this.id,
      topic: data.topic.present ? data.topic.value : this.topic,
      summary: data.summary.present ? data.summary.value : this.summary,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiMemorySemanticData(')
          ..write('id: $id, ')
          ..write('topic: $topic, ')
          ..write('summary: $summary, ')
          ..write('conversationId: $conversationId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, topic, summary, conversationId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiMemorySemanticData &&
          other.id == this.id &&
          other.topic == this.topic &&
          other.summary == this.summary &&
          other.conversationId == this.conversationId &&
          other.createdAt == this.createdAt);
}

class AiMemorySemanticCompanion extends UpdateCompanion<AiMemorySemanticData> {
  final Value<String> id;
  final Value<String> topic;
  final Value<String> summary;
  final Value<String?> conversationId;
  final Value<int> createdAt;
  final Value<int> rowid;
  const AiMemorySemanticCompanion({
    this.id = const Value.absent(),
    this.topic = const Value.absent(),
    this.summary = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiMemorySemanticCompanion.insert({
    required String id,
    required String topic,
    required String summary,
    this.conversationId = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       topic = Value(topic),
       summary = Value(summary),
       createdAt = Value(createdAt);
  static Insertable<AiMemorySemanticData> custom({
    Expression<String>? id,
    Expression<String>? topic,
    Expression<String>? summary,
    Expression<String>? conversationId,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (topic != null) 'topic': topic,
      if (summary != null) 'summary': summary,
      if (conversationId != null) 'conversation_id': conversationId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiMemorySemanticCompanion copyWith({
    Value<String>? id,
    Value<String>? topic,
    Value<String>? summary,
    Value<String?>? conversationId,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return AiMemorySemanticCompanion(
      id: id ?? this.id,
      topic: topic ?? this.topic,
      summary: summary ?? this.summary,
      conversationId: conversationId ?? this.conversationId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiMemorySemanticCompanion(')
          ..write('id: $id, ')
          ..write('topic: $topic, ')
          ..write('summary: $summary, ')
          ..write('conversationId: $conversationId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InsightFeedbackTable extends InsightFeedback
    with TableInfo<$InsightFeedbackTable, InsightFeedbackData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InsightFeedbackTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _insightIdMeta = const VerificationMeta(
    'insightId',
  );
  @override
  late final GeneratedColumn<String> insightId = GeneratedColumn<String>(
    'insight_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<String> rating = GeneratedColumn<String>(
    'rating',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, insightId, rating, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'insight_feedback';
  @override
  VerificationContext validateIntegrity(
    Insertable<InsightFeedbackData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('insight_id')) {
      context.handle(
        _insightIdMeta,
        insightId.isAcceptableOrUnknown(data['insight_id']!, _insightIdMeta),
      );
    } else if (isInserting) {
      context.missing(_insightIdMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InsightFeedbackData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InsightFeedbackData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      insightId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}insight_id'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rating'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $InsightFeedbackTable createAlias(String alias) {
    return $InsightFeedbackTable(attachedDatabase, alias);
  }
}

class InsightFeedbackData extends DataClass
    implements Insertable<InsightFeedbackData> {
  final String id;
  final String insightId;
  final String rating;
  final int createdAt;
  const InsightFeedbackData({
    required this.id,
    required this.insightId,
    required this.rating,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['insight_id'] = Variable<String>(insightId);
    map['rating'] = Variable<String>(rating);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  InsightFeedbackCompanion toCompanion(bool nullToAbsent) {
    return InsightFeedbackCompanion(
      id: Value(id),
      insightId: Value(insightId),
      rating: Value(rating),
      createdAt: Value(createdAt),
    );
  }

  factory InsightFeedbackData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InsightFeedbackData(
      id: serializer.fromJson<String>(json['id']),
      insightId: serializer.fromJson<String>(json['insightId']),
      rating: serializer.fromJson<String>(json['rating']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'insightId': serializer.toJson<String>(insightId),
      'rating': serializer.toJson<String>(rating),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  InsightFeedbackData copyWith({
    String? id,
    String? insightId,
    String? rating,
    int? createdAt,
  }) => InsightFeedbackData(
    id: id ?? this.id,
    insightId: insightId ?? this.insightId,
    rating: rating ?? this.rating,
    createdAt: createdAt ?? this.createdAt,
  );
  InsightFeedbackData copyWithCompanion(InsightFeedbackCompanion data) {
    return InsightFeedbackData(
      id: data.id.present ? data.id.value : this.id,
      insightId: data.insightId.present ? data.insightId.value : this.insightId,
      rating: data.rating.present ? data.rating.value : this.rating,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InsightFeedbackData(')
          ..write('id: $id, ')
          ..write('insightId: $insightId, ')
          ..write('rating: $rating, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, insightId, rating, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InsightFeedbackData &&
          other.id == this.id &&
          other.insightId == this.insightId &&
          other.rating == this.rating &&
          other.createdAt == this.createdAt);
}

class InsightFeedbackCompanion extends UpdateCompanion<InsightFeedbackData> {
  final Value<String> id;
  final Value<String> insightId;
  final Value<String> rating;
  final Value<int> createdAt;
  final Value<int> rowid;
  const InsightFeedbackCompanion({
    this.id = const Value.absent(),
    this.insightId = const Value.absent(),
    this.rating = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InsightFeedbackCompanion.insert({
    required String id,
    required String insightId,
    required String rating,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       insightId = Value(insightId),
       rating = Value(rating),
       createdAt = Value(createdAt);
  static Insertable<InsightFeedbackData> custom({
    Expression<String>? id,
    Expression<String>? insightId,
    Expression<String>? rating,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (insightId != null) 'insight_id': insightId,
      if (rating != null) 'rating': rating,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InsightFeedbackCompanion copyWith({
    Value<String>? id,
    Value<String>? insightId,
    Value<String>? rating,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return InsightFeedbackCompanion(
      id: id ?? this.id,
      insightId: insightId ?? this.insightId,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (insightId.present) {
      map['insight_id'] = Variable<String>(insightId.value);
    }
    if (rating.present) {
      map['rating'] = Variable<String>(rating.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InsightFeedbackCompanion(')
          ..write('id: $id, ')
          ..write('insightId: $insightId, ')
          ..write('rating: $rating, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncStateTable extends SyncState
    with TableInfo<$SyncStateTable, SyncStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTableMeta = const VerificationMeta(
    'entityTable',
  );
  @override
  late final GeneratedColumn<String> entityTable = GeneratedColumn<String>(
    'entity_table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<int> syncedAt = GeneratedColumn<int>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityTable,
    entityId,
    operation,
    createdAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncStateData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_table')) {
      context.handle(
        _entityTableMeta,
        entityTable.isAcceptableOrUnknown(
          data['entity_table']!,
          _entityTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entityTableMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_table'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $SyncStateTable createAlias(String alias) {
    return $SyncStateTable(attachedDatabase, alias);
  }
}

class SyncStateData extends DataClass implements Insertable<SyncStateData> {
  final String id;
  final String entityTable;
  final String entityId;
  final String operation;
  final int createdAt;
  final int? syncedAt;
  const SyncStateData({
    required this.id,
    required this.entityTable,
    required this.entityId,
    required this.operation,
    required this.createdAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_table'] = Variable<String>(entityTable);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<int>(syncedAt);
    }
    return map;
  }

  SyncStateCompanion toCompanion(bool nullToAbsent) {
    return SyncStateCompanion(
      id: Value(id),
      entityTable: Value(entityTable),
      entityId: Value(entityId),
      operation: Value(operation),
      createdAt: Value(createdAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory SyncStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateData(
      id: serializer.fromJson<String>(json['id']),
      entityTable: serializer.fromJson<String>(json['entityTable']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      syncedAt: serializer.fromJson<int?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityTable': serializer.toJson<String>(entityTable),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'createdAt': serializer.toJson<int>(createdAt),
      'syncedAt': serializer.toJson<int?>(syncedAt),
    };
  }

  SyncStateData copyWith({
    String? id,
    String? entityTable,
    String? entityId,
    String? operation,
    int? createdAt,
    Value<int?> syncedAt = const Value.absent(),
  }) => SyncStateData(
    id: id ?? this.id,
    entityTable: entityTable ?? this.entityTable,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    createdAt: createdAt ?? this.createdAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  SyncStateData copyWithCompanion(SyncStateCompanion data) {
    return SyncStateData(
      id: data.id.present ? data.id.value : this.id,
      entityTable: data.entityTable.present
          ? data.entityTable.value
          : this.entityTable,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateData(')
          ..write('id: $id, ')
          ..write('entityTable: $entityTable, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, entityTable, entityId, operation, createdAt, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStateData &&
          other.id == this.id &&
          other.entityTable == this.entityTable &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.createdAt == this.createdAt &&
          other.syncedAt == this.syncedAt);
}

class SyncStateCompanion extends UpdateCompanion<SyncStateData> {
  final Value<String> id;
  final Value<String> entityTable;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<int> createdAt;
  final Value<int?> syncedAt;
  final Value<int> rowid;
  const SyncStateCompanion({
    this.id = const Value.absent(),
    this.entityTable = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncStateCompanion.insert({
    required String id,
    required String entityTable,
    required String entityId,
    required String operation,
    required int createdAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityTable = Value(entityTable),
       entityId = Value(entityId),
       operation = Value(operation),
       createdAt = Value(createdAt);
  static Insertable<SyncStateData> custom({
    Expression<String>? id,
    Expression<String>? entityTable,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<int>? createdAt,
    Expression<int>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityTable != null) 'entity_table': entityTable,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncStateCompanion copyWith({
    Value<String>? id,
    Value<String>? entityTable,
    Value<String>? entityId,
    Value<String>? operation,
    Value<int>? createdAt,
    Value<int?>? syncedAt,
    Value<int>? rowid,
  }) {
    return SyncStateCompanion(
      id: id ?? this.id,
      entityTable: entityTable ?? this.entityTable,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityTable.present) {
      map['entity_table'] = Variable<String>(entityTable.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<int>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateCompanion(')
          ..write('id: $id, ')
          ..write('entityTable: $entityTable, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogTable extends AuditLog
    with TableInfo<$AuditLogTable, AuditLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, eventType, details, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AuditLogTable createAlias(String alias) {
    return $AuditLogTable(attachedDatabase, alias);
  }
}

class AuditLogData extends DataClass implements Insertable<AuditLogData> {
  final String id;
  final String eventType;
  final String? details;
  final int createdAt;
  const AuditLogData({
    required this.id,
    required this.eventType,
    this.details,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['event_type'] = Variable<String>(eventType);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  AuditLogCompanion toCompanion(bool nullToAbsent) {
    return AuditLogCompanion(
      id: Value(id),
      eventType: Value(eventType),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      createdAt: Value(createdAt),
    );
  }

  factory AuditLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLogData(
      id: serializer.fromJson<String>(json['id']),
      eventType: serializer.fromJson<String>(json['eventType']),
      details: serializer.fromJson<String?>(json['details']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'eventType': serializer.toJson<String>(eventType),
      'details': serializer.toJson<String?>(details),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  AuditLogData copyWith({
    String? id,
    String? eventType,
    Value<String?> details = const Value.absent(),
    int? createdAt,
  }) => AuditLogData(
    id: id ?? this.id,
    eventType: eventType ?? this.eventType,
    details: details.present ? details.value : this.details,
    createdAt: createdAt ?? this.createdAt,
  );
  AuditLogData copyWithCompanion(AuditLogCompanion data) {
    return AuditLogData(
      id: data.id.present ? data.id.value : this.id,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      details: data.details.present ? data.details.value : this.details,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogData(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('details: $details, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, eventType, details, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLogData &&
          other.id == this.id &&
          other.eventType == this.eventType &&
          other.details == this.details &&
          other.createdAt == this.createdAt);
}

class AuditLogCompanion extends UpdateCompanion<AuditLogData> {
  final Value<String> id;
  final Value<String> eventType;
  final Value<String?> details;
  final Value<int> createdAt;
  final Value<int> rowid;
  const AuditLogCompanion({
    this.id = const Value.absent(),
    this.eventType = const Value.absent(),
    this.details = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditLogCompanion.insert({
    required String id,
    required String eventType,
    this.details = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       eventType = Value(eventType),
       createdAt = Value(createdAt);
  static Insertable<AuditLogData> custom({
    Expression<String>? id,
    Expression<String>? eventType,
    Expression<String>? details,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventType != null) 'event_type': eventType,
      if (details != null) 'details': details,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditLogCompanion copyWith({
    Value<String>? id,
    Value<String>? eventType,
    Value<String?>? details,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return AuditLogCompanion(
      id: id ?? this.id,
      eventType: eventType ?? this.eventType,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogCompanion(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('details: $details, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ImportHistoryTable extends ImportHistory
    with TableInfo<$ImportHistoryTable, ImportHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowCountMeta = const VerificationMeta(
    'rowCount',
  );
  @override
  late final GeneratedColumn<int> rowCount = GeneratedColumn<int>(
    'row_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importedCountMeta = const VerificationMeta(
    'importedCount',
  );
  @override
  late final GeneratedColumn<int> importedCount = GeneratedColumn<int>(
    'imported_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skippedCountMeta = const VerificationMeta(
    'skippedCount',
  );
  @override
  late final GeneratedColumn<int> skippedCount = GeneratedColumn<int>(
    'skipped_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bankConnectionIdMeta = const VerificationMeta(
    'bankConnectionId',
  );
  @override
  late final GeneratedColumn<String> bankConnectionId = GeneratedColumn<String>(
    'bank_connection_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    source,
    fileName,
    rowCount,
    importedCount,
    skippedCount,
    status,
    errorMessage,
    bankConnectionId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'import_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('row_count')) {
      context.handle(
        _rowCountMeta,
        rowCount.isAcceptableOrUnknown(data['row_count']!, _rowCountMeta),
      );
    } else if (isInserting) {
      context.missing(_rowCountMeta);
    }
    if (data.containsKey('imported_count')) {
      context.handle(
        _importedCountMeta,
        importedCount.isAcceptableOrUnknown(
          data['imported_count']!,
          _importedCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_importedCountMeta);
    }
    if (data.containsKey('skipped_count')) {
      context.handle(
        _skippedCountMeta,
        skippedCount.isAcceptableOrUnknown(
          data['skipped_count']!,
          _skippedCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_skippedCountMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('bank_connection_id')) {
      context.handle(
        _bankConnectionIdMeta,
        bankConnectionId.isAcceptableOrUnknown(
          data['bank_connection_id']!,
          _bankConnectionIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      rowCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_count'],
      )!,
      importedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}imported_count'],
      )!,
      skippedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}skipped_count'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      bankConnectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_connection_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ImportHistoryTable createAlias(String alias) {
    return $ImportHistoryTable(attachedDatabase, alias);
  }
}

class ImportHistoryData extends DataClass
    implements Insertable<ImportHistoryData> {
  final String id;
  final String source;
  final String fileName;
  final int rowCount;
  final int importedCount;
  final int skippedCount;
  final String status;
  final String? errorMessage;
  final String? bankConnectionId;
  final int createdAt;
  const ImportHistoryData({
    required this.id,
    required this.source,
    required this.fileName,
    required this.rowCount,
    required this.importedCount,
    required this.skippedCount,
    required this.status,
    this.errorMessage,
    this.bankConnectionId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source'] = Variable<String>(source);
    map['file_name'] = Variable<String>(fileName);
    map['row_count'] = Variable<int>(rowCount);
    map['imported_count'] = Variable<int>(importedCount);
    map['skipped_count'] = Variable<int>(skippedCount);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    if (!nullToAbsent || bankConnectionId != null) {
      map['bank_connection_id'] = Variable<String>(bankConnectionId);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  ImportHistoryCompanion toCompanion(bool nullToAbsent) {
    return ImportHistoryCompanion(
      id: Value(id),
      source: Value(source),
      fileName: Value(fileName),
      rowCount: Value(rowCount),
      importedCount: Value(importedCount),
      skippedCount: Value(skippedCount),
      status: Value(status),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      bankConnectionId: bankConnectionId == null && nullToAbsent
          ? const Value.absent()
          : Value(bankConnectionId),
      createdAt: Value(createdAt),
    );
  }

  factory ImportHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportHistoryData(
      id: serializer.fromJson<String>(json['id']),
      source: serializer.fromJson<String>(json['source']),
      fileName: serializer.fromJson<String>(json['fileName']),
      rowCount: serializer.fromJson<int>(json['rowCount']),
      importedCount: serializer.fromJson<int>(json['importedCount']),
      skippedCount: serializer.fromJson<int>(json['skippedCount']),
      status: serializer.fromJson<String>(json['status']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      bankConnectionId: serializer.fromJson<String?>(json['bankConnectionId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'source': serializer.toJson<String>(source),
      'fileName': serializer.toJson<String>(fileName),
      'rowCount': serializer.toJson<int>(rowCount),
      'importedCount': serializer.toJson<int>(importedCount),
      'skippedCount': serializer.toJson<int>(skippedCount),
      'status': serializer.toJson<String>(status),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'bankConnectionId': serializer.toJson<String?>(bankConnectionId),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  ImportHistoryData copyWith({
    String? id,
    String? source,
    String? fileName,
    int? rowCount,
    int? importedCount,
    int? skippedCount,
    String? status,
    Value<String?> errorMessage = const Value.absent(),
    Value<String?> bankConnectionId = const Value.absent(),
    int? createdAt,
  }) => ImportHistoryData(
    id: id ?? this.id,
    source: source ?? this.source,
    fileName: fileName ?? this.fileName,
    rowCount: rowCount ?? this.rowCount,
    importedCount: importedCount ?? this.importedCount,
    skippedCount: skippedCount ?? this.skippedCount,
    status: status ?? this.status,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    bankConnectionId: bankConnectionId.present
        ? bankConnectionId.value
        : this.bankConnectionId,
    createdAt: createdAt ?? this.createdAt,
  );
  ImportHistoryData copyWithCompanion(ImportHistoryCompanion data) {
    return ImportHistoryData(
      id: data.id.present ? data.id.value : this.id,
      source: data.source.present ? data.source.value : this.source,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      rowCount: data.rowCount.present ? data.rowCount.value : this.rowCount,
      importedCount: data.importedCount.present
          ? data.importedCount.value
          : this.importedCount,
      skippedCount: data.skippedCount.present
          ? data.skippedCount.value
          : this.skippedCount,
      status: data.status.present ? data.status.value : this.status,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      bankConnectionId: data.bankConnectionId.present
          ? data.bankConnectionId.value
          : this.bankConnectionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportHistoryData(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('fileName: $fileName, ')
          ..write('rowCount: $rowCount, ')
          ..write('importedCount: $importedCount, ')
          ..write('skippedCount: $skippedCount, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('bankConnectionId: $bankConnectionId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    source,
    fileName,
    rowCount,
    importedCount,
    skippedCount,
    status,
    errorMessage,
    bankConnectionId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportHistoryData &&
          other.id == this.id &&
          other.source == this.source &&
          other.fileName == this.fileName &&
          other.rowCount == this.rowCount &&
          other.importedCount == this.importedCount &&
          other.skippedCount == this.skippedCount &&
          other.status == this.status &&
          other.errorMessage == this.errorMessage &&
          other.bankConnectionId == this.bankConnectionId &&
          other.createdAt == this.createdAt);
}

class ImportHistoryCompanion extends UpdateCompanion<ImportHistoryData> {
  final Value<String> id;
  final Value<String> source;
  final Value<String> fileName;
  final Value<int> rowCount;
  final Value<int> importedCount;
  final Value<int> skippedCount;
  final Value<String> status;
  final Value<String?> errorMessage;
  final Value<String?> bankConnectionId;
  final Value<int> createdAt;
  final Value<int> rowid;
  const ImportHistoryCompanion({
    this.id = const Value.absent(),
    this.source = const Value.absent(),
    this.fileName = const Value.absent(),
    this.rowCount = const Value.absent(),
    this.importedCount = const Value.absent(),
    this.skippedCount = const Value.absent(),
    this.status = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.bankConnectionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImportHistoryCompanion.insert({
    required String id,
    required String source,
    required String fileName,
    required int rowCount,
    required int importedCount,
    required int skippedCount,
    required String status,
    this.errorMessage = const Value.absent(),
    this.bankConnectionId = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       source = Value(source),
       fileName = Value(fileName),
       rowCount = Value(rowCount),
       importedCount = Value(importedCount),
       skippedCount = Value(skippedCount),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<ImportHistoryData> custom({
    Expression<String>? id,
    Expression<String>? source,
    Expression<String>? fileName,
    Expression<int>? rowCount,
    Expression<int>? importedCount,
    Expression<int>? skippedCount,
    Expression<String>? status,
    Expression<String>? errorMessage,
    Expression<String>? bankConnectionId,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (source != null) 'source': source,
      if (fileName != null) 'file_name': fileName,
      if (rowCount != null) 'row_count': rowCount,
      if (importedCount != null) 'imported_count': importedCount,
      if (skippedCount != null) 'skipped_count': skippedCount,
      if (status != null) 'status': status,
      if (errorMessage != null) 'error_message': errorMessage,
      if (bankConnectionId != null) 'bank_connection_id': bankConnectionId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImportHistoryCompanion copyWith({
    Value<String>? id,
    Value<String>? source,
    Value<String>? fileName,
    Value<int>? rowCount,
    Value<int>? importedCount,
    Value<int>? skippedCount,
    Value<String>? status,
    Value<String?>? errorMessage,
    Value<String?>? bankConnectionId,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return ImportHistoryCompanion(
      id: id ?? this.id,
      source: source ?? this.source,
      fileName: fileName ?? this.fileName,
      rowCount: rowCount ?? this.rowCount,
      importedCount: importedCount ?? this.importedCount,
      skippedCount: skippedCount ?? this.skippedCount,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      bankConnectionId: bankConnectionId ?? this.bankConnectionId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (rowCount.present) {
      map['row_count'] = Variable<int>(rowCount.value);
    }
    if (importedCount.present) {
      map['imported_count'] = Variable<int>(importedCount.value);
    }
    if (skippedCount.present) {
      map['skipped_count'] = Variable<int>(skippedCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (bankConnectionId.present) {
      map['bank_connection_id'] = Variable<String>(bankConnectionId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportHistoryCompanion(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('fileName: $fileName, ')
          ..write('rowCount: $rowCount, ')
          ..write('importedCount: $importedCount, ')
          ..write('skippedCount: $skippedCount, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('bankConnectionId: $bankConnectionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  final int updatedAt;
  const AppSetting({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  AppSetting copyWith({String? key, String? value, int? updatedAt}) =>
      AppSetting(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
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
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $AutoCategorizeRulesTable autoCategorizeRules =
      $AutoCategorizeRulesTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $InvestmentHoldingsTable investmentHoldings =
      $InvestmentHoldingsTable(this);
  late final $BankConnectionsTable bankConnections = $BankConnectionsTable(
    this,
  );
  late final $RecurringTransactionsTable recurringTransactions =
      $RecurringTransactionsTable(this);
  late final $PayeeCategoryCacheTable payeeCategoryCache =
      $PayeeCategoryCacheTable(this);
  late final $CategorizationCorrectionsTable categorizationCorrections =
      $CategorizationCorrectionsTable(this);
  late final $ConversationsTable conversations = $ConversationsTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $InsightsTable insights = $InsightsTable(this);
  late final $AiMemoryCoreTable aiMemoryCore = $AiMemoryCoreTable(this);
  late final $AiMemorySemanticTable aiMemorySemantic = $AiMemorySemanticTable(
    this,
  );
  late final $InsightFeedbackTable insightFeedback = $InsightFeedbackTable(
    this,
  );
  late final $SyncStateTable syncState = $SyncStateTable(this);
  late final $AuditLogTable auditLog = $AuditLogTable(this);
  late final $ImportHistoryTable importHistory = $ImportHistoryTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accounts,
    transactions,
    categories,
    budgets,
    autoCategorizeRules,
    goals,
    investmentHoldings,
    bankConnections,
    recurringTransactions,
    payeeCategoryCache,
    categorizationCorrections,
    conversations,
    messages,
    insights,
    aiMemoryCore,
    aiMemorySemantic,
    insightFeedback,
    syncState,
    auditLog,
    importHistory,
    appSettings,
  ];
}

typedef $$AccountsTableCreateCompanionBuilder =
    AccountsCompanion Function({
      required String id,
      required String name,
      Value<String?> institutionName,
      required String accountType,
      Value<String?> accountSubtype,
      required int balanceCents,
      Value<String> currencyCode,
      required bool isAsset,
      Value<bool> isHidden,
      required int displayOrder,
      Value<int?> color,
      Value<String?> icon,
      Value<String?> bankConnectionId,
      Value<String?> externalId,
      Value<int?> lastSyncedAt,
      required int createdAt,
      required int updatedAt,
      Value<int> version,
      Value<bool> invertSign,
      Value<int> syncStatus,
      Value<int> rowid,
    });
typedef $$AccountsTableUpdateCompanionBuilder =
    AccountsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> institutionName,
      Value<String> accountType,
      Value<String?> accountSubtype,
      Value<int> balanceCents,
      Value<String> currencyCode,
      Value<bool> isAsset,
      Value<bool> isHidden,
      Value<int> displayOrder,
      Value<int?> color,
      Value<String?> icon,
      Value<String?> bankConnectionId,
      Value<String?> externalId,
      Value<int?> lastSyncedAt,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> version,
      Value<bool> invertSign,
      Value<int> syncStatus,
      Value<int> rowid,
    });

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get institutionName => $composableBuilder(
    column: $table.institutionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountSubtype => $composableBuilder(
    column: $table.accountSubtype,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAsset => $composableBuilder(
    column: $table.isAsset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isHidden => $composableBuilder(
    column: $table.isHidden,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankConnectionId => $composableBuilder(
    column: $table.bankConnectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get invertSign => $composableBuilder(
    column: $table.invertSign,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get institutionName => $composableBuilder(
    column: $table.institutionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountSubtype => $composableBuilder(
    column: $table.accountSubtype,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAsset => $composableBuilder(
    column: $table.isAsset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isHidden => $composableBuilder(
    column: $table.isHidden,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankConnectionId => $composableBuilder(
    column: $table.bankConnectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get invertSign => $composableBuilder(
    column: $table.invertSign,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get institutionName => $composableBuilder(
    column: $table.institutionName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountSubtype => $composableBuilder(
    column: $table.accountSubtype,
    builder: (column) => column,
  );

  GeneratedColumn<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAsset =>
      $composableBuilder(column: $table.isAsset, builder: (column) => column);

  GeneratedColumn<bool> get isHidden =>
      $composableBuilder(column: $table.isHidden, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get bankConnectionId => $composableBuilder(
    column: $table.bankConnectionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get invertSign => $composableBuilder(
    column: $table.invertSign,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          Account,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
          Account,
          PrefetchHooks Function()
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> institutionName = const Value.absent(),
                Value<String> accountType = const Value.absent(),
                Value<String?> accountSubtype = const Value.absent(),
                Value<int> balanceCents = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<bool> isAsset = const Value.absent(),
                Value<bool> isHidden = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<int?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> bankConnectionId = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<int?> lastSyncedAt = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> invertSign = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                name: name,
                institutionName: institutionName,
                accountType: accountType,
                accountSubtype: accountSubtype,
                balanceCents: balanceCents,
                currencyCode: currencyCode,
                isAsset: isAsset,
                isHidden: isHidden,
                displayOrder: displayOrder,
                color: color,
                icon: icon,
                bankConnectionId: bankConnectionId,
                externalId: externalId,
                lastSyncedAt: lastSyncedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                invertSign: invertSign,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> institutionName = const Value.absent(),
                required String accountType,
                Value<String?> accountSubtype = const Value.absent(),
                required int balanceCents,
                Value<String> currencyCode = const Value.absent(),
                required bool isAsset,
                Value<bool> isHidden = const Value.absent(),
                required int displayOrder,
                Value<int?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> bankConnectionId = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<int?> lastSyncedAt = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> version = const Value.absent(),
                Value<bool> invertSign = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                name: name,
                institutionName: institutionName,
                accountType: accountType,
                accountSubtype: accountSubtype,
                balanceCents: balanceCents,
                currencyCode: currencyCode,
                isAsset: isAsset,
                isHidden: isHidden,
                displayOrder: displayOrder,
                color: color,
                icon: icon,
                bankConnectionId: bankConnectionId,
                externalId: externalId,
                lastSyncedAt: lastSyncedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                invertSign: invertSign,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      Account,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
      Account,
      PrefetchHooks Function()
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      required String id,
      required String accountId,
      required int amountCents,
      required int date,
      required String payee,
      Value<String?> notes,
      Value<String?> categoryId,
      Value<bool> isReviewed,
      Value<bool> isPending,
      Value<String?> transferAccountId,
      Value<String?> transferTransactionId,
      Value<String?> externalId,
      Value<String?> tags,
      required int createdAt,
      required int updatedAt,
      Value<int> version,
      Value<int> syncStatus,
      Value<int> rowid,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<int> amountCents,
      Value<int> date,
      Value<String> payee,
      Value<String?> notes,
      Value<String?> categoryId,
      Value<bool> isReviewed,
      Value<bool> isPending,
      Value<String?> transferAccountId,
      Value<String?> transferTransactionId,
      Value<String?> externalId,
      Value<String?> tags,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> version,
      Value<int> syncStatus,
      Value<int> rowid,
    });

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payee => $composableBuilder(
    column: $table.payee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isReviewed => $composableBuilder(
    column: $table.isReviewed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transferAccountId => $composableBuilder(
    column: $table.transferAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transferTransactionId => $composableBuilder(
    column: $table.transferTransactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payee => $composableBuilder(
    column: $table.payee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isReviewed => $composableBuilder(
    column: $table.isReviewed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transferAccountId => $composableBuilder(
    column: $table.transferAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transferTransactionId => $composableBuilder(
    column: $table.transferTransactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get payee =>
      $composableBuilder(column: $table.payee, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isReviewed => $composableBuilder(
    column: $table.isReviewed,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPending =>
      $composableBuilder(column: $table.isPending, builder: (column) => column);

  GeneratedColumn<String> get transferAccountId => $composableBuilder(
    column: $table.transferAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get transferTransactionId => $composableBuilder(
    column: $table.transferTransactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (
            Transaction,
            BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
          ),
          Transaction,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<String> payee = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<bool> isReviewed = const Value.absent(),
                Value<bool> isPending = const Value.absent(),
                Value<String?> transferAccountId = const Value.absent(),
                Value<String?> transferTransactionId = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                accountId: accountId,
                amountCents: amountCents,
                date: date,
                payee: payee,
                notes: notes,
                categoryId: categoryId,
                isReviewed: isReviewed,
                isPending: isPending,
                transferAccountId: transferAccountId,
                transferTransactionId: transferTransactionId,
                externalId: externalId,
                tags: tags,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required int amountCents,
                required int date,
                required String payee,
                Value<String?> notes = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<bool> isReviewed = const Value.absent(),
                Value<bool> isPending = const Value.absent(),
                Value<String?> transferAccountId = const Value.absent(),
                Value<String?> transferTransactionId = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> version = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                accountId: accountId,
                amountCents: amountCents,
                date: date,
                payee: payee,
                notes: notes,
                categoryId: categoryId,
                isReviewed: isReviewed,
                isPending: isPending,
                transferAccountId: transferAccountId,
                transferTransactionId: transferTransactionId,
                externalId: externalId,
                tags: tags,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (
        Transaction,
        BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
      ),
      Transaction,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      required String name,
      Value<String?> parentId,
      required String type,
      required String icon,
      required int color,
      required int displayOrder,
      Value<bool> isSystem,
      required int createdAt,
      required int updatedAt,
      Value<int> version,
      Value<int> syncStatus,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> parentId,
      Value<String> type,
      Value<String> icon,
      Value<int> color,
      Value<int> displayOrder,
      Value<bool> isSystem,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> version,
      Value<int> syncStatus,
      Value<int> rowid,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                parentId: parentId,
                type: type,
                icon: icon,
                color: color,
                displayOrder: displayOrder,
                isSystem: isSystem,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> parentId = const Value.absent(),
                required String type,
                required String icon,
                required int color,
                required int displayOrder,
                Value<bool> isSystem = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> version = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                parentId: parentId,
                type: type,
                icon: icon,
                color: color,
                displayOrder: displayOrder,
                isSystem: isSystem,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;
typedef $$BudgetsTableCreateCompanionBuilder =
    BudgetsCompanion Function({
      required String id,
      required String categoryId,
      required int amountCents,
      required String periodType,
      required int startDate,
      Value<int?> endDate,
      Value<bool> rollover,
      Value<int> rolloverAmountCents,
      Value<double> alertThreshold,
      required int createdAt,
      required int updatedAt,
      Value<int> version,
      Value<int> syncStatus,
      Value<int> rowid,
    });
typedef $$BudgetsTableUpdateCompanionBuilder =
    BudgetsCompanion Function({
      Value<String> id,
      Value<String> categoryId,
      Value<int> amountCents,
      Value<String> periodType,
      Value<int> startDate,
      Value<int?> endDate,
      Value<bool> rollover,
      Value<int> rolloverAmountCents,
      Value<double> alertThreshold,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> version,
      Value<int> syncStatus,
      Value<int> rowid,
    });

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get periodType => $composableBuilder(
    column: $table.periodType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get rollover => $composableBuilder(
    column: $table.rollover,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rolloverAmountCents => $composableBuilder(
    column: $table.rolloverAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get alertThreshold => $composableBuilder(
    column: $table.alertThreshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get periodType => $composableBuilder(
    column: $table.periodType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get rollover => $composableBuilder(
    column: $table.rollover,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rolloverAmountCents => $composableBuilder(
    column: $table.rolloverAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get alertThreshold => $composableBuilder(
    column: $table.alertThreshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get periodType => $composableBuilder(
    column: $table.periodType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<int> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get rollover =>
      $composableBuilder(column: $table.rollover, builder: (column) => column);

  GeneratedColumn<int> get rolloverAmountCents => $composableBuilder(
    column: $table.rolloverAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<double> get alertThreshold => $composableBuilder(
    column: $table.alertThreshold,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTable,
          Budget,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (Budget, BaseReferences<_$AppDatabase, $BudgetsTable, Budget>),
          Budget,
          PrefetchHooks Function()
        > {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<String> periodType = const Value.absent(),
                Value<int> startDate = const Value.absent(),
                Value<int?> endDate = const Value.absent(),
                Value<bool> rollover = const Value.absent(),
                Value<int> rolloverAmountCents = const Value.absent(),
                Value<double> alertThreshold = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                categoryId: categoryId,
                amountCents: amountCents,
                periodType: periodType,
                startDate: startDate,
                endDate: endDate,
                rollover: rollover,
                rolloverAmountCents: rolloverAmountCents,
                alertThreshold: alertThreshold,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String categoryId,
                required int amountCents,
                required String periodType,
                required int startDate,
                Value<int?> endDate = const Value.absent(),
                Value<bool> rollover = const Value.absent(),
                Value<int> rolloverAmountCents = const Value.absent(),
                Value<double> alertThreshold = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> version = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion.insert(
                id: id,
                categoryId: categoryId,
                amountCents: amountCents,
                periodType: periodType,
                startDate: startDate,
                endDate: endDate,
                rollover: rollover,
                rolloverAmountCents: rolloverAmountCents,
                alertThreshold: alertThreshold,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTable,
      Budget,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (Budget, BaseReferences<_$AppDatabase, $BudgetsTable, Budget>),
      Budget,
      PrefetchHooks Function()
    >;
typedef $$AutoCategorizeRulesTableCreateCompanionBuilder =
    AutoCategorizeRulesCompanion Function({
      required String id,
      required String name,
      required int priority,
      Value<String?> payeeContains,
      Value<String?> payeeExact,
      Value<int?> amountMinCents,
      Value<int?> amountMaxCents,
      Value<String?> accountId,
      required String categoryId,
      Value<String?> accountType,
      Value<bool> isEnabled,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$AutoCategorizeRulesTableUpdateCompanionBuilder =
    AutoCategorizeRulesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> priority,
      Value<String?> payeeContains,
      Value<String?> payeeExact,
      Value<int?> amountMinCents,
      Value<int?> amountMaxCents,
      Value<String?> accountId,
      Value<String> categoryId,
      Value<String?> accountType,
      Value<bool> isEnabled,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$AutoCategorizeRulesTableFilterComposer
    extends Composer<_$AppDatabase, $AutoCategorizeRulesTable> {
  $$AutoCategorizeRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payeeContains => $composableBuilder(
    column: $table.payeeContains,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payeeExact => $composableBuilder(
    column: $table.payeeExact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinCents => $composableBuilder(
    column: $table.amountMinCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMaxCents => $composableBuilder(
    column: $table.amountMaxCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AutoCategorizeRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $AutoCategorizeRulesTable> {
  $$AutoCategorizeRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payeeContains => $composableBuilder(
    column: $table.payeeContains,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payeeExact => $composableBuilder(
    column: $table.payeeExact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinCents => $composableBuilder(
    column: $table.amountMinCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMaxCents => $composableBuilder(
    column: $table.amountMaxCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AutoCategorizeRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AutoCategorizeRulesTable> {
  $$AutoCategorizeRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get payeeContains => $composableBuilder(
    column: $table.payeeContains,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payeeExact => $composableBuilder(
    column: $table.payeeExact,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountMinCents => $composableBuilder(
    column: $table.amountMinCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountMaxCents => $composableBuilder(
    column: $table.amountMaxCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AutoCategorizeRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AutoCategorizeRulesTable,
          AutoCategorizeRule,
          $$AutoCategorizeRulesTableFilterComposer,
          $$AutoCategorizeRulesTableOrderingComposer,
          $$AutoCategorizeRulesTableAnnotationComposer,
          $$AutoCategorizeRulesTableCreateCompanionBuilder,
          $$AutoCategorizeRulesTableUpdateCompanionBuilder,
          (
            AutoCategorizeRule,
            BaseReferences<
              _$AppDatabase,
              $AutoCategorizeRulesTable,
              AutoCategorizeRule
            >,
          ),
          AutoCategorizeRule,
          PrefetchHooks Function()
        > {
  $$AutoCategorizeRulesTableTableManager(
    _$AppDatabase db,
    $AutoCategorizeRulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AutoCategorizeRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AutoCategorizeRulesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AutoCategorizeRulesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<String?> payeeContains = const Value.absent(),
                Value<String?> payeeExact = const Value.absent(),
                Value<int?> amountMinCents = const Value.absent(),
                Value<int?> amountMaxCents = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String?> accountType = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AutoCategorizeRulesCompanion(
                id: id,
                name: name,
                priority: priority,
                payeeContains: payeeContains,
                payeeExact: payeeExact,
                amountMinCents: amountMinCents,
                amountMaxCents: amountMaxCents,
                accountId: accountId,
                categoryId: categoryId,
                accountType: accountType,
                isEnabled: isEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int priority,
                Value<String?> payeeContains = const Value.absent(),
                Value<String?> payeeExact = const Value.absent(),
                Value<int?> amountMinCents = const Value.absent(),
                Value<int?> amountMaxCents = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                required String categoryId,
                Value<String?> accountType = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AutoCategorizeRulesCompanion.insert(
                id: id,
                name: name,
                priority: priority,
                payeeContains: payeeContains,
                payeeExact: payeeExact,
                amountMinCents: amountMinCents,
                amountMaxCents: amountMaxCents,
                accountId: accountId,
                categoryId: categoryId,
                accountType: accountType,
                isEnabled: isEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AutoCategorizeRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AutoCategorizeRulesTable,
      AutoCategorizeRule,
      $$AutoCategorizeRulesTableFilterComposer,
      $$AutoCategorizeRulesTableOrderingComposer,
      $$AutoCategorizeRulesTableAnnotationComposer,
      $$AutoCategorizeRulesTableCreateCompanionBuilder,
      $$AutoCategorizeRulesTableUpdateCompanionBuilder,
      (
        AutoCategorizeRule,
        BaseReferences<
          _$AppDatabase,
          $AutoCategorizeRulesTable,
          AutoCategorizeRule
        >,
      ),
      AutoCategorizeRule,
      PrefetchHooks Function()
    >;
typedef $$GoalsTableCreateCompanionBuilder =
    GoalsCompanion Function({
      required String id,
      required String name,
      required String goalType,
      required int targetAmountCents,
      Value<int> currentAmountCents,
      Value<int?> targetDate,
      Value<String?> linkedAccountId,
      required String icon,
      required int color,
      Value<bool> isCompleted,
      Value<int?> completedAt,
      Value<int?> monthlyContributionCents,
      Value<int?> annualReturnBps,
      Value<int?> annualVolatilityBps,
      Value<int?> retirementYear,
      Value<int?> desiredMonthlyIncomeCents,
      required int createdAt,
      required int updatedAt,
      Value<int> version,
      Value<int> syncStatus,
      Value<int> rowid,
    });
typedef $$GoalsTableUpdateCompanionBuilder =
    GoalsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> goalType,
      Value<int> targetAmountCents,
      Value<int> currentAmountCents,
      Value<int?> targetDate,
      Value<String?> linkedAccountId,
      Value<String> icon,
      Value<int> color,
      Value<bool> isCompleted,
      Value<int?> completedAt,
      Value<int?> monthlyContributionCents,
      Value<int?> annualReturnBps,
      Value<int?> annualVolatilityBps,
      Value<int?> retirementYear,
      Value<int?> desiredMonthlyIncomeCents,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> version,
      Value<int> syncStatus,
      Value<int> rowid,
    });

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetAmountCents => $composableBuilder(
    column: $table.targetAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentAmountCents => $composableBuilder(
    column: $table.currentAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedAccountId => $composableBuilder(
    column: $table.linkedAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyContributionCents => $composableBuilder(
    column: $table.monthlyContributionCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get annualReturnBps => $composableBuilder(
    column: $table.annualReturnBps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get annualVolatilityBps => $composableBuilder(
    column: $table.annualVolatilityBps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retirementYear => $composableBuilder(
    column: $table.retirementYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get desiredMonthlyIncomeCents => $composableBuilder(
    column: $table.desiredMonthlyIncomeCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetAmountCents => $composableBuilder(
    column: $table.targetAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentAmountCents => $composableBuilder(
    column: $table.currentAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedAccountId => $composableBuilder(
    column: $table.linkedAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyContributionCents => $composableBuilder(
    column: $table.monthlyContributionCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get annualReturnBps => $composableBuilder(
    column: $table.annualReturnBps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get annualVolatilityBps => $composableBuilder(
    column: $table.annualVolatilityBps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retirementYear => $composableBuilder(
    column: $table.retirementYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get desiredMonthlyIncomeCents => $composableBuilder(
    column: $table.desiredMonthlyIncomeCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get goalType =>
      $composableBuilder(column: $table.goalType, builder: (column) => column);

  GeneratedColumn<int> get targetAmountCents => $composableBuilder(
    column: $table.targetAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentAmountCents => $composableBuilder(
    column: $table.currentAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkedAccountId => $composableBuilder(
    column: $table.linkedAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get monthlyContributionCents => $composableBuilder(
    column: $table.monthlyContributionCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get annualReturnBps => $composableBuilder(
    column: $table.annualReturnBps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get annualVolatilityBps => $composableBuilder(
    column: $table.annualVolatilityBps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get retirementYear => $composableBuilder(
    column: $table.retirementYear,
    builder: (column) => column,
  );

  GeneratedColumn<int> get desiredMonthlyIncomeCents => $composableBuilder(
    column: $table.desiredMonthlyIncomeCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTable,
          Goal,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (Goal, BaseReferences<_$AppDatabase, $GoalsTable, Goal>),
          Goal,
          PrefetchHooks Function()
        > {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> goalType = const Value.absent(),
                Value<int> targetAmountCents = const Value.absent(),
                Value<int> currentAmountCents = const Value.absent(),
                Value<int?> targetDate = const Value.absent(),
                Value<String?> linkedAccountId = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int?> completedAt = const Value.absent(),
                Value<int?> monthlyContributionCents = const Value.absent(),
                Value<int?> annualReturnBps = const Value.absent(),
                Value<int?> annualVolatilityBps = const Value.absent(),
                Value<int?> retirementYear = const Value.absent(),
                Value<int?> desiredMonthlyIncomeCents = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion(
                id: id,
                name: name,
                goalType: goalType,
                targetAmountCents: targetAmountCents,
                currentAmountCents: currentAmountCents,
                targetDate: targetDate,
                linkedAccountId: linkedAccountId,
                icon: icon,
                color: color,
                isCompleted: isCompleted,
                completedAt: completedAt,
                monthlyContributionCents: monthlyContributionCents,
                annualReturnBps: annualReturnBps,
                annualVolatilityBps: annualVolatilityBps,
                retirementYear: retirementYear,
                desiredMonthlyIncomeCents: desiredMonthlyIncomeCents,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String goalType,
                required int targetAmountCents,
                Value<int> currentAmountCents = const Value.absent(),
                Value<int?> targetDate = const Value.absent(),
                Value<String?> linkedAccountId = const Value.absent(),
                required String icon,
                required int color,
                Value<bool> isCompleted = const Value.absent(),
                Value<int?> completedAt = const Value.absent(),
                Value<int?> monthlyContributionCents = const Value.absent(),
                Value<int?> annualReturnBps = const Value.absent(),
                Value<int?> annualVolatilityBps = const Value.absent(),
                Value<int?> retirementYear = const Value.absent(),
                Value<int?> desiredMonthlyIncomeCents = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> version = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion.insert(
                id: id,
                name: name,
                goalType: goalType,
                targetAmountCents: targetAmountCents,
                currentAmountCents: currentAmountCents,
                targetDate: targetDate,
                linkedAccountId: linkedAccountId,
                icon: icon,
                color: color,
                isCompleted: isCompleted,
                completedAt: completedAt,
                monthlyContributionCents: monthlyContributionCents,
                annualReturnBps: annualReturnBps,
                annualVolatilityBps: annualVolatilityBps,
                retirementYear: retirementYear,
                desiredMonthlyIncomeCents: desiredMonthlyIncomeCents,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTable,
      Goal,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (Goal, BaseReferences<_$AppDatabase, $GoalsTable, Goal>),
      Goal,
      PrefetchHooks Function()
    >;
typedef $$InvestmentHoldingsTableCreateCompanionBuilder =
    InvestmentHoldingsCompanion Function({
      required String id,
      required String accountId,
      required String symbol,
      required String name,
      required double quantity,
      required int costBasisCents,
      required int currentPriceCents,
      required int currentValueCents,
      required String assetClass,
      Value<int?> lastPriceUpdate,
      required int createdAt,
      required int updatedAt,
      Value<int> version,
      Value<int> syncStatus,
      Value<int> rowid,
    });
typedef $$InvestmentHoldingsTableUpdateCompanionBuilder =
    InvestmentHoldingsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> symbol,
      Value<String> name,
      Value<double> quantity,
      Value<int> costBasisCents,
      Value<int> currentPriceCents,
      Value<int> currentValueCents,
      Value<String> assetClass,
      Value<int?> lastPriceUpdate,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> version,
      Value<int> syncStatus,
      Value<int> rowid,
    });

class $$InvestmentHoldingsTableFilterComposer
    extends Composer<_$AppDatabase, $InvestmentHoldingsTable> {
  $$InvestmentHoldingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costBasisCents => $composableBuilder(
    column: $table.costBasisCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentPriceCents => $composableBuilder(
    column: $table.currentPriceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentValueCents => $composableBuilder(
    column: $table.currentValueCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetClass => $composableBuilder(
    column: $table.assetClass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastPriceUpdate => $composableBuilder(
    column: $table.lastPriceUpdate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InvestmentHoldingsTableOrderingComposer
    extends Composer<_$AppDatabase, $InvestmentHoldingsTable> {
  $$InvestmentHoldingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costBasisCents => $composableBuilder(
    column: $table.costBasisCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentPriceCents => $composableBuilder(
    column: $table.currentPriceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentValueCents => $composableBuilder(
    column: $table.currentValueCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetClass => $composableBuilder(
    column: $table.assetClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastPriceUpdate => $composableBuilder(
    column: $table.lastPriceUpdate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InvestmentHoldingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvestmentHoldingsTable> {
  $$InvestmentHoldingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get costBasisCents => $composableBuilder(
    column: $table.costBasisCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentPriceCents => $composableBuilder(
    column: $table.currentPriceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentValueCents => $composableBuilder(
    column: $table.currentValueCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assetClass => $composableBuilder(
    column: $table.assetClass,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastPriceUpdate => $composableBuilder(
    column: $table.lastPriceUpdate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$InvestmentHoldingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvestmentHoldingsTable,
          InvestmentHolding,
          $$InvestmentHoldingsTableFilterComposer,
          $$InvestmentHoldingsTableOrderingComposer,
          $$InvestmentHoldingsTableAnnotationComposer,
          $$InvestmentHoldingsTableCreateCompanionBuilder,
          $$InvestmentHoldingsTableUpdateCompanionBuilder,
          (
            InvestmentHolding,
            BaseReferences<
              _$AppDatabase,
              $InvestmentHoldingsTable,
              InvestmentHolding
            >,
          ),
          InvestmentHolding,
          PrefetchHooks Function()
        > {
  $$InvestmentHoldingsTableTableManager(
    _$AppDatabase db,
    $InvestmentHoldingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvestmentHoldingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvestmentHoldingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvestmentHoldingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> symbol = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<int> costBasisCents = const Value.absent(),
                Value<int> currentPriceCents = const Value.absent(),
                Value<int> currentValueCents = const Value.absent(),
                Value<String> assetClass = const Value.absent(),
                Value<int?> lastPriceUpdate = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvestmentHoldingsCompanion(
                id: id,
                accountId: accountId,
                symbol: symbol,
                name: name,
                quantity: quantity,
                costBasisCents: costBasisCents,
                currentPriceCents: currentPriceCents,
                currentValueCents: currentValueCents,
                assetClass: assetClass,
                lastPriceUpdate: lastPriceUpdate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String symbol,
                required String name,
                required double quantity,
                required int costBasisCents,
                required int currentPriceCents,
                required int currentValueCents,
                required String assetClass,
                Value<int?> lastPriceUpdate = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> version = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvestmentHoldingsCompanion.insert(
                id: id,
                accountId: accountId,
                symbol: symbol,
                name: name,
                quantity: quantity,
                costBasisCents: costBasisCents,
                currentPriceCents: currentPriceCents,
                currentValueCents: currentValueCents,
                assetClass: assetClass,
                lastPriceUpdate: lastPriceUpdate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InvestmentHoldingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvestmentHoldingsTable,
      InvestmentHolding,
      $$InvestmentHoldingsTableFilterComposer,
      $$InvestmentHoldingsTableOrderingComposer,
      $$InvestmentHoldingsTableAnnotationComposer,
      $$InvestmentHoldingsTableCreateCompanionBuilder,
      $$InvestmentHoldingsTableUpdateCompanionBuilder,
      (
        InvestmentHolding,
        BaseReferences<
          _$AppDatabase,
          $InvestmentHoldingsTable,
          InvestmentHolding
        >,
      ),
      InvestmentHolding,
      PrefetchHooks Function()
    >;
typedef $$BankConnectionsTableCreateCompanionBuilder =
    BankConnectionsCompanion Function({
      required String id,
      required String provider,
      required String institutionName,
      required String status,
      Value<int?> lastSyncedAt,
      Value<String?> errorMessage,
      Value<int> consecutiveFailures,
      Value<int?> lastFailureTime,
      Value<bool> isSyncing,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$BankConnectionsTableUpdateCompanionBuilder =
    BankConnectionsCompanion Function({
      Value<String> id,
      Value<String> provider,
      Value<String> institutionName,
      Value<String> status,
      Value<int?> lastSyncedAt,
      Value<String?> errorMessage,
      Value<int> consecutiveFailures,
      Value<int?> lastFailureTime,
      Value<bool> isSyncing,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$BankConnectionsTableFilterComposer
    extends Composer<_$AppDatabase, $BankConnectionsTable> {
  $$BankConnectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get institutionName => $composableBuilder(
    column: $table.institutionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get consecutiveFailures => $composableBuilder(
    column: $table.consecutiveFailures,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastFailureTime => $composableBuilder(
    column: $table.lastFailureTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSyncing => $composableBuilder(
    column: $table.isSyncing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BankConnectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $BankConnectionsTable> {
  $$BankConnectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get institutionName => $composableBuilder(
    column: $table.institutionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get consecutiveFailures => $composableBuilder(
    column: $table.consecutiveFailures,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastFailureTime => $composableBuilder(
    column: $table.lastFailureTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSyncing => $composableBuilder(
    column: $table.isSyncing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BankConnectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BankConnectionsTable> {
  $$BankConnectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get institutionName => $composableBuilder(
    column: $table.institutionName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get consecutiveFailures => $composableBuilder(
    column: $table.consecutiveFailures,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastFailureTime => $composableBuilder(
    column: $table.lastFailureTime,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSyncing =>
      $composableBuilder(column: $table.isSyncing, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BankConnectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BankConnectionsTable,
          BankConnection,
          $$BankConnectionsTableFilterComposer,
          $$BankConnectionsTableOrderingComposer,
          $$BankConnectionsTableAnnotationComposer,
          $$BankConnectionsTableCreateCompanionBuilder,
          $$BankConnectionsTableUpdateCompanionBuilder,
          (
            BankConnection,
            BaseReferences<
              _$AppDatabase,
              $BankConnectionsTable,
              BankConnection
            >,
          ),
          BankConnection,
          PrefetchHooks Function()
        > {
  $$BankConnectionsTableTableManager(
    _$AppDatabase db,
    $BankConnectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BankConnectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BankConnectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BankConnectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<String> institutionName = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> lastSyncedAt = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<int> consecutiveFailures = const Value.absent(),
                Value<int?> lastFailureTime = const Value.absent(),
                Value<bool> isSyncing = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BankConnectionsCompanion(
                id: id,
                provider: provider,
                institutionName: institutionName,
                status: status,
                lastSyncedAt: lastSyncedAt,
                errorMessage: errorMessage,
                consecutiveFailures: consecutiveFailures,
                lastFailureTime: lastFailureTime,
                isSyncing: isSyncing,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String provider,
                required String institutionName,
                required String status,
                Value<int?> lastSyncedAt = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<int> consecutiveFailures = const Value.absent(),
                Value<int?> lastFailureTime = const Value.absent(),
                Value<bool> isSyncing = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BankConnectionsCompanion.insert(
                id: id,
                provider: provider,
                institutionName: institutionName,
                status: status,
                lastSyncedAt: lastSyncedAt,
                errorMessage: errorMessage,
                consecutiveFailures: consecutiveFailures,
                lastFailureTime: lastFailureTime,
                isSyncing: isSyncing,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BankConnectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BankConnectionsTable,
      BankConnection,
      $$BankConnectionsTableFilterComposer,
      $$BankConnectionsTableOrderingComposer,
      $$BankConnectionsTableAnnotationComposer,
      $$BankConnectionsTableCreateCompanionBuilder,
      $$BankConnectionsTableUpdateCompanionBuilder,
      (
        BankConnection,
        BaseReferences<_$AppDatabase, $BankConnectionsTable, BankConnection>,
      ),
      BankConnection,
      PrefetchHooks Function()
    >;
typedef $$RecurringTransactionsTableCreateCompanionBuilder =
    RecurringTransactionsCompanion Function({
      required String id,
      required String payee,
      required int amountCents,
      Value<String?> categoryId,
      required String accountId,
      required String frequency,
      required int nextExpectedDate,
      required int lastOccurrenceDate,
      Value<bool> isSubscription,
      Value<bool> isActive,
      Value<String?> notes,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$RecurringTransactionsTableUpdateCompanionBuilder =
    RecurringTransactionsCompanion Function({
      Value<String> id,
      Value<String> payee,
      Value<int> amountCents,
      Value<String?> categoryId,
      Value<String> accountId,
      Value<String> frequency,
      Value<int> nextExpectedDate,
      Value<int> lastOccurrenceDate,
      Value<bool> isSubscription,
      Value<bool> isActive,
      Value<String?> notes,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$RecurringTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringTransactionsTable> {
  $$RecurringTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payee => $composableBuilder(
    column: $table.payee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextExpectedDate => $composableBuilder(
    column: $table.nextExpectedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastOccurrenceDate => $composableBuilder(
    column: $table.lastOccurrenceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSubscription => $composableBuilder(
    column: $table.isSubscription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecurringTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringTransactionsTable> {
  $$RecurringTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payee => $composableBuilder(
    column: $table.payee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextExpectedDate => $composableBuilder(
    column: $table.nextExpectedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastOccurrenceDate => $composableBuilder(
    column: $table.lastOccurrenceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSubscription => $composableBuilder(
    column: $table.isSubscription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecurringTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringTransactionsTable> {
  $$RecurringTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get payee =>
      $composableBuilder(column: $table.payee, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<int> get nextExpectedDate => $composableBuilder(
    column: $table.nextExpectedDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastOccurrenceDate => $composableBuilder(
    column: $table.lastOccurrenceDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSubscription => $composableBuilder(
    column: $table.isSubscription,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RecurringTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurringTransactionsTable,
          RecurringTransaction,
          $$RecurringTransactionsTableFilterComposer,
          $$RecurringTransactionsTableOrderingComposer,
          $$RecurringTransactionsTableAnnotationComposer,
          $$RecurringTransactionsTableCreateCompanionBuilder,
          $$RecurringTransactionsTableUpdateCompanionBuilder,
          (
            RecurringTransaction,
            BaseReferences<
              _$AppDatabase,
              $RecurringTransactionsTable,
              RecurringTransaction
            >,
          ),
          RecurringTransaction,
          PrefetchHooks Function()
        > {
  $$RecurringTransactionsTableTableManager(
    _$AppDatabase db,
    $RecurringTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringTransactionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RecurringTransactionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecurringTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> payee = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<int> nextExpectedDate = const Value.absent(),
                Value<int> lastOccurrenceDate = const Value.absent(),
                Value<bool> isSubscription = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurringTransactionsCompanion(
                id: id,
                payee: payee,
                amountCents: amountCents,
                categoryId: categoryId,
                accountId: accountId,
                frequency: frequency,
                nextExpectedDate: nextExpectedDate,
                lastOccurrenceDate: lastOccurrenceDate,
                isSubscription: isSubscription,
                isActive: isActive,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String payee,
                required int amountCents,
                Value<String?> categoryId = const Value.absent(),
                required String accountId,
                required String frequency,
                required int nextExpectedDate,
                required int lastOccurrenceDate,
                Value<bool> isSubscription = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RecurringTransactionsCompanion.insert(
                id: id,
                payee: payee,
                amountCents: amountCents,
                categoryId: categoryId,
                accountId: accountId,
                frequency: frequency,
                nextExpectedDate: nextExpectedDate,
                lastOccurrenceDate: lastOccurrenceDate,
                isSubscription: isSubscription,
                isActive: isActive,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecurringTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurringTransactionsTable,
      RecurringTransaction,
      $$RecurringTransactionsTableFilterComposer,
      $$RecurringTransactionsTableOrderingComposer,
      $$RecurringTransactionsTableAnnotationComposer,
      $$RecurringTransactionsTableCreateCompanionBuilder,
      $$RecurringTransactionsTableUpdateCompanionBuilder,
      (
        RecurringTransaction,
        BaseReferences<
          _$AppDatabase,
          $RecurringTransactionsTable,
          RecurringTransaction
        >,
      ),
      RecurringTransaction,
      PrefetchHooks Function()
    >;
typedef $$PayeeCategoryCacheTableCreateCompanionBuilder =
    PayeeCategoryCacheCompanion Function({
      required String payeeNormalized,
      required String categoryId,
      required double confidence,
      required String source,
      Value<int> useCount,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$PayeeCategoryCacheTableUpdateCompanionBuilder =
    PayeeCategoryCacheCompanion Function({
      Value<String> payeeNormalized,
      Value<String> categoryId,
      Value<double> confidence,
      Value<String> source,
      Value<int> useCount,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$PayeeCategoryCacheTableFilterComposer
    extends Composer<_$AppDatabase, $PayeeCategoryCacheTable> {
  $$PayeeCategoryCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get payeeNormalized => $composableBuilder(
    column: $table.payeeNormalized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get useCount => $composableBuilder(
    column: $table.useCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PayeeCategoryCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $PayeeCategoryCacheTable> {
  $$PayeeCategoryCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get payeeNormalized => $composableBuilder(
    column: $table.payeeNormalized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get useCount => $composableBuilder(
    column: $table.useCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PayeeCategoryCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $PayeeCategoryCacheTable> {
  $$PayeeCategoryCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get payeeNormalized => $composableBuilder(
    column: $table.payeeNormalized,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get useCount =>
      $composableBuilder(column: $table.useCount, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PayeeCategoryCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PayeeCategoryCacheTable,
          PayeeCategoryCacheData,
          $$PayeeCategoryCacheTableFilterComposer,
          $$PayeeCategoryCacheTableOrderingComposer,
          $$PayeeCategoryCacheTableAnnotationComposer,
          $$PayeeCategoryCacheTableCreateCompanionBuilder,
          $$PayeeCategoryCacheTableUpdateCompanionBuilder,
          (
            PayeeCategoryCacheData,
            BaseReferences<
              _$AppDatabase,
              $PayeeCategoryCacheTable,
              PayeeCategoryCacheData
            >,
          ),
          PayeeCategoryCacheData,
          PrefetchHooks Function()
        > {
  $$PayeeCategoryCacheTableTableManager(
    _$AppDatabase db,
    $PayeeCategoryCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PayeeCategoryCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PayeeCategoryCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PayeeCategoryCacheTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> payeeNormalized = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<double> confidence = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> useCount = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PayeeCategoryCacheCompanion(
                payeeNormalized: payeeNormalized,
                categoryId: categoryId,
                confidence: confidence,
                source: source,
                useCount: useCount,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String payeeNormalized,
                required String categoryId,
                required double confidence,
                required String source,
                Value<int> useCount = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PayeeCategoryCacheCompanion.insert(
                payeeNormalized: payeeNormalized,
                categoryId: categoryId,
                confidence: confidence,
                source: source,
                useCount: useCount,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PayeeCategoryCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PayeeCategoryCacheTable,
      PayeeCategoryCacheData,
      $$PayeeCategoryCacheTableFilterComposer,
      $$PayeeCategoryCacheTableOrderingComposer,
      $$PayeeCategoryCacheTableAnnotationComposer,
      $$PayeeCategoryCacheTableCreateCompanionBuilder,
      $$PayeeCategoryCacheTableUpdateCompanionBuilder,
      (
        PayeeCategoryCacheData,
        BaseReferences<
          _$AppDatabase,
          $PayeeCategoryCacheTable,
          PayeeCategoryCacheData
        >,
      ),
      PayeeCategoryCacheData,
      PrefetchHooks Function()
    >;
typedef $$CategorizationCorrectionsTableCreateCompanionBuilder =
    CategorizationCorrectionsCompanion Function({
      required String id,
      required String transactionId,
      Value<String?> oldCategoryId,
      required String newCategoryId,
      required String payee,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$CategorizationCorrectionsTableUpdateCompanionBuilder =
    CategorizationCorrectionsCompanion Function({
      Value<String> id,
      Value<String> transactionId,
      Value<String?> oldCategoryId,
      Value<String> newCategoryId,
      Value<String> payee,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$CategorizationCorrectionsTableFilterComposer
    extends Composer<_$AppDatabase, $CategorizationCorrectionsTable> {
  $$CategorizationCorrectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oldCategoryId => $composableBuilder(
    column: $table.oldCategoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get newCategoryId => $composableBuilder(
    column: $table.newCategoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payee => $composableBuilder(
    column: $table.payee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategorizationCorrectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CategorizationCorrectionsTable> {
  $$CategorizationCorrectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oldCategoryId => $composableBuilder(
    column: $table.oldCategoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get newCategoryId => $composableBuilder(
    column: $table.newCategoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payee => $composableBuilder(
    column: $table.payee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategorizationCorrectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategorizationCorrectionsTable> {
  $$CategorizationCorrectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get oldCategoryId => $composableBuilder(
    column: $table.oldCategoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get newCategoryId => $composableBuilder(
    column: $table.newCategoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payee =>
      $composableBuilder(column: $table.payee, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CategorizationCorrectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategorizationCorrectionsTable,
          CategorizationCorrection,
          $$CategorizationCorrectionsTableFilterComposer,
          $$CategorizationCorrectionsTableOrderingComposer,
          $$CategorizationCorrectionsTableAnnotationComposer,
          $$CategorizationCorrectionsTableCreateCompanionBuilder,
          $$CategorizationCorrectionsTableUpdateCompanionBuilder,
          (
            CategorizationCorrection,
            BaseReferences<
              _$AppDatabase,
              $CategorizationCorrectionsTable,
              CategorizationCorrection
            >,
          ),
          CategorizationCorrection,
          PrefetchHooks Function()
        > {
  $$CategorizationCorrectionsTableTableManager(
    _$AppDatabase db,
    $CategorizationCorrectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategorizationCorrectionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CategorizationCorrectionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CategorizationCorrectionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> transactionId = const Value.absent(),
                Value<String?> oldCategoryId = const Value.absent(),
                Value<String> newCategoryId = const Value.absent(),
                Value<String> payee = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategorizationCorrectionsCompanion(
                id: id,
                transactionId: transactionId,
                oldCategoryId: oldCategoryId,
                newCategoryId: newCategoryId,
                payee: payee,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String transactionId,
                Value<String?> oldCategoryId = const Value.absent(),
                required String newCategoryId,
                required String payee,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CategorizationCorrectionsCompanion.insert(
                id: id,
                transactionId: transactionId,
                oldCategoryId: oldCategoryId,
                newCategoryId: newCategoryId,
                payee: payee,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategorizationCorrectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategorizationCorrectionsTable,
      CategorizationCorrection,
      $$CategorizationCorrectionsTableFilterComposer,
      $$CategorizationCorrectionsTableOrderingComposer,
      $$CategorizationCorrectionsTableAnnotationComposer,
      $$CategorizationCorrectionsTableCreateCompanionBuilder,
      $$CategorizationCorrectionsTableUpdateCompanionBuilder,
      (
        CategorizationCorrection,
        BaseReferences<
          _$AppDatabase,
          $CategorizationCorrectionsTable,
          CategorizationCorrection
        >,
      ),
      CategorizationCorrection,
      PrefetchHooks Function()
    >;
typedef $$ConversationsTableCreateCompanionBuilder =
    ConversationsCompanion Function({
      required String id,
      Value<String?> title,
      required String provider,
      required String model,
      Value<String> purpose,
      required int createdAt,
      required int updatedAt,
      Value<int> version,
      Value<int> syncStatus,
      Value<int> rowid,
    });
typedef $$ConversationsTableUpdateCompanionBuilder =
    ConversationsCompanion Function({
      Value<String> id,
      Value<String?> title,
      Value<String> provider,
      Value<String> model,
      Value<String> purpose,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> version,
      Value<int> syncStatus,
      Value<int> rowid,
    });

class $$ConversationsTableFilterComposer
    extends Composer<_$AppDatabase, $ConversationsTable> {
  $$ConversationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConversationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConversationsTable> {
  $$ConversationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConversationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConversationsTable> {
  $$ConversationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$ConversationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConversationsTable,
          Conversation,
          $$ConversationsTableFilterComposer,
          $$ConversationsTableOrderingComposer,
          $$ConversationsTableAnnotationComposer,
          $$ConversationsTableCreateCompanionBuilder,
          $$ConversationsTableUpdateCompanionBuilder,
          (
            Conversation,
            BaseReferences<_$AppDatabase, $ConversationsTable, Conversation>,
          ),
          Conversation,
          PrefetchHooks Function()
        > {
  $$ConversationsTableTableManager(_$AppDatabase db, $ConversationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConversationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConversationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConversationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<String> purpose = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConversationsCompanion(
                id: id,
                title: title,
                provider: provider,
                model: model,
                purpose: purpose,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> title = const Value.absent(),
                required String provider,
                required String model,
                Value<String> purpose = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> version = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConversationsCompanion.insert(
                id: id,
                title: title,
                provider: provider,
                model: model,
                purpose: purpose,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConversationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConversationsTable,
      Conversation,
      $$ConversationsTableFilterComposer,
      $$ConversationsTableOrderingComposer,
      $$ConversationsTableAnnotationComposer,
      $$ConversationsTableCreateCompanionBuilder,
      $$ConversationsTableUpdateCompanionBuilder,
      (
        Conversation,
        BaseReferences<_$AppDatabase, $ConversationsTable, Conversation>,
      ),
      Conversation,
      PrefetchHooks Function()
    >;
typedef $$MessagesTableCreateCompanionBuilder =
    MessagesCompanion Function({
      required String id,
      required String conversationId,
      required String role,
      required String content,
      Value<int?> tokenCount,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$MessagesTableUpdateCompanionBuilder =
    MessagesCompanion Function({
      Value<String> id,
      Value<String> conversationId,
      Value<String> role,
      Value<String> content,
      Value<int?> tokenCount,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$MessagesTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tokenCount => $composableBuilder(
    column: $table.tokenCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tokenCount => $composableBuilder(
    column: $table.tokenCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get tokenCount => $composableBuilder(
    column: $table.tokenCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessagesTable,
          Message,
          $$MessagesTableFilterComposer,
          $$MessagesTableOrderingComposer,
          $$MessagesTableAnnotationComposer,
          $$MessagesTableCreateCompanionBuilder,
          $$MessagesTableUpdateCompanionBuilder,
          (Message, BaseReferences<_$AppDatabase, $MessagesTable, Message>),
          Message,
          PrefetchHooks Function()
        > {
  $$MessagesTableTableManager(_$AppDatabase db, $MessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int?> tokenCount = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessagesCompanion(
                id: id,
                conversationId: conversationId,
                role: role,
                content: content,
                tokenCount: tokenCount,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String conversationId,
                required String role,
                required String content,
                Value<int?> tokenCount = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => MessagesCompanion.insert(
                id: id,
                conversationId: conversationId,
                role: role,
                content: content,
                tokenCount: tokenCount,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessagesTable,
      Message,
      $$MessagesTableFilterComposer,
      $$MessagesTableOrderingComposer,
      $$MessagesTableAnnotationComposer,
      $$MessagesTableCreateCompanionBuilder,
      $$MessagesTableUpdateCompanionBuilder,
      (Message, BaseReferences<_$AppDatabase, $MessagesTable, Message>),
      Message,
      PrefetchHooks Function()
    >;
typedef $$InsightsTableCreateCompanionBuilder =
    InsightsCompanion Function({
      required String id,
      required String title,
      required String description,
      required String insightType,
      required String severity,
      Value<String?> actionType,
      Value<String?> actionData,
      Value<bool> isRead,
      Value<bool> isDismissed,
      Value<int?> expiresAt,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$InsightsTableUpdateCompanionBuilder =
    InsightsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> description,
      Value<String> insightType,
      Value<String> severity,
      Value<String?> actionType,
      Value<String?> actionData,
      Value<bool> isRead,
      Value<bool> isDismissed,
      Value<int?> expiresAt,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$InsightsTableFilterComposer
    extends Composer<_$AppDatabase, $InsightsTable> {
  $$InsightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get insightType => $composableBuilder(
    column: $table.insightType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionData => $composableBuilder(
    column: $table.actionData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InsightsTableOrderingComposer
    extends Composer<_$AppDatabase, $InsightsTable> {
  $$InsightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get insightType => $composableBuilder(
    column: $table.insightType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionData => $composableBuilder(
    column: $table.actionData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InsightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InsightsTable> {
  $$InsightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get insightType => $composableBuilder(
    column: $table.insightType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actionData => $composableBuilder(
    column: $table.actionData,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$InsightsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InsightsTable,
          Insight,
          $$InsightsTableFilterComposer,
          $$InsightsTableOrderingComposer,
          $$InsightsTableAnnotationComposer,
          $$InsightsTableCreateCompanionBuilder,
          $$InsightsTableUpdateCompanionBuilder,
          (Insight, BaseReferences<_$AppDatabase, $InsightsTable, Insight>),
          Insight,
          PrefetchHooks Function()
        > {
  $$InsightsTableTableManager(_$AppDatabase db, $InsightsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InsightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InsightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InsightsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> insightType = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<String?> actionType = const Value.absent(),
                Value<String?> actionData = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<bool> isDismissed = const Value.absent(),
                Value<int?> expiresAt = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InsightsCompanion(
                id: id,
                title: title,
                description: description,
                insightType: insightType,
                severity: severity,
                actionType: actionType,
                actionData: actionData,
                isRead: isRead,
                isDismissed: isDismissed,
                expiresAt: expiresAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String description,
                required String insightType,
                required String severity,
                Value<String?> actionType = const Value.absent(),
                Value<String?> actionData = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<bool> isDismissed = const Value.absent(),
                Value<int?> expiresAt = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => InsightsCompanion.insert(
                id: id,
                title: title,
                description: description,
                insightType: insightType,
                severity: severity,
                actionType: actionType,
                actionData: actionData,
                isRead: isRead,
                isDismissed: isDismissed,
                expiresAt: expiresAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InsightsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InsightsTable,
      Insight,
      $$InsightsTableFilterComposer,
      $$InsightsTableOrderingComposer,
      $$InsightsTableAnnotationComposer,
      $$InsightsTableCreateCompanionBuilder,
      $$InsightsTableUpdateCompanionBuilder,
      (Insight, BaseReferences<_$AppDatabase, $InsightsTable, Insight>),
      Insight,
      PrefetchHooks Function()
    >;
typedef $$AiMemoryCoreTableCreateCompanionBuilder =
    AiMemoryCoreCompanion Function({
      required String id,
      required String key,
      required String value,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$AiMemoryCoreTableUpdateCompanionBuilder =
    AiMemoryCoreCompanion Function({
      Value<String> id,
      Value<String> key,
      Value<String> value,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$AiMemoryCoreTableFilterComposer
    extends Composer<_$AppDatabase, $AiMemoryCoreTable> {
  $$AiMemoryCoreTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiMemoryCoreTableOrderingComposer
    extends Composer<_$AppDatabase, $AiMemoryCoreTable> {
  $$AiMemoryCoreTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiMemoryCoreTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiMemoryCoreTable> {
  $$AiMemoryCoreTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AiMemoryCoreTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiMemoryCoreTable,
          AiMemoryCoreData,
          $$AiMemoryCoreTableFilterComposer,
          $$AiMemoryCoreTableOrderingComposer,
          $$AiMemoryCoreTableAnnotationComposer,
          $$AiMemoryCoreTableCreateCompanionBuilder,
          $$AiMemoryCoreTableUpdateCompanionBuilder,
          (
            AiMemoryCoreData,
            BaseReferences<_$AppDatabase, $AiMemoryCoreTable, AiMemoryCoreData>,
          ),
          AiMemoryCoreData,
          PrefetchHooks Function()
        > {
  $$AiMemoryCoreTableTableManager(_$AppDatabase db, $AiMemoryCoreTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiMemoryCoreTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiMemoryCoreTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiMemoryCoreTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiMemoryCoreCompanion(
                id: id,
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String key,
                required String value,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AiMemoryCoreCompanion.insert(
                id: id,
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiMemoryCoreTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiMemoryCoreTable,
      AiMemoryCoreData,
      $$AiMemoryCoreTableFilterComposer,
      $$AiMemoryCoreTableOrderingComposer,
      $$AiMemoryCoreTableAnnotationComposer,
      $$AiMemoryCoreTableCreateCompanionBuilder,
      $$AiMemoryCoreTableUpdateCompanionBuilder,
      (
        AiMemoryCoreData,
        BaseReferences<_$AppDatabase, $AiMemoryCoreTable, AiMemoryCoreData>,
      ),
      AiMemoryCoreData,
      PrefetchHooks Function()
    >;
typedef $$AiMemorySemanticTableCreateCompanionBuilder =
    AiMemorySemanticCompanion Function({
      required String id,
      required String topic,
      required String summary,
      Value<String?> conversationId,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$AiMemorySemanticTableUpdateCompanionBuilder =
    AiMemorySemanticCompanion Function({
      Value<String> id,
      Value<String> topic,
      Value<String> summary,
      Value<String?> conversationId,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$AiMemorySemanticTableFilterComposer
    extends Composer<_$AppDatabase, $AiMemorySemanticTable> {
  $$AiMemorySemanticTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiMemorySemanticTableOrderingComposer
    extends Composer<_$AppDatabase, $AiMemorySemanticTable> {
  $$AiMemorySemanticTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiMemorySemanticTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiMemorySemanticTable> {
  $$AiMemorySemanticTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AiMemorySemanticTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiMemorySemanticTable,
          AiMemorySemanticData,
          $$AiMemorySemanticTableFilterComposer,
          $$AiMemorySemanticTableOrderingComposer,
          $$AiMemorySemanticTableAnnotationComposer,
          $$AiMemorySemanticTableCreateCompanionBuilder,
          $$AiMemorySemanticTableUpdateCompanionBuilder,
          (
            AiMemorySemanticData,
            BaseReferences<
              _$AppDatabase,
              $AiMemorySemanticTable,
              AiMemorySemanticData
            >,
          ),
          AiMemorySemanticData,
          PrefetchHooks Function()
        > {
  $$AiMemorySemanticTableTableManager(
    _$AppDatabase db,
    $AiMemorySemanticTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiMemorySemanticTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiMemorySemanticTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiMemorySemanticTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> topic = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String?> conversationId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiMemorySemanticCompanion(
                id: id,
                topic: topic,
                summary: summary,
                conversationId: conversationId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String topic,
                required String summary,
                Value<String?> conversationId = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => AiMemorySemanticCompanion.insert(
                id: id,
                topic: topic,
                summary: summary,
                conversationId: conversationId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiMemorySemanticTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiMemorySemanticTable,
      AiMemorySemanticData,
      $$AiMemorySemanticTableFilterComposer,
      $$AiMemorySemanticTableOrderingComposer,
      $$AiMemorySemanticTableAnnotationComposer,
      $$AiMemorySemanticTableCreateCompanionBuilder,
      $$AiMemorySemanticTableUpdateCompanionBuilder,
      (
        AiMemorySemanticData,
        BaseReferences<
          _$AppDatabase,
          $AiMemorySemanticTable,
          AiMemorySemanticData
        >,
      ),
      AiMemorySemanticData,
      PrefetchHooks Function()
    >;
typedef $$InsightFeedbackTableCreateCompanionBuilder =
    InsightFeedbackCompanion Function({
      required String id,
      required String insightId,
      required String rating,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$InsightFeedbackTableUpdateCompanionBuilder =
    InsightFeedbackCompanion Function({
      Value<String> id,
      Value<String> insightId,
      Value<String> rating,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$InsightFeedbackTableFilterComposer
    extends Composer<_$AppDatabase, $InsightFeedbackTable> {
  $$InsightFeedbackTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get insightId => $composableBuilder(
    column: $table.insightId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InsightFeedbackTableOrderingComposer
    extends Composer<_$AppDatabase, $InsightFeedbackTable> {
  $$InsightFeedbackTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get insightId => $composableBuilder(
    column: $table.insightId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InsightFeedbackTableAnnotationComposer
    extends Composer<_$AppDatabase, $InsightFeedbackTable> {
  $$InsightFeedbackTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get insightId =>
      $composableBuilder(column: $table.insightId, builder: (column) => column);

  GeneratedColumn<String> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$InsightFeedbackTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InsightFeedbackTable,
          InsightFeedbackData,
          $$InsightFeedbackTableFilterComposer,
          $$InsightFeedbackTableOrderingComposer,
          $$InsightFeedbackTableAnnotationComposer,
          $$InsightFeedbackTableCreateCompanionBuilder,
          $$InsightFeedbackTableUpdateCompanionBuilder,
          (
            InsightFeedbackData,
            BaseReferences<
              _$AppDatabase,
              $InsightFeedbackTable,
              InsightFeedbackData
            >,
          ),
          InsightFeedbackData,
          PrefetchHooks Function()
        > {
  $$InsightFeedbackTableTableManager(
    _$AppDatabase db,
    $InsightFeedbackTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InsightFeedbackTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InsightFeedbackTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InsightFeedbackTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> insightId = const Value.absent(),
                Value<String> rating = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InsightFeedbackCompanion(
                id: id,
                insightId: insightId,
                rating: rating,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String insightId,
                required String rating,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => InsightFeedbackCompanion.insert(
                id: id,
                insightId: insightId,
                rating: rating,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InsightFeedbackTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InsightFeedbackTable,
      InsightFeedbackData,
      $$InsightFeedbackTableFilterComposer,
      $$InsightFeedbackTableOrderingComposer,
      $$InsightFeedbackTableAnnotationComposer,
      $$InsightFeedbackTableCreateCompanionBuilder,
      $$InsightFeedbackTableUpdateCompanionBuilder,
      (
        InsightFeedbackData,
        BaseReferences<
          _$AppDatabase,
          $InsightFeedbackTable,
          InsightFeedbackData
        >,
      ),
      InsightFeedbackData,
      PrefetchHooks Function()
    >;
typedef $$SyncStateTableCreateCompanionBuilder =
    SyncStateCompanion Function({
      required String id,
      required String entityTable,
      required String entityId,
      required String operation,
      required int createdAt,
      Value<int?> syncedAt,
      Value<int> rowid,
    });
typedef $$SyncStateTableUpdateCompanionBuilder =
    SyncStateCompanion Function({
      Value<String> id,
      Value<String> entityTable,
      Value<String> entityId,
      Value<String> operation,
      Value<int> createdAt,
      Value<int?> syncedAt,
      Value<int> rowid,
    });

class $$SyncStateTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityTable => $composableBuilder(
    column: $table.entityTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncStateTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityTable => $composableBuilder(
    column: $table.entityTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityTable => $composableBuilder(
    column: $table.entityTable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$SyncStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncStateTable,
          SyncStateData,
          $$SyncStateTableFilterComposer,
          $$SyncStateTableOrderingComposer,
          $$SyncStateTableAnnotationComposer,
          $$SyncStateTableCreateCompanionBuilder,
          $$SyncStateTableUpdateCompanionBuilder,
          (
            SyncStateData,
            BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>,
          ),
          SyncStateData,
          PrefetchHooks Function()
        > {
  $$SyncStateTableTableManager(_$AppDatabase db, $SyncStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityTable = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion(
                id: id,
                entityTable: entityTable,
                entityId: entityId,
                operation: operation,
                createdAt: createdAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityTable,
                required String entityId,
                required String operation,
                required int createdAt,
                Value<int?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion.insert(
                id: id,
                entityTable: entityTable,
                entityId: entityId,
                operation: operation,
                createdAt: createdAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncStateTable,
      SyncStateData,
      $$SyncStateTableFilterComposer,
      $$SyncStateTableOrderingComposer,
      $$SyncStateTableAnnotationComposer,
      $$SyncStateTableCreateCompanionBuilder,
      $$SyncStateTableUpdateCompanionBuilder,
      (
        SyncStateData,
        BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>,
      ),
      SyncStateData,
      PrefetchHooks Function()
    >;
typedef $$AuditLogTableCreateCompanionBuilder =
    AuditLogCompanion Function({
      required String id,
      required String eventType,
      Value<String?> details,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$AuditLogTableUpdateCompanionBuilder =
    AuditLogCompanion Function({
      Value<String> id,
      Value<String> eventType,
      Value<String?> details,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$AuditLogTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditLogTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AuditLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditLogTable,
          AuditLogData,
          $$AuditLogTableFilterComposer,
          $$AuditLogTableOrderingComposer,
          $$AuditLogTableAnnotationComposer,
          $$AuditLogTableCreateCompanionBuilder,
          $$AuditLogTableUpdateCompanionBuilder,
          (
            AuditLogData,
            BaseReferences<_$AppDatabase, $AuditLogTable, AuditLogData>,
          ),
          AuditLogData,
          PrefetchHooks Function()
        > {
  $$AuditLogTableTableManager(_$AppDatabase db, $AuditLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<String?> details = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditLogCompanion(
                id: id,
                eventType: eventType,
                details: details,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String eventType,
                Value<String?> details = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => AuditLogCompanion.insert(
                id: id,
                eventType: eventType,
                details: details,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditLogTable,
      AuditLogData,
      $$AuditLogTableFilterComposer,
      $$AuditLogTableOrderingComposer,
      $$AuditLogTableAnnotationComposer,
      $$AuditLogTableCreateCompanionBuilder,
      $$AuditLogTableUpdateCompanionBuilder,
      (
        AuditLogData,
        BaseReferences<_$AppDatabase, $AuditLogTable, AuditLogData>,
      ),
      AuditLogData,
      PrefetchHooks Function()
    >;
typedef $$ImportHistoryTableCreateCompanionBuilder =
    ImportHistoryCompanion Function({
      required String id,
      required String source,
      required String fileName,
      required int rowCount,
      required int importedCount,
      required int skippedCount,
      required String status,
      Value<String?> errorMessage,
      Value<String?> bankConnectionId,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$ImportHistoryTableUpdateCompanionBuilder =
    ImportHistoryCompanion Function({
      Value<String> id,
      Value<String> source,
      Value<String> fileName,
      Value<int> rowCount,
      Value<int> importedCount,
      Value<int> skippedCount,
      Value<String> status,
      Value<String?> errorMessage,
      Value<String?> bankConnectionId,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$ImportHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $ImportHistoryTable> {
  $$ImportHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rowCount => $composableBuilder(
    column: $table.rowCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get importedCount => $composableBuilder(
    column: $table.importedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get skippedCount => $composableBuilder(
    column: $table.skippedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankConnectionId => $composableBuilder(
    column: $table.bankConnectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ImportHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $ImportHistoryTable> {
  $$ImportHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rowCount => $composableBuilder(
    column: $table.rowCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get importedCount => $composableBuilder(
    column: $table.importedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get skippedCount => $composableBuilder(
    column: $table.skippedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankConnectionId => $composableBuilder(
    column: $table.bankConnectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ImportHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImportHistoryTable> {
  $$ImportHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<int> get rowCount =>
      $composableBuilder(column: $table.rowCount, builder: (column) => column);

  GeneratedColumn<int> get importedCount => $composableBuilder(
    column: $table.importedCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get skippedCount => $composableBuilder(
    column: $table.skippedCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bankConnectionId => $composableBuilder(
    column: $table.bankConnectionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ImportHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImportHistoryTable,
          ImportHistoryData,
          $$ImportHistoryTableFilterComposer,
          $$ImportHistoryTableOrderingComposer,
          $$ImportHistoryTableAnnotationComposer,
          $$ImportHistoryTableCreateCompanionBuilder,
          $$ImportHistoryTableUpdateCompanionBuilder,
          (
            ImportHistoryData,
            BaseReferences<
              _$AppDatabase,
              $ImportHistoryTable,
              ImportHistoryData
            >,
          ),
          ImportHistoryData,
          PrefetchHooks Function()
        > {
  $$ImportHistoryTableTableManager(_$AppDatabase db, $ImportHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImportHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImportHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImportHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<int> rowCount = const Value.absent(),
                Value<int> importedCount = const Value.absent(),
                Value<int> skippedCount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<String?> bankConnectionId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImportHistoryCompanion(
                id: id,
                source: source,
                fileName: fileName,
                rowCount: rowCount,
                importedCount: importedCount,
                skippedCount: skippedCount,
                status: status,
                errorMessage: errorMessage,
                bankConnectionId: bankConnectionId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String source,
                required String fileName,
                required int rowCount,
                required int importedCount,
                required int skippedCount,
                required String status,
                Value<String?> errorMessage = const Value.absent(),
                Value<String?> bankConnectionId = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ImportHistoryCompanion.insert(
                id: id,
                source: source,
                fileName: fileName,
                rowCount: rowCount,
                importedCount: importedCount,
                skippedCount: skippedCount,
                status: status,
                errorMessage: errorMessage,
                bankConnectionId: bankConnectionId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ImportHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImportHistoryTable,
      ImportHistoryData,
      $$ImportHistoryTableFilterComposer,
      $$ImportHistoryTableOrderingComposer,
      $$ImportHistoryTableAnnotationComposer,
      $$ImportHistoryTableCreateCompanionBuilder,
      $$ImportHistoryTableUpdateCompanionBuilder,
      (
        ImportHistoryData,
        BaseReferences<_$AppDatabase, $ImportHistoryTable, ImportHistoryData>,
      ),
      ImportHistoryData,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$AutoCategorizeRulesTableTableManager get autoCategorizeRules =>
      $$AutoCategorizeRulesTableTableManager(_db, _db.autoCategorizeRules);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$InvestmentHoldingsTableTableManager get investmentHoldings =>
      $$InvestmentHoldingsTableTableManager(_db, _db.investmentHoldings);
  $$BankConnectionsTableTableManager get bankConnections =>
      $$BankConnectionsTableTableManager(_db, _db.bankConnections);
  $$RecurringTransactionsTableTableManager get recurringTransactions =>
      $$RecurringTransactionsTableTableManager(_db, _db.recurringTransactions);
  $$PayeeCategoryCacheTableTableManager get payeeCategoryCache =>
      $$PayeeCategoryCacheTableTableManager(_db, _db.payeeCategoryCache);
  $$CategorizationCorrectionsTableTableManager get categorizationCorrections =>
      $$CategorizationCorrectionsTableTableManager(
        _db,
        _db.categorizationCorrections,
      );
  $$ConversationsTableTableManager get conversations =>
      $$ConversationsTableTableManager(_db, _db.conversations);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
  $$InsightsTableTableManager get insights =>
      $$InsightsTableTableManager(_db, _db.insights);
  $$AiMemoryCoreTableTableManager get aiMemoryCore =>
      $$AiMemoryCoreTableTableManager(_db, _db.aiMemoryCore);
  $$AiMemorySemanticTableTableManager get aiMemorySemantic =>
      $$AiMemorySemanticTableTableManager(_db, _db.aiMemorySemantic);
  $$InsightFeedbackTableTableManager get insightFeedback =>
      $$InsightFeedbackTableTableManager(_db, _db.insightFeedback);
  $$SyncStateTableTableManager get syncState =>
      $$SyncStateTableTableManager(_db, _db.syncState);
  $$AuditLogTableTableManager get auditLog =>
      $$AuditLogTableTableManager(_db, _db.auditLog);
  $$ImportHistoryTableTableManager get importHistory =>
      $$ImportHistoryTableTableManager(_db, _db.importHistory);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
