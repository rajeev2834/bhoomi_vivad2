// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Circle _$CircleFromJson(Map<String, dynamic> json) {
  return Circle(
    circleId: json['circleId'] as String,
    circleNameHn: json['circleNameHn'] as String,
  );
}

Map<String, dynamic> _$CircleToJson(Circle instance) => <String, dynamic>{
      'circleId': instance.circleId,
      'circleNameHn': instance.circleNameHn,
    };
