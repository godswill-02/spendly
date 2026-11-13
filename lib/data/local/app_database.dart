import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();

  static Database? _database;

  AppDatabase._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'spendly.db');

    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        // turn on foreign keys, off by default in sqlite
        await db.execute("PRAGMA foreign_keys = ON");
      },
      onCreate: (db, version) async {
        await db.execute(
          '''
            create table categories (
              id integer primary key autoincrement,
              label text not null
            )
          '''
        );
        await db.execute('''
          create table expenses (
            id text primary key,
            amount real not null,
            category_id integer not null,
            date text not null,
            note text,
            payment_method text not null default 'cash',
            foreign key (category_id) references categories(id)
          )
        ''');

        await db.execute(
          "create index idx_expenses_date on expenses(date)"
        );
        final batchCategories = db.batch();
        final categories = [
          "Food", "Transport", "Bills",
          "Shopping", "Health", "Education",
          "Entertainment", "Other"
        ];
        for(final c in categories) {
          batchCategories.insert('categories', {"label": c});
        }
        await batchCategories.commit(noResult: true);
      },
    );
  }
}