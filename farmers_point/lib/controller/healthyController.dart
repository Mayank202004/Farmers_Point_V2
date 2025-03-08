import 'dart:convert';

import 'package:cropunity/models/healthyPlantModel.dart';
import 'package:cropunity/views/utils/helper.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HealthyController extends GetxController {
  var loading=false.obs;
  HealthyPlantModel healthyPlantModel = HealthyPlantModel();
  final urlImages = [
    'https://mjxkyduomhstppmdbidb.supabase.co/storage/v1/object/public/fpBucket/application/tomatoLateBlight1.jpg?t=2024-09-15T10%3A30%3A42.650Z',
    'https://mjxkyduomhstppmdbidb.supabase.co/storage/v1/object/public/fpBucket/application/tomatoLateBlight2.jpg?t=2024-09-15T10%3A31%3A01.059Z',
    'https://mjxkyduomhstppmdbidb.supabase.co/storage/v1/object/public/fpBucket/application/tomatoLateBlight3.jpg?t=2024-09-15T10%3A31%3A10.774Z',
    'https://mjxkyduomhstppmdbidb.supabase.co/storage/v1/object/public/fpBucket/application/tomatoLateBlight4.jpg?t=2024-09-15T10%3A29%3A49.651Z'
  ];


  Future<void> fetchPlant(String plantType) async {
    try {
      loading.value = true;
      // Load JSON from assets
      String jsonString = await rootBundle.loadString(
          'assets/json/healthy.json');
      // Parse JSON data and map to the model
      var jsonData = json.decode(jsonString);
      var plantData = jsonData.firstWhere(
            (plant) => plant['name'].toLowerCase() == plantType.toLowerCase(),
        orElse: () => null, // Handle case when plant is not found
      );
      if (plantData != null) {
        healthyPlantModel = HealthyPlantModel.fromJson(plantData);
      } else {
        showSnackBar("Error", "Plant not found");
      }
    } catch(e){
      showSnackBar("Error", "Something went wrong");
    }
  }
}