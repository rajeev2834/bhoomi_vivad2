import 'package:json_annotation/json_annotation.dart';

part 'mobile_device.g.dart';

@JsonSerializable()
class MobileDevice {
  String phone_number;
  String device_info;
  String device_imei;

  MobileDevice(
      {required this.phone_number,
      required this.device_info,
      required this.device_imei});

  factory MobileDevice.fromJson(Map<String, dynamic> json) =>
      _$MobileDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$MobileDeviceToJson(this);
}
