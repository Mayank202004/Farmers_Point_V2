import 'dart:io';
import 'package:cropunity/models/postModel.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/commentModel.dart';
import '../models/userModel.dart';
import '../services/supabaseService.dart';
import '../views/utils/env.dart';
import '../views/utils/helper.dart';


class ProfileController extends GetxController {
  var loading = false.obs;
  Rx<File?> image = Rx<File?>(null);
  var postLoading = false.obs;
  RxList<PostModel> posts = RxList<PostModel>();
  var repliesLoading = false.obs;
  RxList<ReplyModel> replies = RxList<ReplyModel>();

  var userLoading = false.obs;
  Rx<UserModel> user = Rx<UserModel>(UserModel());

  // Method to reset the data when switching profiles
  void reset() {
    user.value = UserModel(); // Reset user data
    posts.clear(); // Clear posts
    replies.clear(); // Clear replies
    postLoading.value = false; // Reset post loading state
    repliesLoading.value = false; // Reset replies loading state
  }

  //Update User
  Future<void> updateProfile(String userid, String description) async {
    try {
      loading.value = true;
      var uploadedPath = "";
      if (image.value != null && image.value!.existsSync()) {
        final String dir = "$userid/profile.jpg";
        var path = await SupabaseService.SupabaseClientclient.storage.from(
            Env.supabaseimagebucket).upload(
            dir, image.value!, fileOptions: const FileOptions(upsert: true));
        uploadedPath = path;
      }

      // Update User Profile
      await SupabaseService.SupabaseClientclient.auth.updateUser(
          UserAttributes(data: {
            "description": description,
            if (uploadedPath.isNotEmpty) "image": uploadedPath,
          }));
      loading.value = false;
      Get.back();
      showSnackBar("Success", "Profile Updated Successfully!");
    } on StorageException catch (error) {
      loading.value = false;
      showSnackBar("Error", error.message);
    } on AuthException catch (error) {
      loading.value = false;
      showSnackBar("Error", error.message);
    } catch (error) {
      loading.value = false;
      showSnackBar("Error", "Something went wrong");
    }
  }


  // pick image
  void pickImage() async {
    File? file = await pickImageFromGallery();
    if (file != null) image.value = file;
  }

  // Fetch Users
  void fetchUser (String userId) async{
    try{
      userLoading.value = true;
      final response = await SupabaseService.SupabaseClientclient
          .from("users")
          .select("*")
          .eq("id", userId)
          .single();
      userLoading.value=false;
      user.value = UserModel.fromJson(response);
      // fetch user posts and replies
      fetchUserViews(userId);
      fetchUserReplies(userId);

    }catch(error){
      userLoading.value =false;
      showSnackBar("Error", "Something went wrong.");

    }

  }


  // Fetch user posts (views)
  void fetchUserViews(String userId) async {
    try {
      postLoading.value=true;
      final List<dynamic> response = await SupabaseService.SupabaseClientclient
          .from("posts").select('''
      id,content,image,created_at,like_count,comment_count,user_id,user:user_id (email,metadata,isVerified), likes:likes (user_id, post_id)''')
          .eq("user_id", userId)
          .order("id", ascending: false);
      if(response.isNotEmpty){
        posts.value = [for(var item in response) PostModel.fromJson(item)];
      }
      postLoading.value=false;
    } catch (error) {
      postLoading.value=false;
      showSnackBar("Error", "Something went wrong");
    }
  }

  // Fetch user replies
  void fetchUserReplies(String userId) async {
    try {
      repliesLoading.value=true;
      final List<dynamic> response = await SupabaseService.SupabaseClientclient
          .from("comments").select('''id,user_id,post_id,reply,created_at,user:user_id (email,metadata,isVerified)''')
          .eq("user_id", userId)
          .order("id", ascending: false);
      if(response.isNotEmpty){
        replies.value=[for (var item in response) ReplyModel.fromJson(item)];
      }
      repliesLoading.value=false;
    } catch (error) {
      repliesLoading.value=false;
      showSnackBar("Error", "Something went wrong");
    }
  }

  // delete post
  Future<void> deleteThread(int postId) async{
    try{
      await SupabaseService.SupabaseClientclient.from("posts").delete().eq("id", postId);
      posts.removeWhere((element) => element.id == postId);
      if(Get.isDialogOpen == true) Get.back();

      showSnackBar("Success", "View deleted successfully");

    }catch(e){
      showSnackBar("Error", "Something went wrong");
    }
  }

  // delete comment
  Future<void> deleteReply(int replyId) async{
    try{
      await SupabaseService.SupabaseClientclient.from("posts").delete().eq("id", replyId);
      replies.removeWhere((element) => element.id == replyId);
      if(Get.isDialogOpen == true) Get.back();

      showSnackBar("Success", "Reply deleted successfully");

    }catch(e){
      showSnackBar("Error", "Something went wrong");
    }
  }
}