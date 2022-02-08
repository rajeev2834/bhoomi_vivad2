import 'dart:convert';
import 'dart:io';

import 'package:bhoomi_vivad/models/circle.dart';
import 'package:bhoomi_vivad/models/panchayat.dart';
import 'package:bhoomi_vivad/models/vivad_type.dart';
import 'package:bhoomi_vivad/providers/auth.dart';
import 'package:bhoomi_vivad/utils/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import 'package:http/http.dart' as http;

class GetApiData with ChangeNotifier {
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
    final url = base_url + 'circle/';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader: "Token " + _token.toString()
      });
      if (response.statusCode == 200) {
        final extractedCircleData = jsonDecode(utf8.decode(response.bodyBytes));
        _circles = extractedCircleData
            .map(
              (e) => Circle(
                  circleId: e['circle_id'],
                  circleNameHn: e['circle_name_hn'],
                  user: e['user']),
            )
            .toList();
        notifyListeners();
      } else {
        throw HttpException("Unable to load Circle data!!!");
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> getPanchayatList(String circleId) async {
    final qParams = {
      'circle': circleId,
    };
    final uri = Uri.https(base_url, 'panchayat/', qParams);
    try {
      final response = await http.get(uri, headers: {
        HttpHeaders.authorizationHeader: "Token " + _token.toString(),
        HttpHeaders.contentTypeHeader: 'application/json',
      });
      if (response.statusCode == 200) {
        final extractedCircleData = jsonDecode(utf8.decode(response.bodyBytes));
        _circles = extractedCircleData
            .map(
              (e) => Circle(
                  circleId: e['circle_id'],
                  circleNameHn: e['circle_name_hn'],
                  user: e['user']),
            )
            .toList();
        notifyListeners();
      } else {
        throw HttpException("Unable to load Circle data!!!");
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> getVivadType() async {
    final url = base_url + 'vivad-type/';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader: "Token " + _token.toString()
      });
      if (response.statusCode == 200) {
        final extractedVivadType = jsonDecode(utf8.decode(response.bodyBytes));
        _vivadTypes = extractedVivadType
            .map(
              (e) => VivadType(id: e['id'], vivad_type_hn: e['vivad_type_hn']),
            )
            .toList();
        notifyListeners();
      } else {
        throw HttpException("Unable to load Circle data!!!");
      }
    } catch (error) {
      throw (error);
    }
  }
}
