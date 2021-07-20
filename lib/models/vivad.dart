import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vivad.g.dart';

class VivadList{
    final List<Vivad> vivads;

    VivadList({
        required this.vivads,
    });

    factory VivadList.fromJson(List<dynamic> parsedJson) {
        List<Vivad> vivads = [];
        vivads = parsedJson.map((i)=>Vivad.fromJson(i)).toList();

        return new VivadList(vivads: vivads);
    }
}



@JsonSerializable()
class Vivad {
    String abhidari_name;
    String case_status;
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
    String plot_uuid;
    String register_date;
    String remarks;
    String second_party_address;
    String second_party_contact;
    String second_party_name;
    int thana_no;
    String violence_detail;
    String vivad_uuid;

    Vivad({required this.abhidari_name, required this.case_status, required this.cause_vivad,
        required this.circle_id, required this.court_status, required this.first_party_address,
        required this.first_party_contact, required this.first_party_name, required this.is_courtpending,
        required this.is_fir, required this.is_violence, required this.mauza_id, required this.next_hearing_date,
        required this.notice_order, required this.panchayat_id, required this.plot_uuid, required this.register_date,
        required this.remarks, required this.second_party_address, required this.second_party_contact,
        required this.second_party_name, required this.thana_no, required this.violence_detail, required this.vivad_uuid});

    factory Vivad.fromJson(Map<String, dynamic> json) => _$VivadFromJson(json);

    Map<String, dynamic> toJson() => _$VivadToJson(this);
}