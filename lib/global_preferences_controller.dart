import 'dart:convert';
import 'dart:developer';

import 'package:animyon_flutter/anime_detail_model.dart';
import 'package:animyon_flutter/model/provider_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalPreferencesController extends GetxController {
  // final String providerPlaceholder;
  late final SharedPreferences prefs;
  final searchHistoryPrefs = RxList<String>();
  final favoritesPrefs = RxList<AnimeDetailModel>();
  final currentProvider = Rxn<ProviderModel>();

  GlobalPreferencesController({required ProviderModel provider}) {
    currentProvider.value = provider;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();

    getSearchHistory();
    getFavorites();
    getCurrentProvider();
  }

  void getSearchHistory() {
    final searchHistory = prefs.getStringList('search_history');
    // log(searchHistory.toString());
    if (searchHistory != null) {
      searchHistoryPrefs.value = searchHistory;
    }
  }

  void getFavorites() {
    final favorites = prefs.getStringList('favorites');
    // log(favorites.toString());
    if (favorites != null) {
      favoritesPrefs.value = List.from(favorites
          .map((e) => AnimeDetailModel.fromGogoanimeMap(jsonDecode(e))));
    }
  }

  Future<void> setFavorites(AnimeDetailModel animeDetailModel,
      {required void Function() onComplete}) async {
    final List<String> favoriteList;

    //if already favorited, delete from preferences
    if (isFavorited(animeDetailModel.animeId)) {
      favoritesPrefs.removeWhere(
          (element) => element.animeId == animeDetailModel.animeId);
      favoriteList = List.from(
          favoritesPrefs.map((element) => jsonEncode(element.toMap())));
      await prefs.setStringList('favorites', favoriteList);
    } else {
      //else, add to preferences
      favoriteList = List.from(
          favoritesPrefs.map((element) => jsonEncode(element.toMap())));
      await prefs.setStringList(
          'favorites', favoriteList..add(jsonEncode(animeDetailModel.toMap())));
    }

    getFavorites();
    onComplete();
  }

  Future<void> addSearchHistory(String query) async {
    await prefs.setStringList('search_history', searchHistoryPrefs..add(query));
  }

  bool isFavorited(String animeId) {
    final result =
        favoritesPrefs.firstWhereOrNull((p0) => p0.animeId == animeId) != null;
    log({'isFavorited': result}.toString());
    return result;
  }

  void getCurrentProvider() {
    final provider = prefs.getString('current_provider');
    // log(provider.toString());
    if (provider != null) {
      if (provider == 'otakudesu') {
        currentProvider.value = ProviderModel(
            name: provider,
            logoAssetUrl: 'assets/image/otakudesu.png',
            baseUrl: 'http://192.168.0.115:8000/api/');
      } else {
        currentProvider.value = ProviderModel(
            name: provider,
            logoAssetUrl: 'assets/image/gogoanime.png',
            baseUrl: 'http://192.168.0.115:3000/');
      }
    }
  }
}
