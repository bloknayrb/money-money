import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/category_icons.dart';
import '../../../core/di/providers.dart';
import '../../../data/local/database/app_database.dart';

/// Screen for managing income and expense categories.
class CategoryManagementScreen extends ConsumerWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(allCategoriesProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Categories'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Expense'),
              Tab(text: 'Income'),
            ],
          ),
        ),
        body: categoriesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (categories) {
            return TabBarView(
              children: [
                _CategoryList(
                  categories: categories,
                  type: 'expense',
                ),
                _CategoryList(
                  categories: categories,
                  type: 'income',
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddCategoryDialog(context, ref),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => const _CategoryDialog(),
    );
  }
}

class _CategoryList extends ConsumerWidget {
  final List<Category> categories;
  final String type;

  const _CategoryList({
    required this.categories,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parents = categories
        .where((c) => c.parentId == null && c.type == type)
        .toList();

    if (parents.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('No categories yet. Tap + to add one.'),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: parents.length,
      itemBuilder: (context, index) {
        final parent = parents[index];
        final children =
            categories.where((c) => c.parentId == parent.id).toList();
        return _ParentCategoryTile(
          parent: parent,
          children: children,
        );
      },
    );
  }
}

class _ParentCategoryTile extends ConsumerWidget {
  final Category parent;
  final List<Category> children;

  const _ParentCategoryTile({
    required this.parent,
    required this.children,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: Color(parent.color).withValues(alpha: 0.15),
        child: Icon(
          getCategoryIcon(parent.icon),
          color: Color(parent.color),
          size: 20,
        ),
      ),
      title: Text(
        parent.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: children.isNotEmpty
          ? Text('${children.length} subcategories',
              style: theme.textTheme.bodySmall)
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            tooltip: 'Edit',
            onPressed: () => showDialog(
              context: context,
              builder: (_) => _CategoryDialog(category: parent),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline,
                size: 20, color: theme.colorScheme.error),
            tooltip: 'Delete',
            onPressed: () => _confirmDelete(context, ref, parent),
          ),
          const Icon(Icons.expand_more),
        ],
      ),
      children: [
        for (final child in children)
          ListTile(
            contentPadding: const EdgeInsets.only(left: 72, right: 16),
            leading: Icon(
              getCategoryIcon(child.icon),
              color: Color(child.color),
              size: 18,
            ),
            title: Text(child.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  tooltip: 'Edit',
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => _CategoryDialog(
                      category: child,
                      parentCategory: parent,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      size: 18, color: theme.colorScheme.error),
                  tooltip: 'Delete',
                  onPressed: () => _confirmDelete(context, ref, child),
                ),
              ],
            ),
          ),
        // Add subcategory button
        ListTile(
          contentPadding: const EdgeInsets.only(left: 72, right: 16),
          leading: Icon(Icons.add, color: theme.colorScheme.primary, size: 18),
          title: Text(
            'Add Subcategory',
            style: TextStyle(color: theme.colorScheme.primary),
          ),
          onTap: () => showDialog(
            context: context,
            builder: (_) => _CategoryDialog(
              parentCategory: parent,
              defaultType: parent.type,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, Category category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text(
          'Delete "${category.name}"? Transactions using this category '
          'will become uncategorized.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(categoryRepositoryProvider).deleteCategory(category.id);
    }
  }
}

/// Dialog for adding or editing a category with icon and color pickers.
class _CategoryDialog extends ConsumerStatefulWidget {
  final Category? category;
  final Category? parentCategory;
  final String? defaultType;

  const _CategoryDialog({
    this.category,
    this.parentCategory,
    this.defaultType,
  });

  @override
  ConsumerState<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends ConsumerState<_CategoryDialog> {
  late final TextEditingController _nameController;
  late String _type;
  late String _icon;
  late int _color;
  String? _parentId;

  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    final cat = widget.category;
    _nameController = TextEditingController(text: cat?.name ?? '');
    _type = cat?.type ?? widget.defaultType ?? widget.parentCategory?.type ?? 'expense';
    _icon = cat?.icon ?? 'category';
    _color = cat?.color ?? 0xFF9E9E9E;
    _parentId = cat?.parentId ?? widget.parentCategory?.id;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allCategories =
        ref.watch(allCategoriesProvider).valueOrNull ?? [];
    final parents = allCategories
        .where((c) => c.parentId == null && c.type == _type)
        .toList();

    return AlertDialog(
      title: Text(_isEditing ? 'Edit Category' : 'Add Category'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            // Type selector (only for new top-level categories)
            if (!_isEditing && widget.parentCategory == null)
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'expense', label: Text('Expense')),
                  ButtonSegment(value: 'income', label: Text('Income')),
                ],
                selected: {_type},
                onSelectionChanged: (selected) {
                  setState(() {
                    _type = selected.first;
                    _parentId = null;
                  });
                },
              ),
            if (!_isEditing && widget.parentCategory == null)
              const SizedBox(height: 16),
            // Parent selector (only for new categories without a preset parent)
            if (!_isEditing && widget.parentCategory == null)
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
                  for (final parent in parents)
                    DropdownMenuItem(
                      value: parent.id,
                      child: Text(parent.name),
                    ),
                ],
                onChanged: (value) => setState(() => _parentId = value),
              ),
            if (!_isEditing && widget.parentCategory == null)
              const SizedBox(height: 16),
            // Icon picker
            Text('Icon', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            _IconPicker(
              selectedIcon: _icon,
              color: _color,
              onChanged: (icon) => setState(() => _icon = icon),
            ),
            const SizedBox(height: 16),
            // Color picker
            Text('Color', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            _ColorPicker(
              selectedColor: _color,
              onChanged: (color) => setState(() => _color = color),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name is required')),
      );
      return;
    }

    final repo = ref.read(categoryRepositoryProvider);
    final now = DateTime.now().millisecondsSinceEpoch;

    if (_isEditing) {
      await repo.updateCategory(CategoriesCompanion(
        id: Value(widget.category!.id),
        name: Value(name),
        icon: Value(_icon),
        color: Value(_color),
        updatedAt: Value(now),
      ));
    } else {
      await repo.insertCategory(CategoriesCompanion.insert(
        id: const Uuid().v4(),
        name: name,
        parentId: Value(_parentId),
        type: _type,
        icon: _icon,
        color: _color,
        displayOrder: 999,
        createdAt: now,
        updatedAt: now,
      ));
    }

    if (mounted) Navigator.pop(context);
  }
}

class _IconPicker extends StatelessWidget {
  final String selectedIcon;
  final int color;
  final ValueChanged<String> onChanged;

  const _IconPicker({
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelected
                  ? Color(color).withValues(alpha: 0.2)
                  : null,
              border: isSelected
                  ? Border.all(color: Color(color), width: 2)
                  : Border.all(
                      color: theme.colorScheme.outlineVariant,
                      width: 1,
                    ),
            ),
            child: Icon(
              getCategoryIcon(name),
              size: 20,
              color: isSelected ? Color(color) : theme.colorScheme.onSurface,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final int selectedColor;
  final ValueChanged<int> onChanged;

  const _ColorPicker({
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
          borderRadius: BorderRadius.circular(20),
          onTap: () => onChanged(colorValue),
          child: Container(
            width: 36,
            height: 36,
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
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
