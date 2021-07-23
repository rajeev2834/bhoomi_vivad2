import 'package:bhoomi_vivad/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

Future<List> getOpenClosed(bool getAll, String fromdate, String todate) async {
  List result = [];
  Database db = await DatabaseHelper.instance.database;
  List<Map> panchyats = await db.rawQuery("Select * from panchayat");
  List<Map> circles = await db.rawQuery("Select * from circle");
  List<Map> res = !getAll
      ? await db.rawQuery(
          '''Select circle_id, panchayat_id, sum(case_status = 'Pending') as pending, sum(case_status = 'Closed') as closed from vivad 
          where register_date between ? and ? 
          group by panchayat_id
          order by circle_id''', [fromdate, todate])
      : await db.rawQuery(
          '''Select circle_id, panchayat_id, sum(case_status = 'Pending') as pending, sum(case_status = 'Closed') as closed from vivad 
          group by panchayat_id
          order by circle_id
          ''');
  res.forEach((row) {
    String p_id = row["panchayat_id"];
    String c_id = row["circle_id"];
    Map panchayat = panchyats.firstWhere((e) => e['panchayat_id'] == p_id);
    Map circle = circles.firstWhere((e) => e['circle_id'] == c_id);
    Map<String, dynamic> row_ = {
      ...row,
      "panchayat_name_hn": panchayat["panchayat_name_hn"],
      "panchayat_name": panchayat["panchayat_name"],
      "circle_name_hn": circle["circle_name_hn"]
    };
    result.add(row_);
  });
  result.sort((a, b) => a['circle_id'].compareTo(b['circle_id']));
  print(result);
  return result;
}

Future<List> getVivads(String circle_id, String panchayat_id, bool isClosed,
    bool getAll, String fromdate, String todate) async {
  List result = [];
  Database db = await DatabaseHelper.instance.database;
  List<Map> res = getAll
      ? await db.rawQuery(
          '''SELECT vivad.circle_id, circle.circle_name_hn, vivad.panchayat_id, panchayat.panchayat_name_hn, vivad.mauza_id, mauza.mauza_name_hn, plot_detail.khata_no, plot_detail.khesra_no, plot_detail.rakwa, vivad.first_party_name, vivad.first_party_contact, vivad.second_party_name, vivad.second_party_contact, vivad.register_date, vivad.cause_vivad, vivad.case_status
  from vivad
  INNER JOIN circle ON circle.circle_id = vivad.circle_id
  INNER JOIN panchayat ON panchayat.panchayat_id = vivad.panchayat_id
  INNER JOIN mauza ON mauza.mauza_id = vivad.mauza_id
  INNER JOIN plot_detail ON plot_detail.plot_uuid = vivad.plot_uuid
  WHERE vivad.circle_id = ? AND vivad.panchayat_id = ? AND vivad.case_status = ?
  ORDER BY vivad.register_date DESC
  ''', [circle_id, panchayat_id, isClosed ? 'Closed' : 'Pending'])
      : await db.rawQuery(
          '''SELECT vivad.circle_id, circle.circle_name_hn, vivad.panchayat_id, panchayat.panchayat_name_hn, vivad.mauza_id, mauza.mauza_name_hn, plot_detail.khata_no, plot_detail.khesra_no, plot_detail.rakwa, vivad.first_party_name, vivad.first_party_contact, vivad.second_party_name, vivad.second_party_contact, vivad.register_date, vivad.cause_vivad, vivad.case_status
  from vivad
  INNER JOIN circle ON circle.circle_id = vivad.circle_id
  INNER JOIN panchayat ON panchayat.panchayat_id = vivad.panchayat_id
  INNER JOIN mauza ON mauza.mauza_id = vivad.mauza_id
  INNER JOIN plot_detail ON plot_detail.plot_uuid = vivad.plot_uuid
  WHERE vivad.circle_id = ? vivad.panchayat_id = ? AND vivad.case_status = ? AND (vivad.register_date BETWEEN ? AND ?)
  ORDER BY vivad.register_date DESC
  ''',
          [
              circle_id,
              panchayat_id,
              isClosed ? 'Closed' : 'Pending',
              fromdate,
              todate,
            ]);
  res.forEach((element) {
    print(element);
  });
  result = res.map((e) => Map.from(e)).toList();
  return result;
}
