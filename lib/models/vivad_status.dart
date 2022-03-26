import 'package:json_annotation/json_annotation.dart';

part 'vivad_status.g.dart';


class VivadStatusList {
  final List<VivadStatus> vivads;

  VivadStatusList({
    required this.vivads,
  });

  factory VivadStatusList.fromJson(List<dynamic> parsedJson) {
    List<VivadStatus> vivads = [];
    vivads = parsedJson.map((i) => VivadStatus.fromJson(i)).toList();

    return new VivadStatusList(vivads: vivads);
  }
}

@JsonSerializable()
class VivadStatus {
  String vivad_id;
  String register_no;
  String register_date;
  String circle;
  String panchayat;
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
  String vivad_type;
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
  String created_date;

  VivadStatus(
      {
        required this.vivad_id,
        required this.register_no,
        required this.register_date,
        required this.circle,
        required this.panchayat,
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
        required this.vivad_type,
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
        required this.created_date,
      });

  factory VivadStatus.fromJson(Map<String, dynamic> json) => _$VivadStatusFromJson(json);

  Map<String, dynamic> toJson() => _$VivadStatusToJson(this);
}