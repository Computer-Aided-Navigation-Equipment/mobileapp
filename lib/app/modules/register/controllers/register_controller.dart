import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:smart_cane_app/app/config/dio_config.dart';

class RegisterController extends GetxController {
  //TODO: Implement RegisterController
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String accountType = "User";

  bool obscureText = true;
  final dio = DioConfig.instance;
  final FlutterSecureStorage storage = FlutterSecureStorage();

  void handleRegister() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      Get.snackbar("Login", "Please fill all fields",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      final response = await dio.post('/user/register', data: {
        "email": email.text,
        "password": password.text,
        "firstName": firstName.text,
        "lastName": lastName.text,
        "address": address.text,
        "phoneNumber": phoneNumber.text,
        "dateOfBirth": dateOfBirth.text,
        "userType": accountType.toLowerCase()
      });

      String accessToken = response.data['accessToken'];
      String refreshToken = response.data['refreshToken'];

      // Save tokens securely
      await storage.write(key: 'accessToken', value: accessToken);
      await storage.write(key: 'refreshToken', value: refreshToken);

      if (response.data['user'] != null) {
        Get.offAndToNamed("/user-home");
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      print(e);
      print(e.response);
      if (e.response?.data["message"] != null) {
        Get.snackbar("Register", e.response?.data["message"],
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
  void onInit() {
    super.onInit();
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
