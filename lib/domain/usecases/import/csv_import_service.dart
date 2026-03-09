import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../data/local/database/app_database.dart';
import '../../../data/repositories/import_repository.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../categorize/auto_categorize_service.dart';

// =============================================================================
// DATA CLASSES
// =============================================================================

/// Configuration for CSV column mapping.
class CsvImportConfig {
  final int dateColumn;
  final int amountColumn;
  final int payeeColumn;
  final int? categoryColumn;
  final int? notesColumn;
  final String dateFormat;
  final bool hasHeader;
  final bool negativeIsExpense;

  const CsvImportConfig({
    required this.dateColumn,
    required this.amountColumn,
    required this.payeeColumn,
    this.categoryColumn,
    this.notesColumn,
    this.dateFormat = 'MM/dd/yyyy',
    this.hasHeader = true,
    this.negativeIsExpense = true,
  });
}

/// Preview of parsed data before import.
class CsvImportPreview {
  final String fileName;
  final List<String> headers;
  final List<ParsedTransaction> transactions;
  final List<ImportError> errors;
  final int totalRows;

  const CsvImportPreview({
    required this.fileName,
    required this.headers,
    required this.transactions,
    required this.errors,
    required this.totalRows,
  });

  int get validCount => transactions.where((t) => !t.isDuplicate).length;
  int get duplicateCount => transactions.where((t) => t.isDuplicate).length;
}

/// A single parsed transaction row.
class ParsedTransaction {
  final int rowNumber;
  final DateTime date;
  final int amountCents;
  final String payee;
  final String? category;
  final String? notes;
  final bool isDuplicate;
  final String externalId;

  const ParsedTransaction({
    required this.rowNumber,
    required this.date,
    required this.amountCents,
    required this.payee,
    this.category,
    this.notes,
    this.isDuplicate = false,
    required this.externalId,
  });
}

/// An error encountered while parsing a row.
class ImportError {
  final int rowNumber;
  final String message;

  const ImportError({required this.rowNumber, required this.message});
}

/// Result of executing an import.
class CsvImportResult {
  final int importedCount;
  final int skippedCount;
  final int errorCount;
  final String? errorMessage;

  const CsvImportResult({
    required this.importedCount,
    required this.skippedCount,
    required this.errorCount,
    this.errorMessage,
  });
}

/// Supported date format presets.
const dateFormats = [
  ('MM/dd/yyyy', 'MM/DD/YYYY (US)'),
  ('dd/MM/yyyy', 'DD/MM/YYYY (EU)'),
  ('yyyy-MM-dd', 'YYYY-MM-DD (ISO)'),
  ('M/d/yyyy', 'M/D/YYYY'),
  ('yyyy/MM/dd', 'YYYY/MM/DD'),
];

// =============================================================================
// SERVICE
// =============================================================================

/// Service that handles CSV parsing and import.
class CsvImportService {
  CsvImportService(
    this._transactionRepo,
    this._importRepo,
    this._autoCategorizeService,
  );

  final TransactionRepository _transactionRepo;
  final ImportRepository _importRepo;
  final AutoCategorizeService _autoCategorizeService;

  /// Parse a CSV file and return preview data.
  Future<CsvImportPreview> parseFile(
    String filePath,
    CsvImportConfig config,
  ) async {
    final file = File(filePath);
    if (!await file.exists()) {
      return CsvImportPreview(
        fileName: _fileNameFromPath(filePath),
        headers: [],
        transactions: [],
        errors: [const ImportError(rowNumber: 0, message: 'File not found')],
        totalRows: 0,
      );
    }

    final lines = await file.readAsLines(encoding: utf8);
    if (lines.isEmpty) {
      return CsvImportPreview(
        fileName: _fileNameFromPath(filePath),
        headers: [],
        transactions: [],
        errors: [const ImportError(rowNumber: 0, message: 'File is empty')],
        totalRows: 0,
      );
    }

    final rows = lines.map(_parseCsvLine).toList();
    final headers = config.hasHeader ? rows.first : <String>[];
    final dataRows = config.hasHeader ? rows.skip(1).toList() : rows;

    final transactions = <ParsedTransaction>[];
    final errors = <ImportError>[];
    final dateParser = DateFormat(config.dateFormat);

    for (var i = 0; i < dataRows.length; i++) {
      final rowNumber = config.hasHeader ? i + 2 : i + 1; // 1-indexed
      final row = dataRows[i];

      // Skip empty rows
      if (row.isEmpty || (row.length == 1 && row[0].trim().isEmpty)) continue;

      // Validate column count
      final maxCol = [
        config.dateColumn,
        config.amountColumn,
        config.payeeColumn,
        if (config.categoryColumn != null) config.categoryColumn!,
        if (config.notesColumn != null) config.notesColumn!,
      ].reduce((a, b) => a > b ? a : b);

      if (row.length <= maxCol) {
        errors.add(ImportError(
          rowNumber: rowNumber,
          message: 'Row has ${row.length} columns, expected at least ${maxCol + 1}',
        ));
        continue;
      }

      // Parse date
      final dateStr = row[config.dateColumn].trim();
      DateTime date;
      try {
        date = dateParser.parseStrict(dateStr);
      } catch (_) {
        errors.add(ImportError(
          rowNumber: rowNumber,
          message: 'Invalid date: "$dateStr"',
        ));
        continue;
      }

      // Parse amount
      final amountStr = row[config.amountColumn].trim();
      final amountCents = _parseAmountToCents(amountStr);
      if (amountCents == null) {
        errors.add(ImportError(
          rowNumber: rowNumber,
          message: 'Invalid amount: "$amountStr"',
        ));
        continue;
      }

      // Parse payee
      final payee = row[config.payeeColumn].trim();
      if (payee.isEmpty) {
        errors.add(ImportError(
          rowNumber: rowNumber,
          message: 'Payee is empty',
        ));
        continue;
      }

      // Optional fields
      final category = config.categoryColumn != null && row.length > config.categoryColumn!
          ? row[config.categoryColumn!].trim()
          : null;
      final notes = config.notesColumn != null && row.length > config.notesColumn!
          ? row[config.notesColumn!].trim()
          : null;

      // Apply sign convention
      final signedCents = config.negativeIsExpense ? amountCents : -amountCents;

      // Generate external ID for duplicate detection
      final externalId = _generateExternalId(date, signedCents, payee);
      final isDuplicate = await _transactionRepo.existsByExternalId(externalId);

      transactions.add(ParsedTransaction(
        rowNumber: rowNumber,
        date: date,
        amountCents: signedCents,
        payee: payee,
        category: category?.isNotEmpty == true ? category : null,
        notes: notes?.isNotEmpty == true ? notes : null,
        isDuplicate: isDuplicate,
        externalId: externalId,
      ));
    }

    return CsvImportPreview(
      fileName: _fileNameFromPath(filePath),
      headers: headers,
      transactions: transactions,
      errors: errors,
      totalRows: dataRows.length,
    );
  }

