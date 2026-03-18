import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/di/providers.dart';
import '../../../core/platform/app_restart.dart';
import '../../../data/remote/backup/backup_destination.dart';
import '../../../data/remote/backup/backup_metadata.dart';
import 'backup_providers.dart';

/// Screen for managing database backups.
class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _prefLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadDestinationPreference();
  }

  Future<void> _loadDestinationPreference() async {
    final storage = ref.read(secureStorageProvider);
    final pref = await storage.getBackupDestination();
    if (!mounted) return;
    final useLocal = pref == BackupDestinationId.local || !Platform.isAndroid;
    ref.read(activeBackupDestinationProvider.notifier).state =
        useLocal
            ? ref.read(localBackupClientProvider)
            : ref.read(googleDriveBackupClientProvider);
    setState(() => _prefLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_prefLoaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Backup & Restore')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final destination = ref.watch(activeBackupDestinationProvider);
    final authStatus = ref.watch(backupAuthStatusProvider);
    final backups = ref.watch(backupsProvider);
    final inProgress = ref.watch(backupInProgressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Backup & Restore')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Destination picker
          _DestinationPicker(
            isGoogleDrive: destination == ref.read(googleDriveBackupClientProvider),
            onChanged: (useGoogleDrive) {
              ref.read(activeBackupDestinationProvider.notifier).state =
                  useGoogleDrive
                      ? ref.read(googleDriveBackupClientProvider)
                      : ref.read(localBackupClientProvider);
              ref.read(secureStorageProvider).setBackupDestination(
                  useGoogleDrive ? BackupDestinationId.googleDrive : BackupDestinationId.local);
              ref.invalidate(backupsProvider);
              ref.invalidate(backupAuthStatusProvider);
            },
          ),

          const SizedBox(height: 16),

          // Auth card (only for destinations that require it)
          if (destination.requiresAuth) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: authStatus.when(
                  data: (isAuthed) => Row(
                    children: [
                      Icon(
                        isAuthed ? Icons.cloud_done : Icons.cloud_off,
                        color: isAuthed
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isAuthed
                              ? 'Connected to ${destination.displayName}'
                              : 'Not connected to ${destination.displayName}',
                        ),
                      ),
                      FilledButton.tonal(
                        onPressed: inProgress ? null : () => _toggleAuth(isAuthed),
                        child: Text(isAuthed ? 'Sign Out' : 'Sign In'),
                      ),
                    ],
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error: $e'),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Action buttons
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: (authStatus.valueOrNull == true && !inProgress)
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
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: inProgress ? null : _importFromFile,
                icon: const Icon(Icons.file_open),
                label: const Text('Import File'),
              ),
            ],
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

  Future<void> _toggleAuth(bool isAuthed) async {
    final destination = ref.read(activeBackupDestinationProvider);
    try {
      if (isAuthed) {
        await destination.signOut();
      } else {
        await destination.signIn();
      }
      ref.invalidate(backupAuthStatusProvider);
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

  Future<void> _importFromFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result == null) return;

    final file = result.files.single;
    if (!file.name.endsWith('.db')) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a .db backup file')),
        );
      }
      return;
    }

    final path = file.path;
    if (path == null) return;

    final confirmed = await _showRestoreConfirmDialog();
    if (confirmed != true) return;

    ref.read(backupInProgressProvider.notifier).state = true;
    try {
      final bytes = await File(path).readAsBytes();
      final success = await ref.read(backupServiceProvider).restoreFromBytes(bytes);
      if (!success || !mounted) return;

      final restarted = await restartApp();
      if (!restarted && mounted) {
        _showManualRestartDialog();
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

  Future<void> _confirmRestore(BackupMetadata backup) async {
    final confirmed = await _showRestoreConfirmDialog();
    if (confirmed != true) return;

    ref.read(backupInProgressProvider.notifier).state = true;
    try {
      final success = await ref.read(backupServiceProvider).restoreBackup(backup.fileId);
      if (!success || !mounted) return;

      final restarted = await restartApp();
      if (!restarted && mounted) {
        _showManualRestartDialog();
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

  Future<bool?> _showRestoreConfirmDialog() {
    return showDialog<bool>(
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
  }

  void _showManualRestartDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        title: Text('Restore Complete'),
        content: Text('Please close and reopen the app to use the restored data.'),
      ),
    );
  }
}

class _DestinationPicker extends StatelessWidget {
  final bool isGoogleDrive;
  final ValueChanged<bool> onChanged;

  const _DestinationPicker({required this.isGoogleDrive, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<bool>(
      segments: [
        ButtonSegment<bool>(
          value: true,
          label: const Text('Google Drive'),
          icon: const Icon(Icons.cloud),
          enabled: Platform.isAndroid,
        ),
        const ButtonSegment<bool>(
          value: false,
          label: Text('Local'),
          icon: Icon(Icons.phone_android),
        ),
      ],
      selected: {isGoogleDrive},
      onSelectionChanged: (selected) => onChanged(selected.first),
    );
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
