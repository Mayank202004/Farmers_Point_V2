import 'dart:convert';

import 'package:cropunity/controller/weatherController.dart';
import 'package:cropunity/models/plantModel.dart';
import 'package:cropunity/models/weatherModel.dart';
import 'package:cropunity/views/utils/helper.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PlantController extends GetxController{
  var loading=false.obs;
  PlantModel plant = PlantModel();
  WeatherController controller = Get.find<WeatherController>();

  List<double> optimalTemps=List.empty();
  double optimalMin=0;
  double optimalMax=0;
  double tooLowTemp=0;
  double tooHighTemp=0;
  // Assume current temperature for example
  double currentTemp=25;


  Future<void> fetchPlant(String plantType) async {
    try {
      loading.value = true;

      // Load JSON from assets
      String jsonString = await rootBundle.loadString('assets/json/$plantType.json');

      // Parse JSON data and map to the model
      var jsonData = json.decode(jsonString);
      plant = PlantModel.fromJson(jsonData); // Assuming PlantModel has a fromJson method

      // setup temp bar values
      try{
        optimalTemps = parseOptimalRange(plant.climate!.temperature!.optimalRange!);
        optimalMin = optimalTemps[0];
        optimalMax = optimalTemps[1];
        tooLowTemp = parseExtremeTemperature(plant.climate!.temperature!.tooLow!);
        tooHighTemp = parseExtremeTemperature(plant.climate!.temperature!.tooHigh!);
        currentTemp = controller.weather.value!.temperature;
      }catch(e){}

      loading.value = false;
    } catch (e) {
      loading.value = false;
      showSnackBar("Error", '$e');
    }
  }


  List<double> parseOptimalRange(String range) {
    RegExp regExp = RegExp(r"(\d+)");
    Iterable<Match> matches = regExp.allMatches(range);
    return matches.map((m) => double.parse(m[0]!)).toList();
  }

  // Function to extract value from "Below" or "Above"
  double parseExtremeTemperature(String extreme) {
    RegExp regExp = RegExp(r"(\d+)");
    return double.parse(regExp.firstMatch(extreme)![0]!);
  }

}