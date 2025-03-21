import 'dart:convert';

import 'package:cropunity/models/infoModel.dart';
import 'package:cropunity/services/supabaseService.dart';
import 'package:get/get.dart';

import '../views/utils/helper.dart';

class InfoController extends GetxController{
  String address="";
  double area=0.0;
  String unit="Acres";
  String contact="";
  int age=0;
  String qualification="None";
  String degree="None";
  String description="";
  Rx<InfoModel> info=Rx<InfoModel>(InfoModel());

  RxBool loading = false.obs;
  final SupabaseService supabaseService = Get.find<SupabaseService>();

  @override
  void onInit(){
    fetchInfo();
    super.onInit();
  }

  Future<void> fetchInfo() async {
    loading.value = true;
    final user = supabaseService.currentUser.value;
    if (user != null) {
      try {
        final response = await SupabaseService.SupabaseClientclient
            .from('farmer_info')
            .select()
            .eq('userId', user.id).maybeSingle();
        if(response!=null) {
          info.value=InfoModel.fromJson(response);
        }
        //print(jsonEncode(response));
        loading.value = false;
      } catch (error) {
        //print(error);
        loading.value = false;
        showSnackBar("Error", "Error fetching user info");
      }
    }
  }


  Future<void> updateInfo() async {
    loading.value = true;
    final user = supabaseService.currentUser.value;
    if (user != null) {
      try {
        // Use upsert to insert or update the record
        await SupabaseService.SupabaseClientclient
            .from('farmer_info')
            .upsert({
          'farmAddress': address,
          'farmArea': area,
          'unit': unit,
          'contact': contact,
          'age': age,
          'qualification': qualification,
          'agriculturalDegree': degree,
          'description': description,
          'userId': user.id, // Ensure the conflict key is included
        }, onConflict: 'userId');
        loading.value = false;
        showSnackBar("Success", "Info changed successfully");
      } catch (error) {
        loading.value = false;
        showSnackBar("Error", "Failed to change info.");
      }
    }
  }
}
