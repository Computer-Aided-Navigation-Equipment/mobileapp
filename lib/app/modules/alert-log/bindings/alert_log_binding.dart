import 'package:get/get.dart';

import '../controllers/alert_log_controller.dart';

class AlertLogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlertLogController>(
      () => AlertLogController(),
    );
  }
}
