import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_cane_app/app/config/dio_config.dart';

class ManageUsersController extends GetxController {
  final Dio dio = DioConfig.instance;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  var users = <Map<String, dynamic>>[].obs;
  String? selectedUser;

  Future<void> searchUsers(String query) async {
    try {
      final response = await dio.post('/user/search', data: {'search': query});
      users.assignAll(List<Map<String, dynamic>>.from(response.data['users']));
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to search users',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void setSelectedUser(String userId) {
    selectedUser = userId;
    update();
  }
}