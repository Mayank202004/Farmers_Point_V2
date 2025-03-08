import 'package:get/get.dart';
import '../models/notificationModel.dart';
import '../services/supabaseService.dart';
import '../views/utils/helper.dart';

class NotificationController extends GetxController{
  var loading = false.obs;
  RxList<NotificationModel> notifications = RxList<NotificationModel>();

  void fetchNotifications(String userId) async{
    try{
      loading.value=true;
      final List<dynamic> response = await SupabaseService.SupabaseClientclient.from("notifications").select(
          ''' id,post_id,notification,created_at,user_id,user:user_id (email,metadata)'''
      ).eq("to_user_id", userId).order("id",ascending: false);

      if(response.isNotEmpty){
        notifications.value = [for(var item in response) NotificationModel.fromJson(item)];
      }

      loading.value=false;

    }catch(error){
      loading.value=false;
      showSnackBar("Error", "Something went wrong");
    }
  }

}