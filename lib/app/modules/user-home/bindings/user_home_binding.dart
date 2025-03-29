import 'package:get/get.dart';

import '../controllers/user_home_controller.dart';

class UserHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserHomeController>(
      () => UserHomeController(),
    );
  }
}
