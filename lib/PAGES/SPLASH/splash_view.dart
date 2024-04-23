import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikidown/CONSTANTS/images.dart';
import 'package:tikidown/PAGES/SPLASH/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        color: const Color.fromARGB(255, 48, 48, 48),
        child: Center(child: Image.asset(logoImg)),
      ),
    );
  }
}
