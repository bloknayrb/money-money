import 'dart:typed_data';

import 'backup_metadata.dart';

/// Storage key values for persisted backup destination preference.
abstract class BackupDestinationId {
  static const googleDrive = 'google_drive';
  static const local = 'local';
}

/// Abstract interface for backup storage destinations.
///
/// Implementations: [GoogleDriveBackupClient], [LocalBackupClient].
abstract class BackupDestination {
  /// User-visible name (e.g., "Google Drive", "Local Storage").
  String get displayName;

  /// Whether this destination requires sign-in before use.
  bool get requiresAuth;

  /// Whether the user is currently authenticated (always true for local).
  Future<bool> isAuthenticated();

  /// Authenticate with the destination. No-op for local.
  Future<void> signIn();

  /// Sign out from the destination. No-op for local.
  Future<void> signOut();

  /// Upload backup bytes with metadata. Returns an identifier for the backup.
  Future<String> uploadFile({
    required Uint8List bytes,
    required String fileName,
    required Map<String, dynamic> metadata,
  });

  /// List available backups, sorted newest first.
  Future<List<BackupMetadata>> listFiles();

  /// Download a backup by its identifier.
  Future<Uint8List> downloadFile(String fileId);

  /// Delete a backup by its identifier.
  Future<void> deleteFile(String fileId);
}
