import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tikidown/CONSTANTS/images.dart';
import 'package:tikidown/PAGES/GALLERY/gallery_controller.dart';

class GalleryScreen extends GetView<GalleryController> {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: InkWell(
      onTap: () => controller.reScale(),
      child: Stack(
        children: [
          SizedBox(
            width: Get.width,
            height: Get.height,
            child: PageView.builder(
                itemCount: controller.list.value.length,
                onPageChanged: (int page) {
                  controller.reScale();
                  controller.index = page;
                },
                itemBuilder: (BuildContext context, int index) {
                  return InteractiveViewer(
                    minScale: 0.5,
                    // boundaryMargin: const EdgeInsets.all(double.infinity),
                    transformationController:
                        controller.transformationController,
                    child: Image.file(
                      File(controller.list[index]["path"]),
                      width: Get.width,
                    ),
                  );
                }),
          ),
          Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () => controller.menu(
                      imgData: controller.list[controller.index]),
                  child: SvgPicture.asset(
                    infoIcon,
                    width: 40,
                  ),
                ),
              )),
        ],
      ),
    ));
  }
}
