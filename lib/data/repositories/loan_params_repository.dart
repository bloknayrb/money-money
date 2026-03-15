import 'package:drift/drift.dart';

import '../../domain/usecases/amortization/loan_params.dart';
import '../local/database/app_database.dart';

/// Repository for storing and retrieving loan parameters via AppSettings.
class LoanParamsRepository {
  LoanParamsRepository(this._db);

  final AppDatabase _db;

  String _key(String accountId) => 'loan_params:$accountId';

  /// Get loan parameters for an account.
  Future<LoanParams?> getLoanParams(String accountId) async {
    final row = await (_db.select(_db.appSettings)
          ..where((s) => s.key.equals(_key(accountId))))
        .getSingleOrNull();
    if (row == null) return null;
    return LoanParams.decode(row.value);
  }

  /// Save loan parameters for an account.
  Future<void> saveLoanParams(String accountId, LoanParams params) async {
    await _db.into(_db.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            key: _key(accountId),
            value: params.encode(),
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
  }

  /// Delete loan parameters for an account.
  Future<void> deleteLoanParams(String accountId) async {
    await (_db.delete(_db.appSettings)
          ..where((s) => s.key.equals(_key(accountId))))
        .go();
  }
}
