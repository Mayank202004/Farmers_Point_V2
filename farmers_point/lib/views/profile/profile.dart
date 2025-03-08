import 'package:cropunity/views/widgets/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/profileController.dart';
import '../../routes/routeNames.dart';
import '../../services/supabaseService.dart';
import '../widgets/commentCard.dart';
import '../widgets/imageAvatar.dart';
import '../widgets/loading.dart';
import '../widgets/postCard.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ProfileController controller = Get.put(ProfileController());
  final SupabaseService supabaseService = Get.find<SupabaseService>();

  @override
  void initState(){
    if(supabaseService.currentUser.value?.id !=null){
       controller.fetchUserViews(supabaseService.currentUser.value!.id);
       controller.fetchUserReplies(supabaseService.currentUser.value!.id);
      super.initState();
    }}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Icon(Icons.language),
        centerTitle: false,
        actions: [IconButton(onPressed: () => Get.toNamed(RouteNames.Settings), icon: const Icon(Icons.sort))],
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 160,
                collapsedHeight: 160,
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
                              Row(
                                children: [
                                  Text(
                                    supabaseService.currentUser.value!.userMetadata?["name"],
                                    style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                                  const SizedBox(width: 5,),
                                  if (supabaseService.currentUser.value!.userMetadata?["isVerified"]=="TRUE")
                                    const Icon(
                                      AppIcons.verified_user,
                                      size: 25,
                                      color: Colors.blue, // Optional: Add a color for distinction
                                    ),
                                ],
                              ),
                              SizedBox(
                                  width: context.width * 0.70,
                                  child: Text(supabaseService.currentUser.value?.userMetadata?["description"] ?? "This is description of user. The user can add his own description here")),
                            ],
                          ),
                          ),
                          ImageAvatar(file:controller.image.value,radius: 40,url: supabaseService.currentUser.value?.userMetadata?["image"],),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(child: OutlinedButton(
                              onPressed: () =>Get.toNamed(RouteNames.EditProfile),
                              child: const Text("Edit Profile"))),
                          const SizedBox(width: 20,),
                          Expanded(child: OutlinedButton(
                              onPressed: (){}, child: const Text("Share Profile")))
                        ],
                      )
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
                          itemBuilder: (context, index) => PostCard(post: controller.posts[index],isAuthCard: true,),)
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
    );
  }
}


// Sliver Pesistent Header Class
class SliverAppBarDeligate extends SliverPersistentHeaderDelegate{
  final TabBar _tabBar;
  SliverAppBarDeligate(this._tabBar);

  @override
  // TODO: implement maxExtent
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  // TODO: implement minExtent
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Color(0xFF2D432D),
      child: _tabBar,
    );

  }
}