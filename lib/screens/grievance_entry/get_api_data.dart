import 'dart:convert';
import 'dart:io';

import 'package:bhoomi_vivad/models/circle.dart';
import 'package:bhoomi_vivad/models/grievance.dart';
import 'package:bhoomi_vivad/models/panchayat.dart';
import 'package:bhoomi_vivad/models/vivad_type.dart';
import 'package:bhoomi_vivad/providers/auth.dart';
import 'package:bhoomi_vivad/utils/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import 'package:http/http.dart' as http;

class GetApiData with ChangeNotifier {
  final dbHelper = DatabaseHelper.instance;
  String? _token;

  dynamic get token {
    if (_token != null) return _token;
    return null;
  }

  List<Circle> _circles = [];

  List<Circle> get circles {
    return [..._circles];
  }

  List<Panchayat> _panchayats = [];

  List<Panchayat> get panchayats {
    return [..._panchayats];
  }

  List<VivadType> _vivadTypes = [];

  List<VivadType> get vivadTypes {
    return [..._vivadTypes];
  }

  Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    _token = extractedUserData['token'];
    notifyListeners();
  }

  Future<void> checkAndSetToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      await new Auth().signin("Test", "Test@123");
    }
  }

  Future<void> getCircleList() async {
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

  Future<void> getPanchayatList(String circleId) async {
    final panchayatData = await dbHelper.queryPanchayatByCircle(circleId);
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

  Future<bool> uploadGrievanceData(Grievance grievance) async{
   print(jsonEncode(grievance));
   return false;
   /* final url = base_url + '/grievance';
    bool status = false;
    try{
      final response = await http.post(Uri.parse(url), headers: {
        "Content-Type" : "application/json; charset=UTF-8",
      },
          body: jsonEncode(grievance);
      );
      //print(response.body);
      notifyListeners();
      if(response.statusCode == 201){
        status = true;
        return status;
      }else {
        throw HttpException("Unable to upload Grievance data !!!");
      }
    }catch(error){
      throw(error);
    }*/
  }
}
