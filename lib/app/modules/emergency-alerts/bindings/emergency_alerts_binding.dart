import 'package:get/get.dart';

import '../controllers/emergency_alerts_controller.dart';

class EmergencyAlertsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmergencyAlertsController>(
      () => EmergencyAlertsController(),
    );
  }
}
