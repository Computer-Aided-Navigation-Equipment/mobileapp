import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart'; // Import the package

class UserHomeController extends GetxController {
  //TODO: Implement UserHomeController

  TextEditingController location = TextEditingController();
  final FlutterSecureStorage storage = FlutterSecureStorage();
  bool isAdmin= false;


  Future<String> decodeJwt(String token) async{
    try {

      final jwt = JWT.decode(token);

      // You can print the decoded JWT object or return it as a string
      return jwt.toString();
    } catch (e) {
      return 'Failed to decode JWT token: $e';
    }
  }
void logout (){
  Get.offAllNamed("/");
  storage.delete(key: "accessToken");
  storage.delete(key: "refreshToken");
}

void setIsAdmin(bool value) {

}
  @override
  void onInit()async {
    super.onInit();

    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken != null) {
      final jwt = JWT.decode(accessToken);
      if (jwt.payload['userType'] == "admin") {
        isAdmin = true;
        update();
      }
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
