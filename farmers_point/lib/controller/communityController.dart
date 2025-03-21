import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/postModel.dart';
import '../models/userModel.dart';
import '../services/supabaseService.dart';

class CommunityController extends GetxController{
  var loading=false.obs;
  RxList<PostModel> posts = RxList<PostModel>();
  @override
  void onInit() async{
    await fetchPosts();
    super.onInit();
  }

  // THis function is used to get all the posts from db
  Future<void> fetchPosts() async{
    loading.value=true;
    final List<dynamic> response = await SupabaseService.SupabaseClientclient.from("posts").select(''' 
    id,content,image,created_at,like_count,comment_count,user_id,
    user:user_id (email,isVerified,metadata), likes:likes (user_id, post_id)
     ''').order("id",ascending: false);
    loading.value=false;
    // If response is not empty then convert json to list using Model
    if(response.isNotEmpty){
      posts.value = [for(var item in response) PostModel.fromJson(item)];
    }
  }

  // listen realtime to database changes
  void listenChanges() async{
    SupabaseService.SupabaseClientclient
        .channel('public:posts')
        .onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'posts',
      callback: (payload) {
        //print('Change received: ${payload.toString()}');
        final PostModel post = PostModel.fromJson(payload.newRecord);
        updateFeed(post);
      },
    ).onPostgresChanges(
        event: PostgresChangeEvent.delete,
        schema: 'public',
        table: 'posts',
        callback: (payload) {
          //print('Delete event received: ${payload.toString()}');
          posts.removeWhere((element) => element.id == payload.oldRecord["id"]);
        }).subscribe();

  }

// to update feed
  void updateFeed(PostModel post) async{
    if (post.userId != null) {
      var user = await SupabaseService.SupabaseClientclient
          .from("users")
          .select("*")
          .eq("id", post.userId!)
          .single();
      post.likes = [];
      post.user = UserModel.fromJson(user);
      posts.insert(0, post);
    }
  }
}