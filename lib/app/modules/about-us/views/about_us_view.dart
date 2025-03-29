import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:smart_cane_app/app/widgets/TitleText.dart';

import '../controllers/about_us_controller.dart';

class AboutUsView extends GetView<AboutUsController> {
  const AboutUsView({super.key});
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
              TitleText(title: "About us"),
              Text("Text goes here")



            ],
          ),
        ),
      ),
    );
  }
}
