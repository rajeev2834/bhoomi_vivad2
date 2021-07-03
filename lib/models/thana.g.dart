// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thana.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Thana _$ThanaFromJson(Map<String, dynamic> json) {
  return Thana(
    circle_id: json['circle_id'] as String,
    thana_id: json['thana_id'] as int,
    thana_name_hn: json['thana_name_hn'] as String,
  );
}

Map<String, dynamic> _$ThanaToJson(Thana instance) => <String, dynamic>{
      'circle_id': instance.circle_id,
      'thana_id': instance.thana_id,
      'thana_name_hn': instance.thana_name_hn,
    };
