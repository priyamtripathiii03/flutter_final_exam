import 'dart:developer';
import 'package:flutter_final_exam/modals/expense_modal.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DbServices {
  DbServices._();

  static final DbServices dbServices = DbServices._();
  Database? _database;
  String tableName = 'expenses';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDatabase();
      return _database!;
    }
  }

  Future<Database> initDatabase() async {
    final filePath = await getDatabasesPath();
    final dbPath = path.join(filePath, 'expense.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          amount REAL,
          date TEXT,
          category TEXT
        )''');
      },
    );
  }

  // Insert an expense
  Future<void> insertExpense(Expense expense) async {
    final db = await database;
    await db.insert(
      tableName,
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all expenses
  Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => Expense.fromMap(maps[i]));
  }

  // Update an expense
  Future<void> updateExpense(Expense expense) async {
    final db = await database;
    await db.update(
      tableName,
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  // Delete an expense
  Future<void> deleteExpense(int id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
