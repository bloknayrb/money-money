import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../../core/extensions/money_extensions.dart';
import '../../../data/repositories/account_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/transaction_repository.dart';

/// Service for exporting app data to CSV files.
class CsvExportService {
  CsvExportService({
    required this.accountRepo,
    required this.transactionRepo,
    required this.categoryRepo,
  });

  final AccountRepository accountRepo;
  final TransactionRepository transactionRepo;
  final CategoryRepository categoryRepo;

  /// Export all data to CSV files in a timestamped directory.
  ///
  /// Returns the path to the export directory containing the CSV files.
  Future<String> exportAll() async {
    final dir = await _createExportDir();

    await Future.wait([
      _exportAccounts(dir),
      _exportTransactions(dir),
    ]);

    return dir.path;
  }

  /// Export accounts only and return the file path.
  Future<String> exportAccounts() async {
    final dir = await _createExportDir();
    final file = await _exportAccounts(dir);
    return file.path;
  }

  /// Export transactions only and return the file path.
  Future<String> exportTransactions() async {
    final dir = await _createExportDir();
    final file = await _exportTransactions(dir);
    return file.path;
  }

  Future<Directory> _createExportDir() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyy-MM-dd_HHmmss').format(DateTime.now());
    final exportDir = Directory(
      p.join(docsDir.path, 'patrimonium_export_$timestamp'),
    );
    await exportDir.create(recursive: true);
    return exportDir;
  }

  Future<File> _exportAccounts(Directory dir) async {
    final accounts = await accountRepo.getAllAccounts();

    final buffer = StringBuffer();
    // Header
    buffer.writeln(
      _csvRow([
        'Name',
        'Institution',
        'Type',
        'Balance',
        'Asset/Liability',
        'Created',
        'Updated',
      ]),
    );

    // Data rows
    for (final a in accounts) {
      buffer.writeln(
        _csvRow([
          a.name,
          a.institutionName ?? '',
          a.accountType,
          a.balanceCents.toCurrencyValue(),
          a.isAsset ? 'Asset' : 'Liability',
          _formatDate(a.createdAt),
          _formatDate(a.updatedAt),
        ]),
      );
    }

    final file = File(p.join(dir.path, 'accounts.csv'));
    await file.writeAsString(buffer.toString());
    return file;
  }

  Future<File> _exportTransactions(Directory dir) async {
    final transactions = await transactionRepo.getAllTransactions();
    final accounts = await accountRepo.getAllAccounts();
    final categories = await categoryRepo.getAllCategories();

    // Build lookup maps
    final accountNames = {for (final a in accounts) a.id: a.name};
    final categoryNames = {for (final c in categories) c.id: c.name};

    final buffer = StringBuffer();
    // Header
    buffer.writeln(
      _csvRow([
        'Date',
        'Payee',
        'Amount',
        'Type',
        'Category',
        'Account',
        'Notes',
        'Tags',
        'Pending',
        'Reviewed',
      ]),
    );

    // Data rows
    for (final t in transactions) {
      buffer.writeln(
        _csvRow([
          _formatDate(t.date),
          t.payee,
          t.amountCents.toCurrencyValue(),
          t.amountCents >= 0 ? 'Income' : 'Expense',
          t.categoryId != null
              ? (categoryNames[t.categoryId] ?? 'Unknown')
              : 'Uncategorized',
          accountNames[t.accountId] ?? 'Unknown',
          t.notes ?? '',
          t.tags ?? '',
          t.isPending ? 'Yes' : 'No',
          t.isReviewed ? 'Yes' : 'No',
        ]),
      );
    }

    final file = File(p.join(dir.path, 'transactions.csv'));
    await file.writeAsString(buffer.toString());
    return file;
  }

  /// Format a value as a proper CSV cell, escaping quotes and commas.
  String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  /// Join values into a CSV row.
  String _csvRow(List<String> values) {
    return values.map(_escapeCsv).join(',');
  }

  /// Format Unix milliseconds as ISO date string.
  String _formatDate(int unixMs) {
    final dt = DateTime.fromMillisecondsSinceEpoch(unixMs);
    return DateFormat('yyyy-MM-dd').format(dt);
  }
}
