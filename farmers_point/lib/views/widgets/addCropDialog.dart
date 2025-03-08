import 'package:cropunity/controller/dashboardController.dart';
import 'package:flutter/material.dart';

import '../utils/helper.dart';

void showAddCropDialog(BuildContext context, List<String> plantOptions,DashboardController controller) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Select a Crop",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: plantOptions.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (!controller.selectedCrops.contains(plantOptions[index])) {
                          controller.addCropToSupabase(plantOptions[index]);
                        } else {
                          showSnackBar(
                            "Duplicate Crop",
                            "${plantOptions[index]} is already added.",
                          );
                        }
                        Navigator.pop(context);
                      },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2000),
                          child: Card(
                            color: Colors.white,

                            shape: const CircleBorder(
                            ), // Shadow for visibility
                            child: Container(
                              
                              decoration: BoxDecoration(border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(50)),
                              child: Padding(
                                padding: const EdgeInsets.all(0), // Padding around the content
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center, // Center the Row content
                                  children: [
                                    Image.asset(
                                      "assets/images/home_screen/information/${plantOptions[index]}.png",
                                      width: 45, // Control image size
                                      height: 45, // Control image size
                                    ), 
                                    Text(plantOptions[index])
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showDeleteConfirmationDialog(BuildContext context,int index,DashboardController controller) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Delete Crop"),
        content: const Text("Are you sure you want to delete this crop?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              controller.deleteCropFromSupabase(controller.selectedCrops[index]);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );
}

