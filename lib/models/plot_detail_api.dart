import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plot_detail_api.g.dart';


@JsonSerializable()
class PlotDetailApi {
  String chauhaddi;
  String circle;
  String khata_no;
  String khesra_no;
  double latitude;
  double longitude;
  int mauza;
  String panchayat;
  String plot_uuid;
  int plot_nature;
  int plot_type;
  double rakwa;
  String remarks;
  String thana_no;
  int is_govtPlot;

  PlotDetailApi({required this.chauhaddi, required this.circle,
    required this.khata_no, required this.khesra_no, required this.latitude, required this.longitude,
    required this.mauza, required this.panchayat, required this.plot_uuid, required this.plot_nature,
    required this.plot_type, required this.rakwa, required this.remarks, required this.thana_no, required this.is_govtPlot});

  factory PlotDetailApi.fromJson(Map<String, dynamic> json) => _$PlotDetailApiFromJson(json);

  Map<String, dynamic> toJson() => _$PlotDetailApiToJson(this);

}