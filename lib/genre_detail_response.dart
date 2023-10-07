class GenreDetailResponse {
  String animeId;
  String animeTitle;
  String animeImg;
  String releasedDate;
  String animeUrl;

  GenreDetailResponse({
    required this.animeId,
    required this.animeTitle,
    required this.animeImg,
    required this.releasedDate,
    required this.animeUrl,
  });

  factory GenreDetailResponse.fromMap(Map<String, dynamic> json) =>
      GenreDetailResponse(
        animeId: json["animeId"],
        animeTitle: json["animeTitle"],
        animeImg: json["animeImg"],
        releasedDate: json["releasedDate"],
        animeUrl: json["animeUrl"],
      );

  Map<String, dynamic> toMap() => {
        "animeId": animeId,
        "animeTitle": animeTitle,
        "animeImg": animeImg,
        "releasedDate": releasedDate,
        "animeUrl": animeUrl,
      };
}
