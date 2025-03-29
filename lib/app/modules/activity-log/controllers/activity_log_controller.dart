import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:smart_cane_app/app/config/dio_config.dart';

class ActivityLogController extends GetxController {
  final Dio dio = DioConfig.instance;
  bool isLoading = false;
  var logs = [].obs;
  var user = Rx<Map<String, dynamic>?>(null);
  var groupedLogs = <String, Map<String, dynamic>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final userId = Get.parameters['userId'] ?? Get.arguments['userId'];
    fetchUserData(userId);
    fetchLogs(userId);
  }

  Future<void> fetchUserData(String userId) async {
    try {
      isLoading=true;
      update();
      final response = await dio.get('/user/get-one/$userId');
      user.value = response.data['user'];
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to fetch user data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading=false;
      update();
    }
  }

  Future<void> fetchLogs(String userId) async {
    try {
      isLoading=true;
      update();
      final response = await dio.get('/admin/get-user-logs/$userId');
      logs.assignAll(response.data['logs']);
      groupLogsByDate();
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to fetch logs',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading=false;
      update();
    }
  }

  void groupLogsByDate() {
    final grouped = <String, Map<String, dynamic>>{};
    for (var log in logs) {
      final date = DateFormat.yMd().format(DateTime.parse(log['createdAt']));
      if (!grouped.containsKey(date)) {
        grouped[date] = {'logs': [], 'totalDistance': 0.0};
      }
      grouped[date]!['logs'].add(log);
      grouped[date]!['totalDistance'] += log['miles'] ?? 0.0;
    }
    groupedLogs.value = grouped;
  }
}