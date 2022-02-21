import 'package:json_annotation/json_annotation.dart';

part 'mobile_otp.g.dart';

@JsonSerializable()
class MobileOTP {
  String phone_number;
  String otp;

  MobileOTP(
      {required this.phone_number,
        required this.otp});

  factory MobileOTP.fromJson(Map<String, dynamic> json) =>
      _$MobileOTPFromJson(json);

  Map<String, dynamic> toJson() => _$MobileOTPToJson(this);
}
