import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:smart_cane_app/app/config/dio_config.dart';

class FeedbackSubmissionsController extends GetxController {
  final Dio dio = DioConfig.instance;

  var feedbacks =[];
  var selectedFeedback = Rxn<dynamic>();
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    fetchFeedbacks();
  }

  Future<void> fetchFeedbacks() async {
    try {
      isLoading=true;
      update();
      final response = await dio.get('/feedback/get-all');
      feedbacks.assignAll(response.data['feedbacks']);
      if (feedbacks.isEmpty) {
        Get.snackbar(
          'No Feedbacks',
          'No feedbacks available',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.yellow,
          colorText: Colors.black,
        );
      }

    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to fetch feedbacks',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading=false;
      update();
    }
  }

  void showFeedbackDetails(dynamic feedback) {
    selectedFeedback.value = feedback;
    Get.dialog(
      AlertDialog(
        title: const Text('Feedback Details'),
        content: SingleChildScrollView(
          child: GetBuilder<FeedbackSubmissionsController>(builder: (controller){
            final feedback = selectedFeedback.value;
            if (feedback == null) return const SizedBox();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Date: ${DateFormat.yMd().add_jm().format(DateTime.parse(feedback['createdAt']))}'),
                const SizedBox(height: 10),
                Text('User: ${feedback['userId']['firstName']} ${feedback['userId']['lastName']}'),
                const SizedBox(height: 10),
                Text('Thoughts: ${feedback['thoughts']}'),
                const SizedBox(height: 10),
                Text('Suggestions: ${feedback['suggestions']}'),
                const SizedBox(height: 10),
                Text('Issues: ${feedback['issues']}'),
                const SizedBox(height: 10),
                Text('Issues Description: ${feedback['issuesDescription']}'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Rating: '),
                    RatingBar.builder(
                      initialRating: feedback['rating']?.toDouble() ?? 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                      ignoreGestures: true,
                    ),
                  ],
                ),
              ],
            );
          })
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}