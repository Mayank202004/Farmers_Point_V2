import 'package:cropunity/auth/login.dart';
import 'package:cropunity/controller/predictionController.dart';
import 'package:cropunity/views/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Predict extends StatefulWidget {
  const Predict({super.key});
  @override
  State<Predict> createState() => _PredictState();
}

class _PredictState extends State<Predict> {
  PredictionController predictionController = Get.find<PredictionController>();
  var items = <String>[].obs;
  int? selectedIndex; // Store the index of the selected item
  @override
  void initState() {
    if(predictionController.selectedCategory.value==0){
      items.value=['Potato', 'Tomato','Rice','Wheat','Cotton','Cucumber','Sugarcane'];
    }
    else{
      items.value=['Apple', 'Pomegranate', 'Pumpkin','Guava','Grapes','Mango Leaf','Pomegranate'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Predict Plant Disease"),),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      //width: context.width * 0.90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all()
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0,right: 16),
                        child: DropdownButton(
                            hint: const Text("Select Plant Type"),
                            value: selectedIndex,
                            items: List.generate(
                                items.length,(index) {
                                  return DropdownMenuItem<int>(
                                      value: index,
                                      child: Text(items[index]));}
                            ),
                            onChanged: (int? newIndex) {setState(() {
                              selectedIndex = newIndex;}
                            );},
                          isExpanded: true,
                          underline: const SizedBox(),
                          style: const TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  IconButton(onPressed: (){
                    predictionController.checkPermission(predictionController, context);
                  }, icon: const Icon(Icons.attach_file))
                ],
              ),
            ),
            Obx(() => Column(
              children: [
                if (predictionController.image.value != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            predictionController.image.value!,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                        Positioned(
                          //right: 10,
                          //top: 10,
                          child: CircleAvatar(
                            backgroundColor: Colors.white38,
                            child: IconButton(
                              onPressed: () {
                                predictionController.image.value = null; // Clear the image
                              },
                              icon: const Icon(Icons.close,color: Colors.black,),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            )),
            const SizedBox(height: 10,),
            SizedBox(
                width: context.width * 0.90,
                child: TextButton(onPressed: () async {
                  if(selectedIndex == null){
                    showSnackBar("Required", "Please select plant type from the dropdown menu");
                  }
                  else if(predictionController.image.value == null){
                  showSnackBar("Required", "Please select an image");
                  }
                  else{
                    // Call controller function to load model and predict
                    await predictionController.loadModelAndPredict(items[selectedIndex!]);
                  }

                }, child: const Text("Next"),))
          ],
        ),
      ),
    );
  }
}
