// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Circle _$CircleFromJson(Map<String, dynamic> json) {
  return Circle(
      circleId: json['circle_id'] as String,
      circleNameHn: json['circle_name_hn'] as String,
      user: json['user'] as int);
}

Map<String, dynamic> _$CircleToJson(Circle instance) => <String, dynamic>{
      'circle_Id': instance.circleId,
      'circle_name_hn': instance.circleNameHn,
      'user': instance.user,
    };
