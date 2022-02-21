// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_otp.dart';

// **************************************************************************
// JsonSerializableGenerator
//
MobileOTP _$MobileOTPFromJson(Map<String, dynamic> json) {
  return MobileOTP(
      phone_number: json['phone_number'] as String,
      otp: json['otp'] as String);
}

Map<String, dynamic> _$MobileOTPToJson(MobileOTP instance) =>
    <String, dynamic>{
      'phone_number': instance.phone_number,
      'otp': instance.otp
    };
