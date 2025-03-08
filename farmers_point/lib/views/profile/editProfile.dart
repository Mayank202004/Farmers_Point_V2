import 'package:cropunity/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/profileController.dart';
import '../../services/supabaseService.dart';
import '../widgets/imageAvatar.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final TextEditingController textEditingController = TextEditingController(text: "");
  final ProfileController controller = Get.find<ProfileController>();
  final SupabaseService supabaseService = Get.find<SupabaseService>();

  @override
  void initState(){
    if(supabaseService.currentUser.value?.userMetadata?["description"] != null) {
      textEditingController.text = supabaseService.currentUser.value?.userMetadata?["description"];
    }
    super.initState();
  }
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          Obx(() => TextButton(
              onPressed: (){
                controller.updateProfile(supabaseService.currentUser.value!.id, textEditingController.text);},style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.transparent),foregroundColor: WidgetStatePropertyAll(theme.textTheme.titleSmall?.color)),
              child: controller.loading.value? const SizedBox(height: 14,width: 14,child: CircularProgressIndicator(),) : const Text("Done"),),
          )],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Obx(()=>
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ImageAvatar(radius: 80,file: controller.image.value,url: supabaseService.currentUser.value?.userMetadata?["image"],),
                    IconButton(onPressed: () {
                      controller.pickImage();
                    }, icon: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white38,
                      child: Icon(Icons.edit),
                    ))
                  ],
                ),
            ),
            const SizedBox(height: 20,),
            TextFormField(
              controller: textEditingController,
              maxLength: 55,
              decoration: const InputDecoration(border: UnderlineInputBorder(),
                  hintText: "Add your description here.",
                  label: Text("Description")),
            )
          ],
        ),
      ),
    );
  }
}
