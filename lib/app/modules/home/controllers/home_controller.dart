import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final FlutterSecureStorage storage = FlutterSecureStorage();
  @override
  void onInit()async {
    super.onInit();
    // Check if the user is logged in

    String? accessToken = await storage.read(key: 'accessToken');

    print("Access Token: $accessToken");
    if (accessToken != null) {
      // User is logged in, navigate to user home
      Get.offAndToNamed("/user-home");
    } else {
      // User is not logged in, navigate to login
      Get.offAndToNamed("/login");
    }
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
