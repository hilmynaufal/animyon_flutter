class SearchResponse {
  String animeId;
  String animeTitle;
  String animeUrl;
  String animeImg;
  String status;

  SearchResponse({
    required this.animeId,
    required this.animeTitle,
    required this.animeUrl,
    required this.animeImg,
    required this.status,
  });

  factory SearchResponse.fromMap(Map<String, dynamic> json) => SearchResponse(
        animeId: json["animeId"],
        animeTitle: json["animeTitle"],
        animeUrl: json["animeUrl"],
        animeImg: json["animeImg"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "animeId": animeId,
        "animeTitle": animeTitle,
        "animeUrl": animeUrl,
        "animeImg": animeImg,
        "status": status,
      };
}
