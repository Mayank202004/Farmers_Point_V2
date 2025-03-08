import 'package:cropunity/controller/homeController.dart';
import 'package:cropunity/controller/predictionController.dart';
import 'package:cropunity/routes/routeNames.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../controller/weatherController.dart';
import '../utils/helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeController = Get.put(HomeController());
  final WeatherController weatherController = Get.put(WeatherController());
  final PredictionController predictionController = Get.put(PredictionController());
  bool isFloatingVisible=true;
  int selectedCategory=0; // for checking category selected color
  List selectedList = [];

  @override
  void initState() {
    super.initState();
    weatherController.fetchWeather();
    selectedList=homeController.plants;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isFloatingVisible ? FloatingActionButton(
        onPressed: () {
          Get.toNamed(RouteNames.Chatbot);
        },
        child: const Icon(Icons.chat_outlined),
      ) : null,
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if(notification.metrics.axis == Axis.vertical && notification.direction == ScrollDirection.forward){
            setState(() {
              isFloatingVisible=true;
            });
          }
          else if(notification.metrics.axis == Axis.vertical && notification.direction == ScrollDirection.reverse){
            setState(() {
              isFloatingVisible=false;
            });
          }
          return true;
        },
        child: Obx(() {
            final weather = weatherController.weather.value;
            final isWeatherFetched = weather != null;
            final borderColor = isWeatherFetched ? const Color(0xFF8AAFC6) : const Color(0xE4CFBB84);

            return Padding(
              padding: const EdgeInsets.only(right: 20,left: 20),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        //width: context.width * 0.90,
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: weatherController.loading.value
                            ?  Center(child: Padding(padding: const EdgeInsets.all(5), child: Lottie.asset("assets/animations/locationWaiting.json",height: 80,width: 80)))
                            : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 4, left: 15, right: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(width: 10),
                                      Text(
                                        "${weather?.cityName ?? 'Today'}, ${weather != null ? convertUnixToIST(weather.date) : DateFormat('dd MMM').format(DateTime.now())}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      weather != null
                                          ? Text(
                                        "${weather.main} ${weather.temp_min.round()}° | ${weather.temp_max.round()}°",
                                      )
                                          : const Text("Clear 24° | 28°"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${weather?.temperature.round().toString() ?? '24'}°C",
                                        style: const TextStyle(fontSize: 25),
                                      ),
                                      weather != null
                                          ? Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                "https://openweathermap.org/img/wn/${weather.icon}@4x.png"),
                                          ),
                                        ),
                                      )
                                          : const SizedBox(width: 10),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                weather == null ? Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 4, left: 5, right: 4),
                                      child: Container(
                                        height: 54,
                                        width: context.width * 0.87,
                                        decoration: const BoxDecoration(
                                          color: Color(0xE4CFBB84),
                                          borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(20),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Icon(Icons.location_off),
                                                Text("Location permission required"),
                                              ],
                                            ),
                                            SizedBox(
                                              child: TextButton(
                                                onPressed: () {
                                                  weatherController.fetchWeather();
                                                },
                                                style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.transparent)),
                                                child: const Text("Allow", style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    : const SizedBox(height: 10),
                                ],
                            ),
                          ],
                        ),
                      ),
                  
                  
                      // ================ Scan Image Section ====================
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          const Text("Scan your Crop",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                          Container(
                          margin: const EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: const Color(0x1F857171)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Lottie.asset("assets/animations/leafScanning.json",width: 100,height: 100,repeat: false),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text("Click an image to get started"),
                                      SizedBox(
                                          width: context.width * 0.55,
                                          child: TextButton(onPressed: (){
                                            predictionController.selectedCategory.value=0;
                                            predictionController.checkPermission(predictionController, context);
                                          }, child: const Text("Click an Image"),))
                                    ],
                                  )
                                ],
                              ),
                          ),
                        ),
                        ]
                      ),
              
                        // ====================== Scan your fruit and Scan soil section ===================================
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: const Color(0x1F857171)),
                                  width: context.width *0.44,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:[
                                        const Text("Scan your fruit"),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 60,
                                              height: 60,
                                              child: Image.asset("assets/images/home_screen/fruit1.png")
                                            ),
                                            TextButton(onPressed: (){
                                              predictionController.selectedCategory.value=1;
                                              predictionController.checkPermission(predictionController, context);
                                            },style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color(0xFF2D432D)),foregroundColor: WidgetStatePropertyAll(Colors.white),), child: const Text("Get Started",style: TextStyle(fontSize: 12),))
                                        ],
                                      ),
                                      ]
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: const Color(0x1F857171)),
                                  width: context.width * 0.44,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:[
                                          const Text("Check your soil"),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                  width: 60,
                                                  height: 60,
                                                  child: Image.asset("assets/images/home_screen/soil.png")
                                              ),
                                              TextButton(onPressed: (){
                                                //predictionController.selectedCategory.value=2;
                                                //predictionController.checkPermission(predictionController, context);
                                              },style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color(0xFF2D432D)),foregroundColor: WidgetStatePropertyAll(Colors.white),), child: const Text("Get Started",style: TextStyle(fontSize: 12),))
                                            ],
                                          ),
                                        ]
                                    ),
                                  ),
              
                                )
                              ],
                            ),
                          ),
                        ),


                      //============================== Information Zone ========================
                      Column(
                        children: [
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Information Zone",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                              TextButton(onPressed: (){Get.toNamed(RouteNames.InformationZone);},style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.transparent),foregroundColor: WidgetStatePropertyAll(Colors.black)), child: const Row(children: [Text("View All"),Icon(Icons.next_plan,)],))
                            ],
                          ),
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
                                          ),))
                              ],
                            ),
                          ),
                          // ================================= scroll view items ============================
                          SizedBox(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.only(top: 10,bottom: 10),
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ...List.generate(selectedList.length,
                                          (index)=> Padding(
                                              padding: const EdgeInsets.all(10),
                                            child: GestureDetector(
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
                                              child: Container(
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.black12.withOpacity(0.03)),
                                                padding: const EdgeInsets.all(15),
                                                width: context.width * 0.70,
                                                child: Row(
                                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Hero(
                                                      tag: "${selectedList[index]}",
                                                      child: Image.asset(
                                                        "assets/images/home_screen/information/${selectedList[index]}.png",
                                                        width: 50,
                                                        height: 50,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                          Text(selectedList[index],style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                                          SizedBox(
                                                              width: context.width * 0.45,
                                                              child: Builder(builder:(context){
                                                                if(selectedCategory==0) {
                                                                  return Text("${homeController.plantDiseaseCount[index]} diseases that can affect ${selectedList[index].toLowerCase()}.\nClick to know more.",style: const TextStyle(fontSize: 15),);
                                                                }
                                                                else if(selectedCategory==1) {
                                                                  return Text("${homeController.fruitDiseaseCount[index]} diseases that can affect ${selectedList[index].toLowerCase()}.\nClick to know more.", style: const TextStyle(fontSize: 15),);
                                                                }
                                                                else{
                                                                  return Text("Find out which plants can grow in ${selectedList[index].toLowerCase()}.\nClick to know more.", style: const TextStyle(fontSize: 15),);
                                                                }

                                                              })),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ))
                                ],
                          
                              ),
                            ),
                          ),
                        ],
                      ),
                    //  =================================== My crops ========================
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("My Crops",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: const Color(0x1F857171)),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("Estimate your profit",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),
                                        const Text("Track your field and crops"),
                                        SizedBox(
                                            width: context.width * 0.55,
                                            child: TextButton(onPressed: (){
                                              Get.toNamed(RouteNames.MyCrops);
                                            }, child: const Text("Get Started"),))
                                      ],
                                    ),
                                    Lottie.asset("assets/animations/graph.json",width: 100,height: 100,repeat: false,),
                                  ],
                                ),
                              ),
                            ),
                          ]
                      ),
                      const SizedBox(height: 20,),


                      //  =================================== Top Farmers ========================
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Top Farmers",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: const Color(0x1F857171)),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Lottie.asset("assets/animations/farmer.json",width: 100,height: 100,),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const Text("View Top Farmers",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),
                                        const Text("Watch out their secret to success"),
                                        SizedBox(
                                            width: context.width * 0.45,
                                            child: TextButton(onPressed: (){
                                              Get.toNamed(RouteNames.TopFarmers);
                                            }, child: const Text("View"),))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]
                      ),
                      const SizedBox(height: 20,)

                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
