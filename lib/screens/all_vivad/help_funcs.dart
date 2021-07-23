import 'package:bhoomi_vivad/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

Future<List> getOpenClosed(bool getAll, String fromdate, String todate) async {
  List result = [];
  Database db = await DatabaseHelper.instance.database;
  List<Map> panchyats = await db.rawQuery("Select * from panchayat");
  List<Map> res = !getAll
      ? await db.rawQuery(
          "Select panchayat_id, sum(case_status = 'Pending') as pending, sum(case_status = 'Closed') as closed from vivad where register_date between ? and ? group by panchayat_id",
          [
              fromdate,
              todate
            ])
      : await db.rawQuery(
          "Select panchayat_id, sum(case_status = 'Pending') as pending, sum(case_status = 'Closed') as closed from vivad group by panchayat_id");
  res.forEach((row) {
    String p_id = row["panchayat_id"];
    Map panchayat = panchyats.firstWhere((e) => e['panchayat_id'] == p_id);
    Map<String, dynamic> row_ = {
      ...row,
      "panchayat_name_hn": panchayat["panchayat_name_hn"],
      "panchayat_name": panchayat["panchayat_name"]
    };
    result.add(row_);
  });
  result.sort((a, b) => a['panchayat_name'].compareTo(b['panchayat_name']));
  print(result);
  return result;
}
