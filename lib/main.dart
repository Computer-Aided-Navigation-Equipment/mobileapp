import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_cane_app/app/AppColors.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: "/",
      theme: ThemeData(
        primaryColor: AppColors.mainColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.mainColor!,
          // ···
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.mainColor!, // Change the cursor color here
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.mainColor!), // Change the border color here
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.mainColor!), // Change the border color here
          ),
          // Customize other properties as needed
        ),
      ),
      getPages: AppPages.routes,
    );
  }
}
