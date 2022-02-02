import 'package:json_annotation/json_annotation.dart';

part 'vivad_type.g.dart';

class VivadTypeList{
    final List<VivadType> vivadTypes;

   VivadTypeList({
        required this.vivadTypes,
    });

    factory VivadTypeList.fromJson(List<dynamic> parsedJson) {
        List<VivadType> vivadTypes = [];
        vivadTypes = parsedJson.map((i)=>VivadType.fromJson(i)).toList();

        return new VivadTypeList(vivadTypes: vivadTypes);
    }
}

@JsonSerializable()
class VivadType {
    int id;
    String vivad_type_hn;

    VivadType({required this.id, required this.vivad_type_hn});

    factory VivadType.fromJson(Map<String, dynamic> json) => _$VivadTypeFromJson(json);

    Map<String, dynamic> toJson() => _$VivadTypeToJson(this);
}