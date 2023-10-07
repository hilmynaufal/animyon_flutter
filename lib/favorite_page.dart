import 'package:animyon_flutter/anime_detail_controller.dart';
import 'package:animyon_flutter/anime_detail_page.dart';
import 'package:animyon_flutter/global_preferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritePage extends StatelessWidget {
  FavoritePage({super.key});

  final globalPreferencesController = Get.find<GlobalPreferencesController>()
    ..getFavorites();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 32,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              'Favorites',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Obx(() {
            if (globalPreferencesController.favoritesPrefs.isEmpty) {
              return const Text('No Favorite');
            }
            return Expanded(
              child: ListView.builder(
                itemCount: globalPreferencesController.favoritesPrefs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => AnimeDetailPage(
                          animeDetailController: Get.put(AnimeDetailController(
                              animeId: globalPreferencesController
                                  .favoritesPrefs[index].animeId))));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              height: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Image.network(
                                globalPreferencesController
                                    .favoritesPrefs[index].animeImg,
                                fit: BoxFit.fitHeight,
                              )),
                          const SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  globalPreferencesController
                                      .favoritesPrefs[index].animeTitle,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${globalPreferencesController.favoritesPrefs[index].releasedDate}  ${globalPreferencesController.favoritesPrefs[index].status}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.primary),
                                ),
                                SizedBox(
                                  height: 30,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: globalPreferencesController
                                        .favoritesPrefs[index].genres
                                        .map((e) => Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 4),
                                              child: ElevatedButton(
                                                  onPressed: () {},
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          side: BorderSide(
                                                              width: 1,
                                                              color: theme
                                                                  .colorScheme
                                                                  .primary))),
                                                  child: Text(
                                                    e,
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  )),
                                            ))
                                        .toList()
                                        .cast<Widget>(),
                                  ),
                                ),
                                Text(
                                  '${globalPreferencesController.favoritesPrefs[index].totalEpisodes} Episodes',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: theme
                                          .colorScheme.onSecondaryContainer),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          })
        ],
      )),
    );
  }
}
