import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_cane_app/app/config/dio_config.dart';

class ContactsController extends GetxController {
  final Dio dio = DioConfig.instance;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  var contacts = <Map<String, dynamic>>[];
  var users = <Map<String, dynamic>>[];
  var isLoading = false;
  var selectedUser="";

  @override
  void onInit() {
    super.onInit();
    fetchContacts();
    fetchUsers();
  }

  Future<void> fetchContacts() async {
    try {
      isLoading=true;
      update();

      final response = await dio.get('/contact/get-user');
      contacts.assignAll(List<Map<String, dynamic>>.from(response.data['contacts']));
      print(response.data["contacts"]);
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to fetch contacts',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      print("finally");
      isLoading=false;
      update();
    }
  }

  Future<void> fetchUsers() async {
    try {
      final response = await dio.get('/user/get-all');
      users.assignAll(List<Map<String, dynamic>>.from(response.data['users']));
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to fetch users',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void openAddContactDialog() {
    Get.defaultDialog(
      title: 'Add Contact',
      content: Column(
        children: [
          DropdownButtonFormField<String>(
            items: users.map((user) {
              return DropdownMenuItem<String>(
                value: user['_id'],
                child: Text('${user['firstName']} ${user['lastName']} - ${user['phoneNumber']}'),
              );
            }).toList(),
            onChanged: (value) {
              print(value);
              selectedUser = value!;
            },
            decoration: const InputDecoration(
              labelText: 'Select a user',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await addContact();
              Get.back();
            },
            child: const Text('Add Contact'),
          ),
        ],
      ),
    );
  }

  Future<void> addContact() async {
    try {
      // You'll need to get the selected contact ID from your form
      print("added");
      print(selectedUser);
      final response = await dio.post('/contact/create', data: {
        'contactId': selectedUser,
      });

      print("added");
      Get.snackbar(
        'Success',
        'Contact added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await fetchContacts();
    } on DioException catch (e) {
      print("error");
      print(e.response);
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to add contact',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}