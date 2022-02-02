import 'package:bhoomi_vivad/models/circle.dart';
import 'package:bhoomi_vivad/models/panchayat.dart';
import 'package:bhoomi_vivad/models/vivad_type.dart';
import 'package:bhoomi_vivad/utils/database_helper.dart';
import 'package:flutter/material.dart';

class GetBaseData with ChangeNotifier {
  final dbHelper = DatabaseHelper.instance;

  List<Circle> _circles = [];

  List<Circle> get circles {
    return [..._circles];
  }

  List<Panchayat> _panchayats = [];

  List<Panchayat> get panchayats {
    return [..._panchayats];
  }

  List<VivadType> _vivadTypes = [];

  List<VivadType> get vivadTypes{
    return [..._vivadTypes];
  }


  Future<void> getCircleData(int _userId) async {
    final circleData = await dbHelper.queryTableByUser('circle', _userId);
    _circles = circleData
        .map(
          (e) => Circle(
              circleId: e['circle_id'],
              circleNameHn: e['circle_name_hn'],
              user: e['user']),
        )
        .toList();
    notifyListeners();
  }

  Future<void> getPanchayatData() async {
    final panchayatData = await dbHelper.queryAll('panchayat');
    _panchayats = panchayatData
        .map(
          (e) => Panchayat(
              circle_id: e['circle_id'],
              panchayat_id: e['panchayat_id'],
              panchayat_name: e['panchayat_name'],
              panchayat_name_hn: e['panchayat_name_hn']),
        )
        .toList();
    notifyListeners();
  }

  Future<void> getVivadTypeData() async{
    final vivadTypeData = await dbHelper.queryAll('vivad_type');
    _vivadTypes = vivadTypeData.map((e) => VivadType(
        id: e['id'],
        vivad_type_hn: e['vivad_type_hn']),
    )
    .toList();
    notifyListeners();
  }

}
