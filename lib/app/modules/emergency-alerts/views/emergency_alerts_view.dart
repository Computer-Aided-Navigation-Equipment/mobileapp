import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/emergency_alerts_controller.dart';

class EmergencyAlertsView extends GetView<EmergencyAlertsController> {
  const EmergencyAlertsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EmergencyAlertsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EmergencyAlertsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
