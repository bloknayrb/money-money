import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/category_icons.dart';
import '../../../../core/extensions/money_extensions.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/local/database/models.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final Category? category;
  final String? accountName;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.category,
    this.accountName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final finance = theme.finance;
    final isIncome = transaction.amountCents > 0;

    final iconData = category != null
        ? categoryIconMap[category!.icon] ?? Icons.category
        : Icons.help_outline;
    final iconColor = category != null
        ? Color(category!.color)
        : colorScheme.onSurfaceVariant;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: category != null
            ? iconColor.withValues(alpha: 0.15)
            : colorScheme.surfaceContainerHighest,
        child: Icon(iconData, color: iconColor, size: 20),
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
          category?.name ?? (transaction.categoryId == null ? 'Uncategorized' : ''),
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
