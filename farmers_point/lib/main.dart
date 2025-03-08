import 'package:cropunity/routes/route.dart';
import 'package:cropunity/routes/routeNames.dart';
import 'package:cropunity/services/storageServices.dart';
import 'package:cropunity/services/supabaseService.dart';
import 'package:cropunity/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  Get.put(SupabaseService());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      title: 'Flutter Demo',
      getPages: Routes.pages,
      initialRoute: StorageService.userSession != null ? RouteNames.Home : RouteNames.Login,

    );
  }
}
