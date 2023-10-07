import 'dart:convert';

import 'package:animyon_flutter/api_service.dart';
import 'package:animyon_flutter/genre_detail_response.dart';
import 'package:animyon_flutter/global_preferences_controller.dart';
import 'package:get/get.dart';

class GenreDetailController extends GetxController {
  final String genreName;
  final genreDetailResponseList = RxList<GenreDetailResponse>();

  GenreDetailController({required this.genreName});

  Future<void> getGenreDetail() async {
    final provider = Get.find<GlobalPreferencesController>();
    final response = await ApiService.getCall(
        header: 'genre/$genreName?page=1',
        baseUrl: provider.currentProvider.value!.baseUrl);

    if (response.statusCode == 200) {
      genreDetailResponseList.value = List.from(
          jsonDecode(response.body).map((e) => GenreDetailResponse.fromMap(e)));
    }
  }
}
