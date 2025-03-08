import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/commentModel.dart';
import '../utils/helper.dart';
import 'app_icons.dart';
import 'imageAvatar.dart';

class CommentCard extends StatelessWidget {
  final ReplyModel reply;
  const CommentCard({super.key, required this.reply});

  @override
  Widget build(BuildContext context) {
    return Column(
        children:[
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: context.width * 0.12,
                  child: ImageAvatar(radius: 30,url: reply.user?.metadata?.image,),
                ),
                const SizedBox(width: 10,),
                SizedBox(
                  width: context.width * 0.80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  Text(reply.user!.metadata!.name!,style: const TextStyle(fontWeight: FontWeight.bold),),
                                  const SizedBox(width: 3,),
                                  if (reply.user!.isVerified!)
                                    const Icon(
                                      AppIcons.verified_user,
                                      size: 15,
                                      color: Colors.blue, // Optional: Add a color for distinction
                                    ),
                                ],
                              ),
                              const Text("replied to @user",style: TextStyle(color: Colors.grey),),
                            ],
                          ),
                          Row(
                            children: [
                              Text(formatDateTime(reply.createdAt!)),
                              IconButton(onPressed: (){}, icon: const Icon(Icons.more_horiz)),
                            ],
                          ),
                        ],
                      ),
                      Text(reply.reply!)
                    ],
                  ),
                ),

              ]
          ),
          const Divider(
            color: Color(0xff242424),
          )
        ]
    );

  }
}
