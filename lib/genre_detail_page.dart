import 'package:animyon_flutter/anime_detail_controller.dart';
import 'package:animyon_flutter/anime_detail_page.dart';
import 'package:animyon_flutter/genre_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenreDetailPage extends StatelessWidget {
  const GenreDetailPage({super.key, required this.genreDetailController});

  final GenreDetailController genreDetailController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 32,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  genreDetailController.genreName.capitalizeFirst!,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Obx(() {
                if (genreDetailController.genreDetailResponseList.isEmpty) {
                  genreDetailController.getGenreDetail();
                  return Container(
                      alignment: Alignment.center,
                      // height: 32,
                      width: double.infinity,
                      child: const CircularProgressIndicator());
                }
                return GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  // mainAxisSpacing: ,
                  shrinkWrap: true,
                  children: genreDetailController.genreDetailResponseList
                      .map((e) => Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ElevatedButton(
                                  clipBehavior: Clip.antiAlias,
                                  style: ElevatedButton.styleFrom(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      padding: const EdgeInsets.all(0),
                                      // shadowColor: Colors.transparent,
                                      // foregroundColor: Colors.transparent,
                                      surfaceTintColor: Colors.transparent,
                                      backgroundColor: Colors.transparent),
                                  onPressed: () {
                                    Get.to(() => AnimeDetailPage(
                                        animeDetailController: Get.put(
                                            AnimeDetailController(
                                                animeId: e.animeId))));
                                  },
                                  child: Container(
                                      clipBehavior: Clip.antiAlias,
                                      height: 180,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Image.network(
                                        e.animeImg,
                                        fit: BoxFit.fitHeight,
                                      ))),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                e.animeTitle,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                // softWrap: true,
                              ),
                              Text(
                                e.releasedDate,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: theme.colorScheme.onPrimaryContainer,
                                    fontSize: 12),
                                // softWrap: true,
                              )
                            ],
                          ))
                      .toList()
                      .cast<Widget>(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
