import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/di/providers.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';

/// Settings screen with app configuration sections.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeMode = ref.watch(appThemeModeProvider);
    final biometricAvailable = ref.watch(biometricAvailableProvider);
    final biometricEnabled = ref.watch(biometricEnabledProvider);
    final autoLockTimeout = ref.watch(autoLockTimeoutProvider);
    final bankConnections = ref.watch(bankConnectionsStreamProvider);
    final autoSyncEnabled = ref.watch(autoSyncEnabledProvider);
    final activeLlmProvider = ref.watch(activeLlmProviderNameProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // AI Configuration
          const _SectionHeader(title: 'AI Assistant'),
          ListTile(
            leading: const Icon(Icons.smart_toy),
            title: const Text('LLM Provider'),
            subtitle: Text(
              activeLlmProvider.valueOrNull != null
                  ? 'Active: ${activeLlmProvider.value!}'
                  : 'Configure Claude, OpenAI, Gemini, or Ollama',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.llmSettings),
          ),

          const Divider(),

          // Bank Connections
          const _SectionHeader(title: 'Bank Connections'),
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text('Connected Accounts'),
            subtitle: const Text('Manage bank connections'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push(AppRoutes.bankConnections);
            },
          ),

          // Auto-sync toggle — only shown when connections exist
          if ((bankConnections.valueOrNull ?? []).isNotEmpty)
            SwitchListTile(
              secondary: const Icon(Icons.sync),
              title: const Text('Auto Sync'),
              subtitle: Text(
                autoSyncEnabled.valueOrNull == true
                    ? 'Sync bank accounts every 8 hours'
                    : 'Disabled',
              ),
              value: autoSyncEnabled.valueOrNull ?? false,
              onChanged: (value) async {
                final storage = ref.read(secureStorageProvider);
                await storage.setAutoSyncEnabled(value);
                ref.invalidate(autoSyncEnabledProvider);

                final syncManager = ref.read(backgroundSyncManagerProvider);
                if (value) {
                  await syncManager.register(syncCallback: () async {});
                } else {
                  await syncManager.cancel();
                }
              },
            ),

          const Divider(),

          // Financial Planning
          const _SectionHeader(title: 'Financial Planning'),
          ListTile(
            leading: const Icon(Icons.pie_chart_outline),
            title: const Text('Budgets'),
            subtitle: const Text('Track spending by category'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.budgets),
          ),
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: const Text('Goals'),
            subtitle: const Text('Savings and debt payoff targets'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.goals),
          ),
          ListTile(
            leading: const Icon(Icons.repeat),
            title: const Text('Recurring Transactions'),
            subtitle: const Text('Subscriptions and regular payments'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.recurring),
          ),

          const Divider(),

          // Categories
          const _SectionHeader(title: 'Categories & Rules'),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categories'),
            subtitle: const Text('Manage income and expense categories'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showComingSoon(context, 'Category management');
            },
          ),
          ListTile(
            leading: const Icon(Icons.rule),
            title: const Text('Auto-Categorization Rules'),
            subtitle: const Text('Rules for automatic transaction categorization'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.autoCategorizeRules),
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Import Category Rules'),
            subtitle: const Text('Bulk-add rules from a CSV file'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.importRules),
          ),

          const Divider(),

          // Security
          const _SectionHeader(title: 'Security'),

          // Biometric toggle - only show if device supports it
          if (biometricAvailable.valueOrNull == true)
            ListTile(
              leading: const Icon(Icons.fingerprint),
              title: const Text('Biometric Authentication'),
              subtitle: const Text('Use fingerprint or face to unlock'),
              trailing: Switch(
                value: biometricEnabled.valueOrNull ?? false,
                onChanged: (value) async {
                  final biometricService = ref.read(biometricServiceProvider);
                  if (value) {
                    // Verify biometric works before enabling
                    final success = await biometricService.verifyAndEnable();
                    if (!success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Biometric authentication failed. Please try again.'),
                        ),
                      );
                    }
                  } else {
                    await biometricService.setEnabled(false);
                  }
                  ref.invalidate(biometricEnabledProvider);
                },
              ),
            ),

          ListTile(
            leading: const Icon(Icons.pin),
            title: const Text('Change PIN'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push(AppRoutes.pinChange);
            },
          ),

          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Auto-Lock Timeout'),
            subtitle: Text(_formatTimeout(autoLockTimeout.valueOrNull ?? 300)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showTimeoutPicker(context, ref,
                autoLockTimeout.valueOrNull ?? 300),
          ),

          const Divider(),

          // Appearance
          const _SectionHeader(title: 'Appearance'),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Theme'),
            trailing: SegmentedButton<AppThemeMode>(
              segments: const [
                ButtonSegment(
                  value: AppThemeMode.system,
                  icon: Icon(Icons.brightness_auto),
                ),
                ButtonSegment(
                  value: AppThemeMode.light,
                  icon: Icon(Icons.light_mode),
                ),
                ButtonSegment(
                  value: AppThemeMode.dark,
                  icon: Icon(Icons.dark_mode),
                ),
                ButtonSegment(
                  value: AppThemeMode.amoledBlack,
                  icon: Icon(Icons.nightlight_round),
                ),
              ],
              selected: {appThemeMode},
              onSelectionChanged: (modes) {
                final mode = modes.first;
                ref.read(appThemeModeProvider.notifier).state = mode;
                ref.read(secureStorageProvider).setThemeMode(mode.name);
              },
            ),
          ),

          const Divider(),

          // Data
          const _SectionHeader(title: 'Data'),
          ListTile(
            leading: const Icon(Icons.file_upload),
            title: const Text('Import Data'),
            subtitle: const Text('CSV, Mint, YNAB, Monarch'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.csvImport),
          ),
          ListTile(
            leading: const Icon(Icons.file_download),
            title: const Text('Export Data'),
            subtitle: const Text('Export accounts & transactions to CSV'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _exportData(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('Cloud Sync'),
            subtitle: const Text('Supabase backup'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showComingSoon(context, 'Cloud sync');
            },
          ),

          const Divider(),

          // About
          const _SectionHeader(title: 'About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text(AppConstants.appName),
            subtitle: Text('Version ${AppConstants.appVersion}'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Licenses'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: AppConstants.appName,
                applicationVersion: AppConstants.appVersion,
              );
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature coming soon.')),
    );
  }

  String _formatTimeout(int seconds) {
    if (seconds < 60) return '$seconds seconds';
    final minutes = seconds ~/ 60;
    if (minutes == 1) return '1 minute';
    return '$minutes minutes';
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    final exportService = ref.read(csvExportServiceProvider);

    // Show a loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final exportDir = await exportService.exportAll();
      if (context.mounted) {
        Navigator.of(context).pop(); // dismiss loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exported to: $exportDir'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // dismiss loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _showTimeoutPicker(BuildContext context, WidgetRef ref, int current) {
    final options = [
      (30, '30 seconds'),
      (60, '1 minute'),
      (120, '2 minutes'),
      (300, '5 minutes'),
      (600, '10 minutes'),
      (900, '15 minutes'),
      (1800, '30 minutes'),
    ];

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Auto-Lock Timeout'),
        children: options.map((option) {
          final (seconds, label) = option;
          return SimpleDialogOption(
            onPressed: () async {
              final storage = ref.read(secureStorageProvider);
              await storage.setAutoLockTimeoutSeconds(seconds);
              ref.invalidate(autoLockTimeoutProvider);
              if (context.mounted) Navigator.of(context).pop();
            },
            child: Row(
              children: [
                if (seconds == current)
                  Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                else
                  const SizedBox(width: 24),
                const SizedBox(width: 12),
                Text(label),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
