import 'package:animyon_flutter/episode_list_model.dart';

class AnimeDetailModel {
  String animeId;
  String animeTitle;
  String type;
  String releasedDate;
  String status;
  List<String> genres;
  String otherNames;
  String synopsis;
  String animeImg;
  String totalEpisodes;
  List<EpisodesListModel> episodesList;

  AnimeDetailModel({
    required this.animeId,
    required this.animeTitle,
    required this.type,
    required this.releasedDate,
    required this.status,
    required this.genres,
    required this.otherNames,
    required this.synopsis,
    required this.animeImg,
    required this.totalEpisodes,
    required this.episodesList,
  });

  factory AnimeDetailModel.fromGogoanimeMap(Map<String, dynamic> json,
          {String? withAnimeId}) =>
      AnimeDetailModel(
        animeId: withAnimeId ?? json['animeId'],
        animeTitle: json["animeTitle"],
        type: json["type"],
        releasedDate: json["releasedDate"],
        status: json["status"],
        genres: List<String>.from(json["genres"].map((x) => x)),
        otherNames: json["otherNames"],
        synopsis: json["synopsis"],
        animeImg: json["animeImg"],
        totalEpisodes: json["totalEpisodes"],
        episodesList: List<EpisodesListModel>.from(json["episodesList"].map(
            (x) => EpisodesListModel.fromGogoanimeMap(x,
                withAnimeTitle: json['animeTitle']))),
      );

  factory AnimeDetailModel.fromOtakudesuMap(Map<String, dynamic> json) =>
      AnimeDetailModel(
        animeId: json['anime_id'],
        animeTitle: json["title"],
        type: json["type"],
        releasedDate: json["release_date"],
        status: json["status"],
        genres:
            List<String>.from(json["genre_list"].map((x) => x['genre_name'])),
        otherNames: json["japanase"],
        synopsis: json["synopsis"],
        animeImg: json["thumb"],
        totalEpisodes: json["episode_list"].length.toString(),
        episodesList: List<EpisodesListModel>.from(json["episode_list"]
            .map((x) => EpisodesListModel.fromOtakudesuMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "animeId": animeId,
        "animeTitle": animeTitle,
        "type": type,
        "releasedDate": releasedDate,
        "status": status,
        "genres": List<dynamic>.from(genres.map((x) => x)),
        "otherNames": otherNames,
        "synopsis": synopsis,
        "animeImg": animeImg,
        "totalEpisodes": totalEpisodes,
        "episodesList": List<dynamic>.from(episodesList.map((x) => x.toMap())),
      };
}
