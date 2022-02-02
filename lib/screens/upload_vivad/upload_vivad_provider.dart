import 'dart:convert';
import 'dart:io';

import 'package:bhoomi_vivad/constants.dart';
import 'package:bhoomi_vivad/models/vivad.dart';
import 'package:bhoomi_vivad/models/vivad_api.dart';
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

  Future<void> getVivadDetail(String vivad_uuid) async {
    final detailVivad = await dbHelper.queryVivadDetail(vivad_uuid);
    _editVivads = detailVivad;
    notifyListeners();
  }

  Future<int> updateVivadData(Vivad _vivad) async {
    try {
      final result =
      await dbHelper.updateVivadData('vivad', _vivad.toJson());
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

    final vivadData = await dbHelper.queryAll('vivad');
    List<VivadApi> _vivadApiList = [];
    vivadData.forEach((element) {
      var res = VivadApi.fromJson(element);
      _vivadApiList.add(res);
    });

    final url = base_url + 'vivad/';
    try{
      final response = await http.post(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader: "Token " + _token.toString(),
        "Content-Type" : "application/json; charset=UTF-8",
      },
        body: jsonEncode(_vivadApiList[0])
      );
      print(jsonEncode(_vivadApiList[0]));
      print(response.body);
    }catch(error){
      throw(error);
    }
  }
}
