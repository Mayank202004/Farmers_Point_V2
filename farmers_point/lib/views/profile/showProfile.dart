import 'package:cropunity/views/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/profileController.dart';
import '../../routes/routeNames.dart';
import '../widgets/commentCard.dart';
import '../widgets/imageAvatar.dart';
import '../widgets/loading.dart';
import '../widgets/postCard.dart';

class ShowProfile extends StatefulWidget {
  const ShowProfile({super.key});

  @override
  State<ShowProfile> createState() => _ShowProfileState();
}

class _ShowProfileState extends State<ShowProfile> {
  final String userId = Get.arguments;
  final ProfileController controller = Get.put(ProfileController());


  @override
  void initState(){
    controller.reset();
    controller.fetchUser(userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: false,
        actions: [IconButton(onPressed: () => Get.toNamed(RouteNames.Settings), icon: const Icon(Icons.sort))],
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 100,
                collapsedHeight: 100,
                automaticallyImplyLeading: false,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child:Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(controller.userLoading.value)
                                const Loading()
                              else
                                Text(
                                  controller.user.value.metadata!.name!,
                                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                              SizedBox(
                                  width: context.width * 0.70,
                                  child: Text(controller.user.value.metadata?.description ?? "This is description of user.")),
                            ],
                          ),
                          ),
                          Obx(()=>ImageAvatar(radius: 40,url: controller.user.value.metadata?.image,)),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                  floating: true,
                  pinned: true,
                  delegate: SliverAppBarDeligate(const TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white12,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: Colors.black,

                      tabs: [
                        Tab(text: "Posts",),
                        Tab(text: "Comments",),
                      ])))
            ];
          },
          body:Padding(
            padding: const EdgeInsets.all(10.0),
            child: TabBarView(
              children: [
                Obx(()=> SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      if(controller.postLoading.value)
                        const Loading()
                      else if(controller.posts.isNotEmpty)
                        ListView.builder(
                          itemCount: controller.posts.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => PostCard(post: controller.posts[index]),)
                      else
                        SizedBox(
                          height: context.height * 0.50,
                          child: const Center(

                            child: Text("No Views Yet!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          ),
                        )
                    ],
                  ),
                )),
                Obx(()=> SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      if(controller.repliesLoading.value)
                        const Loading()
                      else if(controller.replies.isNotEmpty)
                        ListView.builder(
                          itemCount: controller.replies.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => CommentCard(reply: controller.replies[index]),)
                      else
                        SizedBox(
                          height: context.height * 0.50,
                          child: const Center(

                            child: Text("No Replies Yet!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          ),
                        )
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );;
  }
}
