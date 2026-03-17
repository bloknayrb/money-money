import 'package:flutter/material.dart';

import '../../../../domain/usecases/sync/sync_models.dart';

/// Shows per-account sync diagnostics after a bank sync.
class SyncResultDialog extends StatelessWidget {
  final int accountsUpdated;
  final int transactionsImported;
  final String? warning;
  final List<AccountSyncDetail> accountDetails;

  const SyncResultDialog({
    super.key,
    required this.accountsUpdated,
    required this.transactionsImported,
    this.warning,
    required this.accountDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasUnlinked = accountDetails.any((d) => !d.linked);

    return AlertDialog(
      title: const Text('Sync Complete'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Synced $accountsUpdated account${accountsUpdated == 1 ? '' : 's'}, '
              '$transactionsImported new transaction${transactionsImported == 1 ? '' : 's'}',
              style: theme.textTheme.bodyMedium,
            ),
            if (warning != null) ...[
              const SizedBox(height: 8),
              Text(
                warning!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ],
            if (hasUnlinked) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: colorScheme.onErrorContainer, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Some SimpleFIN accounts are not linked — '
                        'their transactions are being skipped.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (accountDetails.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Per-Account Breakdown',
                  style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              for (final detail in accountDetails)
                _AccountDetailRow(detail: detail),
            ],
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class _AccountDetailRow extends StatelessWidget {
  final AccountSyncDetail detail;

  const _AccountDetailRow({required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: detail.linked
              ? colorScheme.surfaceContainerHighest
              : colorScheme.errorContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  detail.linked ? Icons.link : Icons.link_off,
                  size: 16,
                  color: detail.linked
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.error,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    detail.localAccountName ?? detail.sfAccountName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (detail.linked)
              Text(
                _linkedSummary(detail),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            else
              Text(
                'Not linked — ${detail.received} transactions skipped',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _linkedSummary(AccountSyncDetail d) {
    final parts = <String>[];
    parts.add('${d.received} received');
    if (d.imported > 0) parts.add('${d.imported} new');
    if (d.skippedKnown > 0) parts.add('${d.skippedKnown} known');
    if (d.pendingPosted > 0) parts.add('${d.pendingPosted} posted');
    if (d.skippedFuzzy > 0) parts.add('${d.skippedFuzzy} fuzzy-skipped');
    return parts.join(', ');
  }
}
