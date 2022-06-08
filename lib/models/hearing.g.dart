// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hearing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hearing _$HearingFromJson(Map<String, dynamic> json) {
  return Hearing(
    id: json['id'] as int,
    grievance_id: json['grievance_id'] as String,
    hearing_date: json['hearing_date'] as String,
    remarks: json['remarks'] as String,
    case_status: json['status'] as String,
    next_date: json['next_date'] as String,
  );
}

Map<String, dynamic> _$HearingToJson(Hearing instance) => <String, dynamic>{
      'grievance_id': instance.grievance_id,
      'hearing_ date': instance.hearing_date,
      'next_date': instance.next_date,
      'status': instance.case_status,
      'remarks': instance.remarks,
    };
