import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/feedback_submissions_controller.dart';

class FeedbackSubmissionsView extends GetView<FeedbackSubmissionsController> {
  const FeedbackSubmissionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedbackSubmissionsController>(builder: (controller){
      return Scaffold(
        appBar: AppBar(
          title: const Text('Feedback Submissions'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Feedback Submissions',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text('Feedback List:'),
              const SizedBox(height: 10),
              Expanded(
                  child: controller.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListView.builder(
                      itemCount: controller.feedbacks.length,
                      itemBuilder: (context, index) {
                        final feedback = controller.feedbacks[index];
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${DateFormat.yMd().add_jm().format(DateTime.parse(feedback['createdAt']))} | '
                                      '${feedback['userId']?['firstName']} ${feedback['userId']?['lastName']} : '
                                      '${feedback['thoughts']}',
                                ),
                              ),
                              GestureDetector(
                                onTap: () => controller
                                    .showFeedbackDetails(feedback),
                                child: const Text(
                                  '[view]',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )),
            ],
          ),
        ),
      );
    });
  }
}
