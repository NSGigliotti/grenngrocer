import 'package:get/get.dart';

import 'package:grenngrocer/src/pages/base/base_screen.dart';
import 'package:grenngrocer/src/pages/base/binding/navidation_binding.dart';
import 'package:grenngrocer/src/pages/cart/bainding/cart_binding.dart';
import 'package:grenngrocer/src/pages/home/controller/home_biding.dart';
import 'package:grenngrocer/src/pages/orders/binding/orders_binding.dart';
import 'package:grenngrocer/src/pages/product/product_screen.dart';
import 'package:grenngrocer/src/pages/splash/splash_screen.dart';

import '../pages/auth/view/sign_in_screen.dart';
import '../pages/auth/view/sign_up_screen.dart';

abstract class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: PageRoutes.productRoute,
      page: () => ProductScreen(),
    ),
    GetPage(
      name: PageRoutes.splashRoutes,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: PageRoutes.songInRoutes,
      page: () => SignInScreen(),
    ),
    GetPage(
      name: PageRoutes.songUpRoutes,
      page: () => SignUpScreen(),
    ),
    GetPage(
      name: PageRoutes.baseRoute,
      page: () => const BaseScreen(),
      bindings: [
        NavigationBinding(),
        HomeBinding(),
        CartBinding(),
        OrdersBindind(),
      ],
    ),
  ];
}

abstract class PageRoutes {
  static const String splashRoutes = '/splash';
  static const String productRoute = '/product';
  static const String songInRoutes = '/signin';
  static const String songUpRoutes = '/signup';
  static const String baseRoute = '/';
}
