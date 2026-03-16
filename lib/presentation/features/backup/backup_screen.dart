import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/di/providers.dart';
import '../../../core/platform/app_restart.dart';
import '../../../data/remote/google_drive/backup_metadata.dart';
import 'backup_providers.dart';

/// Screen for managing Google Drive backups.
class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  @override
  Widget build(BuildContext context) {
    if (!Platform.isAndroid) {
      return Scaffold(
        appBar: AppBar(title: const Text('Backup & Restore')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Google Drive backup is only available on Android.\n\n'
              'On Linux, you can manually copy the database file from your application data directory.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final signedIn = ref.watch(googleSignInStatusProvider);
    final backups = ref.watch(backupsProvider);
    final inProgress = ref.watch(backupInProgressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Backup & Restore')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sign-in status card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: signedIn.when(
                data: (isSignedIn) => Row(
                  children: [
                    Icon(
                      isSignedIn ? Icons.cloud_done : Icons.cloud_off,
                      color: isSignedIn
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isSignedIn
                            ? 'Connected to Google Drive'
                            : 'Not connected to Google Drive',
                      ),
                    ),
                    FilledButton.tonal(
                      onPressed: inProgress ? null : () => _toggleSignIn(isSignedIn),
                      child: Text(isSignedIn ? 'Sign Out' : 'Sign In'),
                    ),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error: $e'),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Backup Now button
          FilledButton.icon(
            onPressed: (signedIn.valueOrNull == true && !inProgress)
                ? _createBackup
                : null,
            icon: inProgress
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.backup),
            label: Text(inProgress ? 'Backing up...' : 'Backup Now'),
          ),

          const SizedBox(height: 24),

          // Backups list
          Text(
            'Available Backups',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),

          backups.when(
            data: (list) {
              if (list.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: Text('No backups yet')),
                );
              }
              return Column(
                children: list.map((b) => _BackupTile(
                  backup: b,
                  onRestore: inProgress ? null : () => _confirmRestore(b),
                )).toList(),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Failed to load backups: $e'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleSignIn(bool isSignedIn) async {
    final client = ref.read(googleDriveBackupClientProvider);
    try {
      if (isSignedIn) {
        await client.signOut();
      } else {
        await client.signIn();
      }
      ref.invalidate(googleSignInStatusProvider);
      ref.invalidate(backupsProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-in failed: $e')),
        );
      }
    }
  }

  Future<void> _createBackup() async {
    ref.read(backupInProgressProvider.notifier).state = true;
    try {
      await ref.read(backupServiceProvider).createBackup();
      ref.invalidate(backupsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup created successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Backup failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      ref.read(backupInProgressProvider.notifier).state = false;
    }
  }

  Future<void> _confirmRestore(BackupMetadata backup) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Backup?'),
        content: const Text(
          'Restoring will replace ALL current data.\n\n'
          'You will need to:\n'
          '  - Re-set up your PIN\n'
          '  - Re-enter API keys\n'
          '  - Re-claim SimpleFIN token\n'
          '  - Re-enable biometrics\n\n'
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    ref.read(backupInProgressProvider.notifier).state = true;
    try {
      final success = await ref.read(backupServiceProvider).restoreBackup(backup.fileId);
      if (!success || !mounted) return;

      final restarted = await restartApp();
      if (!restarted && mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            title: Text('Restore Complete'),
            content: Text('Please close and reopen the app to use the restored data.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Restore failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      ref.read(backupInProgressProvider.notifier).state = false;
    }
  }
}

class _BackupTile extends StatelessWidget {
  final BackupMetadata backup;
  final VoidCallback? onRestore;

  const _BackupTile({required this.backup, this.onRestore});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(backup.createdAtMs);
    final dateStr = DateFormat.yMMMd().add_jm().format(date);
    final sizeStr = _formatBytes(backup.fileSizeBytes);

    return Card(
      child: ListTile(
        leading: const Icon(Icons.cloud_download),
        title: Text(dateStr),
        subtitle: Text(
          'v${backup.appVersion} | '
          '${backup.accountCount} accounts, '
          '${backup.transactionCount} transactions | '
          '$sizeStr',
        ),
        trailing: TextButton(
          onPressed: onRestore,
          child: const Text('Restore'),
        ),
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
