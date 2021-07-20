// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hearing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hearing _$HearingFromJson(Map<String, dynamic> json) {
  return Hearing(
    vivad_uuid: json['vivad_uuid'] as String,
    hearing_date: DateTime.parse(json['hearing_date'] as String),
    remarks: json['remarks'] as String,
    first_party: json['first_party'] as bool,
    second_party: json['second_party'] as bool,
  );
}

Map<String, dynamic> _$HearingToJson(Hearing instance) => <String, dynamic>{
      'vivad_uuid': instance.vivad_uuid,
      'hearing_date': instance.hearing_date.toIso8601String(),
      'remarks': instance.remarks,
      'first_party': instance.first_party,
      'second_party': instance.second_party,
    };
