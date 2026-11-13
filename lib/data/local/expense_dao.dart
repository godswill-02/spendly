import 'package:sqflite/sqflite.dart';
import 'package:spendly/data/local/app_database.dart';
import 'package:spendly/data/models/category_total.dart';
import 'package:spendly/data/models/expense.dart';

class ExpenseDao {
  final AppDatabase _database;

  ExpenseDao({AppDatabase? database}) : _database = database ?? AppDatabase.instance;

  static const _selectWithCategory = '''
    SELECT e.*, c.label AS category_label
    FROM expenses e
    JOIN categories c ON c.id = e.category_id
  ''';

  Future<List<Expense>> getExpenses({
    DateTime? from,
    DateTime? to, // exclusive upper bound
    int? categoryId,
  }) async {
    final db = await _database.database;

    final where = <String>[];
    final args = <Object?>[];
    if (from != null) {
      where.add('e.date >= ?');
      args.add(from.toIso8601String());
    }
    if (to != null) {
      where.add('e.date < ?');
      args.add(to.toIso8601String());
    }
    if (categoryId != null) {
      where.add('e.category_id = ?');
      args.add(categoryId);
    }

    final rows = await db.rawQuery(
      '$_selectWithCategory '
          '${where.isEmpty ? '' : 'WHERE ${where.join(' AND ')}'} '
          'ORDER BY e.date DESC',
      args,
    );
    return rows.map(Expense.fromMap).toList();
  }

  Future<Expense?> getById(String id) async {
    final db = await _database.database;
    final rows = await db.rawQuery(
      '$_selectWithCategory WHERE e.id = ? LIMIT 1',
      [id],
    );
    return rows.isEmpty ? null : Expense.fromMap(rows.first);
  }

  Future<void> insertExpense(Expense expense) async {
    final db = await _database.database;
    await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  /// Returns the number of rows updated (0 = id not found).
  Future<int> updateExpense(Expense expense) async {
    final db = await _database.database;
    return db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  /// Returns the number of rows deleted (0 = id not found).
  Future<int> deleteExpense(String id) async {
    final db = await _database.database;
    return db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> totalBetween(DateTime from, DateTime to) async {
    final db = await _database.database;
    final rows = await db.rawQuery(
      'SELECT COALESCE(SUM(amount), 0) AS total FROM expenses '
          'WHERE date >= ? AND date < ?',
      [from.toIso8601String(), to.toIso8601String()],
    );
    return rows.first['total'] as int;
  }

  Future<List<CategoryTotal>> totalsByCategory(
      DateTime from, DateTime to) async {
    final db = await _database.database;
    final rows = await db.rawQuery('''
      SELECT c.id AS category_id, c.label, SUM(e.amount) AS total
      FROM expenses e
      JOIN categories c ON c.id = e.category_id
      WHERE e.date >= ? AND e.date < ?
      GROUP BY c.id, c.label
      ORDER BY total DESC
    ''', [from.toIso8601String(), to.toIso8601String()]);
    return rows.map(CategoryTotal.fromMap).toList();
  }
}