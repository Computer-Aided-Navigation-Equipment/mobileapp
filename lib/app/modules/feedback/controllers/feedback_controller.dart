import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:smart_cane_app/app/config/dio_config.dart';

class FeedbackController extends GetxController {
  final Dio dio = DioConfig.instance;

  int rating = 2;
  String thoughts = '';
  bool hasIssues = false;
  String issuesDescription = '';
  String suggestions = '';
  bool isLoading = false;

  void updateRating(int newRating) {
    rating = newRating;
    update();
  }

  void updateThoughts(String newThoughts) {
    thoughts = newThoughts;
    update();
  }

  void toggleIssues(bool newValue) {
    hasIssues = newValue;
    update();
  }

  void updateIssuesDescription(String newDescription) {
    issuesDescription = newDescription;
    update();
  }

  void updateSuggestions(String newSuggestions) {
    suggestions = newSuggestions;
    update();
  }

  Future<void> submitFeedback() async {
    try {
      isLoading = true;
      update();

      final response = await dio.post('/feedback/create', data: {
        'rating': rating,
        'thoughts': thoughts,
        'issues': hasIssues ? 'Yes' : 'No',
        'issuesDescription': issuesDescription,
        'suggestions': suggestions,
      });

      Get.snackbar(
        'Success',
        'Feedback submitted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Reset form
      rating = 2;
      thoughts = '';
      hasIssues = false;
      issuesDescription = '';
      suggestions = '';
      update();
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to submit feedback',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  bool validateForm() {
    if (rating == 0) {
      Get.snackbar('Error', 'Rating is required');
      return false;
    }
    if (thoughts.isEmpty) {
      Get.snackbar('Error', 'Thoughts are required');
      return false;
    }
    if (hasIssues && issuesDescription.isEmpty) {
      Get.snackbar('Error', 'Issues description is required');
      return false;
    }
    if (suggestions.isEmpty) {
      Get.snackbar('Error', 'Suggestions are required');
      return false;
    }
    return true;
  }
}