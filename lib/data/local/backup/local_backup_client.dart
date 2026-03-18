import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../remote/backup/backup_destination.dart';
import '../../remote/backup/backup_metadata.dart';

/// Local file backup destination.
///
/// Stores backups in an internal `backups/` directory within the app's
/// documents folder. Each backup consists of a `.db` file and a companion
/// `.json` metadata file.
class LocalBackupClient implements BackupDestination {
  Directory? _backupDir;

  Future<Directory> _getBackupDir() async {
    if (_backupDir != null) return _backupDir!;
    final docsDir = await getApplicationDocumentsDirectory();
    _backupDir = Directory(p.join(docsDir.path, 'backups'));
    return _backupDir!;
  }

  @override
  String get displayName => 'Local Storage';

  @override
  bool get requiresAuth => false;

  @override
  Future<bool> isAuthenticated() async => true;

  @override
  Future<void> signIn() async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<String> uploadFile({
    required Uint8List bytes,
    required String fileName,
    required Map<String, dynamic> metadata,
  }) async {
    final dir = await _getBackupDir();
    await dir.create(recursive: true);

    final dbFile = File(p.join(dir.path, fileName));
    await dbFile.writeAsBytes(bytes);

    // Write companion metadata JSON
    final metaFile = File('${dbFile.path}.json');
    await metaFile.writeAsString(jsonEncode(metadata));

    return fileName;
  }

  @override
  Future<List<BackupMetadata>> listFiles() async {
    final dir = await _getBackupDir();
    if (!await dir.exists()) return [];

    final results = <BackupMetadata>[];
    await for (final entity in dir.list()) {
      if (entity is! File || !entity.path.endsWith('.db')) continue;

      final metaFile = File('${entity.path}.json');
      if (!await metaFile.exists()) continue;

      try {
        final metaJson = jsonDecode(await metaFile.readAsString()) as Map<String, dynamic>;
        final description = BackupMetadata.encodeDescription(metaJson);
        final stat = await entity.stat();
        results.add(BackupMetadata.fromDescription(
          fileId: p.basename(entity.path),
          description: description,
          fileSizeBytes: stat.size,
        ));
      } catch (_) {
        // Skip files with invalid metadata
      }
    }

    // Sort newest first
    results.sort((a, b) => b.createdAtMs.compareTo(a.createdAtMs));
    return results;
  }

  @override
  Future<Uint8List> downloadFile(String fileId) async {
    final dir = await _getBackupDir();
    final file = File(p.join(dir.path, fileId));
    return file.readAsBytes();
  }

  @override
  Future<void> deleteFile(String fileId) async {
    final dir = await _getBackupDir();
    final dbFile = File(p.join(dir.path, fileId));
    final metaFile = File('${dbFile.path}.json');
    if (await dbFile.exists()) await dbFile.delete();
    if (await metaFile.exists()) await metaFile.delete();
  }
}
