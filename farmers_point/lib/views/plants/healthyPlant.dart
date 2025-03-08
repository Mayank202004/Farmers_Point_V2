import 'package:cropunity/controller/healthyController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../widgets/imageCarousal.dart';

class HealthyPlant extends StatefulWidget {
  const HealthyPlant({super.key});

  @override
  State<HealthyPlant> createState() => _HealthyPlantState();
}

class _HealthyPlantState extends State<HealthyPlant> {
  bool _animationFinished = false;
  HealthyController healthyController = Get.put(HealthyController());
  final String plant = Get.arguments ?? 'Unknown Plant';

  @override
  void initState(){
    healthyController.fetchPlant(plant);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _animationFinished
      // If animation is finished, display normal content
          ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/animations/star.json',
                      repeat: true,
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Sit Back Tight",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
                        Text("Your Plant is doing just Fine!",style: TextStyle(fontSize: 22),),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      Image.asset("assets/images/home_screen/information/$plant.png",width: 40,height: 40,),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Healthy ${healthyController.healthyPlantModel.name}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Color(0xff242424),
                ),
                const SizedBox(height: 10,),
                // ==================== image carousal ========================
                // The images are stored in supabase image bucket in folder : application/{plantname}/x.jpg format
                //There re 1 images per plant ranging from 1.jpeg to 5.jpeg
                ImageCarousal(urlImages: List.generate(3, // Number of images
                        (index) => 'https://mjxkyduomhstppmdbidb.supabase.co/storage/v1/object/public/fpBucket/application/${healthyController.healthyPlantModel.name}/${index + 1}.jpg'),),

                const Text("Healthy Appearance",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                Text('${healthyController.healthyPlantModel.appearanceWhenHealthy}',style: const TextStyle(fontSize: 15,),textAlign: TextAlign.justify,),
                const SizedBox(height: 20,),
                const Text("Growth Stages",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                Text('${healthyController.healthyPlantModel.growthStages}',style: const TextStyle(fontSize: 15,),textAlign: TextAlign.justify,),
                const SizedBox(height: 20,),
                const Text("Optimal Conditions",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                Text('${healthyController.healthyPlantModel.optimalConditions}',style: const TextStyle(fontSize: 15,),textAlign: TextAlign.justify,),
                const SizedBox(height: 20,),
                const Text("Maintenance Instructions",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                Text('${healthyController.healthyPlantModel.maintenanceInstructions}',style: const TextStyle(fontSize: 15,),textAlign: TextAlign.justify,),
                const SizedBox(height: 20,),
                const Text("Key Benefits",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                Text('${healthyController.healthyPlantModel.keyBenefits}',style: const TextStyle(fontSize: 15,),textAlign: TextAlign.justify,),
                const SizedBox(height: 20,),
              ],
            ),
          )
      // If animation is not finished, display tick animation at the center
          : Center(
        child: Lottie.asset(
          'assets/animations/tick.json',
          width: 300,
          height: 300,
          fit: BoxFit.contain,
          onLoaded: (composition) {
            // After tick animation finishes, update state
            Future.delayed(composition.duration, () {
              setState(() {
                _animationFinished = true;
              });
            });
          },
        ),
      ),
    );
  }
}
