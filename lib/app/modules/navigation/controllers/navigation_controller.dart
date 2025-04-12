import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_cane_app/app/config/dio_config.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class NavigationController extends GetxController {
  final stt.SpeechToText speech = stt.SpeechToText();
  final Dio dio = DioConfig.instance;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  TextEditingController location = TextEditingController();

  var listening = false.obs;
  var currentPosition = LatLng(0, 0).obs;
  var navigationStarted = false.obs;
  var steps = <String>[].obs;
  var totalDistance = ''.obs;
  var totalDuration = ''.obs;
  var savedLocations = <Map<String, dynamic>>[].obs;
  var polylines = <Polyline>[].obs;
  var markers = <Marker>[].obs;
  bool _onDevice = false;

  @override
  void onInit() {
    super.onInit();
    fetchSavedLocations();
  }

  void resultListener(SpeechRecognitionResult result) {
    print(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    location.text=result.recognizedWords;
    print('${result.recognizedWords} - ${result.finalResult}');
  }
  Future<void> handleMicClick() async {
    // Check and request microphone permission
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted) {
        Get.snackbar('Error', 'Microphone permission not granted',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }
    }

    bool available = await speech.initialize(
      onStatus: (status) {
        print('Speech status: $status');
      },
      onError: (error) {
        print('Speech error: $error');
        // Optionally, handle specific error types here
        if (error.toString().contains('error_speech_timeout')) {
          Get.snackbar('Error', 'Speech recognition timed out.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      },
    );

    if (!available) {
      Get.snackbar('Error', 'Speech recognition not available',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    listening.value = true;
    final options = stt.SpeechListenOptions(
        onDevice: _onDevice,
        listenMode: stt.ListenMode.confirmation,
        cancelOnError: true,
        partialResults: true,
        autoPunctuation: true,
        enableHapticFeedback: true);
    speech.listen(
      onResult: resultListener,
      listenFor: Duration(seconds: 30),
      pauseFor: Duration(seconds:  3),
      listenOptions: options,
    );

    // Stop listening after the duration is over
    Future.delayed(const Duration(seconds: 15), () {
      listening.value = false;
      speech.stop();
    });
  }


  Future<void> getDirections() async {
    if (location.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a location',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }
    final permissionStatus = await Permission.location.status;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Location Services Disabled', 'Please enable location services',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    if (!permissionStatus.isGranted) {
      final result = await Permission.location.request();

      if (result.isDenied) {
        Get.snackbar(
          'Permission Required',
          'Location permission is needed to get directions',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (result.isPermanentlyDenied) {
        Get.snackbar(
          'Permission Denied',
          'Please enable location permissions in app settings',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        // Optionally open app settings
        await openAppSettings();
        return;
      }
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentPosition.value = LatLng(position.latitude, position.longitude);
      await fetchRoute();
    } on DioException {
      Get.snackbar('Error', 'Failed to get current location',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> fetchRoute() async {
    try {
      // First, we need to geocode the destination address to get its coordinates
      final geocodeResponse = await dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'address': location.text,
          'key': 'AIzaSyC8HMZ7W3pj64xlKYgxPK8id395G8JQfso', // Replace with your API key
        },
      );

      if (geocodeResponse.data['results'].isEmpty) {
        Get.snackbar('Error', 'Location not found',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      final destinationLocation = geocodeResponse.data['results'][0]['geometry']['location'];
      final destLatLng = LatLng(
        destinationLocation['lat'],
        destinationLocation['lng'],
      );

      // Get directions from Google Directions API
      final directionsResponse = await dio.get(
        'https://maps.googleapis.com/maps/api/directions/json',
        queryParameters: {
          'origin': '36.91634527212171,10.284255709555794',
          'destination': '${destLatLng.latitude},${destLatLng.longitude}',
          'mode': 'walking', // or 'driving', 'bicycling', 'transit'
          'key': 'AIzaSyC8HMZ7W3pj64xlKYgxPK8id395G8JQfso', // Replace with your API key
        },
      );


      if (directionsResponse.data['routes'].isEmpty) {
        Get.snackbar('Error', 'No route found',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      final route = directionsResponse.data['routes'][0];
      final legs = route['legs'][0];

      // Update distance and duration
      totalDistance.value = legs['distance']['text'];
      totalDuration.value = legs['duration']['text'];

      // Parse steps for navigation instructions
      steps.clear();
      for (var step in legs['steps']) {
        steps.add(step['html_instructions']
            .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
            .replaceAll('&nbsp;', ' '));
      }

      // Decode polyline points
      final points = route['overview_polyline']['points'];
      final polylinePoints = PolylinePoints();
      final result = polylinePoints.decodePolyline(points);

      // Create polyline coordinates
      final polylineCoordinates = result
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      // Clear existing polylines and markers
      polylines.clear();
      markers.clear();

      // Add origin and destination markers
      markers.addAll([
        Marker(
          markerId: const MarkerId('origin'),
          position: currentPosition.value,
          infoWindow: const InfoWindow(title: 'Origin'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
        Marker(
          markerId: const MarkerId('destination'),
          position: destLatLng,
          infoWindow: InfoWindow(title: location.text),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      ]);

      // Add the polyline
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: polylineCoordinates,
          color: Colors.blue,
          width: 5,
        ),
      );

      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch route: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
  Future<void> startNavigation() async {
    if (currentPosition.value.latitude == 0 || location.text.isEmpty) {
      Get.snackbar('Error', 'Please get directions first',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    navigationStarted.value = true;

    // Ensure that the destination is valid
    if (markers.isEmpty) {
      Get.snackbar('Error', 'Destination marker not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      final response = await dio.post('/log/create', data: {
        'numberOfObsticles': steps.length.toString(),
        'numberOfSteps': steps.length.toString(),
        'miles': totalDistance.value.split(' ')[0],
        'location': location.text,
      });

      Get.snackbar('Success', 'Navigation started',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);

      final destination = markers.firstWhere((marker) => marker.markerId.value == 'destination').position;

      polylines.add(
        Polyline(
          polylineId: const PolylineId('navigationRoute'),
          points: [
            currentPosition.value,
            destination,
          ],
          color: Colors.blue,
          width: 5,
        ),
      );
      update();

    } on DioException catch (e) {
      if (e.response?.data["message"] != null) {
        Get.snackbar('Error', e.response?.data["message"],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }
      Get.snackbar('Error', 'Error starting navigation',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> saveLocation() async {
    if (location.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a location',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      final response = await dio.post('/location/create', data: {
        'location': location.text,
      });

      savedLocations.add({'location': location.text});
      Get.snackbar('Success', 'Location saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } on DioException catch (e) {
      if (e.response?.data["message"] != null) {
        Get.snackbar('Error', e.response?.data["message"],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }
      Get.snackbar('Error', 'Error saving location',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> sendAlert() async {
    if (location.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a location',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      final response = await dio.post('/log/alert', data: {
        'location': location.text,
      });

      Get.snackbar('Success', 'Alert sent successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } on DioException catch (e) {
      print(e);
      if (e.response?.data["message"] != null) {
        Get.snackbar('Error', e.response?.data["message"],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }
      Get.snackbar('Error', 'Error sending alert',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> fetchSavedLocations() async {
    try {
      final response = await dio.get('/location/get-user');
      savedLocations.assignAll(List<Map<String, dynamic>>.from(response.data['locations']));
    } on DioException catch (e) {
      if (e.response?.data["message"] != null) {
        Get.snackbar('Error', e.response?.data["message"],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }
      Get.snackbar('Error', 'Error fetching saved locations',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}