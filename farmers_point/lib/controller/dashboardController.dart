import 'package:cropunity/views/utils/helper.dart';
import 'package:get/get.dart';
import '../services/supabaseService.dart';

class DashboardController extends GetxController {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();
  RxList<String> selectedCrops = <String>[].obs; // RxList in controller
  var loading = false.obs;
  RxInt profit =0.obs;


  @override
  void onInit() {
    super.onInit();
    fetchUserCrops(); // Fetch user's crops when the controller is created
    fetchTotalProfit();
  }

  // Fetch user's crops
  Future<void> fetchUserCrops() async {
    loading.value = true;
    final user = _supabaseService.currentUser.value;
    if (user != null) {
      try {
        final response = await SupabaseService.SupabaseClientclient
            .from('user_crops')
            .select('crop_name')
            .eq('user_id', user.id);
        selectedCrops.value =
        List<String>.from(response.map((row) => row['crop_name']));
        loading.value = false;
      } catch (error) {
        loading.value = false;
        showSnackBar("Error", "Error fetching user crop data");
      }
    }
  }

  // Add a crop to Supabase
  Future<void> addCropToSupabase(String crop) async {
    loading.value = true;
    final user = _supabaseService.currentUser.value;
    if (user != null) {
      try {
        await SupabaseService.SupabaseClientclient.from('user_crops').insert({
          'user_id': user.id,
          'crop_name': crop,
        });
        selectedCrops.add(crop); // Update RxList
        loading.value = false;
        showSnackBar("Success", "Crop added successfully");
      } catch (error) {
        loading.value = false;
        showSnackBar("Error", "Failed to add crop.");
      }
    }
  }

  // Delete a crop from Supabase
  Future<void> deleteCropFromSupabase(String crop) async {
    loading.value = true;
    final user = _supabaseService.currentUser.value;
    if (user != null) {
      try {
        await SupabaseService.SupabaseClientclient.from('user_crops').delete().eq(
            'user_id', user.id).eq('crop_name', crop);
        selectedCrops.remove(crop); // Update RxList
        loading.value = false;
        showSnackBar("Success", "Crop deleted successfully");
      } catch (error) {
        loading.value = false;
        showSnackBar("Error", "Failed to delete crop.");
      }
    }
  }

  Future<void> fetchTotalProfit() async {
    try {
      var id=_supabaseService.currentUser.value?.id;
      final response = await SupabaseService.SupabaseClientclient.rpc(
          'get_total_profit',params: {'user_id': id});
      if(response!=null) {
        profit.value=response;
      } else{
        profit.value=0;
      }
    }catch(e){
      profit.value=0;
      showSnackBar("Error", "Cannot load total profit");
      print(e);
    }
  }




  @override
  void onClose() {
    super.onClose();
  }
}
