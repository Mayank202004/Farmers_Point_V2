import 'package:cropunity/controller/plantController.dart';
import 'package:cropunity/views/widgets/diseaseGrid.dart';
import 'package:cropunity/views/widgets/imageCarousal.dart';
import 'package:cropunity/views/widgets/loading.dart';
import 'package:cropunity/views/widgets/tempBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlantInfo extends StatelessWidget {
  const PlantInfo({super.key});


  @override
  Widget build(BuildContext context) {
  PlantController controller= Get.put(PlantController());
    // Retrieve the plant name from Get.arguments
    final String plant = Get.arguments ?? 'Unknown Plant';
    controller.fetchPlant(plant);

    return Scaffold(
      appBar: AppBar(
        title: Text(plant),
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
                      tag: plant,
                      child: Image.asset("assets/images/home_screen/information/$plant.png",width: 60,height: 60,)),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${controller.plant.plantName}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                      Text('${controller.plant.scientificName}',style: const TextStyle(fontSize: 15,color: Colors.black45))
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
                  Text('${controller.plant.description}',style: const TextStyle(fontSize: 15,),textAlign: TextAlign.justify,),
                  const SizedBox(height: 20,),

                  // ============= Image Carousal ===================


                  // * =============== Working ==================== *
                  // The images are stored in supabase image bucket in folder : application/{plantname}/x.jpg format
                  //There re 1 images per plant ranging from 1.jpeg to 5.jpeg
                  ImageCarousal(urlImages: List.generate(5, // Number of images
                    (index) => 'https://mjxkyduomhstppmdbidb.supabase.co/storage/v1/object/public/fpBucket/application/${controller.plant.plantName}/${index + 1}.jpg'),),


                  const Text("Uses",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Text(controller.plant.uses!.map((cure) => '• $cure')
                      .join('\n'),style: const TextStyle(fontSize: 15,)),
                  const SizedBox(height: 20,),
                  const Text("Suitable Climate",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Temperature",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        Text('Optimal Range : ${controller.plant.climate?.temperature?.optimalRange!}',style: const TextStyle(fontSize: 15,)),
                        Text('Low : ${controller.plant.climate?.temperature?.tooLow!}',style: const TextStyle(fontSize: 15,)),
                        Text('High : ${controller.plant.climate?.temperature?.tooHigh!}',style: const TextStyle(fontSize: 15,)),
                        const SizedBox(height: 10,),
                        // ============== Temp Bar ===============
                        TempBar(controller: controller),
                        const SizedBox(height: 10,),


                        const Text("Humidity",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        Text('Optimal Range ${controller.plant.climate?.humidity?.optimalRange!}',style: const TextStyle(fontSize: 15,)),
                        const SizedBox(height: 10,),
                        const Text("Feasible Soil",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        Text('${controller.plant.climate?.soil?.type!}',style: const TextStyle(fontSize: 15,)),
                        Text('pH Range ${controller.plant.climate?.soil?.pHRange!}',style: const TextStyle(fontSize: 15,)),
                        const SizedBox(height: 10,),
                        const Text("Watering",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        Text('Low ${controller.plant.climate?.watering}',style: const TextStyle(fontSize: 15,)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Text("Common Diseases",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  DiseaseGrid(controller: controller), // Used to create custom grid

                  const SizedBox(height: 20,),
                  const Text("Precautions",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      controller.plant.preventivePractices
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
