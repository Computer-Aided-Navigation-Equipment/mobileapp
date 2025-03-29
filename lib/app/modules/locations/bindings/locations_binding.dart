import 'package:get/get.dart';

import '../controllers/locations_controller.dart';

class LocationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationsController>(
      () => LocationsController(),
    );
  }
}
