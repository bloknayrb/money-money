import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/app_error.dart';
import '../../../data/local/database/app_database.dart';
import '../../../data/remote/google_drive/backup_metadata.dart';
import '../../../data/remote/google_drive/google_drive_backup_client.dart';
import '../../../data/repositories/bank_connection_repository.dart';

/// Service for creating and restoring database backups via Google Drive.
class BackupService {
  final GoogleDriveBackupClient _driveClient;
  final AppDatabase _database;
  final BankConnectionRepository _connectionRepo;

  BackupService({
    required GoogleDriveBackupClient driveClient,
    required AppDatabase database,
    required BankConnectionRepository connectionRepo,
  })  : _driveClient = driveClient,
        _database = database,
        _connectionRepo = connectionRepo;

  /// Create a backup of the current database and upload to Google Drive.
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
    final dbPath = p.join(dbFolder.path, 'patrimonium.db');

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
        fileId: '', // Set by Drive after upload
        appVersion: AppConstants.appVersion,
        schemaVersion: _database.schemaVersion,
        createdAtMs: timestamp,
        accountCount: accountCount,
        transactionCount: transactionCount,
        fileSizeBytes: await File(tempPath).length(),
      );

      // 6. Upload to Drive
      final bytes = await File(tempPath).readAsBytes();
      await _driveClient.uploadFile(
        bytes: bytes,
        fileName: 'patrimonium_$timestamp.db',
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

  /// Restore a backup from Google Drive, replacing the current database.
  ///
  /// Returns true on success. Caller must restart the app after restore.
  Future<bool> restoreBackup(String fileId) async {
    // 1. Download backup to temp location
    final tempDir = await getTemporaryDirectory();
    final tempPath = p.join(tempDir.path, 'restore_${DateTime.now().millisecondsSinceEpoch}.db');
    final bytes = await _driveClient.downloadFile(fileId);
    await File(tempPath).writeAsBytes(bytes);

    try {
      // 2. Validate: open as separate connection, check integrity
      final backupSchemaVersion = await _validateBackup(tempPath);

      // 3. Reject if backup schema is newer than current app
      if (backupSchemaVersion > _database.schemaVersion) {
        throw const BackupError(
          message: 'This backup was created with a newer version of the app. Please update the app before restoring.',
        );
      }

      // 4. Close current database
      await _database.close();

      // 5. Brief delay for isolate cleanup
      await Future.delayed(const Duration(milliseconds: 500));

      // 6. Replace DB file (also delete -wal and -shm)
      final dbFolder = await getApplicationDocumentsDirectory();
      final dbPath = p.join(dbFolder.path, 'patrimonium.db');

      for (final suffix in ['', '-wal', '-shm']) {
        final file = File('$dbPath$suffix');
        if (await file.exists()) {
          await file.delete();
        }
      }

      await File(tempPath).copy(dbPath);

      return true;
    } finally {
      // Clean up temp file
      final tempFile = File(tempPath);
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    }
  }

  /// List available backups from Google Drive, sorted newest first.
  Future<List<BackupMetadata>> listBackups() async {
    return _driveClient.listFiles();
  }

  /// Delete old backups beyond the keep threshold.
  Future<void> pruneOldBackups(int keepCount) async {
    final backups = await _driveClient.listFiles();
    if (backups.length <= keepCount) return;

    // Backups are already sorted newest first from listFiles()
    final toDelete = backups.sublist(keepCount);
    for (final backup in toDelete) {
      await _driveClient.deleteFile(backup.fileId);
    }
  }

  Future<int> _countRows(String table) async {
    final result = await _database.customSelect('SELECT COUNT(*) AS c FROM $table').getSingle();
    return result.read<int>('c');
  }

  /// Validates a backup DB file. Returns the schema version.
  /// Throws [BackupError] if corrupt.
  Future<int> _validateBackup(String path) async {
    NativeDatabase? db;
    try {
      db = NativeDatabase(File(path));
      final executor = db;
      await executor.ensureOpen(_SchemaVersionReader());
      final result = await executor.runSelect('PRAGMA integrity_check', []);
      if (result.isEmpty || result.first['integrity_check'] != 'ok') {
        throw const BackupError(
          message: 'The backup file is corrupt and cannot be restored.',
        );
      }
      final versionResult = await executor.runSelect('PRAGMA user_version', []);
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
      await db?.close();
    }
  }
}

/// Minimal OpeningDetails provider for validation reads.
class _SchemaVersionReader extends QueryExecutorUser {
  @override
  int get schemaVersion => 1; // Don't run migrations during validation

  @override
  Future<void> beforeOpen(QueryExecutor executor, OpeningDetails details) async {
    // No-op — we just want to read, not migrate
  }
}
