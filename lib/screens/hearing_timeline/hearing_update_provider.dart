import 'dart:convert';
import 'dart:io';

import 'package:bhoomi_vivad/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:bhoomi_vivad/models/http_exception.dart';

import '../../models/hearing.dart';

class HearingUpdateProvider with ChangeNotifier{

  late HearingList _hearingStatusList;

  HearingList get hearingStatusList {
    return _hearingStatusList;
  }


  Future<bool> updateHearing(Map<String, dynamic> statusUpdateVariable) async {
    var grievance_id = statusUpdateVariable['vivad_id'].toString();
    String table = "hearing-create";

    String id = statusUpdateVariable['id'].toString();
    String _token = statusUpdateVariable['token'].toString();

    final Url = base_url + '$table/';
    bool status = false;
    try {
      final response = await http.post(Uri.parse(Url),
          headers: {
            "Authorization": "Token " + _token.toString(),
            "Content-Type": "application/json; charset=UTF-8",
          },
          body: jsonEncode({
            'grievance_id' : grievance_id,
            'status': statusUpdateVariable['case_status'],
            'hearing_date': statusUpdateVariable['hearingDate'] == "" ? null : statusUpdateVariable['hearingDate'],
            'remarks': statusUpdateVariable['remarks'],
            'user' : statusUpdateVariable['user'],
          }));
      print(response.body);
      notifyListeners();
      if (response.statusCode == 201) {
        status = true;
        return status;
      } else {
        throw HttpException("Unable to upload hearing data !!!");
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> getHearingData(String grievanceId) async{
    String table = 'hearing/';
    var url = Uri.parse(base_url).authority;
    try {
      final uri = Uri.http(
        url,
        '/api/$table',
        {"grievance": grievanceId}
            .map((key, value) => MapEntry(key, value.toString())),
      );
      final response = await http.get(uri, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });
      print(response.body);
      if (response.statusCode == 200) {
        final extractedHearingData = jsonDecode(utf8.decode(response.bodyBytes));
        _hearingStatusList = HearingList.fromJson(extractedHearingData);
        notifyListeners();
      } else {
        throw HttpException("Unable to load Hearing data !!!");
      }
    } catch (error) {
    throw error;
    }
  }
}