import 'package:cropunity/views/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/postModel.dart';
import '../../routes/routeNames.dart';
import '../../services/navigationService.dart';
import '../../services/supabaseService.dart';
import '../utils/helper.dart';
import '../utils/type_def.dart';
import 'app_icons.dart';

class PostTopBar extends StatelessWidget {
  final PostModel post;
  final bool isAuthCard;
  final DeleteCallback? callback;
  const PostTopBar({super.key, required this.post, this.isAuthCard=false, this.callback});

  @override
  Widget build(BuildContext context) {
    final SupabaseService supabaseService = Get.find<SupabaseService>();
    final NavigationService navigationService = Get.find<NavigationService>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
            onTap: (){
              // If the clicked username is on self then navigate to profile else navigate to specific user showprofile
              if (post.userId == supabaseService.currentUser.value!.id) {
                navigationService.updateCurrentIndex(4);
              } else {
                Get.toNamed(RouteNames.ShowProfile, arguments: post.userId); // Navigate to other user's profile
              }
            },
            child: Row(
              children: [
                Text(post.user!.metadata!.name!,style: const TextStyle(fontWeight: FontWeight.bold),),
                const SizedBox(width: 5,),
                if (post.user!.isVerified!)
                  const Icon(
                    AppIcons.verified_user,
                    size: 15,
                    color: Colors.blue, // Optional: Add a color for distinction
                  ),
              ],
            )),
        Row(
          children: [
            Text(formatDateTime(post.createdAt!)),
            isAuthCard ? PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  // Handle edit action
                  Get.toNamed(RouteNames.AddPost, arguments: post);
                } else if (value == 'delete') {
                  // Handle delete action (show confirmation dialog)
                  confirmDialog(
                    "Are you sure?",
                    "The post will be deleted forever.",
                        () {
                      callback!(post.id!);  // Call the delete callback with the postId
                    },
                  );
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
              icon: const Icon(Icons.more_horiz),
            )
                : IconButton(onPressed: () {},icon: const Icon(Icons.more_horiz),
            ),
          ],
        )
      ],
    );
  }
}
