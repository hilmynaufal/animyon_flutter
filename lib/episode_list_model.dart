class EpisodesListModel {
  String episodeId;
  String episodeNum;
  String episodeTitle;
  // String episodeUrl;

  EpisodesListModel({
    required this.episodeId,
    required this.episodeNum,
    required this.episodeTitle,
    // required this.episodeUrl,
  });

  factory EpisodesListModel.fromGogoanimeMap(Map<String, dynamic> json,
          {required String? withAnimeTitle}) =>
      EpisodesListModel(
        episodeId: json["episodeId"],
        episodeNum: json["episodeNum"],
        // episodeUrl: json["episodeUrl"],
        episodeTitle: '$withAnimeTitle Episode ${json['episodeNum']}',
      );

  factory EpisodesListModel.fromOtakudesuMap(Map<String, dynamic> json) =>
      EpisodesListModel(
          episodeId: json["id"],
          episodeNum: json["episodeNumber"],
          // episodeUrl: json["title"],
          episodeTitle: json['title']);

  Map<String, dynamic> toMap() => {
        "episodeId": episodeId,
        "episodeNum": episodeNum,
        // "episodeUrl": episodeUrl,
        "episodeTitle": episodeTitle
      };
}
