// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_device.dart';

// **************************************************************************
// JsonSerializableGenerator
//
MobileDevice _$MobileDeviceFromJson(Map<String, dynamic> json) {
  return MobileDevice(
      phone_number: json['phone_number'] as String,
      device_info: json['device_info'] as String,
      device_imei: json['device_imei'] as String);
}

Map<String, dynamic> _$MobileDeviceToJson(MobileDevice instance) =>
    <String, dynamic>{
      'phone_number': instance.phone_number,
      'device_info': instance.device_info,
      'device_imei': instance.device_imei,
    };
