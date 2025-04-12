import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:smart_cane_app/app/AppColors.dart';
import 'package:smart_cane_app/app/config/dio_config.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool obscureText = true;
  final dio = DioConfig.instance;
  final FlutterSecureStorage storage = FlutterSecureStorage();

  void handleLogin() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      Get.snackbar("Login", "Please fill all fields",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      print("logging in");
      final response = await dio.post('/user/login',
          data: {"email": email.text, "password": password.text});
print("got response");
      String accessToken = response.data['accessToken'];
      String refreshToken = response.data['refreshToken'];

      // Save tokens securely
      await storage.write(key: 'accessToken', value: accessToken);
      await storage.write(key: 'refreshToken', value: refreshToken);

      if (response.data['user'] != null) {
        Get.offAndToNamed("/user-home");
      } else {
        Get.snackbar("Login", "Wrong email and password",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      print("Dio error: $e");
      if (e.response?.data["message"] != null) {
        Get.snackbar("Login", e.response?.data["message"],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }
      Get.snackbar("Login", "Try again later",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } catch (error) {
      print("General error: $error");
    }
  }

  @override
  void onInit()async {
    super.onInit();
    // Check if the user is logged in

    String? accessToken = await storage.read(key: 'accessToken');

    print("Access Token: $accessToken");
    Get.offAndToNamed("/user-home");
    }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
