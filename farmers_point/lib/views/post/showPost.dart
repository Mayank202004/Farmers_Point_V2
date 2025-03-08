import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/postController.dart';
import '../widgets/commentCard.dart';
import '../widgets/loading.dart';
import '../widgets/postCard.dart';

class ShowPost extends StatefulWidget {
  const ShowPost({super.key});

  @override
  State<ShowPost> createState() => _ShowViewState();
}

class _ShowViewState extends State<ShowPost> {
  final int postId = Get.arguments;
  final ViewsController controller = Get.put(ViewsController());

  @override
  void initState(){
    controller.show(postId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Show View"),
      ),
      body: Obx(() => controller.showViewLoading.value ? const Loading() :
      SingleChildScrollView(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            PostCard(post: controller.postFetched.value),
            const SizedBox(height: 10,),
            // Show comments if exists
            if(controller.showReplyLoading.value)
              const Loading()
            else if(controller.replies.isNotEmpty)
              ListView.builder(
                  itemCount: controller.replies.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context,index) => CommentCard(reply: controller.replies[index]))
            else
              const Center(
                child: Text("No Comments"),
              )
          ],
        ),
      ),
      ),
    );
  }
}
