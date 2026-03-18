import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import '../../../core/constants/app_constants.dart';
import '../../../core/error/app_error.dart';
import '../../../data/local/database/app_database.dart';
import '../../../data/remote/backup/backup_destination.dart';
import '../../../data/remote/backup/backup_metadata.dart';
import '../../../data/repositories/bank_connection_repository.dart';

/// Service for creating and restoring database backups.
class BackupService {
  final BackupDestination _destination;
  final AppDatabase _database;
  final BankConnectionRepository _connectionRepo;

  BackupService({
    required BackupDestination destination,
    required AppDatabase database,
    required BankConnectionRepository connectionRepo,
  })  : _destination = destination,
        _database = database,
        _connectionRepo = connectionRepo;

  /// Create a backup of the current database and upload to the destination.
  Future<void> createBackup() async {
    // 1. Check no sync in progress
    final connections = await _connectionRepo.getAllConnections();
    final anySyncing = connections.any((c) => c.isSyncing);
    if (anySyncing) {
      throw const BackupError(
        message: 'Cannot backup while a bank sync is in progress. Please wait for sync to complete.',
      );
    }

    // 2. Get DB file path
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbFolder.path, 'moneymoney.db');

    // 3. Flush WAL to main database file
    await _database.customStatement('PRAGMA wal_checkpoint(TRUNCATE)');

    // 4. Copy DB to temp directory
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final tempPath = p.join(tempDir.path, 'backup_$timestamp.db');
    await File(dbPath).copy(tempPath);

    try {
      // 5. Collect metadata
      final accountCount = await _countRows('accounts');
      final transactionCount = await _countRows('transactions');
      final metadata = BackupMetadata(
        fileId: '', // Set by destination after upload
        appVersion: AppConstants.appVersion,
        schemaVersion: _database.schemaVersion,
        createdAtMs: timestamp,
        accountCount: accountCount,
        transactionCount: transactionCount,
        fileSizeBytes: await File(tempPath).length(),
      );

      // 6. Upload to destination
      final bytes = await File(tempPath).readAsBytes();
      await _destination.uploadFile(
        bytes: bytes,
        fileName: 'moneymoney_$timestamp.db',
        metadata: metadata.toDescriptionMap(),
      );

      // 7. Prune old backups (keep last 3)
      await pruneOldBackups(3);
    } finally {
      // Clean up temp file
      final tempFile = File(tempPath);
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    }
  }

  /// Restore a backup, replacing the current database.
  ///
  /// Returns true on success. Caller must restart the app after restore.
  Future<bool> restoreBackup(String fileId) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = p.join(tempDir.path, 'restore_${DateTime.now().millisecondsSinceEpoch}.db');
    final bytes = await _destination.downloadFile(fileId);
    await File(tempPath).writeAsBytes(bytes);
    return _restoreFromTempFile(tempPath);
  }

  /// Restore a backup from raw bytes (e.g., from a file picker).
  ///
  /// Returns true on success. Caller must restart the app after restore.
  Future<bool> restoreFromBytes(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = p.join(tempDir.path, 'restore_${DateTime.now().millisecondsSinceEpoch}.db');
    await File(tempPath).writeAsBytes(bytes);
    return _restoreFromTempFile(tempPath);
  }

  /// Validate, close current DB, and replace with the backup at [tempPath].
  Future<bool> _restoreFromTempFile(String tempPath) async {
    try {
      final backupSchemaVersion = await _validateBackup(tempPath);

      if (backupSchemaVersion > _database.schemaVersion) {
        throw const BackupError(
          message: 'This backup was created with a newer version of the app. Please update the app before restoring.',
        );
      }

      await _database.close();
      await Future.delayed(const Duration(milliseconds: 500));

      final dbFolder = await getApplicationDocumentsDirectory();
      final dbPath = p.join(dbFolder.path, 'moneymoney.db');

      for (final suffix in ['', '-wal', '-shm']) {
        final file = File('$dbPath$suffix');
        if (await file.exists()) {
          await file.delete();
        }
      }

      await File(tempPath).copy(dbPath);
      return true;
    } finally {
      final tempFile = File(tempPath);
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    }
  }

  /// List available backups, sorted newest first.
  Future<List<BackupMetadata>> listBackups() async {
    return _destination.listFiles();
  }

  /// Delete old backups beyond the keep threshold.
  Future<void> pruneOldBackups(int keepCount) async {
    final backups = await _destination.listFiles();
    if (backups.length <= keepCount) return;

    // Backups are already sorted newest first from listFiles()
    final toDelete = backups.sublist(keepCount);
    for (final backup in toDelete) {
      await _destination.deleteFile(backup.fileId);
    }
  }

  Future<int> _countRows(String table) async {
    final result = await _database.customSelect('SELECT COUNT(*) AS c FROM $table').getSingle();
    return result.read<int>('c');
  }

  /// Validates a backup DB file. Returns the schema version.
  /// Throws [BackupError] if corrupt.
  ///
  /// Uses raw sqlite3 (not Drift) to avoid modifying the backup's
  /// PRAGMA user_version during validation.
  Future<int> _validateBackup(String path) async {
    sqlite.Database? db;
    try {
      db = sqlite.sqlite3.open(path, mode: sqlite.OpenMode.readOnly);
      final result = db.select('PRAGMA integrity_check');
      if (result.isEmpty || result.first['integrity_check'] != 'ok') {
        throw const BackupError(
          message: 'The backup file is corrupt and cannot be restored.',
        );
      }
      final versionResult = db.select('PRAGMA user_version');
      final version = versionResult.first['user_version'] as int? ?? 0;
      return version;
    } catch (e) {
      if (e is BackupError) rethrow;
      throw BackupError(
        message: 'The backup file is corrupt and cannot be restored.',
        technicalDetails: e.toString(),
        originalError: e,
      );
    } finally {
      db?.dispose();
    }
  }
}
