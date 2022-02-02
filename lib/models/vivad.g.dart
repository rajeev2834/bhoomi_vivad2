// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vivad.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vivad _$VivadFromJson(Map<String, dynamic> json) {
  return Vivad(
    vivad_uuid: json['vivad_uuid'] as String,
    register_no: json['register_no'] as String,
    register_date: json['register_date'] as String,
    circle_id: json['circle_id'] as String,
    panchayat_id: json['panchayat_id'] as int,
    first_party_name: json['first_party_name'] as String,
    first_party_address: json['first_party_address'] as String,
    first_party_contact: json['first_party_contact'] as String,
    second_party_address: json['second_party_address'] as String,
    second_party_contact: json['second_party_contact'] as String,
    second_party_name: json['second_party_name'] as String,
    thana_no: json['thana_no'] as String,
    mauza: json['mauza'] as String,
    khata_no: json['khata_no'] as String,
    khesra_no: json['khesra_no'] as String,
    rakwa: json['rakwa'] as String,
    chauhaddi: json['chauhaddi'] as String,
    vivad_type_id: json['vivad_type_id'] as int,
    case_detail: json['case_detail'] as String,
    is_violence: json['is_violence'] as int,
    violence_detail: json['violence_detail'] as String,
    is_fir: json['is_fir'] as int,
    notice_order: json['notice_order'] as String,
    is_courtpending: json['is_courtpending'] as int,
    court_status: json['court_status'] as String,
    case_status: json['case_status'] as String,
    next_hearing_date: json['next_hearing_date'] as String,
    remarks: json['remarks'] as String
  );
}

Map<String, dynamic> _$VivadToJson(Vivad instance) => <String, dynamic>{
  'vivad_uuid' : instance.vivad_uuid,
  'register_no' : instance.register_no,
  'register_date' : instance.register_date,
  'circle_id' : instance.circle_id,
  'panchayat_id' : instance.panchayat_id,
  'first_party_name' : instance.first_party_name,
  'first_party_contact' : instance.first_party_contact,
  'first_party_address' : instance.first_party_address,
  'second_party_name' : instance.second_party_name,
  'second_party_contact' : instance.second_party_contact,
  'second_party_address' : instance.second_party_address,
  'thana_no' : instance.thana_no,
  'mauza' : instance.mauza,
  'khata_no' : instance.khata_no,
  'khesra_no' : instance.khesra_no,
  'rakwa' : instance.rakwa,
  'chauhaddi' : instance.chauhaddi,
  'vivad_type_id' : instance.vivad_type_id,
  'case_detail' : instance.case_detail,
  'is_violence' : instance.is_violence,
  'violence_detail' : instance.violence_detail,
  'is_fir' : instance.is_fir,
  'notice_order' : instance.notice_order,
  'is_courtpending' : instance.is_courtpending,
  'court_status' : instance.court_status,
  'case_status' : instance.case_status,
  'next_hearing_date' : instance.next_hearing_date,
  'remarks' : instance.remarks,
};
