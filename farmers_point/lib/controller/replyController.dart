import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../services/supabaseService.dart';
import '../views/utils/helper.dart';

class ReplyController extends GetxController{
  final TextEditingController replyController = TextEditingController(text: "");
  var loading = false.obs;
  var reply = "".obs;

  void addReply(String userId,int postId,String postUserID) async{
    try{
      loading.value=true;

      // increase comment count
      await SupabaseService.SupabaseClientclient.rpc("comment_increment", params: {"count":1,"row_id":postId});

      // Add Notification
      if(postUserID!=userId){
        await SupabaseService.SupabaseClientclient.from("notifications").insert({
          "user_id":userId,
          "post_id":postId,
          "notification":"commented on your post",
          "to_user_id":postUserID});}

      // Add comment in comments table
      await SupabaseService.SupabaseClientclient.from("comments").insert({
        "post_id":postId,
        "user_id":userId,
        "reply":replyController.text
      });

      loading.value=false;
      showSnackBar("Success", "Comment added Successfully");

    } catch(error){
      showSnackBar("Error", "Something went wrong");
    }
  }

  @override
  void onClose(){
    replyController.dispose();
    super.onClose();
  }
}