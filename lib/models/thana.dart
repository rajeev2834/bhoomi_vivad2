import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'thana.g.dart';

@JsonSerializable()
class Thana {
    String circle_id;
    int thana_id;
    String thana_name_hn;

    Thana({required this.circle_id, required this.thana_id, required this.thana_name_hn});

    factory Thana.fromJson(Map<String, dynamic> json) => _$ThanaFromJson(json);

    Map<String, dynamic> toJson() => _$ThanaToJson(this);
}