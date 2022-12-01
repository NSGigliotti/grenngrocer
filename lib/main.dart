import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grenngrocer/src/pages_routes/app_pages.dart';

import 'src/pages/auth/controller/auth_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Greengrocer',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white.withAlpha(190),
      ),
      //home: const SplashScreen(),

      initialRoute: PageRoutes.splashRoutes,
      getPages: AppPages.pages,
    );
  }
}
