import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:drift/drift.dart' show Value;
import '../../../core/constants/category_icons.dart';
import '../../../core/di/providers.dart';
import '../../../data/local/database/app_database.dart';
import 'category_picker_sheet.dart';

/// Shows a bottom sheet to create a new category.
///
/// Returns a [CategoryPickerResult] with the newly created category,
/// or null if dismissed.
Future<CategoryPickerResult?> showAddCategorySheet({
  required BuildContext context,
  required WidgetRef ref,
  String? initialName,
  String defaultType = 'expense',
}) {
  return showModalBottomSheet<CategoryPickerResult>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(ctx).viewInsets.bottom,
      ),
      child: _AddCategoryForm(
        ref: ref,
        initialName: initialName,
        defaultType: defaultType,
      ),
    ),
  );
}

class _AddCategoryForm extends StatefulWidget {
  final WidgetRef ref;
  final String? initialName;
  final String defaultType;

  const _AddCategoryForm({
    required this.ref,
    this.initialName,
    required this.defaultType,
  });

  @override
  State<_AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<_AddCategoryForm> {
  late final TextEditingController _nameController;
  late String _type;
  String? _parentId;
  String _icon = 'category';
  int _color = 0xFF9E9E9E;
  bool _isSaving = false;
  String? _errorText;
  bool _showIconPicker = false;
  bool _showColorPicker = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _type = widget.defaultType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  List<Category> _getParents(List<Category> categories) {
    return categories
        .where((c) => c.parentId == null && c.type == _type)
        .toList();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorText = 'Name is required');
      return;
    }
    if (name.length > 50) {
      setState(() => _errorText = 'Name must be 50 characters or less');
      return;
    }

    // Duplicate check
    final categories =
        widget.ref.read(allCategoriesProvider).valueOrNull ?? [];
    final duplicate = categories.any(
      (c) =>
          c.name.toLowerCase() == name.toLowerCase() &&
          c.parentId == _parentId &&
          c.type == _type,
    );
    if (duplicate) {
      setState(() => _errorText = 'Category already exists');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorText = null;
    });

    try {
      final id = const Uuid().v4();
      final now = DateTime.now().millisecondsSinceEpoch;
      await widget.ref.read(categoryRepositoryProvider).insertCategory(
            CategoriesCompanion.insert(
              id: id,
              name: name,
              parentId: Value(_parentId),
              type: _type,
              icon: _icon,
              color: _color,
              displayOrder: 999,
              createdAt: now,
              updatedAt: now,
            ),
          );
      if (!mounted) return;
      Navigator.pop(context, CategoryPickerResult(id: id, name: name));
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create category: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories =
        widget.ref.read(allCategoriesProvider).valueOrNull ?? [];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('New Category', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              autofocus: true,
              maxLength: 50,
              decoration: InputDecoration(
                labelText: 'Name',
                errorText: _errorText,
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) {
                if (_errorText != null) setState(() => _errorText = null);
              },
            ),
            const SizedBox(height: 16),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'expense', label: Text('Expense')),
                ButtonSegment(value: 'income', label: Text('Income')),
              ],
              selected: {_type},
              onSelectionChanged: (selected) {
                setState(() {
                  _type = selected.first;
                  if (_parentId != null) {
                    final parents = _getParents(categories);
                    final stillValid =
                        parents.any((p) => p.id == _parentId);
                    if (!stillValid) _parentId = null;
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String?>(
              initialValue: _parentId,
              decoration: const InputDecoration(
                labelText: 'Parent Category',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('None (top-level)'),
                ),
                for (final parent in _getParents(categories))
                  DropdownMenuItem(
                    value: parent.id,
                    child: Text(parent.name),
                  ),
              ],
              onChanged: (value) => setState(() => _parentId = value),
            ),
            const SizedBox(height: 16),
            // Icon and Color row
            Row(
              children: [
                // Icon preview + picker toggle
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => setState(() {
                    _showIconPicker = !_showIconPicker;
                    _showColorPicker = false;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: theme.colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(getCategoryIcon(_icon),
                            color: Color(_color), size: 24),
                        const SizedBox(width: 8),
                        const Text('Icon'),
                        Icon(
                          _showIconPicker
                              ? Icons.expand_less
                              : Icons.expand_more,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Color preview + picker toggle
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => setState(() {
                    _showColorPicker = !_showColorPicker;
                    _showIconPicker = false;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: theme.colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(_color),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Color'),
                        Icon(
                          _showColorPicker
                              ? Icons.expand_less
                              : Icons.expand_more,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_showIconPicker) ...[
              const SizedBox(height: 12),
              _MiniIconPicker(
                selectedIcon: _icon,
                color: _color,
                onChanged: (icon) => setState(() => _icon = icon),
              ),
            ],
            if (_showColorPicker) ...[
              const SizedBox(height: 12),
              _MiniColorPicker(
                selectedColor: _color,
                onChanged: (color) => setState(() => _color = color),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save & Select'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _MiniIconPicker extends StatelessWidget {
  final String selectedIcon;
  final int color;
  final ValueChanged<String> onChanged;

  const _MiniIconPicker({
    required this.selectedIcon,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: pickableIconNames.map((name) {
        final isSelected = name == selectedIcon;
        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => onChanged(name),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelected
                  ? Color(color).withValues(alpha: 0.2)
                  : null,
              border: isSelected
                  ? Border.all(color: Color(color), width: 2)
                  : Border.all(
                      color: theme.colorScheme.outlineVariant, width: 1),
            ),
            child: Icon(
              getCategoryIcon(name),
              size: 18,
              color:
                  isSelected ? Color(color) : theme.colorScheme.onSurface,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _MiniColorPicker extends StatelessWidget {
  final int selectedColor;
  final ValueChanged<int> onChanged;

  const _MiniColorPicker({
    required this.selectedColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: pickableColors.map((colorValue) {
        final isSelected = colorValue == selectedColor;
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onChanged(colorValue),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(colorValue),
              border: isSelected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 3,
                    )
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
