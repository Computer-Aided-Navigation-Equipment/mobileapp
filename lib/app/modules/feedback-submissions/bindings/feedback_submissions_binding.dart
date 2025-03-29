import 'package:get/get.dart';

import '../controllers/feedback_submissions_controller.dart';

class FeedbackSubmissionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedbackSubmissionsController>(
      () => FeedbackSubmissionsController(),
    );
  }
}
