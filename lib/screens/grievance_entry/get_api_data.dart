import 'dart:convert';
import 'dart:io';

import 'package:bhoomi_vivad/models/case_status.dart';
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

  late CaseStatus _caseStatus;

  CaseStatus get caseStatus {
    return _caseStatus;
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

  Future<String> uploadGrievanceData(Grievance grievance) async {
    final url = base_url + 'grievance/';
    bool status = false;
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
          },
          body: jsonEncode(grievance));
      //print(response.body);
      final id = jsonDecode(response.body)['id'];
      notifyListeners();
      if (response.statusCode == 201) {
        status = true;
        return id;
      } else {
        throw HttpException("Unable to upload Grievance data !!!");
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> getGrievanceStatus(String trackingId) async {
    if (trackingId.startsWith('GR')) {
      var url = Uri.parse(base_url).authority;
      final uri =
          Uri.http(url, '/api/grievance/', {"grievance_id": trackingId});
      try {
        final response = await http.get(uri, headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        });
        if (response.statusCode == 200) {
          final extractedGrievanceData =
              jsonDecode(utf8.decode(response.bodyBytes));

          _caseStatus = CaseStatus.fromJson(extractedGrievanceData[0]);
          notifyListeners();
        } else {
          throw HttpException("Unable to load Grievance status!!!");
        }
      } catch (error) {
        throw (error);
      }
    }
  }
}
