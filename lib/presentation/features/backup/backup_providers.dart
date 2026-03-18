import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../data/remote/backup/backup_metadata.dart';

/// Available backups from the active destination, sorted newest first.
/// Only fetches when authenticated (avoids auth errors on screen load).
final backupsProvider = FutureProvider.autoDispose<List<BackupMetadata>>((ref) async {
  final isAuthed = await ref.watch(backupAuthStatusProvider.future);
  if (!isAuthed) return [];
  return ref.watch(backupServiceProvider).listBackups();
});

/// Whether the user is authenticated with the active backup destination.
final backupAuthStatusProvider = FutureProvider.autoDispose<bool>((ref) {
  return ref.watch(activeBackupDestinationProvider).isAuthenticated();
});

/// Whether a backup or restore operation is in progress.
final backupInProgressProvider = StateProvider<bool>((ref) => false);
