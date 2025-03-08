import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:uuid/uuid.dart';

import '../widgets/confirmDialog.dart';
import 'env.dart';

void showSnackBar(String title,String message){
  Get.snackbar(title,message,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
      backgroundColor: const Color(0xff252526),
      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      snackStyle: SnackStyle.GROUNDED,
      margin: const EdgeInsets.all(0)
  );
}

Future<File?> pickImageFromGallery() async {
  const uid=Uuid();
  final ImagePicker picker = ImagePicker();
  final XFile? file = await picker.pickImage(source: ImageSource.gallery);
  if(file == null) return null;
  final dir = Directory.systemTemp;
  final targetPath = "${dir.absolute.path}/${uid.v6()}.jpg";
  File image = await compressImage(File(file.path), targetPath);
  return image;
}

// Compress file
Future<File> compressImage(File file,String targetpath) async{
  var result = await FlutterImageCompress.compressAndGetFile(file.path, targetpath,quality: 50);
  return File(result!.path);
}

// To get image bucket url
String getBucketUrl(String path){
  return "${Env.supabaseUrl}/storage/v1/object/public/$path";
}


// Open confirm dialog box
void confirmDialog(String title,String text,VoidCallback voidCallback){
  Get.dialog(DialogFb1(title: title,text: text,voidCallback: voidCallback));
}

// To change date time format
String formatDateTime(String date){
  DateTime utcDateTime = DateTime.parse(date.split("+")[0].trim());
  // convert utc to ist
  DateTime istDateTime = utcDateTime.add(const Duration(hours: 5,minutes: 30));

  return Jiffy.parseFromDateTime(istDateTime).fromNow();

}

String formatNonStringDate(DateTime dateTime) {
  // Format the IST DateTime to "dd-MM-yyyy"
  return DateFormat('dd-MM-yyyy').format(dateTime);
}

String convertUnixToIST(int unixTimestamp) {
  // Convert Unix timestamp to DateTime
  DateTime utcDateTime = DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000, isUtc: true);

  // Convert UTC to IST (add 5 hours and 30 minutes)
  DateTime istDateTime = utcDateTime.add(const Duration(hours: 5, minutes: 30));

  // Format DateTime to a string in "d MMM" format (e.g., "1 Sept")
  String formattedDate = DateFormat('d MMM').format(istDateTime);

  return formattedDate;
}