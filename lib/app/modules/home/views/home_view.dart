import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:smart_cane_app/app/AppColors.dart';
import 'package:smart_cane_app/app/widgets/PrimaryButton.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 20),
              PrimaryButton(
                buttonText: "Sign In",
                onPressed: () {
                  Get.toNamed("login");
                },
              ),
              SizedBox(
                height: 10,
              ),
              PrimaryButton(
                buttonText: "Sign Up",
                onPressed: () {
                  Get.toNamed("/register");
                },
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed("/about-us");
                },
                child: Text(
                  "About Us",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: AppColors.mainColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
