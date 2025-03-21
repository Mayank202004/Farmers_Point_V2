import 'dart:io';
import 'package:cropunity/routes/routeNames.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/commentModel.dart';
import '../models/postModel.dart';
import '../services/navigationService.dart';
import '../services/supabaseService.dart';
import '../views/utils/env.dart';
import '../views/utils/helper.dart';

class ViewsController extends GetxController{
  final TextEditingController textEditingController = TextEditingController(text: "");
  var content = "".obs;
  var loading = false.obs;
  Rx<File?> image = Rx<File?>(null);

  // show view variables
  var showViewLoading = false.obs;
  Rx<PostModel> postFetched = Rx<PostModel>(PostModel());

  // fetch comments variables
  var showReplyLoading = false.obs;
  RxList<ReplyModel> replies = RxList<ReplyModel>();

  // To pick image to share with view
  void pickImage() async {
    String currentText = content.value; // Store existing content

    File? file = await pickImageFromGallery();
    if (file != null) {
      image.value = file;
      image.refresh();  // Ensure UI updates without clearing text
    }

    content.value = currentText; // Restore text
    textEditingController.text = currentText; // Ensure UI reflects the change
  }


  void post(String userId) async{
    try {
      loading.value = true;
      // Upload Photo and get path
      const uuid=Uuid();
      final dir = "$userId/${uuid.v6()}";
      var imgPath="";
      if(image.value != null && image.value!.existsSync()){
        imgPath = await SupabaseService.SupabaseClientclient.storage
            .from(Env.supabaseimagebucket)
            .upload(dir, image.value!);
      }
      // Save post to db with image path and msg
      await SupabaseService.SupabaseClientclient.from("posts").insert({
        "user_id":userId,
        "content":content.value,
        "image":imgPath.isNotEmpty ? imgPath : null
      });
      loading.value=false;
      Get.toNamed(RouteNames.Home);
      //Get.find<NavigationService>().currentIndex.value=0;
      //resetState();
      showSnackBar("Success", "View added Successfully");
    }on StorageException catch(error){
      // resetState();
      loading.value=false;
      showSnackBar("Error", error.message);
    }
    catch(error){
      // resetState();
      loading.value=false;
      showSnackBar("Error", "Something went wrong");
    }
  }

  // update post
  void editPost(int postId) async {
    try {
      loading.value = true;

      final response = await SupabaseService.SupabaseClientclient
          .from("posts")
          .update({
        "content": content.value,
      }).eq("id", postId);  // Update the post where the ID matches
      loading.value = false;
      Get.toNamed(RouteNames.Home);
      showSnackBar("Success", "View updated successfully");
    } on StorageException catch (error) {
      // resetState();
      loading.value = false;
      showSnackBar("Error", error.message);
    } catch (error) {
      // resetState();
      loading.value = false;
      showSnackBar("Error", "Something went wrong");
    }
  }



  // Show VIew
  void show(int postId) async{
    try{
      postFetched.value=PostModel();
      replies.value=[];
      showViewLoading.value=true;
      // get single post from post id
      final response = await SupabaseService.SupabaseClientclient.from("posts").select(
          '''id,content,image,created_at,like_count,comment_count,user_id,
    user:user_id (email,metadata,isVerified), likes:likes (user_id, post_id)'''
      ).eq("id",postId).single();
      showViewLoading.value=false;
      postFetched.value = PostModel.fromJson(response);
      // fetch respective comments
      fetchPostComments(postId);
    }catch(error){
      showViewLoading.value=false;
      showSnackBar("Error", "Something went wrong");
    }
  }

  // Like dislike function

  Future<void> likeDislike(String status,int postId, String postUserId,String userId) async{
    if(status == "1"){
      // add entry to likes table
      await SupabaseService.SupabaseClientclient
          .from("likes")
          .insert({"user_id":userId, "post_id":postId});

      // Add notification for like added
      if(postUserId!=userId){ // DOnt add to notification if user self liked
        await SupabaseService.SupabaseClientclient.from("notifications").insert({
          "user_id":userId,
          "post_id":postId,
          "notification":"liked your post",
          "to_user_id":postUserId});}

      // increase like count
      await SupabaseService.SupabaseClientclient.rpc("like_increment",params:{"count":1,"row_id": postId});

    } else{
      // delete entry from likes table
      await SupabaseService.SupabaseClientclient
          .from("likes")
          .delete()
          .match({"user_id":userId, "post_id":postId});

      // delete notification
      // Add notification for like added
    if(postUserId!=userId){
      await SupabaseService.SupabaseClientclient
          .from("notifications")
          .delete()
          .match({"user_id":userId,"post_id":postId,"to_user_id":postUserId,"notification":"liked your post"});}
      //add field type in supabase table cause deleteing based on userid and post id may delete reply as well

      // decrement like count
      await SupabaseService.SupabaseClientclient.rpc("like_decrement",params:{"count":1,"row_id": postId});

    }
  }


  // fetch post comments
  void fetchPostComments(int postId) async{
    try{
      showReplyLoading.value=true;
      final List<dynamic> response = await SupabaseService.SupabaseClientclient
          .from("comments").select('''id,user_id,post_id,reply,created_at,user:user_id (email,metadata,isVerified)''')
          .eq("post_id",postId)
          .order("id", ascending: false);
      if(response.isNotEmpty){
        replies.value=[for (var item in response) ReplyModel.fromJson(item)];
      }
      showReplyLoading.value=false;

    }catch(error){
      showReplyLoading.value=false;
      showSnackBar("Error", "Something went wrong");
    }

  }





// // to reset add view variables state
//   void resetState(){
//     content.value="";
//     image.value=null;
//   }

  @override
  void onClose(){
    //textEditingController.dispose();
    super.onClose();
  }
}