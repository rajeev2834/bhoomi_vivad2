import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vivad.g.dart';

class VivadList {
  final List<Vivad> vivads;

  VivadList({
    required this.vivads,
  });

  factory VivadList.fromJson(List<dynamic> parsedJson) {
    List<Vivad> vivads = [];
    vivads = parsedJson.map((i) => Vivad.fromJson(i)).toList();

    return new VivadList(vivads: vivads);
  }
}

@JsonSerializable()
class Vivad {
  String vivad_uuid;
  String register_no;
  String register_date;
  String circle_id;
  int panchayat_id;
  String first_party_address;
  String first_party_contact;
  String first_party_name;
  String second_party_address;
  String second_party_contact;
  String second_party_name;
  String thana_no;
  String mauza;
  String khata_no;
  String khesra_no;
  String rakwa;
  String chauhaddi;
  int vivad_type_id;
  String case_detail;
  int is_violence;
  String violence_detail;
  int is_fir;
  String notice_order;
  int is_courtpending;
  String court_status;
  String case_status;
  String next_hearing_date;
  String remarks;

  Vivad(
      {
        required this.vivad_uuid,
        required this.register_no,
        required this.register_date,
        required this.circle_id,
        required this.panchayat_id,
        required this.first_party_address,
        required this.first_party_contact,
        required this.first_party_name,
        required this.second_party_address,
        required this.second_party_contact,
        required this.second_party_name,
        required this.thana_no,
        required this.mauza,
        required this.khata_no,
        required this.khesra_no,
        required this.rakwa,
        required this.chauhaddi,
        required this.vivad_type_id,
        required this.case_detail,
        required this.is_violence,
        required this.violence_detail,
        required this.is_fir,
        required this.notice_order,
        required this.is_courtpending,
        required this.court_status,
        required this.case_status,
        required this.next_hearing_date,
        required this.remarks,
});

  factory Vivad.fromJson(Map<String, dynamic> json) => _$VivadFromJson(json);

  Map<String, dynamic> toJson() => _$VivadToJson(this);
}
