import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:smart_cane_app/app/config/dio_config.dart';

class AlertLogController extends GetxController {
  final Dio dio = DioConfig.instance;
  bool isLoading = false;
  var alerts = [].obs;
  var user = Rx<Map<String, dynamic>?>(null);
  var groupedAlerts = <String, List<dynamic>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final userId = Get.parameters['userId'] ?? Get.arguments['userId'];
    fetchUserData(userId);
    fetchAlerts(userId);
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

  Future<void> fetchAlerts(String userId) async {
    try {
      isLoading=true;
      update();
      final response = await dio.get('/admin/get-user-alerts/$userId');
      alerts.assignAll(response.data['alerts']);
      groupAlertsByDate();
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to fetch alerts',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading=false;
      update();
    }
  }

  void groupAlertsByDate() {
    final grouped = <String, List<dynamic>>{};
    for (var alert in alerts) {
      final date = DateFormat.yMd().format(DateTime.parse(alert['createdAt']));
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(alert);
    }
    groupedAlerts.value = grouped;
  }
}