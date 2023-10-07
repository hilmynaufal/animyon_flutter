import 'package:animyon_flutter/anime_detail_controller.dart';
import 'package:animyon_flutter/global_preferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class AnimeDetailPage extends StatelessWidget {
  const AnimeDetailPage({super.key, required this.animeDetailController});

  final AnimeDetailController animeDetailController;
  // final VideoPlayerController videoPlayerController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        body: SafeArea(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetBuilder<AnimeDetailController>(
            id: 'video_player',
            // stream: null,
            builder: (controller) {
              if (controller.videoPlayerController.value == null &&
                  controller.isVideoReady.isFalse) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: theme.colorScheme.secondaryContainer,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              }
              if (controller.animeDetail.value!.episodesList.isEmpty) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: theme.colorScheme.secondaryContainer,
                  alignment: Alignment.center,
                  child: const Text('Not Available.'),
                );
              }
              return AspectRatio(
                aspectRatio:
                    controller.videoPlayerController.value!.value.aspectRatio,
                child: GestureDetector(
                  onTap: () {
                    controller.toogleControlVisibility();
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      VideoPlayer(controller.videoPlayerController.value!),
                      videoPlayerControls(
                          controller: controller,
                          theme: theme,
                          context: context,
                          fromLandscape: false)
                    ],
                  ),
                ),
              );
            }),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GetBuilder<GlobalPreferencesController>(
              id: 'favorite_button',
              builder: (controller) {
                return IconButton(
                    onPressed: () async {
                      controller.setFavorites(
                          animeDetailController.animeDetail.value!,
                          onComplete: () {
                        controller.update(
                          ['favorite_button'],
                        );
                      });
                    },
                    icon: Icon(
                      Icons.favorite,
                      color:
                          controller.isFavorited(animeDetailController.animeId)
                              ? theme.colorScheme.primary
                              : theme.colorScheme.secondary,
                    ));
              },
            ),
            GetBuilder<AnimeDetailController>(
                id: 'episode_controller',
                builder: (controller) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            if (controller.isVideoReady.isFalse) {
                              Get.snackbar(
                                  "Please Wait.", 'Video is still loading...',
                                  snackStyle: SnackStyle.GROUNDED,
                                  snackPosition: SnackPosition.BOTTOM);
                              return;
                            }
                            controller.nextEpisode();
                          },
                          icon: Icon(
                            Icons.chevron_left,
                            color: theme.colorScheme.onPrimaryContainer,
                          )),
                      Text(
                        'Episode ${controller.animeDetail.value != null && controller.animeDetail.value!.episodesList.isNotEmpty ? controller.animeDetail.value!.episodesList[controller.currentEpisode.value].episodeNum : 0}',
                        style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer),
                      ),
                      controller.currentEpisode.value != 0
                          ? IconButton(
                              onPressed: () {
                                if (controller.isVideoReady.isFalse) {
                                  Get.snackbar("Please Wait.",
                                      'Video is still loading...',
                                      snackStyle: SnackStyle.GROUNDED,
                                      snackPosition: SnackPosition.BOTTOM);
                                  return;
                                }
                                controller.nextEpisode();
                              },
                              icon: Icon(
                                Icons.chevron_right,
                                color: theme.colorScheme.onPrimaryContainer,
                              ))
                          : const SizedBox(
                              width: 24,
                            )
                    ],
                  );
                }),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: GetBuilder<AnimeDetailController>(
              id: 'anime_detail',
              builder: (controller) {
                if (controller.animeDetail.value == null) {
                  controller.fetchDetail();
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        itemCount: controller.animeDetail.value!.genres.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: ElevatedButton(
                                onPressed: () {},
                                child: Text(controller
                                    .animeDetail.value!.genres[index])),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "About",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      animeDetailController.animeDetail.value!.synopsis,
                      maxLines: 10,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    )
                  ],
                );
              },
            ))
      ],
    )));
  }

  void pushFullScreenVideo(
      {required final mainContext,
      required final VideoPlayerController controller}) {
//This will help to hide the status bar and bottom bar of Mobile
//also helps you to set preferred device orientations like landscape

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations(
      [
        // DeviceOrientation.portraitUp,
        // DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );

//This will help you to push fullscreen view of video player on top of current page

    Navigator.of(mainContext)
        .push(
      PageRouteBuilder(
        opaque: false,
        settings: const RouteSettings(),
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return GetBuilder<AnimeDetailController>(
              id: 'video_player',
              builder: (controller) {
                return Scaffold(
                    backgroundColor: Colors.transparent,
                    body: OrientationBuilder(
                      builder: (context, orientation) {
                        return Center(
                            child: GestureDetector(
                          onTap: () {
                            controller.toogleControlVisibility();
                          },
                          child: Stack(
                            // fit: isPortrait ? StackFit.loose : StackFit.expand,
                            alignment: Alignment.center,

                            children: [
                              Container(
                                color: Colors.black,
                                width: double.infinity,
                              ),
                              AspectRatio(
                                aspectRatio: controller.videoPlayerController
                                    .value!.value.aspectRatio,
                                child: VideoPlayer(
                                    controller.videoPlayerController.value!),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: AspectRatio(
                                  aspectRatio: controller.videoPlayerController
                                      .value!.value.aspectRatio,
                                  child: videoPlayerControls(
                                      controller: controller,
                                      theme: Theme.of(context),
                                      context: context,
                                      fromLandscape: true),
                                ),
                              )
                            ],
                          ),
                        ));
                      },
                    ));
              });
        },
      ),
    )
        .then(
      (value) {
//This will help you to set previous Device orientations of screen so App will continue for portrait mode

        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
        SystemChrome.setPreferredOrientations(
          [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ],
        );
      },
    );
  }

  Widget videoPlayerControls({
    required AnimeDetailController controller,
    required final theme,
    required final context,
    required bool fromLandscape,
  }) {
    return Visibility(
        visible: controller.videoPlayerControlsVisibility.value,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              controller.animeDetail.value!
                  .episodesList[controller.currentEpisode.value].episodeTitle,
              style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      fromLandscape
                          ? Get.back()
                          : pushFullScreenVideo(
                              mainContext: context,
                              controller:
                                  controller.videoPlayerController.value!);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: const CircleBorder(side: BorderSide.none)),
                    child: const Icon(Icons.fullscreen)),
                ElevatedButton(
                    onPressed: () {
                      controller.tooglePlayback();
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: const CircleBorder(side: BorderSide.none)),
                    child: Icon(
                        controller.videoPlayerController.value!.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow)),
              ],
            ),
            VideoProgressIndicator(
              controller.videoPlayerController.value!,
              allowScrubbing: true,
              colors: VideoProgressColors(
                  playedColor: theme.colorScheme.primary,
                  // backgroundColor: Colors.grey.withOpacity(0.8),
                  bufferedColor: theme.colorScheme.secondary),
            )
          ],
        ));
  }
}
