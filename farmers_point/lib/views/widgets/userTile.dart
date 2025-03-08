import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/userModel.dart';
import '../../routes/routeNames.dart';
import '../utils/helper.dart';
import 'imageAvatar.dart';

class Usertile extends StatelessWidget {
  final UserModel user;
  const Usertile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(padding: const EdgeInsets.only(top: 6)
        ,child: ImageAvatar(radius: 20,url: user.metadata?.image,),),
      title: Text(user.metadata!.name!),
      titleAlignment: ListTileTitleAlignment.top,
      trailing: OutlinedButton(onPressed: (){Get.toNamed(RouteNames.ShowProfile,arguments: user.id);}, child: const Text("View Profile"),),
      subtitle: Text(formatDateTime(user.createdAt!)),
    );
  }
}
