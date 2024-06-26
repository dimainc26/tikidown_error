import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikidown/WIDGETS/popup.dart';

class GalleryController extends GetxController {
  dynamic list;
  int index = 0;

  final TransformationController transformationController =
      TransformationController();

  static Matrix4 matrix4 = Matrix4(1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0,
      0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0);

  @override
  void onInit() {
    super.onInit();
    imagesInfos();
  }

  reScale() {
    if (transformationController.value.getMaxScaleOnAxis() != 1) {
      transformationController.value = Matrix4.identity();
    }
  }

  menu({required imgData}) {
    Get.bottomSheet(MenuPopup(file: imgData));
  }

  imagesInfos() {
    list = Get.arguments["list"];
    index = Get.arguments["index"];

    log(list.toString());
  }
}
