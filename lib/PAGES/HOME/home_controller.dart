import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tikidown/CONSTANTS/images.dart';
import 'package:tikidown/CONSTANTS/pages.dart';
import 'package:tikidown/MODELS/AdController.dart';
import 'package:tikidown/MODELS/VideoModel.dart';
import 'package:tikidown/MODELS/videos_class.dart';
import 'package:tikidown/MYPACKAGES/PhoneInfos.dart';
import 'package:tikidown/MYPACKAGES/VerifyStorage.dart';
import 'package:tikidown/WIDGETS/popup.dart';

import 'package:share_plus/share_plus.dart';

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

  // Class instances
  GetMedia getMedia = GetMedia();
  PhoneInfos phoneInfos = PhoneInfos();
  VideoInfo? videoData = VideoInfo(url: "");

  // Controllers
  final AdController adController = Get.put(AdController());

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    isFirstTime();
    tabBarController = TabController(length: 3, vsync: this, initialIndex: 0);
    downPageController = PageController(initialPage: tabSelectedPage.value);
    currentIndicator = pageController.initialPage.obs;
    checkClipboardForLink();
    getVideos();
    Future.delayed(const Duration(seconds: 5), () {
      adController.showAppOpenAdIfAvailable();
    });
  }

  @override
  void onClose() {
    super.onClose();
    linkController.dispose();
  }

  Future<Map<String, dynamic>> getPhoneInfo() async {
    var phone = await phoneInfos.deviceInfos();
    phone.addAll({"photoPermission": false, "musicPermission": false});
    return phone;
  }

  isFirstTime() async {
    final firstDataSave = jsonEncode(await getPhoneInfo());
    RxList dataList = [].obs;

    if (!box.hasData("isFirstTime")) {
      box.write("isFirstTime", false);
      box.writeIfNull("phone", firstDataSave).then((value) => box.save());
      box
          .writeIfNull("dataList", jsonEncode(dataList.value))
          .then((value) => box.save());
    }
  }
  // -------------------------------------------------------------------------
  // Navigations

  home() {
    if (pageController.page != 0) {
      tabBarController.animateTo(0);
      tabSelectedPage.value = 0;
      getVideos();
      pageController.animateToPage(0, duration: duration, curve: Curves.linear);
    }
  }

  downloads() async {
    if (pageController.page != 1) {
      pageController.animateToPage(1, duration: duration, curve: Curves.linear);
    }
  }

  changePage(pageSelected) {
    if (pageSelected == 0) {
      getVideos();
    } else if (pageSelected == 1) {
      getImages();
    } else if (pageSelected == 2) {
      getMusics();
    }
    downPageController.animateToPage(pageSelected,
        duration: duration, curve: Curves.ease);
  }

  settings() {
    Get.toNamed("/settings");
  }

  gallery({required int index}) {
    Get.toNamed("/gallery", arguments: {"list": filesList, "index": index});
  }
  // end Navigation
  // -------------------------------------------------------------------------

  // Shares
  shareApp() async {
    const String appLink =
        'https://play.google.com/store/apps/details?id=inc.dima.tikidown';
    const String message = 'Check out my new app: $appLink';

    final result = await Share.shareWithResult(appLink, subject: message);

    if (result.status == ShareResultStatus.success) {
      log('Thank you for sharing my website!');
    }
  }

  Future<bool> shareFiles({required List filesToShare}) async {
    List<XFile>? shares = [];
    RxBool goodShare = false.obs;

    for (var shareElement in filesToShare) {
      for (var share in shareElement) {
        if (share["isSelected"].value == true) {
          shares.add(XFile(share["path"]));
          goodShare.value = false;
        }
      }
    }
    goodShare.value = true;
    if (shares.isNotEmpty) {
      if (goodShare.value == true) await Share.shareXFiles(shares);

      for (var shareElement in filesToShare) {
        for (var share in shareElement) {
          if (share["isSelected"].value == true) {
            share["isSelected"].value = false;
          }
        }
      }
      selectionMode.value = false;
    }
    return true;
  }

  fetchDatas({required String link}) async {
    RegExp regExp =
        RegExp(r"https?:\/\/[^\s()<>]+(?:\([\w\d]+\)|([^[:punct:]\s]|\/))");

    final match = regExp.firstMatch(link);

    if (match == null) {
      Get.bottomSheet(const ErrorPopup(
          errorTitle: "Link error",
          errorText:
              "Try to enter good link. \nExemple: https://vm.tiktok.com/....",
          errorImage: error_link_icon));
    } else {
      videoData = await videoModel.checkDatas(match.group(0)!);
      if (videoData?.video == "" || videoData?.video == null) {
        Get.bottomSheet(const ErrorPopup(
            errorTitle: "errorTitle",
            errorText: "Unknown Video context datas",
            errorImage: pause_icon));
      } else {
        VideoInfo datas = videoData!;

        // is Images?
        if (datas.images != null) {
          Get.bottomSheet(ImagePopup(data: datas));
        } else {
          Get.bottomSheet(VideoPopup(
            data: datas,
          ));

          linkController.text = "";
        }
      }
    }
  }

  // -------------------------------------------------------------------------
  // Downloads

  downloadImages() async {
    Map<String, dynamic> phone = jsonDecode(box.read("phone"));
    bool okPermission = phone["photoPermission"];
    if (okPermission) {
      downloading.value = true;
      downloadProgress = await videoModel.downloadMedia(
          mode: "images", datas: videoData!, date: DateTime.now());
      log("${downloadProgress.value}   ${downloading.value}");
      if (downloadProgress.value == 1.0) {
        downloading.value = false;
      }
    } else {
      if (await verifyStorage.requestPermission(phone["version.sdkInt"] < 33
          ? Permission.storage
          : Permission.photos)) {
        phone["photoPermission"] = true;
        box.write("phone", jsonEncode(phone));

        // log(phone["photoPermission"].toString());
        downloadImages();
      } else {
        Get.bottomSheet(const ErrorPopup(
            errorTitle: " Permission",
            errorText: "Give Photo Permission",
            errorImage: warning_icon));
      }
    }

    ever(
        downloadProgress,
        (callback) => {
              if (downloadProgress.value == 1.0) {downloading.value = false}
            });
  }

  downloadVideo() async {
    Map<String, dynamic> phone = jsonDecode(box.read("phone"));
    bool okPermission = phone["photoPermission"];
    if (okPermission) {
      downloading.value = true;
      downloadProgress = await videoModel.downloadMedia(
          mode: "authentik", datas: videoData!, date: DateTime.now());
    } else {
      if (await verifyStorage.requestPermission(phone["version.sdkInt"] < 33
          ? Permission.storage
          : Permission.photos)) {
        phone["photoPermission"] = true;
        box.write("phone", jsonEncode(phone));

        // log(phone["photoPermission"].toString());
        downloadVideo();
      } else {
        Get.bottomSheet(const ErrorPopup(
            errorTitle: " Permission",
            errorText: "Give Photo Permission",
            errorImage: warning_icon));
      }
    }

    ever(
        downloadProgress,
        (callback) => {
              if (downloadProgress.value == 1.0) {downloading.value = false}
            });
  }

  downloadWatermarkVideo() async {
    Map<String, dynamic> phone = jsonDecode(box.read("phone"));
    bool okPermission = phone["photoPermission"];
    if (okPermission) {
      downloading.value = true;
      downloadProgress = await videoModel.downloadMedia(
          mode: "watermark", datas: videoData!, date: DateTime.now());
    } else {
      if (await verifyStorage.requestPermission(phone["version.sdkInt"] < 33
          ? Permission.storage
          : Permission.photos)) {
        phone["photoPermission"] = true;
        box.write("phone", jsonEncode(phone));

        // log(phone["photoPermission"].toString());
        downloadWatermarkVideo();
      } else {
        Get.bottomSheet(const ErrorPopup(
            errorTitle: " Permission",
            errorText: "Give Photo Permission",
            errorImage: warning_icon));
      }
    }

    ever(
        downloadProgress,
        (callback) => {
              if (downloadProgress.value == 1.0) {downloading.value = false}
            });
  }

  downloadMusic() async {
    Map<String, dynamic> phone = jsonDecode(box.read("phone"));
    bool okPermission = phone["musicPermission"];
    if (okPermission) {
      downloading.value = true;
      log("message  ici");
      downloadProgress = await videoModel.downloadMedia(
          mode: "music", datas: videoData!, date: DateTime.now());
    } else {
      if (await verifyStorage.requestPermission(phone["version.sdkInt"] < 33
          ? Permission.storage
          : Permission.audio)) {
        phone["musicPermission"] = true;
        box.write("phone", jsonEncode(phone));

        downloadMusic();
      } else {
        Get.bottomSheet(const ErrorPopup(
            errorTitle: " Permission",
            errorText: "Give Music Permission",
            errorImage: warning_icon));
      }
    }
    ever(
        downloadProgress,
        (callback) => {
              if (downloadProgress.value == 1.0) {downloading.value = false},
            });
  }

  // -------------------------------------------------------------------------

  oneSelected({required RxList list}) {
    for (var oneSelected in list) {
      if (oneSelected['isSelected'].value == true) {
        selectionMode.value = true;
        break;
      } else {
        selectionMode.value = false;
      }
    }
  }

  deleteFile() {
    Get.bottomSheet(
      settings: RouteSettings(arguments: filesList),
      const DeletePopup(),
    );
  }

  deselectAll({required RxList list}) async {
    selectionMode.value = false;
  }

  // -------------------------------------------------------------------------
  // Storage

  getImages() async {
    filesList = [].obs;
    filesList = await getMedia.getImages();
    filesList = filesList.reversed.toList().obs;
  }

  getVideos() async {
    filesList = [].obs;
    filesList = await getMedia.getVideos();
    filesList = filesList.reversed.toList().obs;
  }

  getMusics() async {
    filesList = await getMedia.getMusics();
    filesList = filesList.reversed.toList().obs;
  }

  // -------------------------------------------------------------------------

  // Check Clipboard

  void checkClipboardForLink() async {
    ClipboardData? clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    String clipboardDataText = clipboardData?.text ?? "";
    // log(clipboardDataText);
    if (Uri.tryParse(clipboardDataText)?.hasAbsolutePath ?? false) {
      fetchDatas(link: clipboardDataText);
      Future.delayed(const Duration(seconds: 3), () {
        Clipboard.setData(const ClipboardData(text: ""));
      });
    } else {
      log("Aucun lien trouvé dans le presse-papiers.");
    }
  }
}
