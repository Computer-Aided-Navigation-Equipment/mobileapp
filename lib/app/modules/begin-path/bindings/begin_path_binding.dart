import 'package:get/get.dart';

import '../controllers/begin_path_controller.dart';

class BeginPathBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BeginPathController>(
      () => BeginPathController(),
    );
  }
}
