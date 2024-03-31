// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tikidown/CONSTANTS/colors.dart';
import 'package:tikidown/CONSTANTS/images.dart';
import 'package:tikidown/CONSTANTS/pages.dart';
import 'package:tikidown/CONSTANTS/texts.dart';
import 'package:tikidown/CONSTANTS/texts_styles.dart';
import 'package:tikidown/MODELS/VideoModel.dart';
import 'package:tikidown/MODELS/videos_class.dart';
import 'package:tikidown/PAGES/HOME/home_controller.dart';
import 'package:tikidown/WIDGETS/buttons.dart';

VideoModel videoModel = VideoModel();

class ErrorPopup extends StatelessWidget {
  const ErrorPopup(
      {required this.errorTitle,
      required this.errorText,
      required this.errorImage,
      super.key});

  final String errorTitle;
  final String errorText;
  final String errorImage;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Get.height / 3 + 40,
        width: Get.width,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          color: white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Column(
          children: [
            Text(
              errorTitle,
              style: largeText,
            ),
            Expanded(
              flex: 2,
              child: SvgPicture.asset(
                errorImage,
                // colorFilter:
                //     const ColorFilter.mode(secondColor, BlendMode.saturation),
                width: 100,
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  errorText,
                  style: formTitle,
                ),
              ),
            ),
            LargeButton(
                onTap: () => Get.back(), color: firstColor, text: "Back")
          ],
        ));
  }
}

class DeletePopup extends StatelessWidget {
  const DeletePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeleteController>(
        init: DeleteController(),
        builder: (DeleteController controller) {
          return Container(
            height: Get.height / 3,
            width: Get.width,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              color: thirdColor,
            ),
            child: Column(
              children: [
                const Text(
                  delete_text,
                  style: formTitle,
                ),
                SizedBox(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      LargeButton(
                        onTap: () => controller.eraseFiles(),
                        color: secondColor,
                        text: "Oui",
                      ),
                      LargeButton(
                        onTap: () => Get.back(),
                        color: firstColor,
                        text: "Non",
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}

class DeleteController extends GetxController {
  RxString previousRoot = "videos".obs;
  RxList list = [].obs;
  @override
  void onInit() {
    super.onInit();
    list.value = Get.arguments;
  }

  eraseFiles() {
    RxList list = Get.find<HomeController>().filesList;
    var toRemove = [];
    for (var element in list) {
      if (element["isSelected"].value == true) {
        File delFile = File(element["path"]);
        delFile.deleteSync();
        toRemove.add(element);
      }
    }

    RxList dataList = [].obs;
    dataList.value = jsonDecode(box.read("dataList"));
    for (var e in dataList) {
      e["isSelected"] = false.obs;
    }
    // log("BEFORE: ${dataList.length}");

    dataList.removeWhere(
        (aItem) => toRemove.any((bItem) => aItem["path"] == bItem["path"]));
    // log("AFTER: ${dataList.length}");

    list.removeWhere((element) => toRemove.contains(element));
    Get.find<HomeController>().deselectAll(list: list);

    for (var e in dataList) {
      e["isSelected"] = false;
    }

    final saveList = jsonEncode(dataList);
    box.write("dataList", saveList).then((value) {
      box.save();
      for (var e in list) {
        e["isSelected"] = false.obs;
      }
    });
    Get.find<HomeController>().update();
    Get.back();
  }
}

class MenuPopup extends StatelessWidget {
  MenuPopup({required this.file, super.key});

  dynamic file;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuController>(
      init: MenuController(),
      builder: (MenuController controller) {
        return Container(
          width: Get.width,
          height: Get.height / 2.4,
          decoration: const BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          child: Column(
            children: [
              Container(
                width: Get.width,
                height: 65,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextButton(
                    onPressed: () {
                      Get.back();
                      controller.details(details: file);
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Details",
                            style: miniTitle.copyWith(
                                fontSize: 22, decoration: TextDecoration.none),
                            textAlign: TextAlign.end,
                          ),
                          SvgPicture.asset(infoIcon, width: 25),
                        ],
                      ),
                    )),
              ),
              Container(
                width: Get.width - 60,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                height: 2,
                color: firstColor,
              ),
              Container(
                width: Get.width,
                height: 65,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextButton(
                    onPressed: () => controller.delete(file: file),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Supprimer",
                            style: miniTitle.copyWith(
                                fontSize: 22,
                                decoration: TextDecoration.none,
                                color: secondColor),
                            textAlign: TextAlign.end,
                          ),
                          SvgPicture.asset(
                            delete_icon,
                            width: 25,
                            colorFilter: const ColorFilter.mode(
                                secondColor, BlendMode.srcIn),
                          ),
                        ],
                      ),
                    )),
              ),
              Container(
                width: Get.width - 60,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                height: 2,
                color: firstColor,
              ),
              Expanded(
                  child: Center(
                child: InkWell(
                  onTap: () => controller.shareFile(file: file),
                  child: Container(
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: thirdColor),
                    child: SvgPicture.asset(
                      shareIcon,
                      colorFilter:
                          const ColorFilter.mode(firstColor, BlendMode.srcIn),
                    ),
                  ),
                ),
              ))
            ],
          ),
        );
      },
    );
  }
}

class MenuController extends GetxController {
  shareFile({required file}) {
    // Share.shareXFiles([XFile(file["path"])]);
  }

