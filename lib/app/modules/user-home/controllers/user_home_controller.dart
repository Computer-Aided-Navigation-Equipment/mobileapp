import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UserHomeController extends GetxController {
  //TODO: Implement UserHomeController

  TextEditingController location = TextEditingController();

void logout (){
  Get.offAllNamed("/");
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
