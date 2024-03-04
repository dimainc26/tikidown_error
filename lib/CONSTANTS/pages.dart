import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tikidown/PAGES/HOME/home_binding.dart';
import 'package:tikidown/PAGES/HOME/home_view.dart';

part 'routes.dart';

GetStorage box = GetStorage();

class AppPages {
  static const initial = Routes.home;
  // static const first = Routes.splash;
  // static const working = Routes.working;
  // static const gallery = Routes.gallery;
  // static const player = Routes.player;

  static final androidRoutes = [
    // Current working page
    GetPage(name: '/', page: () => const HomeScreen(), binding: HomeBinding()),

    // GetPage(
    //     name: '/',
    //     page: () {
    //       if (box.hasData('isFirstTime')) {
    //         return const SwipeScreen();
    //       } else {
    //         return const SplashScreen();
    //       }
    //     },
    //     binding: box.hasData('isFirstTime') ? SwipeBinding() : SplashBinding()),
    // GetPage(
    //     name: '/onboard',
    //     page: () => const OnBoardingScreen(),
    //     binding: OnboardBinding()),
    // GetPage(
    //     name: '/swipes',
    //     page: () => const SwipeScreen(),
    //     binding: SwipeBinding()),
    // GetPage(
    //     name: '/gallery',
    //     page: () => const GalleryScreen(),
    //     binding: GalleryBinding()),
    // GetPage(
    //     name: '/player',
    //     page: () => const PlayerScreen(),
    //     binding: PlayerBinding()),
    // GetPage(
    //     name: '/music',
    //     page: () => const MusicScreen(),
    //     binding: MusicBinding()),
    // GetPage(
    //     name: '/home',
    //     page: () => const SwipeScreen(),
    //     binding: SwipeBinding()),
    // GetPage(
    //     name: '/sets',
    //     page: () => const SettingsScreen(),
    //     binding: SettingsBinding()),
    // GetPage(
    //     name: '/tutor',
    //     page: () => const TutorScreen(),
    //     binding: TutorBinding()),
  ];
}
