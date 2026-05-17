import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moneymoney/data/local/database/app_database.dart';
import 'package:moneymoney/data/repositories/auto_categorize_repository.dart';

void main() {
  late AppDatabase database;
  late AutoCategorizeRepository repo;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repo = AutoCategorizeRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  AutoCategorizeRulesCompanion makeRule({
    required String id,
    required int priority,
    String? payeeContains = 'TEST',
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return AutoCategorizeRulesCompanion.insert(
      id: id,
      name: 'rule-$id',
      priority: priority,
      categoryId: 'cat-1',
      createdAt: now,
      updatedAt: now,
      payeeContains: Value(payeeContains),
    );
  }

  group('reassignPriorities', () {
    test('rewrites priorities in the supplied order with step 10', () async {
      await repo.insertRules([
        makeRule(id: 'a', priority: 100),
        makeRule(id: 'b', priority: 200),
        makeRule(id: 'c', priority: 300),
      ]);

      final now = DateTime.now().millisecondsSinceEpoch;
      // Caller submits new order: c, a, b (priorities should become 10, 20, 30).
      await repo.reassignPriorities([
        ('c', 10),
        ('a', 20),
        ('b', 30),
      ], now);

      final rules = await repo.getAllRules();
      final byId = {for (final r in rules) r.id: r};
      expect(byId['c']!.priority, 10);
      expect(byId['a']!.priority, 20);
      expect(byId['b']!.priority, 30);
      // updatedAt is bumped on every reordered row.
      expect(byId['a']!.updatedAt, now);
      expect(byId['b']!.updatedAt, now);
      expect(byId['c']!.updatedAt, now);
    });

    test('empty updates list is a no-op', () async {
      await repo.insertRules([makeRule(id: 'a', priority: 100)]);
      final original = (await repo.getAllRules()).single;

      await repo.reassignPriorities([], original.updatedAt + 1000);

      final after = (await repo.getAllRules()).single;
      expect(after.priority, 100);
      expect(after.updatedAt, original.updatedAt);
    });

    test('ignores ids that do not exist (no-op for missing rules)', () async {
      await repo.insertRules([makeRule(id: 'a', priority: 100)]);
      final now = DateTime.now().millisecondsSinceEpoch;

      await repo.reassignPriorities([
        ('a', 10),
        ('ghost', 20),
      ], now);

      final rules = await repo.getAllRules();
      expect(rules.length, 1);
      expect(rules.single.priority, 10);
    });
  });
}
