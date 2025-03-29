import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../controllers/feedback_controller.dart';

class FeedbackView extends GetView<FeedbackController> {
  const FeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Feedback',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            GetBuilder<FeedbackController>(
              builder: (controller) {
                return Form(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'How would you rate the Smart Cane',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                RatingBar.builder(
                                  initialRating: controller.rating.toDouble(),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: 30,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    controller.updateRating(rating.toInt());
                                  },
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Please share your thoughts',
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 5,
                                  onChanged: controller.updateThoughts,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          // Right Column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Did you encounter any issues?',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                SegmentedButton(
                                  segments: const [
                                    ButtonSegment(
                                      value: true,
                                      label: Text('Yes'),
                                    ),
                                    ButtonSegment(
                                      value: false,
                                      label: Text('No'),
                                    ),
                                  ],
                                  selected: {controller.hasIssues},
                                  onSelectionChanged: (newSelection) {
                                    controller.toggleIssues(newSelection.first);
                                  },
                                ),
                                const SizedBox(height: 20),
                                Visibility(
                                  visible: controller.hasIssues,
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'If yes, describe the issues',
                                      border: OutlineInputBorder(),
                                    ),
                                    maxLines: 3,
                                    onChanged: controller.updateIssuesDescription,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Suggestions for improvement',
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 3,
                                  onChanged: controller.updateSuggestions,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      GetBuilder<FeedbackController>(
                        builder: (controller) {
                          return ElevatedButton(
                            onPressed: controller.isLoading
                                ? null
                                : () {
                              if (controller.validateForm()) {
                                controller.submitFeedback();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4BB9B3),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: controller.isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                              'Submit',
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}