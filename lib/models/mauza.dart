import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mauza.g.dart';

@JsonSerializable()
class Mauza {
    String circle_id;
    int mauza_id;
    String mauza_name_hn;
    String panchayat_id;

    Mauza({required this.circle_id, required this.mauza_id, required this.mauza_name_hn, required this.panchayat_id});

    factory Mauza.fromJson(Map<String, dynamic> json) => _$MauzaFromJson(json);

    Map<String, dynamic> toJson() => _$MauzaToJson(this);
}