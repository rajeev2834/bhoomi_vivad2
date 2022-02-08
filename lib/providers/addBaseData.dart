import 'dart:convert';
import 'dart:io';

import 'package:bhoomi_vivad/models/circle.dart';
import 'package:bhoomi_vivad/models/panchayat.dart';

import 'package:bhoomi_vivad/models/user.dart';
import 'package:bhoomi_vivad/models/vivad.dart';
import 'package:bhoomi_vivad/models/vivad_type.dart';
import 'package:bhoomi_vivad/utils/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'auth.dart';

class AddBaseData with ChangeNotifier {
  final dbHelper = DatabaseHelper.instance;

  String? _token;

  List<User> _users = [];

  List<User> get users {
    return [..._users];
  }

  dynamic get token {
    if (_token != null) return _token;
    return null;
  }

  Future<void> getUserData() async {
    final userData = await dbHelper.queryAll('user');
    _users = userData
        .map(
          (item) => User(
            firstName: item['first_name'],
            id: item['id'],
          ),
        )
        .toList();
    notifyListeners();
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
  Future<void> fetchAndSetCircle() async {
    final url = base_url + 'circle/';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader: "Token " + _token.toString()
      });
      if (response.statusCode == 200) {
        final extractedCircleData = jsonDecode(utf8.decode(response.bodyBytes));
        notifyListeners();
        CircleList circleList = CircleList.fromJson(extractedCircleData);
        await dbHelper.deleteTableData('circle');
        circleList.circles.forEach((Circle) async {
          await dbHelper.insertTableData('circle', Circle.toJson());
        });
      } else {
        throw HttpException("Unable to load Circle data!!!");
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetPanchayat() async {
    final url = base_url + 'panchayat/';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader: "Token " + _token.toString()
      });
      if (response.statusCode == 200) {
        final extractedPanchayatData =
            jsonDecode(utf8.decode(response.bodyBytes));
        notifyListeners();
        PanchayatList panchayatList =
            PanchayatList.fromJson(extractedPanchayatData);
        await dbHelper.deleteTableData('panchayat');
        panchayatList.panchayats.forEach((Panchayat) async {
          await dbHelper.insertTableData('panchayat', Panchayat.toJson());
        });
      } else {
        throw HttpException("Unable to load Panchayat data!!!");
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetVivadType() async {
    final url = base_url + 'vivad-type/';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader: "Token " + _token.toString()
      });
      if (response.statusCode == 200) {
        final extractedVivadTypeData =
        jsonDecode(utf8.decode(response.bodyBytes));
        notifyListeners();
        VivadTypeList vivadTypeList =
        VivadTypeList.fromJson(extractedVivadTypeData);
        await dbHelper.deleteTableData('vivad_type');
        vivadTypeList.vivadTypes.forEach((VivadType) async {
          await dbHelper.insertTableData('vivad_type', VivadType.toJson());
        });
      } else {
        throw HttpException("Unable to load Vivad Type data!!!");
      }
    } catch (error) {
      throw error;
    }
  }

  Future<int> insertVivadData(Vivad _vivadData) async {
    try {
      final result =
          await dbHelper.insertTableData('vivad', _vivadData.toJson());
      notifyListeners();
      return result;
    } catch (error) {
      throw (error);
    }
  }

  Future<void> closeDatabaseInstance() async {
    await dbHelper.closeDatabase();
  }
}
