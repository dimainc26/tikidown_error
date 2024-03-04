import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tikidown/CONSTANTS/colors.dart';
import 'package:tikidown/CONSTANTS/pages.dart';
import 'package:tikidown/PAGES/HOME/home_controller.dart';
import 'package:tikidown/PAGES/HOME/home_view.dart';

void main() async {
  await GetStorage.init();
  // MobileAds.instance.initialize();
  Get.put(HomeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TikiDown - TikTok Video Saver',
      theme: ThemeData(
        primarySwatch: thirdSwatch,
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.androidRoutes,
    );
  }
}
