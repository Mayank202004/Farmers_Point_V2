
import 'package:cropunity/views/widgets/imageCarousal.dart';
import 'package:cropunity/views/widgets/loading.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/soilController.dart';

class SoilInfo extends StatelessWidget {
  const SoilInfo({super.key});


  @override
  Widget build(BuildContext context) {
    SoilController controller= Get.put(SoilController());
    // Retrieve the plant name from Get.arguments
    final String soil = Get.arguments ?? 'Unknown Soil';
    controller.fetchSoil(soil);

    return Scaffold(
      appBar: AppBar(
        title: Text(soil),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: Loading());
        }

        // Display the plant name from the controller's plant model
        return SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Hero(
                      tag: soil,
                      child: Image.asset("assets/images/home_screen/information/$soil.png",width: 60,height: 60,)),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${controller.soilModel.soilName}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ],
              ),
              const Divider(
                color: Color(0xff242424),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Description",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Text('${controller.soilModel.description}',style: const TextStyle(fontSize: 15,),textAlign: TextAlign.justify,),
                  const SizedBox(height: 20,),

                  // // ============= Image Carousal ===================
                  //
                  //
                  // // * =============== Working ==================== *
                  // // The images are stored in supabase image bucket in folder : application/{plantname}/x.jpg format
                  // //There re 1 images per plant ranging from 1.jpeg to 5.jpeg
                  // ImageCarousal(urlImages: List.generate(5, // Number of images
                  //         (index) => 'https://mjxkyduomhstppmdbidb.supabase.co/storage/v1/object/public/fpBucket/application/${controller.plant.plantName}/${index + 1}.jpg'),),
                  //


                  const Text("Key Characteristics",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Colour : ${controller.soilModel.keyCharacteristics?.color}',style: const TextStyle(fontSize: 15,)),
                        Text('Texture : ${controller.soilModel.keyCharacteristics?.texture}',style: const TextStyle(fontSize: 15,)),
                        Text('Drainage : ${controller.soilModel.keyCharacteristics?.drainage}',style: const TextStyle(fontSize: 15,)),
                        Text('Ph Range : ${controller.soilModel.keyCharacteristics?.pHRange}',style: const TextStyle(fontSize: 15,)),
                        Text('Organic Matter : ${controller.soilModel.keyCharacteristics?.organicMatter}',style: const TextStyle(fontSize: 15,)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Text("Watering Requirments",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Text('${controller.soilModel.wateringRequirements}',style: const TextStyle(fontSize: 15,),textAlign: TextAlign.justify,),
                  const SizedBox(height: 20,),
                  const Text("Plants that can grow well",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Text(controller.soilModel.plantsThatCanGrowWell!.map((cure) => '• $cure')
                      .join('\n'),style: const TextStyle(fontSize: 15,)),

                  const SizedBox(height: 20,),
                  const Text("Best For",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      controller.soilModel.bestFor
                      !.map((practice) => '• $practice')
                          .join('\n'), // Join the practices with newline for each bullet point
                      style: const TextStyle(fontSize: 15),
                      textAlign: TextAlign.justify,
                    ),
                  )
                ],
              ),


              // You can add more details here as needed
            ],
          ),
        );
      }),
    );
  }
}
