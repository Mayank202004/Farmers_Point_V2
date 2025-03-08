import 'package:carousel_slider/carousel_slider.dart';
import 'package:cropunity/models/plantModel.dart';
import 'package:cropunity/views/widgets/imageCarousal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PlantDisease extends StatefulWidget {
  const PlantDisease({super.key});

  @override
  State<PlantDisease> createState() => _PlantDiseaseState();
}

class _PlantDiseaseState extends State<PlantDisease> {


  @override
  Widget build(BuildContext context) {
    final Disease disease = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Disease"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(disease.diseaseName!,style: const TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
              Text(disease.scientificName!,style: const TextStyle(color: Colors.black54),),
              const Divider(
                color: Color(0xff242424),
              ),
              const SizedBox(height: 20,),

              // ==================== image carousal ========================
              // The images are stored in supabase image bucket in folder : application/{plantname}/x.jpg format
              //There re 1 images per plant ranging from 1.jpeg to 5.jpeg
              ImageCarousal(urlImages: List.generate(3, // Number of images
                      (index) => 'https://mjxkyduomhstppmdbidb.supabase.co/storage/v1/object/public/fpBucket/application/Diseases/${disease.diseaseName}/${index + 1}.jpg'),),


              const Text("Background",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Text("Caused by: ${disease.background!.cause!}",style: const TextStyle(fontSize: 16,color: Colors.black54),textAlign: TextAlign.justify),
              Text("Spread by: ${disease.background!.spreadBy!}",style: const TextStyle(fontSize: 16,color: Colors.black54),textAlign: TextAlign.justify),
              const SizedBox(height: 20,),
              const Text("Symptoms",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
              Text(disease.symptoms!.map((symptoms) => '• $symptoms')
                  .join('\n'), // Join the practices with newline for each bullet point
                style: const TextStyle(fontSize: 16,color: Colors.black54),
                textAlign: TextAlign.justify,),
              const SizedBox(height: 20,),
              const Text("Prevention",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
              Text(disease.prevention!.map((prevention) => '• $prevention')
                  .join('\n'), // Join the practices with newline for each bullet point
                style: const TextStyle(fontSize: 16,color: Colors.black54),
                textAlign: TextAlign.justify,),
              const SizedBox(height: 20,),
              const Text("Cure",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
              Text(disease.cure!.map((cure) => '• $cure')
                  .join('\n'), // Join the practices with newline for each bullet point
                style: const TextStyle(fontSize: 16,color: Colors.black54),
                textAlign: TextAlign.justify,),
              const SizedBox(height: 20,),
              const Text("Fertilizers",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
              Text(disease.fertilizers!,style: const TextStyle(fontSize: 16,color: Colors.black54),)
            ],
          ),
        ),),
    );
  }
}
