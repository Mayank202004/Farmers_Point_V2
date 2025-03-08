import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../controller/postController.dart';
import '../../models/postModel.dart';
import '../../routes/routeNames.dart';
import '../../services/supabaseService.dart';

class PostcardBottomBar extends StatefulWidget {
  final PostModel post;
  const PostcardBottomBar({super.key, required this.post});

  @override
  State<PostcardBottomBar> createState() => _PostcardBottombarState();
}

class _PostcardBottombarState extends State<PostcardBottomBar> {
  String likeStatus = "";
  final ViewsController controller = Get.put(ViewsController());
  final SupabaseService supabaseService = Get.find<SupabaseService>();
  void likeDislike(String status) async{
    setState(() {
      likeStatus = status;
    });
    if(likeStatus == "0") {
      widget.post.likes = [];
    }
    await controller.likeDislike(status, widget.post.id!, widget.post.userId!, supabaseService.currentUser.value!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children:[ Row(
          children: [
            likeStatus=="1" || widget.post.likes!.isNotEmpty
                ? IconButton(onPressed: (){
              likeDislike("0");
            },
                icon: Icon(Icons.favorite,color: Colors.red[700],))
                :IconButton(onPressed: (){
              likeDislike("1");
            },
                icon: const Icon(Icons.favorite_outline)),
            IconButton(onPressed: (){
              Get.toNamed(RouteNames.AddReply,arguments: widget.post);
            }, icon: const Icon(Icons.chat_bubble_outline)),
            IconButton(onPressed: (){}, icon: const Icon(Icons.send_outlined)),
          ],
        ),
          Row(children: [
            Text("${widget.post.likeCount} likes"),
            const SizedBox(width: 10,),
            Text("${widget.post.commentCount} replies"),

          ],
          )
        ]
    );
  }
}
