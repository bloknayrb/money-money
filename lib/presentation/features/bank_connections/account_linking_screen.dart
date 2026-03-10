import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/account_types.dart';
import '../../../core/di/providers.dart';
import '../../../data/local/database/app_database.dart';
import '../../../data/remote/simplefin/simplefin_models.dart';
import 'bank_connections_providers.dart';
import 'widgets/account_link_card.dart';

const _uuid = Uuid();

/// Screen for linking discovered SimpleFIN accounts to local accounts.
class AccountLinkingScreen extends ConsumerStatefulWidget {
  const AccountLinkingScreen({super.key, required this.connectionId});

  final String connectionId;

  @override
  ConsumerState<AccountLinkingScreen> createState() =>
      _AccountLinkingScreenState();
}

class _AccountLinkingScreenState extends ConsumerState<AccountLinkingScreen> {
  List<SimplefinAccount>? _discoveredAccounts;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  final Map<String, AccountLinkChoice> _choices = {};
  final Map<String, String> _selectedAccountTypes = {};

  @override
  void initState() {
    super.initState();
    _fetchAccounts();
  }

  Future<void> _fetchAccounts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final tokenString = await ref.read(secureStorageProvider).getSimplefinToken();
      if (tokenString == null) {
        setState(() {
          _errorMessage = 'No SimpleFIN credentials found.';
          _isLoading = false;
        });
        return;
      }

      final response = await ref.read(simplefinClientProvider).getAccounts(
            SimplefinAccessUrl.parse(tokenString), balancesOnly: true);

      setState(() {
        _discoveredAccounts = response.accounts;
        for (final account in response.accounts) {
          _choices[account.id] = const AccountLinkChoice(LinkAction.createNew);
          _selectedAccountTypes[account.id] =
              account.balanceCents < 0 ? 'credit_card' : 'checking';
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch accounts. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<void> _save() async {
    if (_discoveredAccounts == null) return;
    setState(() => _isSaving = true);

    try {
      // Check for potential duplicates on existing account links
      final txnRepo = ref.read(transactionRepositoryProvider);
      final linkedWithTxns = <String, int>{};
      for (final sfAccount in _discoveredAccounts!) {
        final choice = _choices[sfAccount.id];
        if (choice?.action == LinkAction.linkExisting &&
            choice?.existingAccountId != null) {
          final count = await txnRepo
              .getTransactionCountForAccount(choice!.existingAccountId!);
          if (count > 0) {
            linkedWithTxns[sfAccount.name] = count;
          }
        }
      }

      if (linkedWithTxns.isNotEmpty && mounted) {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Existing Transactions Found'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'The following accounts have existing transactions. '
                  'The first sync will use fuzzy matching to skip duplicates, '
                  'but some may still be duplicated.',
                ),
                const SizedBox(height: 12),
                ...linkedWithTxns.entries.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '\u2022 ${e.key}: ${e.value} transactions',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Continue'),
              ),
            ],
          ),
        );
        if (confirmed != true) {
          setState(() => _isSaving = false);
          return;
        }
      }

      final db = ref.read(databaseProvider);
      final accountRepo = ref.read(accountRepositoryProvider);
      final existingCount = await accountRepo.getAccountCount();
      var displayOrder = existingCount;
      var linkedCount = 0;

      await db.transaction(() async {
        for (final sfAccount in _discoveredAccounts!) {
          final choice = _choices[sfAccount.id];
          if (choice == null || choice.action == LinkAction.skip) continue;

          if (choice.action == LinkAction.createNew) {
            final now = DateTime.now().millisecondsSinceEpoch;
            final selectedType = _selectedAccountTypes[sfAccount.id] ?? 'checking';
            await accountRepo.insertAccount(AccountsCompanion.insert(
              id: _uuid.v4(),
              name: sfAccount.name,
              institutionName: Value(sfAccount.orgName ?? sfAccount.orgDomain),
              accountType: selectedType,
              balanceCents: sfAccount.balanceCents,
              isAsset: isAccountTypeAsset(selectedType),
              displayOrder: displayOrder++,
              bankConnectionId: Value(widget.connectionId),
              externalId: Value(sfAccount.id),
              createdAt: now,
              updatedAt: now,
            ));
            linkedCount++;
          } else if (choice.action == LinkAction.linkExisting &&
              choice.existingAccountId != null) {
            await accountRepo.linkToBank(
              choice.existingAccountId!,
              widget.connectionId,
              sfAccount.id,
            );
            linkedCount++;
          }
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$linkedCount account(s) linked.')));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to link accounts. No changes were saved.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final unlinkedAccounts = ref.watch(unlinkedAccountsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Link Accounts')),
      body: _buildBody(unlinkedAccounts),
      bottomNavigationBar: _discoveredAccounts != null
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Save'),
                ),
              ))
          : null,
    );
  }

  Widget _buildBody(AsyncValue<List<Account>> unlinkedAccounts) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: _fetchAccounts, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (_discoveredAccounts == null || _discoveredAccounts!.isEmpty) {
      return const Center(child: Text('No accounts found.'));
    }
    final existingAccounts = unlinkedAccounts.valueOrNull ?? [];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _discoveredAccounts!.length,
      itemBuilder: (context, index) {
        final account = _discoveredAccounts![index];
        return AccountLinkCard(
          sfAccount: account,
          choice: _choices[account.id] ?? const AccountLinkChoice(LinkAction.createNew),
          existingAccounts: existingAccounts,
          selectedAccountType: _selectedAccountTypes[account.id] ?? 'checking',
          onChoiceChanged: (choice) => setState(() => _choices[account.id] = choice),
          onAccountTypeChanged: (type) => setState(() => _selectedAccountTypes[account.id] = type),
        );
      },
    );
  }
}
