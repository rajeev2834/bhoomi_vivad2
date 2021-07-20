import 'dart:convert';
import 'dart:io';

import 'package:bhoomi_vivad/models/circle.dart';
import 'package:bhoomi_vivad/models/mauza.dart';
import 'package:bhoomi_vivad/models/panchayat.dart';
import 'package:bhoomi_vivad/models/plot_nature.dart';
import 'package:bhoomi_vivad/models/plot_type.dart';
import 'package:bhoomi_vivad/models/thana.dart';
import 'package:bhoomi_vivad/models/user.dart';
import 'package:bhoomi_vivad/utils/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class AddBaseData with ChangeNotifier {

  final dbHelper = DatabaseHelper.instance;

  String? _token;
  String? _circle_id;

  List<User> _users = [];

  List<User> get users {
    return [..._users];
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
        circleList.circles.forEach((Circle) async{
          await dbHelper.insertTableData('circle', Circle.toJson());
        });
      } else {
        throw HttpException("Unable to load Circle data!!!");
      }
    } catch (error) {
      print('error try');
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
        final extractedPanchayatData = jsonDecode(utf8.decode(response.bodyBytes));
        notifyListeners();
        PanchayatList panchayatList = PanchayatList.fromJson(extractedPanchayatData);
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

  Future<void> fetchAndSetMauza() async {
    final url = base_url + 'mauza/';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader: "Token " + _token.toString()
      });
      if (response.statusCode == 200) {
        final extractedMauzaData = jsonDecode(utf8.decode(response.bodyBytes));
        notifyListeners();
        MauzaList mauzaList = MauzaList.fromJson(extractedMauzaData);
        await dbHelper.deleteTableData('mauza');
        mauzaList.mauzas.forEach((Mauza) async {
          await dbHelper.insertTableData('mauza', Mauza.toJson());
        });
      } else {
        throw HttpException("Unable to load Mauza data!!!");
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetThana() async {
    final url = base_url + 'thana/';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader: "Token " + _token.toString()
      });
      if (response.statusCode == 200) {
        final extractedThanaData = jsonDecode(utf8.decode(response.bodyBytes));
        print(extractedThanaData);
        notifyListeners();
        ThanaList thanaList = ThanaList.fromJson(extractedThanaData);
        await dbHelper.deleteTableData('thana');
       thanaList.thanas.forEach((Thana) async {
          await dbHelper.insertTableData('thana', Thana.toJson());
        });
      } else {
        throw HttpException("Unable to load Thana data!!!");
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetPlotNature() async {
    final url = base_url + 'plot-nature/';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader: "Token " + _token.toString()
      });
      if (response.statusCode == 200) {
        final extractedPlotData = jsonDecode(utf8.decode(response.bodyBytes));
        notifyListeners();
        PlotNatureList plotNatureList = PlotNatureList.fromJson(extractedPlotData);
        await dbHelper.deleteTableData('plot_nature');
        plotNatureList.plot_natures.forEach((PlotNature) async {
          await dbHelper.insertTableData('plot_nature', PlotNature.toJson());
        });
      } else {
        throw HttpException("Unable to load Plot Nature data!!!");
      }
    } catch (error) {
      throw error;
    }
  }
  Future<void> fetchAndSetPlotType() async {
    final url = base_url + 'plot-type/';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader: "Token " + _token.toString()
      });
      if (response.statusCode == 200) {
        final extractedPlotData = jsonDecode(utf8.decode(response.bodyBytes));
        notifyListeners();
        PlotTypeList plotTypeList = PlotTypeList.fromJson(extractedPlotData);
        await dbHelper.deleteTableData('plot_type');
        plotTypeList.plot_types.forEach((PlotType) async {
          await dbHelper.insertTableData('plot_type', PlotType.toJson());
        });
      } else {
        throw HttpException("Unable to load Plot Type data!!!");
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> setPlotData() async{

  }

  Future<void> setVivadData() async{

  }
}