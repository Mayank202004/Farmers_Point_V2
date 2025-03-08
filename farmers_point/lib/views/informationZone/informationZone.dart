import 'package:cropunity/controller/homeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/routeNames.dart';

class InformationZone extends StatefulWidget {
  const InformationZone({super.key});

  @override
  State<InformationZone> createState() => _InformationZoneState();
}

class _InformationZoneState extends State<InformationZone> {
  HomeController homeController = Get.find<HomeController>();
  int selectedCategory=0; // for checking category selected color
  List selectedList = [];


  @override
  void initState(){
    selectedList=homeController.plants;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Information Zone"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ===================== Buttons =======================
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    ...List.generate(homeController.categories.length,
                            (index)=> Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: (){
                              selectedCategory = index;
                              // change below scroll view contents as per selection
                              switch (selectedCategory) {
                                case 0:
                                  selectedList = homeController.plants;
                                  break;
                                case 1:
                                  selectedList = homeController.fruits;
                                  break;
                                case 2:
                                  selectedList = homeController.soil;
                                  break;
                                case 3:
                                  selectedList = homeController.seasons;
                                  break;
                              }
                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 10
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: selectedCategory == index ? const Color(0xFF2D432D) : Colors.black12.withOpacity(0.03)
                              ),
                              child: Text(
                                homeController.categories[index],
                                style: TextStyle(fontSize: 16,color: selectedCategory == index ? Colors.white: Colors.black),
                              ),
                            ),
                          ),)),
                  ],
                ),
              ),

                    // ================== Buttons Complete =====================


                    SizedBox(
                      width: context.width,
                      height: context.height,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: selectedList.length,
                        //shrinkWrap: true,
                        itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            if(selectedCategory==2){
                              Get.toNamed(RouteNames.ShowSoil,arguments: selectedList[index]);
                            }
                            else if(selectedCategory==3){
                              Get.toNamed(RouteNames.ShowSeason,arguments: selectedList[index]);
                            }
                            else{
                              Get.toNamed(RouteNames.ShowPlant,arguments: selectedList[index]);}
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/home_screen/information/${selectedList[index]}.png",
                                      width: 60,
                                      height: 60,
                                    ),
                                    const SizedBox(width: 20,),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(selectedList[index],style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                                          const Icon(Icons.chevron_right),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                color: Color(0xff242424),
                              )
                            ],
                          ),
                        );
                      },),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

