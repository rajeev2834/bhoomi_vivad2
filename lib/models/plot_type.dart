import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plot_type.g.dart';

@JsonSerializable()
class PlotType {
    int id;
    String plot_type;

    PlotType({required this.id, required this.plot_type});

    factory PlotType.fromJson(Map<String, dynamic> json) => _$PlotTypeFromJson(json);

    Map<String, dynamic> toJson() => _$PlotTypeToJson(this);
}