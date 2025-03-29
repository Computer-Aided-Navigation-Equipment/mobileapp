import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/alert_log_controller.dart';

class AlertLogView extends GetView<AlertLogController> {
  const AlertLogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Activity Alerts'),
        centerTitle: true,
      ),
      body: GetBuilder<AlertLogController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'User Activity Alerts',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // User Info
                if (controller.user.value != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('User Name:'),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          '${controller.user.value?['firstName']} ${controller.user.value?['lastName']} : ${controller.user.value?['email']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),

                // Grouped Alerts
                if (controller.groupedAlerts.isNotEmpty)
                  ...controller.groupedAlerts.entries.map((entry) {
                    final date = entry.key;
                    final alerts = entry.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...alerts.map((alert) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 32, bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• '),
                                Expanded(
                                  child: Text(
                                    '${DateFormat.jm().format(DateTime.parse(alert['createdAt']))} | '
                                        '${controller.user.value?['firstName']} '
                                        '${controller.user.value?['lastName']} sent an alert at '
                                        '${alert['location']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}