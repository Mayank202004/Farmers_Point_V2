import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/searchController.dart';
import '../widgets/loading.dart';
import '../widgets/searchInput.dart';
import '../widgets/userTile.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController controller = TextEditingController(text: "");
  final SearchUserController searchUserController = Get.put(SearchUserController());

  void searchUser(String? name){
    if(name!=null){
      searchUserController.searchUser(name);

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            centerTitle: false,
            title: const Text("Search"),
            expandedHeight: GetPlatform.isIOS ? 110 : 105,
            collapsedHeight: GetPlatform.isIOS ? 90 : 80,
            flexibleSpace: Padding(
              padding: EdgeInsets.only(
                top:GetPlatform.isIOS ? 105 : 60,
                right: 10,
                left: 10,
              ),
              child: SearchInput(controller: controller,callback: searchUser,),
            ),

          ),
          SliverToBoxAdapter(
            child: Obx(()=> searchUserController.loading.value ? const Loading() : Column(
              children: [
                if(searchUserController.users.isNotEmpty)
                  ListView.builder(
                      itemCount: searchUserController.users.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context,index)=>Usertile(user: searchUserController.users[index]!))
                else if(searchUserController.users.isEmpty && searchUserController.notFound.value == true)
                  const Text("No user found")
                else
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text("Search users with their names"),),
                  )
              ],
            )),
          )
        ],
      ),
    );
  }
}
