import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/dashboardController.dart';
import '../../routes/routeNames.dart';
import '../widgets/addCropDialog.dart';

class MyCropsDashboard extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());

  final List<String> plantOptions = [
    "Apple", "Cotton", "Cucumber", "Grapes", "Guava", "Pomegranate",
    "Potato", "Pumpkin", "Rice", "Sugarcane", "Tomato", "Wheat", "Other"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0x1F857171),
                    ),
                    child:  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Estimated Profit",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Obx(
                                    () => Text(
                                  "₹${controller.profit.value}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0x326FD147)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Manage Your Information",
                      style: TextStyle(fontSize: 20),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(RouteNames.ManageInfo);
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                          WidgetStatePropertyAll(Colors.transparent)),
                      child: const Icon(
                        Icons.navigate_next_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Your Crops",
                    style: TextStyle(fontSize: 20),
                  ),
                  TextButton(
                    onPressed: () {
                      showAddCropDialog(
                        context,
                        plantOptions,
                        controller,
                      );
                    },
                    style: const ButtonStyle(
                        backgroundColor:
                        WidgetStatePropertyAll(Colors.transparent),
                        foregroundColor: WidgetStatePropertyAll(Colors.indigo)),
                    child: const Text("+ Add Crop"),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Obx(
                    () => controller.loading.value
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.selectedCrops.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(
                          children: [
                            Image.asset(
                              "assets/images/home_screen/information/${controller.selectedCrops[index]}.png",
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              controller.selectedCrops[index],
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Get.toNamed(
                            RouteNames.ManagePlant,
                            arguments: controller.selectedCrops[index],
                          );
                        },
                        onLongPress: () {
                          showDeleteConfirmationDialog(context, index, controller);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
