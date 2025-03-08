import 'package:cropunity/views/widgets/postBottomBar.dart';
import 'package:cropunity/views/widgets/postTopBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/postModel.dart';
import '../../routes/routeNames.dart';
import '../utils/helper.dart';
import '../utils/type_def.dart';
import 'imageAvatar.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final bool isAuthCard;
  final DeleteCallback? callback;
  const PostCard({super.key, required this.post, this.isAuthCard=false, this.callback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: context.width * 0.12,
                child: ImageAvatar(radius: 30,url: post.user?.metadata?.image,),
              ),
              const SizedBox(width: 10,),
              SizedBox(
                width: context.width * 0.80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PostTopBar(post: post,callback: callback,isAuthCard: isAuthCard,),
                    GestureDetector(
                        onTap: ()=>{
                          Get.toNamed(RouteNames.ShowPost,arguments: post.id)
                        },
                        child: Text(post.content!)),
                    const SizedBox(height: 10,),
                    if(post.image!=null)
                      GestureDetector(
                        onTap: ()=> {
                          Get.toNamed(RouteNames.ShowImage,arguments: post.image!)
                        },
                        child: ConstrainedBox(constraints: BoxConstraints(
                            maxHeight: context.height * 0.60,
                            maxWidth: context.width * 0.80
                        ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(getBucketUrl(post.image!),fit: BoxFit.cover,alignment: Alignment.topCenter,),
                          ),
                        ),
                      ),
                    PostcardBottomBar(post: post),
                  ],
                ),
              )
            ],
          ),
          const Divider(
            color: Color(0xff242424),
          )
        ],
      ),
    );
  }
}
