import 'package:bhoomi_vivad/models/circle.dart';
import 'package:bhoomi_vivad/models/mauza.dart';
import 'package:bhoomi_vivad/models/panchayat.dart';
import 'package:bhoomi_vivad/models/plot_nature.dart';
import 'package:bhoomi_vivad/models/plot_type.dart';
import 'package:bhoomi_vivad/models/thana.dart';
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

  List<Mauza> _mauzas = [];

  List<Mauza> get mauzas {
    return [..._mauzas];
  }

  List<Thana> _thanas = [];

  List<Thana> get thanas {
    return [..._thanas];
  }

  List<PlotType> _plot_types = [];

  List<PlotType> get plot_types {
    return [..._plot_types];
  }

  List<PlotNature> _plot_nature = [];

  List<PlotNature> get plot_nature {
    return [..._plot_nature];
  }

  Future<void> getCircleData() async {
    final circleData = await dbHelper.queryAll('circle');
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
    print(panchayatData.length);
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

  Future<void> getMauzaData(String? panchayatId) async {
    final mauzaData =
        await dbHelper.queryMauzaByPanchayat('mauza', panchayatId!);
    _mauzas = mauzaData
        .map(
          (e) => Mauza(
            circle_id: e['circle_id'],
            panchayat_id: e['panchayat_id'],
            mauza_id: e['mauza_id'],
            mauza_name_hn: e['mauza_name_hn'],
          ),
        )
        .toList();
    notifyListeners();
  }

  Future<void> getThanaData() async {
    final thanaData = await dbHelper.queryAll('thana');
    _thanas = thanaData
        .map(
          (e) => Thana(
              circle_id: e['circle_id'],
              thana_id: e['thana_id'],
              thana_name_hn: e['thana_name_hn']),
        )
        .toList();
    notifyListeners();
  }

  Future<void> getPlotTypeData() async {
    final plotTypeData = await dbHelper.queryAll('plot_type');
    _plot_types = plotTypeData
        .map(
          (e) => PlotType(id: e['id'], plot_type: e['plot_type']),
        )
        .toList();
    notifyListeners();
  }

  Future<void> getPlotNatureData() async {
    final plotNatureData = await dbHelper.queryAll('plot_nature');
    _plot_nature = plotNatureData
        .map(
          (e) => PlotNature(id: e['id'], plot_nature: e['plot_nature']),
        )
        .toList();
    notifyListeners();
  }
}
