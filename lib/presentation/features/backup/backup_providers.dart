import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../data/remote/google_drive/backup_metadata.dart';

/// Available backups from Google Drive, sorted newest first.
final backupsProvider = FutureProvider.autoDispose<List<BackupMetadata>>((ref) {
  return ref.watch(backupServiceProvider).listBackups();
});

/// Whether the user is signed in to Google.
final googleSignInStatusProvider = FutureProvider.autoDispose<bool>((ref) {
  return ref.watch(googleDriveBackupClientProvider).isSignedIn();
});

/// Whether a backup or restore operation is in progress.
final backupInProgressProvider = StateProvider<bool>((ref) => false);
