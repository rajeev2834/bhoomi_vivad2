import 'dart:convert';

import 'package:bhoomi_vivad/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:bhoomi_vivad/models/http_exception.dart';

class HearingUpdateProvider with ChangeNotifier{

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
}