  delete({required file}) {
    RxList list = Get.find<HomeController>().filesList;
    var toRemove = [];

    File delFile = File(file["path"]);
    delFile.deleteSync();
    toRemove.add(file);

    list.removeWhere((element) => toRemove.contains(element));

    for (var e in list) {
      e["isSelected"] = false;
    }

    final saveList = jsonEncode(list);
    box.write("dataList", saveList).then((value) {
      box.save();
      for (var e in list) {
        e["isSelected"] = false.obs;
      }
      Get.find<HomeController>().update();
    });

    Get.back();
    Get.back();
  }

  details({required details}) {
    Get.bottomSheet(
      ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: Get.width,
          height: Get.height / 2.5,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white38,
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  SizedBox(
                    width: Get.width,
                    height: 50,
                    // padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      "title: ${details["title"]}",
                      style: miniTitle.copyWith(
                          decoration: TextDecoration.none,
                          fontSize: 24,
                          color: white,
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    width: Get.width - 12,
                    height: 2,
                    color: firstColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 140,
                        padding: const EdgeInsets.only(right: 12),
                        child: Image.network(
                          details["avatar"],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Container(
                              width: Get.width - 200,
                              height: 50,
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                "name: ${details["name"]}",
                                style: miniTitle.copyWith(
                                    decoration: TextDecoration.none,
                                    color: white),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(
                              width: Get.width - 200,
                              height: 50,
                              child: Text(
                                "username: ${details["username"]}",
                                style: miniTitle.copyWith(
                                    decoration: TextDecoration.none,
                                    color: white),
                              ),
                            ),
                            SizedBox(
                              width: Get.width - 200,
                              height: 50,
                              child: Row(
                                children: [
                                  SvgPicture.asset(settings_icon),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Text(
                                      details["country"] ?? "World",
                                      style: miniTitle.copyWith(
                                          color: firstColor, fontSize: 20),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: Get.width - 24,
                    height: 2,
                    color: firstColor,
                    margin: const EdgeInsets.only(right: 12),
                  ),
                  Image.asset(
                    logoImg,
                    width: 70,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImagePopup extends StatelessWidget {
  ImagePopup({required this.data, super.key});

  dynamic data;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageController>(
        init: ImageController(),
        builder: (ImageController controller) {
          return Container(
            height: Get.height / 2 + 40,
            width: Get.width,
            decoration: const BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.only(top: 10),
                    height: (Get.height / 2) - 100,
                    child: Stack(
                      children: [
                        PageView.builder(
                            itemCount: data.images!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                width: Get.width - 20,
                                height: (Get.height / 2) - 180,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey,
                                  image: DecorationImage(
                                    image: NetworkImage(data.images![index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }),
                        Positioned(
                          right: 20,
                          child: Container(
                              width: 180,
                              color: secondColor.withOpacity(.4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "P: ${data.plays!}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "S: ${data.shares!}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "C: ${data.comments!}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                        ),
                        Positioned(
                          left: 20,
                          bottom: 0,
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 2),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(data.avatar!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            left: 120,
                            child: Text(
                              "@${data.name!} / ${data.username!}",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            )),
                      ],
                    )),
                const SizedBox(
                  height: 40,
                ),
                LargeButton(
                    text: "Downloads ${data.images!.length} Image(s)",
                    onTap: () {
                      controller.downloadImages();
                      Get.back();
                    },
                    color: firstColor),
              ],
            ),
          );
        });
  }
}

class ImageController extends GetxController {
  downloadImages() {
    Get.find<HomeController>().downloadImages();
  }
}

class VideoPopup extends StatelessWidget {
  VideoPopup({required this.data, super.key});

  dynamic data;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoController>(
        init: VideoController(),
        builder: (VideoController controller) {
          return Container(
            height: Get.height / 2 + 40,
            width: Get.width,
            decoration: const BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.only(top: 10),
                    height: (Get.height / 2) - 100,
                    child: Stack(
                      children: [
                        Container(
                          width: Get.width - 20,
                          height: (Get.height / 2) - 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey,
                            image: DecorationImage(
                              image: NetworkImage(data.cover!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          child: Container(
                              width: 180,
                              color: secondColor.withOpacity(.4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "P: ${data.plays!}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "S: ${data.shares!}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "C: ${data.comments!}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                        ),
                        Positioned(
                          left: 20,
                          bottom: 20,
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 2),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(data.avatar!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 40,
                            left: 120,
                            child: Text(
                              "@${data.name!} / ${data.username!}",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            )),
                        Positioned(
                          right: 20,
                          bottom: 20,
                          child: InkWell(
                            onTap: () {
                              if (data.music == "" || data.music == null) {
                              } else {
                                controller.downloadMusic();
                              }
                              Get.back();
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 2),
                                shape: BoxShape.circle,
                                image: const DecorationImage(
                                  image: AssetImage(logoImg),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  music_icon,
                                  width: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                LargeButton(
                    text: "Authentik Video",
                    onTap: () {
                      controller.downloadVideo();
                      Get.back();
                    },
                    color: firstColor),
                const SizedBox(
                  height: 10,
                ),
                LargeButton(
                    text: "Watermark Video",
                    onTap: () {
                      controller.downloadWatermarkVideo();
                      Get.back();
                    },
                    color: thirdColor),
              ],
            ),
          );
        });
  }
}

class VideoController extends GetxController {
  downloadWatermarkVideo() {
    Get.find<HomeController>().downloadWatermarkVideo();
  }

  downloadVideo() {
    Get.find<HomeController>().downloadVideo();
  }

  downloadMusic() {
    Get.find<HomeController>().downloadMusic();
  }
}
