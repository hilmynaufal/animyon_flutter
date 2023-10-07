import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:animyon_flutter/anime_detail_model.dart';
import 'package:animyon_flutter/api_service.dart';
import 'package:animyon_flutter/global_preferences_controller.dart';
import 'package:animyon_flutter/model/provider_model.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class AnimeDetailController extends GetxController {
  final String animeId;
  final videoPlayerController = Rxn<VideoPlayerController>();
  final animeDetail = Rxn<AnimeDetailModel>();
  final videoPlayerControlsVisibility = RxBool(false);
  final isVideoReady = RxBool(false);
  final currentEpisode = RxInt(0);

  AnimeDetailController({required this.animeId});

  Future<void> fetchDetail() async {
    final provider =
        Get.find<GlobalPreferencesController>().currentProvider.value;
    final response = await ApiService.getCall(
        header: provider!.name == 'otakudesu'
            ? 'anime/$animeId'
            : 'anime-details/$animeId',
        baseUrl: provider.baseUrl);

    if (response.statusCode == 200) {
      animeDetail.value = provider.name == 'otakudesu'
          ? AnimeDetailModel.fromOtakudesuMap(jsonDecode(response.body))
          : AnimeDetailModel.fromGogoanimeMap(jsonDecode(response.body),
              withAnimeId: animeId);
      update(['anime_detail']);
      handleVideo(provider: provider);
    } else {
      throw UnimplementedError();
    }
  }

  void nextEpisode() {
    //stop the playback
    if (videoPlayerController.value!.value.isPlaying) {
      videoPlayerController.value!.pause();
    }

    //update episode and video player state
    videoPlayerController.value = null;
    currentEpisode.value -= 1;
    isVideoReady.value = false;
    update(['episode_controller', 'video_player']);

    //fetch and attach
    getStreamingUrl(
        episodeId:
            animeDetail.value!.episodesList[currentEpisode.value].episodeId,
        provider:
            Get.find<GlobalPreferencesController>().currentProvider.value!);
  }

  Future<void> getStreamingUrl(
      {required String episodeId, required ProviderModel provider}) async {
    // isVideoReady.value = false;
    // update(['video_player']);
    log(episodeId);

    final response = await ApiService.getCall(
        header: provider.name == 'otakudesu'
            ? 'eps/$episodeId'
            : 'vidcdn/watch/$episodeId',
        baseUrl: provider.baseUrl);
    // late final StreamUrlResponse streamUrlResponse;
    if (response.statusCode == 200) {
      // streamUrlResponse = StreamUrlResponse.fromMap(jsonDecode(response.body));
      final streamLink = provider.name == 'otakudesu'
          ? jsonDecode(response.body)['link_stream']
          : jsonDecode(response.body)['sources'][0]['file'];
      log(streamLink);
      videoPlayerController.value =
          VideoPlayerController.networkUrl(Uri.parse(streamLink))
            ..initialize().whenComplete(() {
              isVideoReady.value = true;
              update(['video_player']);
            })
            ..play();
    } else {
      throw UnimplementedError();
    }
  }

  void toogleControlVisibility() {
    videoPlayerControlsVisibility.toggle();
    update(['video_player']);
    if (videoPlayerControlsVisibility.isTrue) {
      Timer(const Duration(seconds: 2), () {
        videoPlayerControlsVisibility.value = false;
        update(['video_player']);
      });
    }
  }

  void tooglePlayback() {
    videoPlayerController.value!.value.isPlaying
        ? videoPlayerController.value!.pause()
        : videoPlayerController.value!.play();
    update(['video_player']);
  }

  void handleVideo({required ProviderModel provider}) {
    // log(animeDetail.value!.toMap().toString());

    if (animeDetail.value!.episodesList.isNotEmpty) {
      currentEpisode.value = animeDetail.value!.episodesList.length - 1;
      update(['episode_controller']);
      getStreamingUrl(
          episodeId: animeDetail.value!.episodesList.last.episodeId,
          provider: provider);
    } else {
      // log('oy');
      isVideoReady.value = true;
      update(['video_player']);
    }
  }

  @override
  InternalFinalCallback<void> get onDelete => InternalFinalCallback(
        callback: () {
          videoPlayerController.value?.pause();
          videoPlayerController.value?.dispose();
          super.onDelete;
        },
      );
}
