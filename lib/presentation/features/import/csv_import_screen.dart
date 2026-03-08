import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/error/app_error.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/usecases/import/csv_import_service.dart';
import 'widgets/column_mapping_step.dart';
import 'widgets/preview_step.dart';

/// Multi-step CSV import flow.
class CsvImportScreen extends ConsumerStatefulWidget {
  const CsvImportScreen({super.key});

  @override
  ConsumerState<CsvImportScreen> createState() => _CsvImportScreenState();
}

class _CsvImportScreenState extends ConsumerState<CsvImportScreen> {
  int _currentStep = 0;

  // Step 1: File selection
  final _filePathController = TextEditingController();

  // Step 2: Column mapping
  List<List<String>> _previewRows = [];
  List<String> _headers = [];
  int _dateColumn = 0;
  int _amountColumn = 1;
  int _payeeColumn = 2;
  int? _categoryColumn;
  int? _notesColumn;
  String _dateFormat = 'MM/dd/yyyy';
  bool _hasHeader = true;
  bool _negativeIsExpense = true;

  // Step 3: Preview
  CsvImportPreview? _preview;
  bool _isParsing = false;

  // Step 4: Import
  String? _selectedAccountId;
  bool _isImporting = false;
  CsvImportResult? _result;

  @override
  void dispose() {
    _filePathController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Step 1: Load file and read preview rows
  // ---------------------------------------------------------------------------

  Future<void> _loadFile() async {
    final path = _filePathController.text.trim();
    if (path.isEmpty) {
      _showError('Please enter a file path');
      return;
    }

    final file = File(path);
    if (!await file.exists()) {
      if (mounted) _showError('File not found: $path');
      return;
    }

    try {
      final lines = await file.readAsLines();
      if (lines.isEmpty) {
        if (mounted) _showError('File is empty');
        return;
      }

      final rows = lines.take(6).map(_parseCsvLine).toList();

      setState(() {
        _previewRows = rows;
        _headers = _hasHeader && rows.isNotEmpty ? rows.first : [];
        // Auto-detect column count and reset mappings
        final colCount = rows.isNotEmpty ? rows.first.length : 0;
        _dateColumn = 0.clamp(0, (colCount - 1).clamp(0, 999));
        _amountColumn = colCount > 1 ? 1 : 0;
        _payeeColumn = colCount > 2 ? 2 : 0;
        _categoryColumn = null;
        _notesColumn = null;
        _currentStep = 1;
      });
    } catch (e) {
      if (mounted) _showError(ErrorHandler.handle(e).userMessage);
    }
  }

  // ---------------------------------------------------------------------------
  // File picker
  // ---------------------------------------------------------------------------

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'txt'],
    );

    if (result != null && result.files.single.path != null) {
      _filePathController.text = result.files.single.path!;
    }
  }

  // ---------------------------------------------------------------------------
  // Step 2 → 3: Parse file with config
  // ---------------------------------------------------------------------------

  Future<void> _parseWithConfig() async {
    setState(() => _isParsing = true);

    final config = CsvImportConfig(
      dateColumn: _dateColumn,
      amountColumn: _amountColumn,
      payeeColumn: _payeeColumn,
      categoryColumn: _categoryColumn,
      notesColumn: _notesColumn,
      dateFormat: _dateFormat,
      hasHeader: _hasHeader,
      negativeIsExpense: _negativeIsExpense,
    );

    try {
      final service = ref.read(csvImportServiceProvider);
      final preview =
          await service.parseFile(_filePathController.text.trim(), config);

      if (!mounted) return;
      setState(() {
        _preview = preview;
        _isParsing = false;
        _currentStep = 2;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isParsing = false);
        _showError(ErrorHandler.handle(e).userMessage);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Step 3 → 4: Execute import
  // ---------------------------------------------------------------------------

  Future<void> _executeImport() async {
    if (_selectedAccountId == null) {
      _showError('Please select an account');
      return;
    }
    if (_preview == null) return;

    setState(() => _isImporting = true);

    try {
      final service = ref.read(csvImportServiceProvider);
      final result = await service.executeImport(_preview!, _selectedAccountId!);

      if (!mounted) return;
      setState(() {
        _result = result;
        _isImporting = false;
        _currentStep = 3;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isImporting = false);
        _showError(ErrorHandler.handle(e).userMessage);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CSV line parser (same logic as service, for preview)
  // ---------------------------------------------------------------------------

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
            i++;
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

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import CSV')),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: null, // handled by custom buttons
        onStepCancel: _currentStep > 0 && _currentStep < 3
            ? () => setState(() => _currentStep--)
            : null,
        controlsBuilder: (context, details) => const SizedBox.shrink(),
        steps: [
          Step(
            title: const Text('Select File'),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            content: _buildFileStep(),
          ),
          Step(
            title: const Text('Map Columns'),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            content: ColumnMappingStep(
              previewRows: _previewRows,
              headers: _headers,
              hasHeader: _hasHeader,
              dateColumn: _dateColumn,
              dateFormat: _dateFormat,
              amountColumn: _amountColumn,
              payeeColumn: _payeeColumn,
              categoryColumn: _categoryColumn,
              notesColumn: _notesColumn,
              negativeIsExpense: _negativeIsExpense,
              isParsing: _isParsing,
              onDateColumnChanged: (v) =>
                  setState(() => _dateColumn = v ?? 0),
              onDateFormatChanged: (v) =>
                  setState(() => _dateFormat = v ?? 'MM/dd/yyyy'),
              onAmountColumnChanged: (v) =>
                  setState(() => _amountColumn = v ?? 1),
              onPayeeColumnChanged: (v) =>
                  setState(() => _payeeColumn = v ?? 2),
              onCategoryColumnChanged: (v) =>
                  setState(() => _categoryColumn = v),
              onNotesColumnChanged: (v) =>
                  setState(() => _notesColumn = v),
              onNegativeIsExpenseChanged: (v) =>
                  setState(() => _negativeIsExpense = v ?? true),
              onParsePressed: _parseWithConfig,
              onBackPressed: () => setState(() => _currentStep = 0),
            ),
          ),
          Step(
            title: const Text('Preview & Import'),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            content: PreviewStep(
              preview: _preview,
              selectedAccountId: _selectedAccountId,
              isImporting: _isImporting,
              onAccountChanged: (v) =>
                  setState(() => _selectedAccountId = v),
              onImportPressed: _executeImport,
              onBackPressed: () => setState(() => _currentStep = 1),
            ),
          ),
          Step(
            title: const Text('Results'),
            isActive: _currentStep >= 3,
            state: _currentStep == 3 ? StepState.complete : StepState.indexed,
            content: _buildResultStep(),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 1: File Selection
  // ---------------------------------------------------------------------------

  Widget _buildFileStep() {
    final isAndroid = Platform.isAndroid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _filePathController,
          readOnly: isAndroid,
          decoration: InputDecoration(
            labelText: isAndroid ? 'Selected File' : 'File Path',
            hintText: isAndroid
                ? 'Tap browse to select a file'
                : '/path/to/transactions.csv',
            filled: true,
            prefixIcon: const Icon(Icons.file_present),
            suffixIcon: IconButton(
              icon: const Icon(Icons.folder_open),
              onPressed: _pickFile,
              tooltip: 'Browse files',
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text('Has header row'),
                value: _hasHeader,
                onChanged: (v) => setState(() => _hasHeader = v ?? true),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _loadFile,
          icon: const Icon(Icons.upload_file),
          label: const Text('Load File'),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Step 4: Results
  // ---------------------------------------------------------------------------

  Widget _buildResultStep() {
    final result = _result;
    if (result == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasError = result.errorMessage != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          hasError ? Icons.warning_amber_rounded : Icons.check_circle,
          size: 64,
          color: hasError ? colorScheme.error : theme.finance.income,
        ),
        const SizedBox(height: 16),
        Text(
          hasError ? 'Import Failed' : 'Import Complete',
          style: theme.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _resultRow('Imported', '${result.importedCount}'),
                _resultRow('Skipped (duplicates)', '${result.skippedCount}'),
                _resultRow('Errors', '${result.errorCount}'),
                if (result.errorMessage != null) ...[
                  const Divider(),
                  Text(
                    result.errorMessage!,
                    style: TextStyle(color: colorScheme.error, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Done'),
        ),
      ],
    );
  }

  Widget _resultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
