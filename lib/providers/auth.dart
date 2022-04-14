import 'dart:convert';
import 'dart:io';

import 'package:bhoomi_vivad/constants.dart';
import 'package:bhoomi_vivad/models/http_exception.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/database_helper.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _status;
  final dbHelper = DatabaseHelper.instance;

  bool get isAuth {
    return token != null;
  }

  dynamic get token {
    if (_token != null && _status != "True") return _token;
    return null;
  }



  Future<void> _authenticate(String username, String password) async {
    final url = base_url + 'token/';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(
          {
            'username': username,
            'password': password,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['non_field_errors'] != null) {
        throw HttpException(responseData['non_field_errors'][0]);
      }
      if (username.toUpperCase() == "TEST")
        _status = 'True';
      else
        _status = 'False';
      _token = responseData['token'];
      //await fetchAndSetCircle();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'status': _status,
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signin(String username, String password) async {
    return _authenticate(username, password);
  }

  Future<dynamic> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    _token = extractedUserData['token'];
    _status = extractedUserData['status'];

    if(_status == "True")
      return false;

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _status = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> fetchAndSetUser() async {
    final url = base_url + 'manage/';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader: "Token " + _token.toString()
      });
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        notifyListeners();

        deleteUserData('user');
        updateUserTable('user', responseData);

      } else {
        throw HttpException("Unable to load User data!!!");
      }
    } catch (error) {
      throw (error);
    }
  }

  void updateUserTable(String user, Map<String, dynamic> userData) async
  {
    int result;
    result = await dbHelper.insertTableData(user, userData);
    if(result != null)
      print(result);
  }

  void deleteUserData(String user) async{
    var result = await dbHelper.deleteTableData(user);
    print(result);
  }

}
