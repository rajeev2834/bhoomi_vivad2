import 'dart:convert';
import 'dart:io';

import 'package:bhoomi_vivad/constants.dart';
import 'package:bhoomi_vivad/models/plot_detail.dart';
import 'package:bhoomi_vivad/models/vivad.dart';
import 'package:bhoomi_vivad/utils/database_helper.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UploadVivadProvider with ChangeNotifier {
  final dbHelper = DatabaseHelper.instance;

  String? _token;

  bool get isAuth {
    return token != null;
  }

  dynamic get token {
    if (_token != null) return _token;
    return null;
  }

  List _result = [];

  List get result {
    return [..._result];
  }

  List _editVivads = [];

  List get editVivads {
    return [..._editVivads];
  }

  Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final extractedUserData =
    json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    _token = extractedUserData['token'];
    notifyListeners();
  }

  Future<void> getListEnteredVivad() async {
    final enteredVivad = await dbHelper.queryListVivad();
    _result = enteredVivad;
    notifyListeners();
  }

  Future<void> getVivadWithPlotDetail(String vivad_uuid) async {
    final detailVivadPlot = await dbHelper.queryVivadWithPlot(vivad_uuid);
    _editVivads = detailVivadPlot;
    notifyListeners();
  }

  Future<int> updatePlotDetail(PlotDetail _plotDetail) async {
    try {
      final result = await dbHelper.updatePlotVivadData(
          'plot_detail', _plotDetail.toJson());
      notifyListeners();
      return result;
    } catch (error) {
      throw (error);
    }
  }

  Future<int> updateVivadData(Vivad _vivad) async {
    try {
      final result =
          await dbHelper.updatePlotVivadData('vivad', _vivad.toJson());
      notifyListeners();
      return result;
    } catch (error) {
      throw (error);
    }
  }

  Future<void> deleteVivadData(String vivad_uuid) async {
    try {
      await dbHelper.deleteVivadData(vivad_uuid);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> uploadVivadData() async {
    final plotDetail = await dbHelper.queryAll('plot_detail');
    List<PlotDetail> _plotDetail = [];
    plotDetail.forEach((element) {
      var res = PlotDetail.fromJson(element);
      _plotDetail.add(res);
    });

    final _urlPlot = base_url + 'plot/';
    final _urlVivad = base_url + 'vivad/';

    try {
      print(jsonEncode(_plotDetail));
      final response = await http.post(Uri.parse(_urlPlot),
          headers: {
            HttpHeaders.authorizationHeader: "Token " + _token.toString(),
            'Content-Type': 'application/x-www-form-urlencoded',

          },
          body: jsonEncode(_plotDetail));

      print(response.body);
    } catch (error) {
      throw (error);
    }
  }
}
