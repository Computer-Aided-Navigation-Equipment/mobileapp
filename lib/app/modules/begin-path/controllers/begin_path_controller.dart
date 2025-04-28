import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_cane_app/app/config/dio_config.dart';

class BeginPathController extends GetxController {
  final Dio dio = DioConfig.instance;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  var steps = <String>[].obs;
  var totalDistance = ''.obs;
  var totalDuration = ''.obs;
  var currentPosition = LatLng(0, 0).obs;
  var isLoading = false;
  var polylines = <Polyline>[].obs;

  @override
  void onInit() {
    super.onInit();

      getDetailedDirections("Bahrain");

  }
  Future<void> getDetailedDirections(String destination) async {
    isLoading=true;
    update();
    try {
      final response = await dio.get(
        'https://maps.googleapis.com/maps/api/directions/json',
        queryParameters: {
          'origin': '36.91634527212171,10.284255709555794',
          'destination': destination,
          'key': 'AIzaSyC8HMZ7W3pj64xlKYgxPK8id395G8JQfso',
          'mode': 'walking',
        },
      );

      print(response.data);

      if (response.data['status'] == 'OK') {
        final route = response.data['routes'][0];
        final leg = route['legs'][0];



        for (var step in leg['steps']) {
          steps.add(step['html_instructions']
              .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
              .replaceAll('&nbsp;', ' '));
        }

        totalDistance.value = leg['distance']['text'];
        totalDuration.value = leg['duration']['text'];
      }
    } catch (e) {
      // Handle error
    } finally {
      isLoading = false;
      update();
    }
  }
}