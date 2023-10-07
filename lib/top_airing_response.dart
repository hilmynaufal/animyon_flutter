class TopAiringResponse {
  String animeId;
  String animeTitle;
  String animeImg;
  String latestEp;
  String provider;
  // String animeUrl;
  // List<String> genres;

  TopAiringResponse(
      {required this.animeId,
      required this.animeTitle,
      required this.animeImg,
      required this.latestEp,
      required this.provider});

  factory TopAiringResponse.fromGogoanimeMap(Map<String, dynamic> json) =>
      TopAiringResponse(
        animeId: json["animeId"],
        animeTitle: json["animeTitle"],
        animeImg: json["animeImg"],
        latestEp: json["latestEp"],
        provider: 'gogoanime',
      );

  factory TopAiringResponse.fromOtakudesuMap(Map<String, dynamic> json) =>
      TopAiringResponse(
        animeId: json["id"],
        animeTitle: json["title"],
        animeImg: json["thumb"],
        latestEp: json["episode"],
        provider: 'otakudesu',
      );

  Map<String, dynamic> toMap() => {
        "animeId": animeId,
        "animeTitle": animeTitle,
        "animeImg": animeImg,
        "latestEp": latestEp,
        "provide": provider
      };
}
