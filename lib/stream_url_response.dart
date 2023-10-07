import 'package:animyon_flutter/source_model.dart';

class StreamUrlResponse {
  String referer;
  List<SourceModel> sources;
  List<SourceModel> sourcesBk;

  StreamUrlResponse({
    required this.referer,
    required this.sources,
    required this.sourcesBk,
  });

  factory StreamUrlResponse.fromMap(Map<String, dynamic> json) =>
      StreamUrlResponse(
        referer: json["Referer"],
        sources: List<SourceModel>.from(
            json["sources"].map((x) => SourceModel.fromMap(x))),
        sourcesBk: List<SourceModel>.from(
            json["sources_bk"].map((x) => SourceModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "Referer": referer,
        "sources": List<dynamic>.from(sources.map((x) => x.toMap())),
        "sources_bk": List<dynamic>.from(sourcesBk.map((x) => x.toMap())),
      };
}
