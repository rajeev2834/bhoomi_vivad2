import 'dart:convert';

import 'package:bhoomi_vivad/constants.dart';
import 'package:bhoomi_vivad/models/http_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class StatusUpdateProvider with ChangeNotifier {

  Future<bool> updateStatus(Map<String, dynamic> statusUpdateVariable) async {
    var vivad_id = statusUpdateVariable['vivad_id'].toString();
    String table = vivad_id.startsWith("GR", 0) ? "grievance" : "vivad";

    String id = statusUpdateVariable['id'].toString();
    String _token = statusUpdateVariable['token'].toString();

    final Url = base_url + '$table/$id/';
    bool status = false;
    try {
      final response = await http.patch(Uri.parse(Url),
          headers: {
            "Authorization": "Token " + _token.toString(),
            "Content-Type": "application/json; charset=UTF-8",
          },
          body: jsonEncode({
            'case_status': statusUpdateVariable['case_status'],
            'next_hearing_date': statusUpdateVariable['hearingDate'],
            'remarks': statusUpdateVariable['remarks'],
          }));
      final message = jsonDecode(response.body)['message'];
      notifyListeners();
      if (response.statusCode == 200) {
        status = true;
        return status;
      } else {
        throw HttpException(message);
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<List<Map<String, dynamic>>> countCaseStatus(
      String? token, String circleId) async {
    var url = Uri.parse(base_url).authority;

    try {
      final uri1 = Uri.http(
        url,
        '/api/count/',
        {"circle": circleId}
            .map((key, value) => MapEntry(key, value.toString())),
      );

      final uri2 = Uri.http(
        url,
        '/api/count-vivad/',
        {"circle": circleId}
            .map((key, value) => MapEntry(key, value.toString())),
      );

      final response = await Future.wait([
        http.get(uri1, headers: {
          "Authorization": "Token " + token.toString(),
          "Content-Type": 'application/json',
        }),
        http.get(uri2, headers: {
          "Authorization": "Token " + token.toString(),
          "Content-Type": 'application/json',
        }),
      ]);

      var grievanceCount = jsonDecode(response[0].body) as List<dynamic>;
      var vivadCount = jsonDecode(response[1].body) as List<dynamic>;

      var len1 = grievanceCount.length;
      var len2 = vivadCount.length;
      var max = len1 >= len2 ? len1 : len2;

      List<Map<String, dynamic>> caseStatusCount = [];
      grievanceCount.forEach((element) {
        vivadCount.forEach((e) {
          if (e['case_status'] == element['case_status']) {
            caseStatusCount.add(getCaseStatusCount(element['case_status'],
                element['total_grievance'], e['total_vivad']));
          }
        });
      });
      if (caseStatusCount.isEmpty) {
        if (grievanceCount.isNotEmpty) {
          grievanceCount.forEach((element) {
            caseStatusCount.add(getCaseStatusCount(
                element['case_status'], element['total_grievance'], 0));
          });
        }
        if (vivadCount.isNotEmpty) {
          vivadCount.forEach((element) {
            caseStatusCount.add(getCaseStatusCount(
                element['case_status'], 0, element['total_vivad']));
          });
        }
      } else if (caseStatusCount.length < max) {
        if (grievanceCount.isNotEmpty) {
          grievanceCount.forEach((element) {
            caseStatusCount.forEach((e) {
              if (e['case_status'] != element['case_status']) {
                caseStatusCount.add(getCaseStatusCount(
                    element['case_status'], element['total_grievance'], 0));
              }
            });
          });
        }
        if (vivadCount.isNotEmpty) {
          vivadCount.forEach((element) {
            caseStatusCount.forEach((e) {
              if (e['case_status'] != element['case_status']) {
                caseStatusCount.add(getCaseStatusCount(
                    element['case_status'], 0, element['total_vivad']));
              }
            });
          });
        }
      }
      return caseStatusCount;
    } catch (error) {
      throw error;
    }
  }

  Map<String, dynamic> getCaseStatusCount(
      int status, int grievance, int vivad) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['case_status'] = status;
    data['total_grievance'] = grievance;
    data['total_vivad'] = vivad;

    return data;
  }
}
