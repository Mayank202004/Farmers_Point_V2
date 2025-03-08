import 'dart:convert';

import 'package:cropunity/models/weatherModel.dart';
import 'package:cropunity/views/utils/helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../views/utils/env.dart';

class WeatherController extends GetxController{
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  var loading=false.obs;
  var weather = Rx<Weather?>(null);
  var isWeatherFetched = false.obs;

  Future<void> fetchWeather() async {
    if (!isWeatherFetched.value) {
      loading.value = true;
      try {
        // Replace with your weather fetching logic
        weather.value = await getWeather();
        isWeatherFetched.value = true;
      } finally {
        loading.value = false;
      }
    }
  }
  // Get weather details with location
  Future<Weather> getWeather() async{
    try{
      loading.value=true;
      Position position = await fetchPosition();
      final response = await http.get(Uri.parse('$BASE_URL?lon=${position.longitude}&lat=${position.latitude}&appid=${Env.openWeatherKey}&units=metric'));

      if(response.statusCode == 200){
        loading.value=false;
        return Weather.fromJson(jsonDecode(response.body));
      }else{
        throw Exception();
      }
    }catch(error){
      loading.value=false;
      showSnackBar("Error", "Cannot fetch weather details");
      return Future.error(error);
    }
  }
  Future<Position> fetchPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition(locationSettings: AndroidSettings(accuracy: LocationAccuracy.bestForNavigation));
  }
}