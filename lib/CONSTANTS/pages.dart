import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tikidown/PAGES/GALLERY/gallery_binding.dart';
import 'package:tikidown/PAGES/GALLERY/gallery_view.dart';
import 'package:tikidown/PAGES/HOME/home_binding.dart';
import 'package:tikidown/PAGES/HOME/home_view.dart';
import 'package:tikidown/PAGES/MUSIC/music_binding.dart';
import 'package:tikidown/PAGES/MUSIC/music_view.dart';
import 'package:tikidown/PAGES/ONBOARD/onboard_binding.dart';
import 'package:tikidown/PAGES/ONBOARD/onboard_view.dart';
import 'package:tikidown/PAGES/PLAYER/player_binding.dart';
import 'package:tikidown/PAGES/PLAYER/player_view.dart';
import 'package:tikidown/PAGES/SETTINGS/settings_binding.dart';
import 'package:tikidown/PAGES/SETTINGS/settings_view.dart';
import 'package:tikidown/PAGES/SPLASH/splash_binding.dart';
import 'package:tikidown/PAGES/SPLASH/splash_view.dart';
import 'package:tikidown/PAGES/TUTOR/tutor_binding.dart';
import 'package:tikidown/PAGES/TUTOR/tutor_view.dart';

part 'routes.dart';

GetStorage box = GetStorage();

class AppPages {
  static const initial = Routes.home;

  static final androidRoutes = [
    GetPage(
        name: '/',
        page: () {
          if (box.hasData('isFirstTime')) {
            return const HomeScreen();
          } else {
            return const SplashScreen();
          }
        },
        binding: box.hasData('isFirstTime') ? HomeBinding() : SplashBinding()),
    GetPage(
        name: '/onboard',
        page: () => const OnBoardingScreen(),
        binding: OnboardBinding()),
    GetPage(
        name: '/gallery',
        page: () => const GalleryScreen(),
        binding: GalleryBinding()),
    GetPage(
        name: '/player',
        page: () => const PlayerScreen(),
        binding: PlayerBinding()),
    GetPage(
        name: '/music',
        page: () => const MusicScreen(),
        binding: MusicBinding()),
    GetPage(
        name: '/home', page: () => const HomeScreen(), binding: HomeBinding()),
    GetPage(
        name: '/settings',
        page: () => const SettingsScreen(),
        binding: SettingsBinding()),
    GetPage(
        name: '/tutor',
        page: () => const TutorScreen(),
        binding: TutorBinding()),
  ];
}
