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
        version: 1, onCreate: _createDb, onUpgrade: _onUpgrade);
    return bhoomiVivadDb;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE user (id integer primary key, first_name text not null)');
    await db.execute(
        'CREATE TABLE circle (circle_id text, circle_name_hn text, user int)');
    await db.execute(
        'CREATE TABLE panchayat (panchayat_id integer Primary Key, circle_id text, panchayat_name text, panchayat_name_hn text,'
            ' Foreign Key (circle_id) REFERENCES circle (circle_id) on delete no action on update no action)');
    await db.execute(
      'CREATE TABLE vivad_type (id integer primary key, vivad_type_hn text not null)');
    await db.execute(
        'CREATE TABLE vivad(vivad_uuid Text PRIMARY KEY, register_no Text, register_date date, circle_id text, panchayat_id integer,'
            ' first_party_name text, first_party_contact text, first_party_address text, second_party_name text, second_party_contact text,'
            ' second_party_address text, thana_no text, mauza text, khata_no text, khesra_no text, rakwa text, chauhaddi text,'
            'vivad_type_id integer, case_detail text, is_violence boolean not null check (is_violence in (0, 1)), violence_detail text,'
            ' is_fir boolean not null check (is_fir in (0, 1)), notice_order text, is_courtpending boolean not null check (is_courtpending in (0, 1)),'
            ' court_status text, case_status text, next_hearing_date date, remarks text,'
            ' Foreign Key (circle_id) REFERENCES circle (circle_id) on delete no action on update no action,'
            ' FOREIGN KEY (panchayat_id) References panchayat (panchayat_id) on delete no action on update no action,'
            ' FOREIGN KEY (vivad_type_id) References vivad_type(id) on delete no action on update no action)');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {}
  }

  Future<int> insertTableData(String table, Map<String, dynamic> rows) async {
    final Database db = await instance.database;
    var result = await db.insert(table, rows,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryPanchayatByCircle(String circleId) async{

    Database db = await instance.database;
   var result = await db.rawQuery(''' SELECT * from panchayat where circle_id = ?''',
            [circleId]);

    return result;
  }

  Future<List<Map<String, dynamic>>> queryTableByUser(String table,
      int _userId) async {
    final Database db = await instance.database;
    var result = await db.query(table, where: "user = ?", whereArgs: [_userId]);
    return result;
  }

  Future<List<Map<String, dynamic>>> queryVivadWithAllTables() async {
    Database db = await instance.database;
    String query =
        'Select V.*, P.panchayat_name_hn from vivad as V left join panchayat as P'
        ' on V.panchayat_id = P.panchayat_id';
    return await db.rawQuery(query);
  }

  Future<List> queryListVivad() async {
    List result = [];
    Database db = await DatabaseHelper.instance.database;
    List<Map> res = await db.rawQuery(
        ''' SELECT * from vivad INNER JOIN panchayat ON panchayat.panchayat_id = vivad.panchayat_id 
        INNER JOIN vivad_type ON vivad_type.id = vivad.vivad_type_id 
        ORDER BY vivad.register_date DESC, panchayat.panchayat_name_hn ASC ''');

    result = res.map((e) => Map.from(e)).toList();
    return result;
  }

  Future<List> queryVivadDetail(String vivad_uuid) async {
    List result = [];
    Database db = await DatabaseHelper.instance.database;
    List<Map> res = await db.rawQuery(''' SELECT * from vivad where vivad_uuid = ?''',
        [vivad_uuid]);

    result = res.map((e) => Map.from(e)).toList();
    return result;
  }

  Future<int> updateVivadData(String table,
      Map<String, dynamic> rows) async {
    Database db = await instance.database;
    var result;
    if (table == 'vivad') {
      result = await db.update(
          table, rows, where: 'vivad_uuid=?', whereArgs: [rows['vivad_uuid']]);
    }
    return result;
  }

  Future<int> deleteTableData(String table) async {
    Database db = await instance.database;
    var result = await db.delete(table);
    return result;
  }

  Future<void> deleteVivadData(String vivad_uuid) async {
    Database db = await instance.database;
    await db.delete('vivad', where: 'vivad_uuid = ?', whereArgs: ['vivad_uuid']);
  }

  Future<void> closeDatabase() async {
    Database db = await instance.database;
    await db.close();
  }
}
