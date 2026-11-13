import 'package:spendly/data/local/app_database.dart';
import 'package:spendly/data/models/expense_category.dart';

class CategoryDao {
  final AppDatabase _database;

  CategoryDao({AppDatabase? database})
      : _database = database ?? AppDatabase.instance;

  Future<List<ExpenseCategory>> getCategories() async {
    final db = await _database.database;
    final rows = await db.query('categories', orderBy: 'label COLLATE NOCASE');
    return rows.map(ExpenseCategory.fromMap).toList();
  }

  /// Returns the new row id.
  Future<int> insertCategory(ExpenseCategory category) async {
    final db = await _database.database;
    return db.insert('categories', category.toMap());
  }

  Future<int> updateCategory(ExpenseCategory category) async {
    final db = await _database.database;
    return db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  /// Fails with a foreign key error if expenses still use this category.
  Future<int> deleteCategory(int id) async {
    final db = await _database.database;
    return db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }
}