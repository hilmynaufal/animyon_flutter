import 'dart:convert';

import 'package:animyon_flutter/api_service.dart';
import 'package:animyon_flutter/global_preferences_controller.dart';
import 'package:animyon_flutter/top_airing_response.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final topAiringList = RxList<TopAiringResponse>();

  Future<void> getTopAiring() async {
    final currentProvider =
        Get.find<GlobalPreferencesController>().currentProvider.value;
    final response = await ApiService.getCall(
        header: currentProvider!.name == 'otakudesu'
            ? 'ongoing/page/1'
            : 'top-airing?page=1',
        baseUrl: currentProvider.baseUrl);

    if (response.statusCode == 200) {
      if (currentProvider.name == 'otakudesu') {
        topAiringList.value = List.from(jsonDecode(response.body)['animeList']
            .map((e) => TopAiringResponse.fromOtakudesuMap(e)));
      } else {
        topAiringList.value = List.from(jsonDecode(response.body)
            .map((e) => TopAiringResponse.fromGogoanimeMap(e)));
      }
      update(['top_airing', 'most_popular']);
    } else {
      throw UnimplementedError();
    }
  }
}