  /// Execute the import with the validated preview.
  Future<CsvImportResult> executeImport(
    CsvImportPreview preview,
    String accountId,
  ) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final uuid = const Uuid();

    final toInsert = <TransactionsCompanion>[];
    var skippedCount = 0;

    for (final t in preview.transactions) {
      if (t.isDuplicate) {
        skippedCount++;
        continue;
      }

      // Fuzzy dedup: catch duplicates from other sources (e.g. SimpleFIN)
      final fuzzyMatch = await _transactionRepo.existsByFuzzyMatch(
        accountId, t.date.millisecondsSinceEpoch, t.amountCents,
      );
      if (fuzzyMatch) {
        skippedCount++;
        continue;
      }

      toInsert.add(TransactionsCompanion.insert(
        id: uuid.v4(),
        accountId: accountId,
        amountCents: t.amountCents,
        date: t.date.millisecondsSinceEpoch,
        payee: t.payee,
        notes: t.notes != null ? Value(t.notes) : const Value(null),
        categoryId: const Value(null),
        externalId: Value(t.externalId),
        createdAt: now,
        updatedAt: now,
      ));
    }

    String? errorMessage;
    var importedCount = 0;
    String status = 'completed';

    try {
      if (toInsert.isNotEmpty) {
        await _transactionRepo.insertTransactions(toInsert);

        // Auto-categorize imported transactions
        for (final companion in toInsert) {
          final categoryId = await _autoCategorizeService.categorize(
            companion.payee.value,
            amountCents: companion.amountCents.value,
            accountId: accountId,
          );
          if (categoryId != null) {
            await _transactionRepo.updateCategory(
              companion.id.value,
              categoryId,
            );
          }
        }
      }
      importedCount = toInsert.length;
    } catch (e) {
      errorMessage = e.toString();
      status = 'failed';
    }

    if (importedCount > 0 && preview.errors.isNotEmpty) {
      status = 'partial';
    }

    // Record in import history
    await _importRepo.insertImportRecord(ImportHistoryCompanion.insert(
      id: uuid.v4(),
      source: 'csv',
      fileName: preview.fileName,
      rowCount: preview.totalRows,
      importedCount: importedCount,
      skippedCount: skippedCount,
      status: status,
      errorMessage: errorMessage != null ? Value(errorMessage) : const Value(null),
      createdAt: now,
    ));

    return CsvImportResult(
      importedCount: importedCount,
      skippedCount: skippedCount,
      errorCount: preview.errors.length,
      errorMessage: errorMessage,
    );
  }

  /// Parse a CSV line, handling quoted fields.
  List<String> _parseCsvLine(String line) {
    final fields = <String>[];
    final buffer = StringBuffer();
    var inQuotes = false;

    for (var i = 0; i < line.length; i++) {
      final char = line[i];
      if (inQuotes) {
        if (char == '"') {
          if (i + 1 < line.length && line[i + 1] == '"') {
            buffer.write('"');
            i++; // skip escaped quote
          } else {
            inQuotes = false;
          }
        } else {
          buffer.write(char);
        }
      } else {
        if (char == '"') {
          inQuotes = true;
        } else if (char == ',') {
          fields.add(buffer.toString());
          buffer.clear();
        } else {
          buffer.write(char);
        }
      }
    }
    fields.add(buffer.toString());
    return fields;
  }

  /// Parse an amount string to cents. Returns null if unparseable.
  int? _parseAmountToCents(String raw) {
    // Strip currency symbols, whitespace, and thousand separators
    final cleaned = raw.replaceAll(RegExp(r'[^\d.\-]'), '');
    if (cleaned.isEmpty) return null;
    try {
      final dollars = double.parse(cleaned);
      return (dollars * 100).round();
    } catch (_) {
      return null;
    }
  }

  /// Generate a deterministic external ID from transaction data.
  String _generateExternalId(DateTime date, int amountCents, String payee) {
    final input = '${date.toIso8601String()}|$amountCents|${payee.toLowerCase().trim()}';
    final hash = sha256.convert(utf8.encode(input));
    return 'csv_${hash.toString().substring(0, 16)}';
  }

  String _fileNameFromPath(String path) {
    return path.split('/').last.split('\\').last;
  }
}
