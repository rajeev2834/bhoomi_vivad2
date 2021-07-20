// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plot_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlotDetail _$PlotDetailFromJson(Map<String, dynamic> json) {
  return PlotDetail(
    chauhaddi: json['chauhaddi'] as String,
    circle_id: json['circle_id'] as String,
    image: json['image'] as String,
    khata_no: json['khata_no'] as String,
    khesra_no: json['khesra_no'] as String,
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    mauza_id: json['mauza_id'] as int,
    panchayat_id: json['panchayat_id'] as String,
    plot_uuid: json['plot_uuid'] as String,
    plot_nature_id: json['plot_nature_id'] as int,
    plot_type_id: json['plot_type_id'] as int,
    rakwa: (json['rakwa'] as num).toDouble(),
    remarks: json['remarks'] as String,
    thana_no: json['thana_no'] as int,
    is_govtPlot: json['is_govtPlot'] as bool,
  );
}

Map<String, dynamic> _$PlotDetailToJson(PlotDetail instance) =>
    <String, dynamic>{
      'chauhaddi': instance.chauhaddi,
      'circle_id': instance.circle_id,
      'image': instance.image,
      'khata_no': instance.khata_no,
      'khesra_no': instance.khesra_no,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'mauza_id': instance.mauza_id,
      'panchayat_id': instance.panchayat_id,
      'plot_uuid': instance.plot_uuid,
      'plot_nature_id': instance.plot_nature_id,
      'plot_type_id': instance.plot_type_id,
      'rakwa': instance.rakwa,
      'remarks': instance.remarks,
      'thana_no': instance.thana_no,
      'is_govtPlot': instance.is_govtPlot,
    };
