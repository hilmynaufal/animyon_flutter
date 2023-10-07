import 'package:animyon_flutter/anime_detail_controller.dart';
import 'package:animyon_flutter/anime_detail_page.dart';
import 'package:animyon_flutter/global_preferences_controller.dart';
import 'package:animyon_flutter/search_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final controller = Get.put(AnimeSearchController());
  final globalPreferencesController = Get.find<GlobalPreferencesController>()
    ..getSearchHistory();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              'Search',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: controller.searchTextEditController,
                // onChanged: (value) {

                // },
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  controller.searchAnime(query: value);
                  globalPreferencesController.addSearchHistory(value);
                },
                decoration: const InputDecoration(
                    // suffix: Icon(Icons.clear_outlined),
                    suffixIcon: Icon(Icons.clear_outlined),
                    filled: true,
                    enabledBorder: OutlineInputBorder()),
              )),
          const SizedBox(
            height: 32,
          ),
          Obx(() {
            if (controller.searchResponse.isEmpty) {
              if (globalPreferencesController.searchHistoryPrefs.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        globalPreferencesController.searchHistoryPrefs.length,
                    itemBuilder: (context, index) {
                      final searchQuery =
                          globalPreferencesController.searchHistoryPrefs[index];
                      return GestureDetector(
                        onTap: () {
                          controller.searchTextEditController.text =
                              globalPreferencesController
                                  .searchHistoryPrefs[index];
                          controller.searchAnime(
                              query: controller.searchTextEditController.text);
                          globalPreferencesController.addSearchHistory(
                              controller.searchTextEditController.text);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.history,
                                size: 28,
                              ),
                              const SizedBox(
                                width: 32,
                              ),
                              Text(
                                searchQuery,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return const Center(child: Text('No Search History'));
            }
            return Expanded(
              child: ListView.builder(
                itemCount: controller.searchResponse.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => AnimeDetailPage(
                          animeDetailController: Get.put(AnimeDetailController(
                              animeId:
                                  controller.searchResponse[index].animeId))));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Container(
                              clipBehavior: Clip.antiAlias,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Image.network(
                                controller.searchResponse[index].animeImg,
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
                                  controller.searchResponse[index].animeTitle,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  controller.searchResponse[index].status,
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
