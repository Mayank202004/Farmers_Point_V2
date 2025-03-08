import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/seasonModel.dart';
import '../models/soilModel.dart';
import '../views/utils/helper.dart';

class SeasonController extends GetxController {
  var loading = false.obs;
  SeasonModel seasonModel=SeasonModel();

  Future<void> fetchSeason(String seasonType) async {
    try {
      loading.value = true;
      // Load the JSON data
      String jsonString = await rootBundle.loadString('assets/json/Season.json');
      var jsonData = json.decode(jsonString);

      // Find the season type directly
      var seasonData = jsonData.firstWhere(
            (plant) => plant['season_name'].toLowerCase() == seasonType.toLowerCase(),
        orElse: () => null, // Handle case when season is not found
      );
      if (seasonData != null) {
        seasonModel = SeasonModel.fromJson(seasonData);
      } else {
        showSnackBar("Error", "Season not found");
      }
    } catch (e) {
      showSnackBar("Error","$e");
    } finally {
      loading.value = false;
    }
  }
}
