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
        version: 4, onCreate: _createDb, onUpgrade: _onUpgrade);
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
        'CREATE TABLE plot_detail (plot_uuid text primary key, circle_id text, panchayat_id text, mauza_id integer,'
            ' khata_no text, khesra_no text, rakwa decimal, chauhaddi text, plot_type_id integer, plot_nature_id integer, latitude decimal,'
            'longitude decimal, image blob, is_govtPlot boolean default No, remarks text,'
            ' Foreign Key (circle_id) REFERENCES circle (circle_id) on delete no action on update no action,'
            ' FOREIGN KEY (panchayat_id) References panchayat (panchayat_id) on delete no action on update no action,'
            ' FOREIGN KEY (mauza_id) References mauza (mauza_id) on delete no action on update no action,'
            ' Foreign Key (plot_type_id) References plot_type (id) on delete no action on update no action,'
            'Foreign Key (plot_nature_id) References plot_nature (id) on delete no action on update no action )');
    await db.execute(
        'CREATE TABLE vivad (vivad_uuid text primary key, circle_id text, panchayat_id text, mauza_id integer, thana_no int, first_party_name text,'
            'first_party_contact text, first_party_address text, second_party_name text, second_party_contact text, second_party_address text,'
            'abhidari_name text, plot_uuid text, cause_vivad text, is_violence boolean default false, violence_detail text, is_fir boolean default false,'
            ' notice_order text, is_courtpending boolean default false, court_status text, case_status text,register_date date, next_date date, remarks text,'
            ' Foreign Key (circle_id) REFERENCES circle (circle_id) on delete no action on update no action,'
            ' FOREIGN KEY (panchayat_id) References panchayat (panchayat_id) on delete no action on update no action,'
            ' FOREIGN KEY (mauza_id) References mauza (mauza_id) on delete no action on update no action,'
            ' Foreign Key (plot_uuid) References plot_detail (plot_uuid) on delete no action on update no action )');
    await db.execute(
        'CREATE TABLE hearing (vivad_uuid text, is_first_present boolean default Yes,'
            ' is_second_present boolean default Yes, hearing_date date,remarks text, '
            ' Foreign Key (vivad_uuid) REFERENCES vivad (vivad_uuid) on delete no action on update no action)');

  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute('DROP Table hearing');
      await db.execute('DROP Table vivad');
      await db.execute('DROP Table plot_detail');
      await db.execute(
          'CREATE TABLE plot_detail (plot_uuid text primary key, circle_id text, panchayat_id text, mauza_id integer,'
          ' khata_no text, khesra_no text, rakwa decimal, chauhaddi text, plot_type_id integer, plot_nature_id integer, latitude decimal,'
          'longitude decimal, image blob, is_govtPlot boolean default No, remarks text,'
          ' Foreign Key (circle_id) REFERENCES circle (circle_id) on delete no action on update no action,'
          ' FOREIGN KEY (panchayat_id) References panchayat (panchayat_id) on delete no action on update no action,'
          ' FOREIGN KEY (mauza_id) References mauza (mauza_id) on delete no action on update no action,'
          ' Foreign Key (plot_type_id) References plot_type (id) on delete no action on update no action,'
          'Foreign Key (plot_nature_id) References plot_nature (id) on delete no action on update no action )');
      await db.execute(
          'CREATE TABLE vivad (vivad_uuid text primary key, circle_id text, panchayat_id text, mauza_id integer, thana_no int, first_party_name text,'
          'first_party_contact text, first_party_address text, second_party_name text, second_party_contact text, second_party_address text,'
          'abhidari_name text, plot_uuid text, cause_vivad text, is_violence boolean default false, violence_detail text, is_fir boolean default false,'
          ' notice_order text, is_courtpending boolean default false, court_status text, case_status text,register_date date, next_date date, remarks text,'
          ' Foreign Key (circle_id) REFERENCES circle (circle_id) on delete no action on update no action,'
          ' FOREIGN KEY (panchayat_id) References panchayat (panchayat_id) on delete no action on update no action,'
          ' FOREIGN KEY (mauza_id) References mauza (mauza_id) on delete no action on update no action,'
          ' Foreign Key (plot_uuid) References plot_detail (plot_uuid) on delete no action on update no action )');
      await db.execute(
          'CREATE TABLE hearing (vivad_uuid text, is_first_present boolean default Yes,'
              ' is_second_present boolean default Yes, hearing_date date,remarks text, '
              ' Foreign Key (vivad_uuid) REFERENCES vivad (vivad_uuid) on delete no action on update no action)');
    }
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

  Future<List<Map<String, dynamic>>> queryTableByUser(
      String table, int user) async {
    final Database db = await instance.database;
    var result = await db.query(table, where: "user = ?", whereArgs: [user]);
    return result;
  }

  Future<List<Map<String, dynamic>>> queryMauzaByPanchayat(
      String table, String panchayatId) async {
    Database db = await instance.database;
    return await db
        .query(table, where: "panchayat_id = ?", whereArgs: [panchayatId]);
  }

  Future<int> deleteTableData(String table) async {
    Database db = await instance.database;
    var result = await db.delete(table);
    return result;
  }
}
