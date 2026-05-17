import 'package:drift/drift.dart' hide isNull;
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

  group('incrementHitCounts', () {
    test('adds the given delta to existing hit_count and updates last_hit_at',
        () async {
      await repo.insertRules([
        makeRule(id: 'a', priority: 100),
        makeRule(id: 'b', priority: 200),
        makeRule(id: 'c', priority: 300),
      ]);
      final t0 = 1_700_000_000_000;

      // First flush: a gets 3 hits, b gets 1.
      await repo.incrementHitCounts({'a': 3, 'b': 1}, t0);
      var rules = await repo.getAllRules();
      var byId = {for (final r in rules) r.id: r};
      expect(byId['a']!.hitCount, 3);
      expect(byId['b']!.hitCount, 1);
      expect(byId['c']!.hitCount, 0);
      expect(byId['a']!.lastHitAt, t0);
      expect(byId['b']!.lastHitAt, t0);
      expect(byId['c']!.lastHitAt, isNull);

      // Second flush: a gets +2 more (cumulative 5), c gets 4 (first hit).
      final t1 = t0 + 60_000;
      await repo.incrementHitCounts({'a': 2, 'c': 4}, t1);
      rules = await repo.getAllRules();
      byId = {for (final r in rules) r.id: r};
      expect(byId['a']!.hitCount, 5);
      expect(byId['a']!.lastHitAt, t1);
      // b was unchanged in second flush.
      expect(byId['b']!.hitCount, 1);
      expect(byId['b']!.lastHitAt, t0);
      expect(byId['c']!.hitCount, 4);
      expect(byId['c']!.lastHitAt, t1);
    });

    test('empty hits map is a no-op', () async {
      await repo.insertRules([makeRule(id: 'a', priority: 100)]);

      await repo.incrementHitCounts({}, 1_700_000_000_000);

      final rule = (await repo.getAllRules()).single;
      expect(rule.hitCount, 0);
      expect(rule.lastHitAt, isNull);
    });

    test('updates only the targeted rule', () async {
      await repo.insertRules([
        makeRule(id: 'a', priority: 100),
        makeRule(id: 'b', priority: 200),
      ]);
      final t = 1_700_000_000_000;

      await repo.incrementHitCounts({'b': 1}, t);

      final rules = await repo.getAllRules();
      final byId = {for (final r in rules) r.id: r};
      expect(byId['a']!.hitCount, 0);
      expect(byId['a']!.lastHitAt, isNull);
      expect(byId['b']!.hitCount, 1);
      expect(byId['b']!.lastHitAt, t);
    });
  });
}
