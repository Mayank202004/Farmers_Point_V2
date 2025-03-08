import 'dart:convert';
import 'dart:io';

import 'package:cropunity/routes/routeNames.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_v2/tflite_v2.dart';

import '../models/plantModel.dart';
import '../views/utils/helper.dart';

class PredictionController extends GetxController{
  final picker = ImagePicker();
  var image = Rx<File?>(null);
  Rx<int> selectedCategory = 0.obs;  // 0 = Plant, 1 = Fruit, 2 = Soil
  var loading=false.obs;
  PlantModel plant = PlantModel();



  // ======================== PERMISSION CHECK ============================
  void checkPermission(PredictionController predictionController,BuildContext context) async{
  // Request storage permission
  PermissionStatus storageStatus;
  if (await Permission.storage.isGranted ||
    await Permission.storage.request().isGranted ||
    await Permission.photos.request().isGranted) { // for Android 13+
    storageStatus = PermissionStatus.granted;
  } else {
    storageStatus = PermissionStatus.denied;
  }

  // Request camera permission
  PermissionStatus cameraStatus = await Permission.camera.request();
  if (storageStatus.isGranted && cameraStatus.isGranted) {
    predictionController.showImagePicker(context);
  } else {
  showSnackBar("Incomplete Permission", "Permissions not granted");
  }
}

  // ==================== PICK IMAGE FROM GALLERY =======================
  _imgFromGallery() async{
    await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100).then((value){
          if(value!=null){
            _cropImage(File(value.path));
          }
    });
  }

  // ==================== PICK IMAGE FROM CAMERA =======================
  _imgFromCamera() async{
    await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100).then((value){
      if(value!=null){
        _cropImage(File(value.path));
      }
    });
  }

  // ==================== CROP PICKED IMAGE =======================
  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // 1:1 for square
        uiSettings: [AndroidUiSettings(
            toolbarTitle: "Image Cropper",
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
          // IOSUiSettings(
          //   title: "Image Cropper",
          // )
        ]);
    if (croppedFile != null) {
      image.value = File(croppedFile.path); // Update the observable with the cropped image
      // Route to predict page
      if(selectedCategory.value!=2){
      Get.toNamed(RouteNames.Predict);}
      else{
        loadModelAndPredict("Soil");
      }
    }
  }

  // ==================== SHOW BOTTOM SHEET FOR STORAGE AD CAMERA OPTION==========================
  void showImagePicker(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return Card(
            child: Container(
              width: context.width,
              height: context.height * 0.15,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: InkWell(
                        child: const Column(
                          children: [
                            Icon(Icons.image,size: 60,),
                            SizedBox(height: 12,),
                            Text("Gallery",textAlign: TextAlign.center,style: TextStyle(fontSize: 16),)
                          ],
                        ),
                        onTap: (){
                          _imgFromGallery();
                          Navigator.pop(context);
                        },
                      )),
                  Expanded(
                      child: InkWell(
                        child: const Column(
                          children: [
                            Icon(Icons.camera,size: 60,),
                            SizedBox(height: 12,),
                            Text("Camera",textAlign: TextAlign.center,style: TextStyle(fontSize: 16),)
                          ],
                        ),
                        onTap: (){
                          _imgFromCamera();
                          Navigator.pop(context);
                        },
                      ))
                ],
              ),
            ),
          );
        }
    );
  }
  // ========================== Load Model and Predict ==============================
  Future<void> loadModelAndPredict(String plantType) async {
    // Construct paths for model and label
    String modelPath = 'assets/models/$plantType.tflite';
    String labelPath = 'assets/labels/$plantType.txt';


    // Load the model
    try{
      String? res = await Tflite.loadModel(
        model: modelPath,
        labels: labelPath,
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false,
      );

      // Predict using the selected image
      if (image.value != null) {
        // Record start time
        DateTime startTime = DateTime.now();

        var prediction = await Tflite.runModelOnImage(
          path: image.value!.path,
          numResults: 5,
          threshold: 0.5,
        );
        if(selectedCategory.value==2){
          print("hello :  ============= ${prediction![0]['label']}");
          Get.toNamed(RouteNames.ShowSoil,arguments: prediction![0]['label']);
        }
        else {
          //If plant is healthy redirect to healthy window
          if (prediction![0]['label'].toLowerCase().contains("healthy")) {
            //await Tflite.close();
            //print("redicrecting to healthy");
            Get.toNamed(RouteNames.Healthy, arguments: plantType);
            return;
          }
          // if plant is not healthy call the following function to redirect to specific disease page
          fetchPlant(prediction![0]['label'], plantType);
        }
        // After prediction, release the model
        await Tflite.close();
      }
      }catch(e){
      print(e);
        showSnackBar("Error", "Model not found ");
    }
  }

  // ====================== Route to specific disease ===========================
  Future<void> fetchPlant(String diseaseName,String plantType) async {
    try {
      loading.value = true;
      // Load JSON from assets
      String jsonString = await rootBundle.loadString('assets/json/$plantType.json');

      // Parse JSON data and map to the model
      var jsonData = json.decode(jsonString);
      plant = PlantModel.fromJson(jsonData); // Assuming PlantModel has a fromJson method
      Disease? disease;
      try {
        print(plantType);
        print(diseaseName);
        disease = plant.diseases?.firstWhere((d) => d.diseaseName == diseaseName);
      } catch (e) {
        print(e);
        // If no matching disease is found, set a default "Unknown" disease
        showSnackBar("Error", "Failed to fetch disease information");
      }
      if (disease != null) {
        // Navigate to the ShowDisease screen with the disease data
        Get.toNamed(RouteNames.ShowDisease, arguments: disease);
      } else {
        showSnackBar("Error", "Something went wrong");
        //print("Disease not found");
      }
      //Get.toNamed(RouteNames.ShowDisease,arguments: plant.diseases![index]);
    }catch(e){
      showSnackBar("Error", "Something went wrong $e");
    }
  }

}