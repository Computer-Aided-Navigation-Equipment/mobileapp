import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:smart_cane_app/app/config/dio_config.dart';

class ProfileController extends GetxController {
  //TODO: Implement ProfileController

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();

  TextEditingController email = TextEditingController();

  String accountType = "User";
  bool obscureText = true;
  final dio = DioConfig.instance;
  final FlutterSecureStorage storage = FlutterSecureStorage();


  void fetchUserDetails() async{
    final response = await dio.get('/user/profile');
    print(response.data);
    if(response.data['user'] != null){
      firstName.text = response.data['user']['firstName'];
      lastName.text = response.data['user']['lastName'];
      address.text = response.data['user']['address'];
      phoneNumber.text = response.data['user']['phoneNumber'];
      dateOfBirth.text = response.data['user']['dateOfBirth'];
      email.text = response.data['user']['email'];
    }

  }

  void handleLogout() async{
    await storage.deleteAll();
    Get.offAllNamed("/login");
  }

  void handleUpdateProfile() async{
    if (email.text.isEmpty) {
      Get.snackbar("Update Profile", "Please fill all fields",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      final response = await dio.post('/user/update', data: {
        "email": email.text,
        "firstName": firstName.text,
        "lastName": lastName.text,
        "address": address.text,
        "phoneNumber": phoneNumber.text,
        "dateOfBirth": dateOfBirth.text,
      });

      print(response.data);
      if (response.data['user'] != null) {
        Get.snackbar("Update Profile", "Profile updated successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      print(e);
      print(e.response);
      if (e.response?.data["message"] != null) {
        Get.snackbar("Update Profile", e.response?.data["message"],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (error) {
      print("General error: $error");
    }
  }
  @override
  void onInit() {
    super.onInit();
    fetchUserDetails();
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
