import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_cane_app/app/config/dio_config.dart';

class LocationsController extends GetxController {
  final Dio dio = DioConfig.instance;
  final FlutterSecureStorage storage = const FlutterSecureStorage();


  TextEditingController title = TextEditingController();
  TextEditingController location = TextEditingController();
  var locations = <Map<String, dynamic>>[].obs;
  var isLoading = false;
  var distances = <String, String>{}.obs;
  var currentPosition = LatLng(0, 0).obs;

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
  }

  Future<void> fetchLocations() async {
    try {
      isLoading=true;
      update();
      final response = await dio.get('/location/get-user');
      locations.assignAll(List<Map<String, dynamic>>.from(response.data['locations']));
      await getCurrentLocation();
    } on DioException catch (e) {
      Get.snackbar('Error', e.response?.data['message'] ?? 'Failed to fetch locations',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading=false;
      update();
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      currentPosition.value = LatLng(position.latitude, position.longitude);
      calculateDistances();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> calculateDistances() async {
    try {
      // This is a simplified version - you'll need to implement actual distance calculation
      // using Google Maps Distance Matrix API or similar
      for (var location in locations) {
        // Simulate distance calculation
        distances[location['id']] = '${5 + locations.indexOf(location)} km';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to calculate distances',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  void openAddLocationDialog() {
    Get.defaultDialog(
      title: 'Add Location',
      content: Form(
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: title,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
            ),
            TextFormField(
              controller: location,
              decoration: const InputDecoration(labelText: 'Location'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Location is required';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          await addLocation();
        },
        child: const Text('Add Location'),
      ),
    );
  }

  Future<void> addLocation() async {
    try {
      // You'll need to get the values from your form
      final response = await dio.post('/location/create', data: {
        'title': title.text, // Replace with form values
        'location':location.text,  // Replace with form values
      });

      Get.snackbar('Success', 'Location added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
      await fetchLocations();
      Get.back();
    } on DioException catch (e) {
      Get.snackbar('Error', e.response?.data['message'] ?? 'Failed to add location',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}