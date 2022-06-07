import 'package:flutter/cupertino.dart';

import '../../constants.dart';

class HearingUpdateProvider with ChangeNotifier{

  Future<bool> updateStatus(Map<String, dynamic> statusUpdateVariable) async {
    print(statusUpdateVariable);
    var vivad_id = statusUpdateVariable['vivad_id'].toString();
    String table = "hearing";

    String id = statusUpdateVariable['id'].toString();
    String _token = statusUpdateVariable['token'].toString();

    final url = base_url + '$table/';
    bool status = false;
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            "Authorization": "Token " + _token.toString(),
            "Content-Type": "application/json; charset=UTF-8",
          },
          body: jsonEncode({
            'grievance_id' : vivad_id,
            'case_status': statusUpdateVariable['case_status'],
            'hearing_date': statusUpdateVariable['hearingDate'],
            'remarks': statusUpdateVariable['remarks'],
          }));
      print(response.body);
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
}