class SourceModel {
  String file;
  String label;
  String type;

  SourceModel({
    required this.file,
    required this.label,
    required this.type,
  });

  factory SourceModel.fromMap(Map<String, dynamic> json) => SourceModel(
        file: json["file"],
        label: json["label"],
        type: json["type"],
      );

  Map<String, dynamic> toMap() => {
        "file": file,
        "label": label,
        "type": type,
      };
}
