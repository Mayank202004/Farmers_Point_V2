import 'package:get/get.dart';
import '../routes/routeNames.dart';
import '../services/storageServices.dart';
import '../services/supabaseService.dart';
import '../views/utils/storageKeys.dart';

class SettingController extends GetxController{
  void logout() async{
    // remove user session from local
    StorageService.session.remove(StorageKeys.userSession); // remove session from local storage
    await SupabaseService.SupabaseClientclient.auth.signOut(); // remove session from Supabase
    Get.offAllNamed(RouteNames.Login); // Remove all routes in stack memory and navigate to login page
  }
}