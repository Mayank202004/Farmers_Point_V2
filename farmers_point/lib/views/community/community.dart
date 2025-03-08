import 'package:cropunity/routes/routeNames.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../controller/communityController.dart';
import '../widgets/loading.dart';
import '../widgets/postCard.dart';

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final CommunityController controller = Get.put(CommunityController());
  bool isFloatingVisible=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isFloatingVisible ? FloatingActionButton(
        onPressed: () {
          Get.toNamed(RouteNames.AddPost);
        },
        child: const Icon(Icons.add),
      ) : null,
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if(notification.direction == ScrollDirection.forward){
            setState(() {
              isFloatingVisible=true;
            });
          }
          else if(notification.direction == ScrollDirection.reverse){
            setState(() {
              isFloatingVisible=false;
            });
          }
            return true;
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: RefreshIndicator(
            onRefresh: () => controller.fetchPosts(),
            child: CustomScrollView(
              //shrinkWrap: true,
              //physics: BouncingScrollPhysics(),
              slivers: [
                const SliverAppBar(
                  snap: true,
                  title: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text("Community"),
                  ),
                  centerTitle: false,
                  floating: true,
                ),
                SliverToBoxAdapter(
                  child: Obx(() => controller.loading.value ? const Loading() : ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.posts.length,
                    itemBuilder: (BuildContext context, int index) => PostCard(post: controller.posts[index]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
