import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moneymoney/data/local/database/app_database.dart';
import 'package:moneymoney/data/repositories/import_repository.dart';
import 'package:moneymoney/data/repositories/transaction_repository.dart';
import 'package:moneymoney/domain/usecases/categorize/auto_categorize_service.dart';
import 'package:moneymoney/domain/usecases/import/csv_import_service.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockImportRepository extends Mock implements ImportRepository {}

class MockAutoCategorizeService extends Mock implements AutoCategorizeService {}

void main() {
  late MockTransactionRepository mockTxnRepo;
  late MockImportRepository mockImportRepo;
  late MockAutoCategorizeService mockAutoCatService;
  late CsvImportService service;
  late Directory tempDir;

  setUp(() {
    mockTxnRepo = MockTransactionRepository();
    mockImportRepo = MockImportRepository();
    mockAutoCatService = MockAutoCategorizeService();
    service = CsvImportService(mockTxnRepo, mockImportRepo, mockAutoCatService);
    tempDir = Directory.systemTemp.createTempSync('csv_import_test_');
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  setUpAll(() {
    registerFallbackValue(const TransactionsCompanion());
    registerFallbackValue(ImportHistoryCompanion.insert(
      id: '',
      source: '',
      fileName: '',
      rowCount: 0,
      importedCount: 0,
      skippedCount: 0,
      status: '',
      createdAt: 0,
    ));
  });

  /// Helper to write a CSV temp file and return its path.
  String writeCsv(String content) {
    final file = File('${tempDir.path}/test.csv');
    file.writeAsStringSync(content);
    return file.path;
  }

  const defaultConfig = CsvImportConfig(
    dateColumn: 0,
    amountColumn: 1,
    payeeColumn: 2,
    hasHeader: true,
    dateFormat: 'MM/dd/yyyy',
  );

  // ===========================================================================
  // parseFile
  // ===========================================================================

  group('parseFile', () {
    test('parses a valid CSV with header row correctly', () async {
      final path = writeCsv(
        'Date,Amount,Payee\n'
        '01/15/2026,50.00,STARBUCKS\n'
        '01/16/2026,-25.50,WALMART\n',
      );

      when(() => mockTxnRepo.existsByExternalId(any()))
          .thenAnswer((_) async => false);

      final preview = await service.parseFile(path, defaultConfig);

      expect(preview.headers, equals(['Date', 'Amount', 'Payee']));
      expect(preview.transactions, hasLength(2));
      expect(preview.errors, isEmpty);
      expect(preview.totalRows, 2);

      expect(preview.transactions[0].payee, 'STARBUCKS');
      expect(preview.transactions[0].amountCents, 5000);
      expect(preview.transactions[0].date, DateTime(2026, 1, 15));

      expect(preview.transactions[1].payee, 'WALMART');
      expect(preview.transactions[1].amountCents, -2550);
    });

    test('respects column mapping config with different column orders',
        () async {
      final path = writeCsv(
        'Payee,Notes,Date,Amount\n'
        'GROCERY STORE,weekly groceries,02/20/2026,100.00\n',
      );

      final config = const CsvImportConfig(
        dateColumn: 2,
        amountColumn: 3,
        payeeColumn: 0,
        notesColumn: 1,
        hasHeader: true,
        dateFormat: 'MM/dd/yyyy',
      );

      when(() => mockTxnRepo.existsByExternalId(any()))
          .thenAnswer((_) async => false);

      final preview = await service.parseFile(path, config);

      expect(preview.transactions, hasLength(1));
      final txn = preview.transactions[0];
      expect(txn.payee, 'GROCERY STORE');
      expect(txn.notes, 'weekly groceries');
      expect(txn.amountCents, 10000);
      expect(txn.date, DateTime(2026, 2, 20));
    });

    test('detects duplicates by external ID', () async {
      final path = writeCsv(
        'Date,Amount,Payee\n'
        '01/15/2026,50.00,STARBUCKS\n',
      );

      when(() => mockTxnRepo.existsByExternalId(any()))
          .thenAnswer((_) async => true);

      final preview = await service.parseFile(path, defaultConfig);

      expect(preview.transactions, hasLength(1));
      expect(preview.transactions[0].isDuplicate, isTrue);
      expect(preview.duplicateCount, 1);
      expect(preview.validCount, 0);
    });

    test('detects duplicates by fuzzy match when accountId is provided',
        () async {
      final path = writeCsv(
        'Date,Amount,Payee\n'
        '01/15/2026,50.00,STARBUCKS\n',
      );

      when(() => mockTxnRepo.existsByExternalId(any()))
          .thenAnswer((_) async => false);
      when(() => mockTxnRepo.existsByFuzzyMatch(any(), any(), any()))
          .thenAnswer((_) async => true);

      final preview = await service.parseFile(
        path,
        defaultConfig,
        accountId: 'acc-1',
      );

      expect(preview.transactions[0].isDuplicate, isTrue);
    });

    test('does not fuzzy match when accountId is null', () async {
      final path = writeCsv(
        'Date,Amount,Payee\n'
        '01/15/2026,50.00,STARBUCKS\n',
      );

      when(() => mockTxnRepo.existsByExternalId(any()))
          .thenAnswer((_) async => false);

      final preview = await service.parseFile(path, defaultConfig);

      expect(preview.transactions[0].isDuplicate, isFalse);
      verifyNever(
          () => mockTxnRepo.existsByFuzzyMatch(any(), any(), any()));
    });

    test('handles ISO date format', () async {
      final path = writeCsv(
        'Date,Amount,Payee\n'
        '2026-03-10,75.00,TARGET\n',
      );

      final config = const CsvImportConfig(
        dateColumn: 0,
        amountColumn: 1,
        payeeColumn: 2,
        dateFormat: 'yyyy-MM-dd',
      );

      when(() => mockTxnRepo.existsByExternalId(any()))
          .thenAnswer((_) async => false);

      final preview = await service.parseFile(path, config);

      expect(preview.transactions, hasLength(1));
      expect(preview.transactions[0].date, DateTime(2026, 3, 10));
    });

    test('handles EU date format', () async {
      final path = writeCsv(
        'Date,Amount,Payee\n'
        '10/03/2026,75.00,TARGET\n',
      );

      final config = const CsvImportConfig(
        dateColumn: 0,
        amountColumn: 1,
        payeeColumn: 2,
        dateFormat: 'dd/MM/yyyy',
      );

      when(() => mockTxnRepo.existsByExternalId(any()))
          .thenAnswer((_) async => false);

      final preview = await service.parseFile(path, config);

      expect(preview.transactions, hasLength(1));
      expect(preview.transactions[0].date, DateTime(2026, 3, 10));
    });

    test('reports error for invalid date', () async {
      final path = writeCsv(
        'Date,Amount,Payee\n'
        'not-a-date,50.00,STARBUCKS\n',
      );

      final preview = await service.parseFile(path, defaultConfig);

      expect(preview.transactions, isEmpty);
      expect(preview.errors, hasLength(1));
      expect(preview.errors[0].rowNumber, 2);
      expect(preview.errors[0].message, contains('Invalid date'));
    });

    test('reports error for invalid amount', () async {
      final path = writeCsv(
        'Date,Amount,Payee\n'
        '01/15/2026,abc,STARBUCKS\n',
      );

      final preview = await service.parseFile(path, defaultConfig);

      expect(preview.transactions, isEmpty);
      expect(preview.errors, hasLength(1));
      expect(preview.errors[0].rowNumber, 2);
      expect(preview.errors[0].message, contains('Invalid amount'));
    });

    test('reports error for empty payee', () async {
      final path = writeCsv(
        'Date,Amount,Payee\n'
        '01/15/2026,50.00,\n',
      );

      final preview = await service.parseFile(path, defaultConfig);

      expect(preview.transactions, isEmpty);
      expect(preview.errors, hasLength(1));
      expect(preview.errors[0].message, 'Payee is empty');
    });

    test('skips empty rows', () async {
      final path = writeCsv(
        'Date,Amount,Payee\n'
        '01/15/2026,50.00,STARBUCKS\n'
        '\n'
        '01/16/2026,25.00,WALMART\n',
      );

      when(() => mockTxnRepo.existsByExternalId(any()))
          .thenAnswer((_) async => false);

      final preview = await service.parseFile(path, defaultConfig);

      expect(preview.transactions, hasLength(2));
      expect(preview.errors, isEmpty);
    });

    test('returns error for file not found', () async {
      final preview = await service.parseFile(
        '${tempDir.path}/nonexistent.csv',
        defaultConfig,
      );

      expect(preview.transactions, isEmpty);
      expect(preview.errors, hasLength(1));
      expect(preview.errors[0].message, 'File not found');
      expect(preview.fileName, 'nonexistent.csv');
    });

    test('returns error for empty file', () async {
      final path = writeCsv('');

      final preview = await service.parseFile(path, defaultConfig);

      expect(preview.transactions, isEmpty);
      expect(preview.errors, hasLength(1));
      expect(preview.errors[0].message, 'File is empty');
    });

    test('negativeIsExpense true keeps negative as expense', () async {
      final path = writeCsv(
        'Date,Amount,Payee\n'
        '01/15/2026,-50.00,STARBUCKS\n'
        '01/16/2026,100.00,EMPLOYER\n',
      );

      when(() => mockTxnRepo.existsByExternalId(any()))
          .thenAnswer((_) async => false);

      final config = const CsvImportConfig(
        dateColumn: 0,
        amountColumn: 1,
        payeeColumn: 2,
        negativeIsExpense: true,
      );

      final preview = await service.parseFile(path, config);

      // negativeIsExpense=true means amount passes through as-is
      expect(preview.transactions[0].amountCents, -5000);
      expect(preview.transactions[1].amountCents, 10000);
    });

    test('negativeIsExpense false inverts sign', () async {
      final path = writeCsv(
        'Date,Amount,Payee\n'
        '01/15/2026,-50.00,STARBUCKS\n'
        '01/16/2026,100.00,EMPLOYER\n',
      );

      when(() => mockTxnRepo.existsByExternalId(any()))
          .thenAnswer((_) async => false);

      final config = const CsvImportConfig(
        dateColumn: 0,
        amountColumn: 1,
        payeeColumn: 2,
        negativeIsExpense: false,
      );

      final preview = await service.parseFile(path, config);

      // negativeIsExpense=false means sign is inverted
      expect(preview.transactions[0].amountCents, 5000);
      expect(preview.transactions[1].amountCents, -10000);
    });

    test('parses amounts with currency symbols and commas', () async {
      final path = writeCsv(
        'Date,Amount,Payee\n'
        '01/15/2026,"\$1,234.56",STORE\n',
      );

      when(() => mockTxnRepo.existsByExternalId(any()))
          .thenAnswer((_) async => false);

      final preview = await service.parseFile(path, defaultConfig);

      expect(preview.transactions, hasLength(1));
      expect(preview.transactions[0].amountCents, 123456);
    });

    test('handles CSV with no header row', () async {
      final path = writeCsv(
        '01/15/2026,50.00,STARBUCKS\n',
      );

      final config = const CsvImportConfig(
        dateColumn: 0,
        amountColumn: 1,
        payeeColumn: 2,
        hasHeader: false,
      );

      when(() => mockTxnRepo.existsByExternalId(any()))
          .thenAnswer((_) async => false);

      final preview = await service.parseFile(path, config);

      expect(preview.headers, isEmpty);
      expect(preview.transactions, hasLength(1));
      expect(preview.transactions[0].rowNumber, 1);
      expect(preview.transactions[0].payee, 'STARBUCKS');
    });

    test('reports error when row has too few columns', () async {
      final path = writeCsv(
        'Date,Amount,Payee\n'
        '01/15/2026,50.00\n',
      );

      final preview = await service.parseFile(path, defaultConfig);

      expect(preview.transactions, isEmpty);
      expect(preview.errors, hasLength(1));
      expect(preview.errors[0].message, contains('columns'));
    });

    test('parses optional category and notes columns', () async {
      final path = writeCsv(
        'Date,Amount,Payee,Category,Notes\n'
        '01/15/2026,50.00,STARBUCKS,Food,morning coffee\n',
      );

      final config = const CsvImportConfig(
        dateColumn: 0,
        amountColumn: 1,
        payeeColumn: 2,
        categoryColumn: 3,
        notesColumn: 4,
      );

      when(() => mockTxnRepo.existsByExternalId(any()))
          .thenAnswer((_) async => false);

      final preview = await service.parseFile(path, config);

      expect(preview.transactions[0].category, 'Food');
      expect(preview.transactions[0].notes, 'morning coffee');
    });

    test('sets category to null when category column is empty', () async {
      final path = writeCsv(
        'Date,Amount,Payee,Category\n'
        '01/15/2026,50.00,STARBUCKS,\n',
      );

      final config = const CsvImportConfig(
        dateColumn: 0,
        amountColumn: 1,
        payeeColumn: 2,
        categoryColumn: 3,
      );

      when(() => mockTxnRepo.existsByExternalId(any()))
          .thenAnswer((_) async => false);

      final preview = await service.parseFile(path, config);

      expect(preview.transactions[0].category, isNull);
    });

    test('generates deterministic external IDs', () async {
      final path = writeCsv(
        'Date,Amount,Payee\n'
        '01/15/2026,50.00,STARBUCKS\n',
      );

      when(() => mockTxnRepo.existsByExternalId(any()))
          .thenAnswer((_) async => false);

      final preview1 = await service.parseFile(path, defaultConfig);
      final preview2 = await service.parseFile(path, defaultConfig);

      expect(preview1.transactions[0].externalId,
          preview2.transactions[0].externalId);
      expect(preview1.transactions[0].externalId, startsWith('csv_'));
    });

    test('handles quoted fields with commas', () async {
      final path = writeCsv(
        'Date,Amount,Payee\n'
        '01/15/2026,50.00,"STORE, INC."\n',
      );

      when(() => mockTxnRepo.existsByExternalId(any()))
          .thenAnswer((_) async => false);

      final preview = await service.parseFile(path, defaultConfig);

      expect(preview.transactions[0].payee, 'STORE, INC.');
    });

    test('invertSign=true negates parsed amounts', () async {
      final path = writeCsv(
        'Date,Amount,Payee\n'
        '01/15/2026,50.00,STARBUCKS\n'
        '01/16/2026,-25.50,WALMART\n',
      );

      when(() => mockTxnRepo.existsByExternalId(any()))
          .thenAnswer((_) async => false);

      final preview =
          await service.parseFile(path, defaultConfig, invertSign: true);

      expect(preview.transactions, hasLength(2));
      // Normal: 50.00 → 5000 (positive=income). With invertSign, negated → -5000
      expect(preview.transactions[0].amountCents, -5000);
      // Normal: -25.50 → -2550 (negative=expense). With invertSign, negated → 2550
      expect(preview.transactions[1].amountCents, 2550);
    });
  });

  // ===========================================================================
  // executeImport
  // ===========================================================================

  group('executeImport', () {
    /// Build a minimal preview with the given transactions.
    CsvImportPreview makePreview({
      List<ParsedTransaction>? transactions,
      List<ImportError>? errors,
    }) {
      return CsvImportPreview(
        fileName: 'test.csv',
        headers: ['Date', 'Amount', 'Payee'],
        transactions: transactions ?? [],
        errors: errors ?? [],
        totalRows: (transactions?.length ?? 0) + (errors?.length ?? 0),
      );
    }

    ParsedTransaction makeParsed({
      int rowNumber = 2,
      DateTime? date,
      int amountCents = -5000,
      String payee = 'STARBUCKS',
      bool isDuplicate = false,
      String externalId = 'csv_abc123',
      String? notes,
    }) {
      return ParsedTransaction(
        rowNumber: rowNumber,
        date: date ?? DateTime(2026, 1, 15),
        amountCents: amountCents,
        payee: payee,
        isDuplicate: isDuplicate,
        externalId: externalId,
        notes: notes,
      );
    }

    test('inserts non-duplicate transactions', () async {
      final preview = makePreview(transactions: [
        makeParsed(externalId: 'csv_001'),
        makeParsed(
          rowNumber: 3,
          payee: 'WALMART',
          externalId: 'csv_002',
          amountCents: -2500,
        ),
      ]);

      when(() => mockTxnRepo.existsByFuzzyMatch(any(), any(), any()))
          .thenAnswer((_) async => false);
      when(() => mockTxnRepo.insertTransactions(any()))
          .thenAnswer((_) async {});
      when(() => mockAutoCatService.loadEnabledRules())
          .thenAnswer((_) async => []);
      when(() => mockAutoCatService.categorizeWithPreloadedRules(
            any(),
            any(),
            amountCents: any(named: 'amountCents'),
            accountId: any(named: 'accountId'),
          )).thenAnswer((_) async => null);
      when(() => mockImportRepo.insertImportRecord(any()))
          .thenAnswer((_) async {});

      final result = await service.executeImport(preview, 'acc-1');

      expect(result.importedCount, 2);
      expect(result.skippedCount, 0);
      expect(result.errorCount, 0);

      final captured = verify(
        () => mockTxnRepo.insertTransactions(captureAny()),
      ).captured.single as List<TransactionsCompanion>;
      expect(captured, hasLength(2));
    });

    test('skips transactions marked as duplicates in preview', () async {
      final preview = makePreview(transactions: [
        makeParsed(isDuplicate: true, externalId: 'csv_dup'),
        makeParsed(
          rowNumber: 3,
          payee: 'WALMART',
          externalId: 'csv_new',
          isDuplicate: false,
        ),
      ]);

      when(() => mockTxnRepo.existsByFuzzyMatch(any(), any(), any()))
          .thenAnswer((_) async => false);
      when(() => mockTxnRepo.insertTransactions(any()))
          .thenAnswer((_) async {});
      when(() => mockAutoCatService.loadEnabledRules())
          .thenAnswer((_) async => []);
      when(() => mockAutoCatService.categorizeWithPreloadedRules(
            any(),
            any(),
            amountCents: any(named: 'amountCents'),
            accountId: any(named: 'accountId'),
          )).thenAnswer((_) async => null);
      when(() => mockImportRepo.insertImportRecord(any()))
          .thenAnswer((_) async {});

      final result = await service.executeImport(preview, 'acc-1');

      expect(result.importedCount, 1);
      expect(result.skippedCount, 1);
    });

    test('skips transactions caught by fuzzy match during import', () async {
      final preview = makePreview(transactions: [
        makeParsed(externalId: 'csv_fuzzy'),
      ]);

      when(() => mockTxnRepo.existsByFuzzyMatch(any(), any(), any()))
          .thenAnswer((_) async => true);
      when(() => mockImportRepo.insertImportRecord(any()))
          .thenAnswer((_) async {});

      final result = await service.executeImport(preview, 'acc-1');

      expect(result.importedCount, 0);
      expect(result.skippedCount, 1);
      verifyNever(() => mockTxnRepo.insertTransactions(any()));
    });

    test('auto-categorizes imported transactions using preloaded rules',
        () async {
      final preview = makePreview(transactions: [
        makeParsed(payee: 'STARBUCKS', externalId: 'csv_cat1'),
        makeParsed(
          rowNumber: 3,
          payee: 'UNKNOWN',
          externalId: 'csv_cat2',
          amountCents: -1000,
        ),
      ]);

      when(() => mockTxnRepo.existsByFuzzyMatch(any(), any(), any()))
          .thenAnswer((_) async => false);
      when(() => mockTxnRepo.insertTransactions(any()))
          .thenAnswer((_) async {});
      when(() => mockAutoCatService.loadEnabledRules())
          .thenAnswer((_) async => <AutoCategorizeRule>[]);

      // First call matches, second doesn't
      var callCount = 0;
      when(() => mockAutoCatService.categorizeWithPreloadedRules(
            any(),
            any(),
            amountCents: any(named: 'amountCents'),
            accountId: any(named: 'accountId'),
          )).thenAnswer((_) async {
        callCount++;
        return callCount == 1 ? 'cat-dining' : null;
      });
      when(() => mockTxnRepo.updateCategory(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockImportRepo.insertImportRecord(any()))
          .thenAnswer((_) async {});

      final result = await service.executeImport(preview, 'acc-1');

      expect(result.importedCount, 2);
      // updateCategory should be called once (for STARBUCKS match)
      verify(() => mockTxnRepo.updateCategory(any(), 'cat-dining')).called(1);
    });

    test('records import history', () async {
      final preview = makePreview(transactions: [
        makeParsed(externalId: 'csv_hist'),
      ]);

      when(() => mockTxnRepo.existsByFuzzyMatch(any(), any(), any()))
          .thenAnswer((_) async => false);
      when(() => mockTxnRepo.insertTransactions(any()))
          .thenAnswer((_) async {});
      when(() => mockAutoCatService.loadEnabledRules())
          .thenAnswer((_) async => []);
      when(() => mockAutoCatService.categorizeWithPreloadedRules(
            any(),
            any(),
            amountCents: any(named: 'amountCents'),
            accountId: any(named: 'accountId'),
          )).thenAnswer((_) async => null);
      when(() => mockImportRepo.insertImportRecord(any()))
          .thenAnswer((_) async {});

      await service.executeImport(preview, 'acc-1');

      final captured = verify(
        () => mockImportRepo.insertImportRecord(captureAny()),
      ).captured.single as ImportHistoryCompanion;

      expect(captured.source.value, 'csv');
      expect(captured.fileName.value, 'test.csv');
      expect(captured.importedCount.value, 1);
      expect(captured.status.value, 'completed');
    });

    test('returns correct counts with mixed results', () async {
      final preview = makePreview(
        transactions: [
          makeParsed(externalId: 'csv_ok1'),
          makeParsed(
            rowNumber: 3,
            isDuplicate: true,
            externalId: 'csv_dup1',
          ),
          makeParsed(
            rowNumber: 4,
            isDuplicate: true,
            externalId: 'csv_dup2',
          ),
        ],
        errors: [
          const ImportError(rowNumber: 5, message: 'bad row'),
        ],
      );

      when(() => mockTxnRepo.existsByFuzzyMatch(any(), any(), any()))
          .thenAnswer((_) async => false);
      when(() => mockTxnRepo.insertTransactions(any()))
          .thenAnswer((_) async {});
      when(() => mockAutoCatService.loadEnabledRules())
          .thenAnswer((_) async => []);
      when(() => mockAutoCatService.categorizeWithPreloadedRules(
            any(),
            any(),
            amountCents: any(named: 'amountCents'),
            accountId: any(named: 'accountId'),
          )).thenAnswer((_) async => null);
      when(() => mockImportRepo.insertImportRecord(any()))
          .thenAnswer((_) async {});

      final result = await service.executeImport(preview, 'acc-1');

      expect(result.importedCount, 1);
      expect(result.skippedCount, 2);
      expect(result.errorCount, 1);
    });

    test('sets status to partial when imports succeed with parse errors',
        () async {
      final preview = makePreview(
        transactions: [makeParsed(externalId: 'csv_partial')],
        errors: [const ImportError(rowNumber: 3, message: 'bad date')],
      );

      when(() => mockTxnRepo.existsByFuzzyMatch(any(), any(), any()))
          .thenAnswer((_) async => false);
      when(() => mockTxnRepo.insertTransactions(any()))
          .thenAnswer((_) async {});
      when(() => mockAutoCatService.loadEnabledRules())
          .thenAnswer((_) async => []);
      when(() => mockAutoCatService.categorizeWithPreloadedRules(
            any(),
            any(),
            amountCents: any(named: 'amountCents'),
            accountId: any(named: 'accountId'),
          )).thenAnswer((_) async => null);
      when(() => mockImportRepo.insertImportRecord(any()))
          .thenAnswer((_) async {});

      await service.executeImport(preview, 'acc-1');

      final captured = verify(
        () => mockImportRepo.insertImportRecord(captureAny()),
      ).captured.single as ImportHistoryCompanion;
      expect(captured.status.value, 'partial');
    });

    test('sets status to failed on insert exception', () async {
      final preview = makePreview(transactions: [
        makeParsed(externalId: 'csv_fail'),
      ]);

      when(() => mockTxnRepo.existsByFuzzyMatch(any(), any(), any()))
          .thenAnswer((_) async => false);
      when(() => mockTxnRepo.insertTransactions(any()))
          .thenThrow(Exception('DB write failed'));
      when(() => mockImportRepo.insertImportRecord(any()))
          .thenAnswer((_) async {});

      final result = await service.executeImport(preview, 'acc-1');

      expect(result.importedCount, 0);
      expect(result.errorMessage, contains('DB write failed'));

      final captured = verify(
        () => mockImportRepo.insertImportRecord(captureAny()),
      ).captured.single as ImportHistoryCompanion;
      expect(captured.status.value, 'failed');
    });

    test('does not call insertTransactions when all are duplicates', () async {
      final preview = makePreview(transactions: [
        makeParsed(isDuplicate: true, externalId: 'csv_dup_all'),
      ]);

      when(() => mockImportRepo.insertImportRecord(any()))
          .thenAnswer((_) async {});

      final result = await service.executeImport(preview, 'acc-1');

      expect(result.importedCount, 0);
      expect(result.skippedCount, 1);
      verifyNever(() => mockTxnRepo.insertTransactions(any()));
    });

    test('passes notes through to companion', () async {
      final preview = makePreview(transactions: [
        makeParsed(externalId: 'csv_notes', notes: 'test note'),
      ]);

      when(() => mockTxnRepo.existsByFuzzyMatch(any(), any(), any()))
          .thenAnswer((_) async => false);
      when(() => mockTxnRepo.insertTransactions(any()))
          .thenAnswer((_) async {});
      when(() => mockAutoCatService.loadEnabledRules())
          .thenAnswer((_) async => []);
      when(() => mockAutoCatService.categorizeWithPreloadedRules(
            any(),
            any(),
            amountCents: any(named: 'amountCents'),
            accountId: any(named: 'accountId'),
          )).thenAnswer((_) async => null);
      when(() => mockImportRepo.insertImportRecord(any()))
          .thenAnswer((_) async {});

      await service.executeImport(preview, 'acc-1');

      final captured = verify(
        () => mockTxnRepo.insertTransactions(captureAny()),
      ).captured.single as List<TransactionsCompanion>;
      expect(captured[0].notes.value, 'test note');
    });
  });
}
