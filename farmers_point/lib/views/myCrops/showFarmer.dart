import 'package:cropunity/controller/TopFarmersController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/app_icons.dart';
import '../widgets/imageAvatar.dart';

class ShowFarmer extends StatefulWidget {
  const ShowFarmer({super.key});

  @override
  State<ShowFarmer> createState() => _ShowFarmerState();
}

class _ShowFarmerState extends State<ShowFarmer> {
  int farmerIndex = Get.arguments;
  TopFarmerController controller = Get.find<TopFarmerController>();

  @override
  void initState() {
    controller.FarmerIndex=farmerIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProfitPerCrop();
      controller.fetchExpenseSummary();
      controller.fetchFarmerInfo();
    });
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Top Farmers"),),
      body: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Obx(()=>controller.loading.value ? const Padding(padding: EdgeInsets.all(10.0), child: Center(child: CircularProgressIndicator()),) :
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ImageAvatar(radius: 70,url: controller.fetchedFarmers[farmerIndex].image),
                          Row(
                            children: [
                              Text(controller.fetchedFarmers[farmerIndex].name!,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                              const SizedBox(width: 3,),
                              if(controller.fetchedFarmers[farmerIndex].isVerified!)
                                const Icon(AppIcons.verified_user,color: Colors.blue,size: 25,)
                            ],
                          ),
                          Text(controller.farmerInfo.value.description!,style: const TextStyle(fontSize: 20,),),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Container(
                    padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D432D)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Address : ${controller.farmerInfo.value.farmAddress!}",style: const TextStyle(fontSize: 20,color: Colors.white),),
                        Text("Farm Area : ${controller.farmerInfo.value.farmArea!} ${controller.farmerInfo.value.unit!}",style: const TextStyle(fontSize: 20,color: Colors.white),),
                        Text("Qualification : ${controller.farmerInfo.value.qualification!}",style: const TextStyle(fontSize: 20,color: Colors.white),),
                        Text("Agricultural Degree : ${controller.farmerInfo.value.agriculturalDegree!}",style: const TextStyle(fontSize: 20,color: Colors.white),),
                        Row(
                          children: [
                            Text("Contact : ${controller.farmerInfo.value.contact!}",style: const TextStyle(fontSize: 20,color: Colors.white),),
                            IconButton(onPressed: () async {
                              final Uri phoneUri = Uri(scheme: 'tel', path:controller.farmerInfo.value.contact!);
                              if (await launchUrl(phoneUri)) {
                                // Open the dialer
                                await launchUrl(phoneUri);
                              } else {
                                // Debugging log if something goes wrong
                                debugPrint('Could not launch dialer.');
                              }
                            }, icon: const Icon(Icons.phone,color: Colors.blue,))
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Text("Overall Transactions",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: (controller.fetchedFarmers[farmerIndex].totalProfit! - controller.fetchedFarmers[farmerIndex].totalExpense!)>0 ? Color(0x5180DD86) : Color(0x47EF9A9A),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Overall Profit",style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    // Use Obx to reactively update the Overall Profit
                    Obx(() {
                      return Text(
                        "₹${(controller.fetchedFarmers[farmerIndex].totalProfit! - controller.fetchedFarmers[farmerIndex].totalExpense!).toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      );
                    }),
                    const Divider(
                      color: Color(0xff242424),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Use Obx to reactively update Total Expense
                        Column(
                          children: [
                            const Text("Profit"),
                            Obx(() {
                              return Text(
                                "₹${controller.fetchedFarmers[farmerIndex].totalProfit!.toStringAsFixed(2)}",
                                style: const TextStyle(fontSize: 16, color: Colors.green,fontWeight: FontWeight.bold),
                              );
                            }),
                          ],
                        ),
                        Column(
                          children: [
                            const Text("Expense"),
                            Obx(() {
                              return Text(
                                "₹${controller.fetchedFarmers[farmerIndex].totalExpense!.toStringAsFixed(2)}",
                                style: const TextStyle(fontSize: 16, color: Colors.red,fontWeight: FontWeight.bold),
                              );
                            }),
                          ],
                        ),
                        // Use Obx to reactively update Total Profit
                      ],
                    ),
                  ],
                ),
              ),
                  const SizedBox(height: 10,),
                  const Text("Crops Grown",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                  controller.fetchedSum.isEmpty
                      ? const Center(child: Text('No crops grown yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))
                      :
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.fetchedSum.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(

                            title: Row(
                              children: [
                                Image.asset("assets/images/home_screen/information/${controller.fetchedSum[index].croptype}.png",height: 30,width: 30,),
                                const SizedBox(width: 5,),
                                Text(
                                  controller.fetchedSum[index].croptype!,
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Profit: ₹${controller.fetchedSum[index].totalProfit}"),
                                Text("Total Expense: ₹${controller.fetchedSum[index].totalExpense}"),
                                Text("Total Yield: ${controller.fetchedSum[index].yieldValue} Kg"),
                              ],
                            ),
                          ),
                          const Divider(color: Colors.black,)
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 10,),
                  const Text("Overall Expenses",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                  controller.expenseSummary.isEmpty
                      ? const Center(child: Text('No Expenses yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))
                      :
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.expenseSummary.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(

                            title: Row(
                              children: [
                                Image.asset("assets/images/Expense/${controller.expenseSummary[index].category}.png",height: 30,width: 30,),
                                const SizedBox(width: 5,),
                                Text(
                                  controller.expenseSummary[index].category!,
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            subtitle: Text("Total Expense: ₹${controller.expenseSummary[index].totalExpense}"),
                          ),
                          const Divider(color: Colors.black,)
                        ],
                      );
                    },
                  ),

                ],

              ),
            ),
          ),
      ),
    );
  }
}
