import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin, WidgetsBindingObserver {
  // Controllers
  late PageController pageController;
  late PageController downPageController;
  late TabController tabBarController;
  final linkController = TextEditingController();

  // Variables
  Duration duration = const Duration(milliseconds: 500);
  RxInt tabSelectedPage = 0.obs;
  RxInt currentIndicator = 0.obs;
  RxDouble downloadProgress = 0.0.obs;
  RxBool selectionMode = false.obs;
  RxBool downloading = false.obs;
  RxBool launchAnimation = false.obs;
  RxList filesList = [].obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    tabBarController = TabController(length: 3, vsync: this, initialIndex: 0);
    downPageController = PageController(initialPage: tabSelectedPage.value);
    currentIndicator = pageController.initialPage.obs;
  }

  @override
  void onClose() {
    super.onClose();
    linkController.dispose();
  }

  // Change pages
  home() {
    if (pageController.page != 0) {
      pageController.animateToPage(0, duration: duration, curve: Curves.linear);
    }
  }

  downloads() async {
    if (pageController.page != 1) {
      pageController.animateToPage(1, duration: duration, curve: Curves.linear);
    }
  }

  shareApp() async {}

  fetchDatas({required String link}) async {}
}
