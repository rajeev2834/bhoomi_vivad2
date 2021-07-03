import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vivad.g.dart';

@JsonSerializable()
class Vivad {
    String abhidari_name;
    int case_status;
    String cause_vivad;
    String circle_id;
    String court_status;
    String first_party_address;
    String first_party_contact;
    String first_party_name;
    bool is_courtpending;
    bool is_fir;
    bool is_violence;
    int mauza_id;
    String next_hearing_date;
    String notice_order;
    String panchayat_id;
    int plot_id;
    String register_date;
    String remarks;
    String second_party_address;
    String second_party_contact;
    String second_party_name;
    int thana_no;
    String violence_detail;
    int vivad_id;

    Vivad({required this.abhidari_name, required this.case_status, required this.cause_vivad,
        required this.circle_id, required this.court_status, required this.first_party_address,
        required this.first_party_contact, required this.first_party_name, required this.is_courtpending,
        required this.is_fir, required this.is_violence, required this.mauza_id, required this.next_hearing_date,
        required this.notice_order, required this.panchayat_id, required this.plot_id, required this.register_date,
        required this.remarks, required this.second_party_address, required this.second_party_contact,
        required this.second_party_name, required this.thana_no, required this.violence_detail, required this.vivad_id});

    factory Vivad.fromJson(Map<String, dynamic> json) => _$VivadFromJson(json);

    Map<String, dynamic> toJson() => _$VivadToJson(this);
}