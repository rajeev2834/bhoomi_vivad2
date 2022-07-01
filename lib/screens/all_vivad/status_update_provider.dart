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
      String? token, String circleId, String duration) async {
    var url = Uri.parse(base_url).authority;

    final queryMaps = <String, String>{};
    if (circleId != "") {
      queryMaps['circle_id'] = circleId;
    }

    if (duration != "") {
      duration == "week" ? queryMaps['week'] = "1" : queryMaps['month'] = "1";
    }

    try {
      final uri1 = Uri.http(
        url,
        '/api/count/',
        queryMaps,
      );

      final uri2 = Uri.http(
        url,
        '/api/count-vivad/',
        queryMaps,
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

      List<dynamic> indexGrievance = [];
      List<dynamic> indexVivad = [];

      var len1 = grievanceCount.length;
      var len2 = vivadCount.length;
      var max = len1 >= len2 ? len1 : len2;

      List<Map<String, dynamic>> caseStatusCount = [];
      grievanceCount.forEach((element) {
        vivadCount.forEach((e) {
          if (e['case_status'] == element['case_status']) {
            caseStatusCount.add(getCaseStatusCount(element['case_status'],
                element['total_grievance'], e['total_vivad']));
            indexGrievance.add(grievanceCount.indexOf(element));
            indexVivad.add(vivadCount.indexOf(e));
          }
        });
      });

      if (indexGrievance.isNotEmpty) {
        indexGrievance.sort();
        for (int i = 0; i < indexGrievance.length; i++) {
          var element = indexGrievance[i];
          grievanceCount.removeAt(element - i);
        }
      }

      if (indexVivad.isNotEmpty) {
        indexVivad.sort();
        for (int i = 0; i < indexVivad.length; i++) {
          var element = indexVivad[i];
          vivadCount.removeAt(element - i);
        }
      }

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

  Future<List<Map<String, dynamic>>> getCircleWiseStatus(
      String token, String caseStatus, String duration) async {
    var url = Uri.parse(base_url).authority;
    final queryMaps = <String, String>{};
    if (caseStatus != "") {
      queryMaps['case_status'] = caseStatus.toString();
    }
    if (duration != "") {
      duration == "week" ? queryMaps['week'] = "1" : queryMaps['month'] = "1";
    }

    try {
      final uri1 = Uri.http(
        url,
        '/api/circle-wise-grievance/',
        queryMaps,
      );
      final uri2 = Uri.http(
        url,
        '/api/circle-wise-vivad/',
        queryMaps,
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

      var indexGrievance = [];
      var indexVivad = [];

      var len1 = grievanceCount.length;
      var len2 = vivadCount.length;
      var max = len1 >= len2 ? len1 : len2;

      List<Map<String, dynamic>> circleWiseStatus = [];

      grievanceCount.forEach((element) {
        vivadCount.forEach((e) {
          if (e['circle_id'] == element['circle_id']) {
            circleWiseStatus.add(getCircleWiseStatusCount(
                element['circle_id'],
                element['circle_name'],
                element['total_vivad'],
                e['total_vivad']));
            indexGrievance.add(grievanceCount.indexOf(element));
            indexVivad.add(vivadCount.indexOf(e));
          }
        });
      });

      if (indexGrievance.isNotEmpty) {
        indexGrievance.sort();
        for (int i = 0; i < indexGrievance.length; i++) {
          var element = indexGrievance[i];
          grievanceCount.removeAt(element - i);
        }
      }

      if (indexVivad.isNotEmpty) {
        indexVivad.sort();
        for (int i = 0; i < indexVivad.length; i++) {
          var element = indexVivad[i];
          vivadCount.removeAt(element - i);
        }
      }

      if (circleWiseStatus.isEmpty) {
        if (grievanceCount.isNotEmpty) {
          grievanceCount.forEach((element) {
            circleWiseStatus.add(getCircleWiseStatusCount(element['circle_id'],
                element['circle_name'], element['total_vivad'], 0));
          });
        }
        if (vivadCount.isNotEmpty) {
          vivadCount.forEach((element) {
            circleWiseStatus.add(getCircleWiseStatusCount(element['circle_id'],
                element['circle_name'], 0, element['total_vivad']));
          });
        }
      } else if (circleWiseStatus.length < max) {
        if (grievanceCount.isNotEmpty) {
          grievanceCount.forEach((element) {
            circleWiseStatus.add(getCircleWiseStatusCount(element['circle_id'],
                element['circle_name'], element['total_vivad'], 0));
          });
        }
        if (vivadCount.isNotEmpty) {
          vivadCount.forEach((element) {
            circleWiseStatus.add(getCircleWiseStatusCount(element['circle_id'],
                element['circle_name'], 0, element['total_vivad']));
          });
        }
      }
      return circleWiseStatus;
    } catch (error) {
      throw error;
    }
  }

  Map<String, dynamic> getCircleWiseStatusCount(
      String circle_id, String circle_name, int grievance, int vivad) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['circle_id'] = circle_id;
    data['circle_name'] = circle_name;
    data['total_grievance'] = grievance;
    data['total_vivad'] = vivad;

    return data;
  }
}
