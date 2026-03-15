import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/category_icons.dart';
import '../../../core/di/providers.dart';
import '../../../data/local/database/app_database.dart';
import 'add_category_sheet.dart';

/// Result returned from the category picker bottom sheet.
///
/// [cleared] is true when the user explicitly tapped "Clear".
/// A null return from [showCategoryPickerSheet] means the sheet was dismissed
/// without action (the caller should preserve the current selection).
class CategoryPickerResult {
  final String? id;
  final String? name;
  final bool cleared;

  const CategoryPickerResult({this.id, this.name, this.cleared = false});

  const CategoryPickerResult.cleared() : id = null, name = null, cleared = true;
}

/// Shows a hierarchical category picker bottom sheet with search and
/// optional inline category creation.
///
/// [categoryType] filters categories: null = all, 'expense', 'income'.
/// [showAddButton] controls whether the "Add New Category" row appears.
Future<CategoryPickerResult?> showCategoryPickerSheet({
  required BuildContext context,
  String? categoryType,
  String? selectedCategoryId,
  String title = 'Select Category',
  bool showClear = true,
  bool showAddButton = true,
}) {
  return showModalBottomSheet<CategoryPickerResult>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => _CategoryPickerBody(
      categoryType: categoryType,
      selectedCategoryId: selectedCategoryId,
      title: title,
      showClear: showClear,
      showAddButton: showAddButton,
    ),
  );
}

class _CategoryPickerBody extends ConsumerStatefulWidget {
  final String? categoryType;
  final String? selectedCategoryId;
  final String title;
  final bool showClear;
  final bool showAddButton;

  const _CategoryPickerBody({
    this.categoryType,
    this.selectedCategoryId,
    required this.title,
    required this.showClear,
    required this.showAddButton,
  });

  @override
  ConsumerState<_CategoryPickerBody> createState() =>
      _CategoryPickerBodyState();
}

class _CategoryPickerBodyState extends ConsumerState<_CategoryPickerBody> {
  final _searchController = TextEditingController();
  final _sheetController = DraggableScrollableController();
  final _searchFocusNode = FocusNode();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onSearchFocusChange);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _sheetController.dispose();
    _searchFocusNode.removeListener(_onSearchFocusChange);
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchFocusChange() {
    if (_searchFocusNode.hasFocus) {
      _sheetController.animateTo(
        1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  AutoDisposeStreamProvider<List<Category>> get _provider {
    switch (widget.categoryType) {
      case 'expense':
        return expenseCategoriesProvider;
      case 'income':
        return incomeCategoriesProvider;
      default:
        return allCategoriesProvider;
    }
  }

  /// Filters parents and children based on search query.
  /// If a parent matches, all its children are included.
  /// If only children match, the parent is included with only matching children.
  List<(Category parent, List<Category> children)> _filterCategories(
    List<Category> allCategories,
  ) {
    final parents =
        allCategories.where((c) => c.parentId == null).toList();
    final query = _searchQuery.toLowerCase();

    final result = <(Category, List<Category>)>[];

    for (final parent in parents) {
      final children =
          allCategories.where((c) => c.parentId == parent.id).toList();

      if (query.isEmpty) {
        result.add((parent, children));
        continue;
      }

      final parentMatches = parent.name.toLowerCase().contains(query);
      if (parentMatches) {
        result.add((parent, children));
      } else {
        final matchingChildren = children
            .where((c) => c.name.toLowerCase().contains(query))
            .toList();
        if (matchingChildren.isNotEmpty) {
          result.add((parent, matchingChildren));
        }
      }
    }

    return result;
  }

  Future<void> _openAddSheet() async {
    final result = await showAddCategorySheet(
      context: context,
      ref: ref,
      initialName: _searchQuery.isNotEmpty ? _searchQuery : null,
      defaultType: widget.categoryType ?? 'expense',
    );
    if (result != null && mounted) {
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final asyncCategories = ref.watch(_provider);

    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) => Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title, style: theme.textTheme.titleLarge),
                if (widget.showClear && widget.selectedCategoryId != null)
                  TextButton(
                    onPressed: () => Navigator.pop(
                      context,
                      const CategoryPickerResult.cleared(),
                    ),
                    child: const Text('Clear'),
                  ),
              ],
            ),
          ),
          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search categories...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                isDense: true,
              ),
              onChanged: (value) =>
                  setState(() => _searchQuery = value.trim()),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          // Category list
          Expanded(
            child: asyncCategories.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (categories) {
                final filtered = _filterCategories(categories);

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('No categories found'),
                        if (widget.showAddButton &&
                            _searchQuery.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _openAddSheet,
                            child: Text('Create "$_searchQuery"?'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return ListView(
                  controller: scrollController,
                  children: [
                    for (final (parent, children) in filtered) ...[
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Color(parent.color).withValues(alpha: 0.15),
                          child: Icon(getCategoryIcon(parent.icon),
                              color: Color(parent.color), size: 20),
                        ),
                        title: Text(parent.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        selected:
                            widget.selectedCategoryId == parent.id,
                        onTap: () => Navigator.pop(
                          context,
                          CategoryPickerResult(
                              id: parent.id, name: parent.name),
                        ),
                      ),
                      for (final child in children)
                        ListTile(
                          contentPadding:
                              const EdgeInsets.only(left: 56, right: 16),
                          title: Text(child.name),
                          selected:
                              widget.selectedCategoryId == child.id,
                          onTap: () => Navigator.pop(
                            context,
                            CategoryPickerResult(
                                id: child.id, name: child.name),
                          ),
                        ),
                    ],
                  ],
                );
              },
            ),
          ),
          // Add New Category button
          if (widget.showAddButton) ...[
            const Divider(height: 1),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(Icons.add, color: colorScheme.primary),
              ),
              title: Text(
                'Add New Category',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: _openAddSheet,
            ),
          ],
        ],
      ),
    );
  }
}
