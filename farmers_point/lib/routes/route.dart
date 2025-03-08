import 'package:cropunity/views/informationZone/informationZone.dart';
import 'package:cropunity/views/myCrops/info.dart';
import 'package:cropunity/views/myCrops/manageplant.dart';
import 'package:cropunity/views/myCrops/showFarmer.dart';
import 'package:cropunity/views/myCrops/topfarmers.dart';
import 'package:cropunity/views/plants/healthyPlant.dart';
import 'package:cropunity/views/plants/plantDisease.dart';
import 'package:cropunity/views/predict/predict.dart';
import 'package:cropunity/views/soil/soilInfo.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import '../auth/login.dart';
import '../auth/signup.dart';
import '../settings/setting.dart';
import '../views/Season/seasonInfo.dart';
import '../views/chatbot/chatbot.dart';
import '../views/home.dart';
import '../views/myCrops/dashboard.dart';
import '../views/plants/plantInfo.dart';
import '../views/post/addPost.dart';
import '../views/post/showImage.dart';
import '../views/post/showPost.dart';
import '../views/profile/editProfile.dart';
import '../views/profile/showProfile.dart';
import '../views/reply/addReply.dart';
import 'routeNames.dart';

class Routes{
  static final pages=[

    GetPage(name: RouteNames.Home,page: () => Home()),
    GetPage(name: RouteNames.Login, page: () =>const Login()),
    GetPage(name: RouteNames.Signup, page: () =>const Signup()),
    GetPage(name: RouteNames.EditProfile, page: () =>const Editprofile(),transition: Transition.rightToLeft),
    GetPage(name: RouteNames.AddPost, page: () =>AddPost(),transition: Transition.downToUp),
    GetPage(name: RouteNames.Settings, page: () =>Setting(),transition: Transition.rightToLeft),
    GetPage(name: RouteNames.AddReply, page: () =>AddReply(),transition: Transition.downToUp),
    GetPage(name: RouteNames.ShowPost, page: () =>const ShowPost(),transition: Transition.leftToRight),
    GetPage(name: RouteNames.ShowImage, page: () =>ShowImage(),transition: Transition.leftToRight),
    GetPage(name: RouteNames.Chatbot, page: () =>const ChatBot(),transition: Transition.downToUp),
    GetPage(name: RouteNames.ShowProfile, page: () =>const ShowProfile(),transition: Transition.leftToRight),
    GetPage(name: RouteNames.ShowPlant, page: () =>const PlantInfo(),transition: Transition.downToUp),
    GetPage(name: RouteNames.ShowDisease, page: () =>const PlantDisease(),transition: Transition.leftToRight),
    GetPage(name: RouteNames.InformationZone, page: () =>const InformationZone(),transition: Transition.leftToRight),
    GetPage(name: RouteNames.Predict, page: () =>const Predict(),transition: Transition.leftToRight),
    GetPage(name: RouteNames.Healthy, page: () =>const HealthyPlant(),transition: Transition.leftToRight),
    GetPage(name: RouteNames.ShowSoil, page: () =>const SoilInfo(),transition: Transition.downToUp),
    GetPage(name: RouteNames.ShowSeason, page: () =>const SeasonInfo(),transition: Transition.downToUp),
    GetPage(name: RouteNames.MyCrops, page: () =>MyCropsDashboard(),transition: Transition.leftToRight),
    GetPage(name: RouteNames.ManageInfo, page: () =>const Info(),transition: Transition.leftToRight),
    GetPage(name: RouteNames.ManagePlant, page: () =>const ManagePlant(),transition: Transition.leftToRight),
    GetPage(name: RouteNames.TopFarmers, page: () =>const TopFarmers(),transition: Transition.leftToRight),
    GetPage(name: RouteNames.ShowFarmer, page: () =>const ShowFarmer(),transition: Transition.leftToRight),
  ];
}