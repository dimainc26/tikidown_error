import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tikidown/CONSTANTS/colors.dart';
import 'package:tikidown/CONSTANTS/images.dart';
import 'package:tikidown/PAGES/HOME/home_controller.dart';
import 'package:tikidown/WIDGETS/buttons.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: (int page) async {
              controller.currentIndicator.value = page;

              //   if (page == 1) {
              //     var r = Random().nextInt(100);
              //     //   if (r > 40) {
              //     //     if (adController.interstitialAd != null) {
              //     //       await adController.interstitialAd?.show();
              //     //     } else {
              //     //       adController.createInterstitialAd();
              //     //     }
              //     //   }
              //   }
            },
            children: [
              Container(
                width: Get.width,
                height: Get.height,
                // color: firstColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () => controller.shareApp(),
                        child: Container(
                          height: Get.height / 3,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(logoImg),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 4),
                      padding:
                          const EdgeInsets.only(left: 32, top: 4, bottom: 4),
                      width: Get.width - 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: TextFormField(
                        controller: controller.linkController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Paste Link Here",
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: fourthColor,
                          ),
                        ),
                        style:
                            const TextStyle(fontSize: 16, color: secondColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Obx(
                        () => Container(
                          margin: const EdgeInsets.only(top: 6, bottom: 12),
                          width: Get.width - 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            // border: Border.all(color: Colors.grey),
                            gradient: const LinearGradient(
                              colors: [secondColor, firstColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: controller.downloading.value
                              ? Container(
                                  height: 55,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Positioned.fill(
                                        child: Obx(
                                          () => LinearProgressIndicator(
                                            value: controller
                                                .downloadProgress.value,
                                            color: Colors.white24,
                                            backgroundColor:
                                                thirdColor.withAlpha(20),
                                          ),
                                        ),
                                      ),
                                      const Center(
                                        child: Text('Download...'),
                                      )
                                    ],
                                  ),
                                )
                              : PageButton(
                                  onTap: () => controller.fetchDatas(
                                      link: controller.linkController.text),
                                  color: firstColor,
                                ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            // Obx(
                            //   () => adController.startBannerAd.value == true
                            //       ? SizedBox(
                            //           height: adController.bannerAd!.size.height
                            //               .toDouble(),
                            //           width: adController.bannerAd!.size.width
                            //               .toDouble(),
                            //           child:
                            //               AdWidget(ad: adController.bannerAd!),
                            //         )
                            //       : Text(""),
                            // ),
                            TextButton(
                                onPressed: null,

                                // () =>
                                //     controller.checkClipboardForLink(),
                                child: const Text("Intent")),
                            TextButton(
                                onPressed: () => controller.shareApp(),
                                child: const Text("Share Files"))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: Get.width,
                height: Get.height,
                color: secondColor,
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            child: Container(
              width: Get.width / 2,
              height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(
                    () => TextButton(
                      onPressed: () => controller.home(),
                      child: SvgPicture.asset(
                        home_icon,
                        width: 35,
                        colorFilter: ColorFilter.mode(
                            controller.currentIndicator.value == 0
                                ? secondColor
                                : fourthColor,
                            BlendMode.srcIn),
                      ),
                    ),
                  ),
                  Obx(
                    () => TextButton(
                      onPressed: () => controller.downloads(),
                      child: SvgPicture.asset(
                        download_icon,
                        width: 35,
                        colorFilter: ColorFilter.mode(
                            controller.currentIndicator.value == 1
                                ? secondColor
                                : fourthColor,
                            BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
