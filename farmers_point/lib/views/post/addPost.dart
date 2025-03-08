import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/postController.dart';
import '../../models/postModel.dart';
import '../../services/supabaseService.dart';
import '../utils/helper.dart';
import '../widgets/imageAvatar.dart';


class AddPost extends StatelessWidget {
  AddPost({super.key});
  final SupabaseService supabaseService=Get.find<SupabaseService>();
  final ViewsController viewsController = Get.put(ViewsController());

  @override
  Widget build(BuildContext context) {

    //============= if edit post is called ==============
    final PostModel? post = Get.arguments;

    // If post exists, pre-fill the content and image
    if (post != null) {
      viewsController.textEditingController.text = post.content ?? '';
    }
    else{
      viewsController.textEditingController.clear();
      viewsController.content.value="";
      viewsController.image.value=null;
    }

    return Scaffold(
        body: SafeArea(child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 60,
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xff242424)))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close)
                        ),
                        const SizedBox(width: 10,),
                        Text(post!= null ? "Edit View" : "Add View",style: const TextStyle(fontSize: 20),),
                      ],
                    ),
                    Obx(() =>
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                              onPressed: (){
                                if(viewsController.content.value.isNotEmpty){
                                  if (post != null) {
                                    viewsController.editPost(post.id!);
                                  } else {
                                    viewsController.post(Get.find<SupabaseService>().currentUser.value!.id);
                                  }
                                }
                              },
                              child: viewsController.loading.value ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator.adaptive(),
                              ) : Text(post != null ? "Edit" : "Post",style: TextStyle(fontSize: 15, fontWeight: viewsController.content.value.isNotEmpty ? FontWeight.bold : FontWeight.normal),
                              )
                          ),
                        ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  Obx(()=>ImageAvatar(
                    radius: 20,
                    url: supabaseService.currentUser.value!.userMetadata?["image"],)
                  ),
                  const SizedBox(width: 10,),
                  SizedBox(
                    width: context.width * 0.80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(()=> Text(
                            supabaseService.currentUser.value!.userMetadata?["name"])
                        ),
                        TextField(
                          //autofocus: true,
                          controller: viewsController.textEditingController,
                          onChanged: (value) => viewsController.content.value=value,
                          style: const TextStyle(fontSize: 14),
                          maxLines: 10,
                          minLines: 1,
                          maxLength: 1000,
                          decoration: const InputDecoration(
                              hintText: "Share your views",
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                          ),
                        ),
                        if (post == null)  // Only show the pick-image icon in add mode
                          GestureDetector(
                            onTap: () => viewsController.pickImage(),
                            child: const Icon(Icons.attach_file),
                          ),

                        // To preview selected image
                        Obx(()=>
                            Column(
                              children: [
                                if(viewsController.image.value != null && post == null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.file(
                                            viewsController.image.value!,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.topCenter,
                                          ),
                                        ),
                                        Positioned(
                                            right: 10,
                                            top: 10,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white38,
                                              child: IconButton(onPressed:() {viewsController.image.value=null;},icon: const Icon(Icons.close)),
                                            ))
                                      ],
                                    ),
                                  ),
                                if (post != null && post.image != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        getBucketUrl(post.image!), // Display the existing image
                                        fit: BoxFit.cover,
                                        alignment: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ))
    );
  }
}
