import 'dart:convert';

import 'package:bhoomi_vivad/models/mobile_device.dart';
import 'package:bhoomi_vivad/models/mobile_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:bhoomi_vivad/models/http_exception.dart';

import '../../constants.dart';
import 'package:http/http.dart' as http;

class VerifyOTPProvider with ChangeNotifier{

  Future<bool> uploadMobileData(MobileDevice mobileDevice) async{
    final url = base_url + 'otp/';
    bool status = false;
    try{
      final response = await http.post(Uri.parse(url), headers: {
        "Content-Type" : "application/json; charset=UTF-8",
      },
          body: jsonEncode(mobileDevice)
      );
      //print(response.body);
      final message = jsonDecode(response.body)['message'];
      notifyListeners();
      if(response.statusCode == 200){
        status = true;
        return status;
      }else {
        throw HttpException(message);
      }
    }catch(error){
      throw(error);
    }
  }

  Future<bool> verifyOTP(MobileOTP mobileOTP) async{
    final url = base_url + 'validate/';
    bool status = false;
    try{
      final response = await http.post(Uri.parse(url), headers: {
        "Content-Type" : "application/json; charset=UTF-8",
      },
          body: jsonEncode(mobileOTP)
      );
      //print(response.body);
      final message = jsonDecode(response.body)['message'];
      notifyListeners();
      if(response.statusCode == 200){
        status = true;
        return status;
      }else {
        throw HttpException(message);
      }
    }catch(error){
      throw(error);
    }
  }
}