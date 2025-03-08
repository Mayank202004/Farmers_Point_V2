import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/soilModel.dart';
import '../views/utils/helper.dart';

class SoilController extends GetxController {
  var loading = false.obs;
  SoilModel soilModel=SoilModel();

  Future<void> fetchSoil(String soilType) async {
    try {
      loading.value = true;
      // Load the JSON data
      String jsonString = await rootBundle.loadString('assets/json/Soil.json');
      var jsonData = json.decode(jsonString);

      // Find the soil type directly
      var soilData = jsonData.firstWhere(
            (plant) => plant['soil_name'].toLowerCase() == soilType.toLowerCase(),
        orElse: () => null, // Handle case when soil is not found
      );
      if (soilData != null) {
        soilModel = SoilModel.fromJson(soilData);
      } else {
        showSnackBar("Error", "Soil not found");
      }
    } catch (e) {
      showSnackBar("Error","$e");
    } finally {
      loading.value = false;
    }
  }
}
