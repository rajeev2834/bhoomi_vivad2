// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vivad.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vivad _$VivadFromJson(Map<String, dynamic> json) {
  return Vivad(
    abhidari_name: json['abhidari_name'] as String,
    case_status: json['case_status'] == 0 ? 'Pending' : 'Closed',
    cause_vivad: json['cause_vivad'] as String,
    circle_id: json['circle_id'] as String,
    court_status: json['court_status'] as String,
    first_party_address: json['first_party_address'] as String,
    first_party_contact: json['first_party_contact'] as String,
    first_party_name: json['first_party_name'] as String,
    is_courtpending: json['is_courtpending'] as bool,
    is_fir: json['is_fir'] as bool,
    is_violence: json['is_violence'] as bool,
    mauza_id: json['mauza_id'] as int,
    next_hearing_date: json['next_hearing_date'] as String,
    notice_order: json['notice_order'] as String,
    panchayat_id: json['panchayat_id'] as String,
    plot_uuid: json['plot_uuid'] as String,
    register_date: json['register_date'] as String,
    remarks: json['remarks'] as String,
    second_party_address: json['second_party_address'] as String,
    second_party_contact: json['second_party_contact'] as String,
    second_party_name: json['second_party_name'] as String,
    thana_no: json['thana_no'] as int,
    violence_detail: json['violence_detail'] as String,
    vivad_uuid: json['vivad_uuid'] as String,
  );
}

Map<String, dynamic> _$VivadToJson(Vivad instance) => <String, dynamic>{
      'abhidari_name': instance.abhidari_name,
      'case_status': instance.case_status,
      'cause_vivad': instance.cause_vivad,
      'circle_id': instance.circle_id,
      'court_status': instance.court_status,
      'first_party_address': instance.first_party_address,
      'first_party_contact': instance.first_party_contact,
      'first_party_name': instance.first_party_name,
      'is_courtpending': instance.is_courtpending,
      'is_fir': instance.is_fir,
      'is_violence': instance.is_violence,
      'mauza_id': instance.mauza_id,
      'next_hearing_date': instance.next_hearing_date,
      'notice_order': instance.notice_order,
      'panchayat_id': instance.panchayat_id,
      'plot_uuid': instance.plot_uuid,
      'register_date': instance.register_date,
      'remarks': instance.remarks,
      'second_party_address': instance.second_party_address,
      'second_party_contact': instance.second_party_contact,
      'second_party_name': instance.second_party_name,
      'thana_no': instance.thana_no,
      'violence_detail': instance.violence_detail,
      'vivad_uuid': instance.vivad_uuid,
    };
