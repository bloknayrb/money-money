import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/money_extensions.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/local/database/models.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final String? categoryName;
  final String? accountName;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.categoryName,
    this.accountName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final finance = theme.finance;
    final isIncome = transaction.amountCents > 0;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isIncome
            ? finance.income.withValues(alpha: 0.15)
            : colorScheme.errorContainer,
        child: Icon(
          isIncome ? Icons.arrow_downward : Icons.arrow_upward,
          color: isIncome ? finance.income : colorScheme.error,
          size: 20,
        ),
      ),
      title: Text(
        transaction.payee,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        <String>[
          ?accountName,
          categoryName ?? (transaction.categoryId == null ? 'Uncategorized' : ''),
        ].where((s) => s.isNotEmpty).join(' · '),
        style: theme.textTheme.bodySmall?.copyWith(
          color: transaction.categoryId == null
              ? colorScheme.error.withValues(alpha: 0.7)
              : colorScheme.onSurfaceVariant,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            transaction.amountCents.toCurrency(),
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: isIncome ? finance.income : colorScheme.onSurface,
            ),
          ),
          if (transaction.isPending)
            Text(
              'Pending',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
      onTap: () {
        context.push(AppRoutes.editTransaction, extra: transaction);
      },
    );
  }
}
