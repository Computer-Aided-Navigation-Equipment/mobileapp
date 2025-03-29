import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/manage_users_controller.dart';

class ManageUsersView extends GetView<ManageUsersController> {
  const ManageUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        centerTitle: true,
      ),
      body: GetBuilder<ManageUsersController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Manage Users',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // User Info Cards
                Row(
                  children: [
                    // First Card
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Users information'),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD9D9D9).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Users: 296'),
                                Text('Active Users: 237'),
                                Text('Alerts: 72'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Second Card
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Users information'),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD9D9D9).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildBulletPoint('John Registered'),
                                _buildBulletPoint(
                                    'Andy sent an alert to caregiver'),
                                _buildBulletPoint('Caregiver called Andy'),
                                _buildBulletPoint('Andy detected 10 obstacles'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // User Search Dropdown
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    controller.searchUsers(textEditingValue.text);
                    return controller.users.map((user) =>
                        '${user['firstName']} ${user['lastName']} - ${user['phoneNumber']}');
                  },
                  onSelected: (String selection) {
                    final selected = controller.users.firstWhere((user) =>
                        '${user['firstName']} ${user['lastName']} - ${user['phoneNumber']}' ==
                        selection);
                    controller.setSelectedUser(selected['_id']);
                  },
                  fieldViewBuilder:
                      (context, controller, focusNode, onFieldSubmitted) {
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      onFieldSubmitted: (value) => onFieldSubmitted(),
                      decoration: const InputDecoration(
                        labelText: 'Select a user',
                        border: OutlineInputBorder(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Action Buttons
                if (controller.selectedUser != null)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(
                              '/activity-log/${controller.selectedUser}',
                              arguments: {
                                'userId': controller.selectedUser
                              }, // Pass the user ID as arguments
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4BB9B3),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('User Activity log'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(
                              '/alert-log/${controller.selectedUser}',
                              arguments: {
                                'userId': controller.selectedUser
                              }, // Pass the user ID as arguments
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4BB9B3),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('User Alerts'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
