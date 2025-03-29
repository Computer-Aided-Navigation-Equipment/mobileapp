import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/feedback_controller.dart';

class FeedbackView extends GetView<FeedbackController> {
  const FeedbackView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FeedbackView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'FeedbackView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
