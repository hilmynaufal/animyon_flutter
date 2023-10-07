import 'dart:convert';

import 'package:animyon_flutter/api_service.dart';
import 'package:animyon_flutter/global_preferences_controller.dart';
import 'package:animyon_flutter/search_response.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AnimeSearchController extends GetxController {
  final searchResponse = RxList<SearchResponse>();
  final searchTextEditController = TextEditingController();
  Future<void> searchAnime({required String query}) async {
    final provider = Get.find<GlobalPreferencesController>();
    final response = await ApiService.getCall(
        header: 'search?keyw=$query',
        baseUrl: provider.currentProvider.value!.baseUrl);

    if (response.statusCode == 200) {
      searchResponse.value = List.from(
          jsonDecode(response.body).map((e) => SearchResponse.fromMap(e)));
    }
  }

  @override
  void dispose() {
    searchTextEditController.dispose();
    super.dispose();
  }
}
