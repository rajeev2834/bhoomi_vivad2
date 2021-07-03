import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plot_nature.g.dart';

@JsonSerializable()
class PlotNature {
    int id;
    String plot_nature;

    PlotNature({required this.id, required this.plot_nature});

    factory PlotNature.fromJson(Map<String, dynamic> json) => _$PlotNatureFromJson(json);

    Map<String, dynamic> toJson() => _$PlotNatureToJson(this);

}