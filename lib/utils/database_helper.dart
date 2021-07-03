import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static Database? _database;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<dynamic> get database async {
    if (_database != null) return _database;
    _database = await _initializeDatabase();
    return _database;
  }

  Future<Database> _initializeDatabase() async {
    Directory pathDirectory = await getApplicationDocumentsDirectory();
    String path = join(pathDirectory.path, 'bhoomi_vivad.db');
    var bhoomiVivadDb = await openDatabase(path,
        version: 1, onCreate: _createDb);
    return bhoomiVivadDb;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE user (id integer primary key, first_name text not null)');
  }


  Future<int> insertTableData(String table, Map<String, dynamic> rows) async {
    final Database db = await instance.database;
    var result = await db.insert(table, rows);
    return result;
  }


  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> deleteTableData(String table) async {
    Database db = await instance.database;
    var result = await db.delete(table);
    return result;
  }
}