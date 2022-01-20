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
        'CREATE TABLE panchayat (panchayat_id text Primary Key, circle_id text, panchayat_name text, panchayat_name_hn text,'
            ' Foreign Key (circle_id) REFERENCES circle (circle_id) on delete no action on update no action)');
    await db.execute(
        ' CREATE TABLE mauza (mauza_id integer Primary Key, circle_id text, panchayat_id text, mauza_name text, mauza_name_hn text,'
            ' FOREIGN KEY (circle_id) References circle (circle_id) on delete no action on update no action,'
            ' FOREIGN KEY (panchayat_id) References panchayat (panchayat_id) on delete no action on update no action)');
    await db.execute(
        'CREATE TABLE thana (thana_id integer primary key, circle_id text, thana_name_hn text,'
            ' Foreign Key (circle_id) REFERENCES circle (circle_id) on delete no action on update no action)');
    await db.execute(
        'CREATE TABLE plot_nature (id integer primary key, plot_nature text)');
    await db.execute(
        'CREATE TABLE plot_type (id integer primary key, plot_type text)');
    await db.execute(
        'CREATE TABLE plot_detail (plot_uuid text primary key, circle_id text, panchayat_id text, mauza_id integer, thana_no text,'
            ' khata_no text, khesra_no text, rakwa decimal, chauhaddi text, plot_type_id integer, plot_nature_id integer, vivad_uuid text, latitude decimal, '
            'longitude decimal, image blob, is_govtPlot boolean not null check (is_govtPlot in (0, 1)), remarks text,'
            ' Foreign Key (circle_id) REFERENCES circle (circle_id) on delete no action on update no action,'
            ' FOREIGN KEY (panchayat_id) References panchayat (panchayat_id) on delete no action on update no action,'
            ' FOREIGN KEY (mauza_id) References mauza (mauza_id) on delete no action on update no action,'
            ' Foreign Key (plot_type_id) References plot_type (id) on delete no action on update no action,'
            ' Foreign Key (plot_nature_id) References plot_nature (id) on delete no action on update no action ,'
            ' Foreign Key (vivad_uuid) References vivad (vivad_uuid) on delete no action on update no action' );
    await db.execute(
        'CREATE TABLE vivad (vivad_uuid text primary key, circle_id text, panchayat_id text, mauza_id integer, thana_no int, first_party_name text,'
            'first_party_contact text, first_party_address text, second_party_name text, second_party_contact text, second_party_address text,'
            'abhidari_name text, cause_vivad text, is_violence boolean not null check (is_violence in (0, 1)), violence_detail text,'
            ' is_fir boolean not null check (is_fir in (0, 1)), notice_order text, is_courtpending boolean not null check (is_courtpending in (0, 1)),'
            ' court_status text, case_status text,register_date date, next_date date, remarks text,'
            ' Foreign Key (circle_id) REFERENCES circle (circle_id) on delete no action on update no action,'
            ' FOREIGN KEY (panchayat_id) References panchayat (panchayat_id) on delete no action on update no action,'
            ' FOREIGN KEY (mauza_id) References mauza (mauza_id) on delete no action on update no action,');
    await db.execute(
        'CREATE TABLE hearing (vivad_uuid text, is_first_present boolean not null check (is_first_present in (0, 1)),'
            ' is_second_present boolean not null check (is_second_present in (0, 1)), hearing_date date,remarks text, '
            ' Foreign Key (vivad_uuid) REFERENCES vivad (vivad_uuid) on delete no action on update no action)');
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

  Future<List<Map<String, dynamic>>> queryTableByUser(String table,
      int _userId) async {
    final Database db = await instance.database;
    var result = await db.query(table, where: "user = ?", whereArgs: [_userId]);
    return result;
  }

  Future<List<Map<String, dynamic>>> queryMauzaByPanchayat(String table,
      String panchayatId) async {
    Database db = await instance.database;
    return await db
        .query(table, where: "panchayat_id = ?", whereArgs: [panchayatId]);
  }

  Future<List<Map<String, dynamic>>> queryVivadWithAllTables() async {
    Database db = await instance.database;
    String query =
        'Select V.*, P.panchayat_name_hn, M.mauza_name_hn from vivad as V left join panchayat as P'
        ' on V.panchayat_id = P.panchayat_id left join mauza as M on V.mauza_id = M.mauza_id';
    return await db.rawQuery(query);
  }

  Future<List> queryListVivad() async {
    List result = [];
    Database db = await DatabaseHelper.instance.database;
    List<Map> res = await db.rawQuery(
        ''' SELECT vivad.vivad_uuid, vivad.panchayat_id, panchayat.panchayat_name_hn, vivad.mauza_id, mauza.mauza_name_hn, plot_detail.khata_no, plot_detail.khesra_no, plot_detail.rakwa, vivad.first_party_name, vivad.first_party_contact, vivad.first_party_address, vivad.second_party_address, vivad.second_party_name, vivad.second_party_contact, vivad.register_date, vivad.cause_vivad, vivad.case_status
  from vivad
  INNER JOIN panchayat ON panchayat.panchayat_id = vivad.panchayat_id
  INNER JOIN mauza ON mauza.mauza_id = vivad.mauza_id
  INNER JOIN plot_detail ON plot_detail.plot_uuid = vivad.plot_uuid
  ORDER BY vivad.panchayat_id, vivad.mauza_id ASC ''');

    result = res.map((e) => Map.from(e)).toList();
    return result;
  }

  Future<List> queryVivadWithPlot(String vivad_uuid) async {
    List result = [];
    Database db = await DatabaseHelper.instance.database;
    List<Map> res = await db.rawQuery(''' SELECT v.*, p.khata_no, p.khesra_no, p.rakwa, p.chauhaddi, p.plot_type_id, p.plot_nature_id
    from vivad as v inner join plot_detail as p ON p.plot_uuid = v.plot_uuid where v.vivad_uuid = ?''',
        [vivad_uuid]);

    result = res.map((e) => Map.from(e)).toList();
    return result;
  }

  Future<int> updatePlotVivadData(String table,
      Map<String, dynamic> rows) async {
    Database db = await instance.database;
    var result;
    if (table == 'vivad') {
      result = await db.update(
          table, rows, where: 'vivad_uuid=?', whereArgs: [rows['vivad_uuid']]);
    } else {
      result = await db.update(
          table, rows, where: 'plot_uuid=?', whereArgs: [rows['plot_uuid']]);
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
    await db.rawQuery(
        'Select plot_uuid from vivad where vivad_uuid = ?', [vivad_uuid]).then((
        value) {
          db.delete('plot_detail', where: 'plot_uuid=?', whereArgs: [value[0]['plot_uuid']]);
    });

    await db.delete('vivad', where: 'vivad_uuid = ?', whereArgs: ['vivad_uuid']);
  }

  Future<void> closeDatabase() async {
    Database db = await instance.database;
    await db.close();
  }
}
