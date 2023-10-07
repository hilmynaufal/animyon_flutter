import 'package:animyon_flutter/anime_detail_controller.dart';
import 'package:animyon_flutter/anime_detail_page.dart';
import 'package:animyon_flutter/data_const.dart';
import 'package:animyon_flutter/favorite_page.dart';
import 'package:animyon_flutter/genre_detail_controller.dart';
import 'package:animyon_flutter/genre_detail_page.dart';
import 'package:animyon_flutter/global_preferences_controller.dart';
import 'package:animyon_flutter/home_controller.dart';
import 'package:animyon_flutter/model/provider_model.dart';
import 'package:animyon_flutter/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  //TODO: still in test using placeholder
  Get.put(GlobalPreferencesController(
      provider: ProviderModel(
          name: 'gogoanime',
          logoAssetUrl: 'logoAssetUrl',
          baseUrl: 'http://192.168.0.115:3000/')));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        // brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    height: 50,
                    child: Image.asset('assets/images/logo-no-background.png')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.to(() => SearchPage());
                      },
                      icon: Icon(
                        CupertinoIcons.search,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(() => FavoritePage());
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(
                      width: 32,
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Most Popular',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            GetBuilder<HomeController>(
                id: 'most_popular',
                builder: (controller) {
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: 3,
                      physics: const PageScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (controller.topAiringList.isEmpty) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: FractionallySizedBox(
                                widthFactor: 0.95,
                                child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Container(
                                      color: theme.colorScheme.secondary,
                                    ))),
                          );
                        }
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: FractionallySizedBox(
                              widthFactor: 0.95,
                              child: Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Image.network(
                                    controller.topAiringList[index].animeImg,
                                    fit: BoxFit.fitWidth,
                                  ))),
                        );
                      },
                    ),
                  );
                }),
            const SizedBox(
              height: 32,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Top Airing',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            GetBuilder<HomeController>(
              id: 'top_airing',
              builder: (controller) {
                if (controller.topAiringList.isEmpty) {
                  controller.getTopAiring();
                  return const CircularProgressIndicator();
                }
                return SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.topAiringList.length,
                    itemBuilder: (context, index) {
                      final anime = controller.topAiringList[index];
                      return Container(
                        margin: EdgeInsets.only(
                            left: index == 0 ? 16 : 0,
                            right: index + 1 == controller.topAiringList.length
                                ? 16
                                : 0),
                        child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                                clipBehavior: Clip.antiAlias,
                                style: ElevatedButton.styleFrom(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    padding: const EdgeInsets.all(8),
                                    // shadowColor: Colors.transparent,
                                    // foregroundColor: Colors.transparent,
                                    surfaceTintColor: Colors.transparent,
                                    backgroundColor: Colors.transparent),
                                onPressed: () {
                                  Get.to(() => AnimeDetailPage(
                                      animeDetailController: Get.put(
                                          AnimeDetailController(
                                              animeId: anime.animeId))));
                                },
                                child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    height: 140,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Image.network(
                                      anime.animeImg,
                                      fit: BoxFit.fitHeight,
                                    ))),
                            SizedBox(
                              width: 100,
                              child: Text(
                                anime.animeTitle,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 2,
                                // softWrap: true,
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Text(
                                anime.latestEp,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: TextStyle(
                                    color: theme.colorScheme.onPrimaryContainer,
                                    fontSize: 12),
                                // softWrap: true,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Genre List',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              height: 180,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                // maxCrossAxisExtent: 200,
                spacing: 8,
                children: DataConst.genreList
                    .take(10)
                    .toList()
                    // .asMap()
                    // .entries
                    .map((e) => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          Get.to(() => GenreDetailPage(
                              genreDetailController: Get.put(
                                  GenreDetailController(genreName: e))));
                        },
                        child: Text(e.capitalizeFirst!)))
                    .toList()
                    .cast<Widget>(),
              ),
            ),
            const SizedBox(
              height: 32,
            )
          ],
        ),
      )),
    );
  }
}
