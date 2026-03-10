import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../domain/usecases/categorize/rules_import_service.dart';

/// Two-step screen for importing auto-categorization rules from CSV.
///
/// Step 1 — paste CSV text or load from file.
/// Step 2 — results summary (imported / skipped counts).
class ImportRulesScreen extends ConsumerStatefulWidget {
  const ImportRulesScreen({super.key});

  @override
  ConsumerState<ImportRulesScreen> createState() => _ImportRulesScreenState();
}

class _ImportRulesScreenState extends ConsumerState<ImportRulesScreen> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  RulesImportResult? _result;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'txt'],
    );
    if (picked == null || picked.files.single.path == null) return;

    final path = picked.files.single.path!;
    final content = await File(path).readAsString();
    setState(() => _controller.text = content);
  }

  Future<void> _import() async {
    final csv = _controller.text.trim();
    if (csv.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paste or load a CSV first')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final service = ref.read(rulesImportServiceProvider);
      final result = await service.importFromCsv(csv);
      setState(() => _result = result);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Import failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import Category Rules')),
      body: _result != null ? _ResultsView(result: _result!) : _InputView(
        controller: _controller,
        isLoading: _isLoading,
        onPickFile: _pickFile,
        onImport: _import,
      ),
    );
  }
}

class _InputView extends StatelessWidget {
  const _InputView({
    required this.controller,
    required this.isLoading,
    required this.onPickFile,
    required this.onImport,
  });

  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onPickFile;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Paste CSV or load a file. Two columns: payee, category.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Example:\npayee,category\nKROGER,Groceries\nMY LOCAL GYM,Gym',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: isLoading ? null : onPickFile,
            icon: const Icon(Icons.folder_open),
            label: const Text('Load from file'),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                hintText: 'payee,category\nKROGER,Groceries\n...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontFamily: 'monospace'),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: isLoading ? null : onImport,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Import Rules'),
          ),
        ],
      ),
    );
  }
}

class _ResultsView extends StatelessWidget {
  const _ResultsView({required this.result});

  final RulesImportResult result;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            result.imported > 0 ? Icons.check_circle : Icons.info_outline,
            size: 48,
            color: result.imported > 0 ? Colors.green : colorScheme.primary,
          ),
          const SizedBox(height: 16),
          _CountRow(
            label: 'Rules imported',
            value: result.imported,
            color: Colors.green,
          ),
          _CountRow(
            label: 'Skipped (already exists)',
            value: result.skippedDuplicate,
          ),
          _CountRow(
            label: 'Skipped (category not found)',
            value: result.skippedCategoryNotFound,
            color: result.skippedCategoryNotFound > 0
                ? colorScheme.error
                : null,
          ),
          if (result.unknownCategories.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Unknown categories — fix in your CSV:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            ...result.unknownCategories.map(
              (name) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  '• $name',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                        fontFamily: 'monospace',
                      ),
                ),
              ),
            ),
          ],
          const Spacer(),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class _CountRow extends StatelessWidget {
  const _CountRow({required this.label, required this.value, this.color});

  final String label;
  final int value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            '$value',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}
