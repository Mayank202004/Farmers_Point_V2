import 'package:cropunity/controller/TopFarmersController.dart';
import 'package:cropunity/views/widgets/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/routeNames.dart';

class TopFarmers extends StatefulWidget {
  const TopFarmers({super.key});

  @override
  State<TopFarmers> createState() => _TopFarmersState();
}

class _TopFarmersState extends State<TopFarmers> {

  TopFarmerController controller = Get.put(TopFarmerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top Framers"),
      ),
      body: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Obx(
                      () => controller.loading.value
                      ? const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                      : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.fetchedFarmers.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(

                                title: Row(
                                  children: [
                                    Text(
                                      controller.fetchedFarmers[index].name!,
                                      style: const TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 3,),
                                    if(controller.fetchedFarmers[index].isVerified!)
                                      const Icon(AppIcons.verified_user,color: Colors.blue,size: 20,)
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Profit per acres: ₹${controller.fetchedFarmers[index].profitPerAcre?.round().toString()}"),
                                    Text("Total Profit: ₹${controller.fetchedFarmers[index].totalProfit?.round().toString()}"),
                                    Text("Total Land: ${controller.fetchedFarmers[index].totalLandAreaAcres?.round().toString()} acres"),
                                  ],
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Get.toNamed(
                                    RouteNames.ShowFarmer,
                                    arguments: index,
                                  );
                                },
                              ),
                              const Divider(color: Colors.black,)
                            ],
                          );
                        },
                      ),
                ),
              ],

            ),
          ),
      ),
    );
  }
}
