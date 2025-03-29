import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/navigation_controller.dart';

class NavigationView extends GetView<NavigationController> {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<NavigationController>(
        builder: (controller) {
          return Column(
            children: [
              // Header Section
              Container(
                height: 170,
                width: double.infinity,
                color: const Color(0xFF4BB9B3).withOpacity(0.07),
                child: const Center(
                  child: Text(
                    'Navigation',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Location Input
                      SizedBox(
                        width: 300,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            TextFormField(
                              controller: controller.location,
                              decoration: InputDecoration(
                                hintText: 'Write/Say location',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.mic,
                                color: controller.listening.value ? Colors.red : Colors.grey,
                              ),
                              onPressed: controller.handleMicClick,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Saved Locations and Buttons Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Saved Locations
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Saved Locations:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: controller.savedLocations.map((location) {
                                    return ElevatedButton(
                                      onPressed: () {
                                        controller.location = location['location'];
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF4BB9B3),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text(location['location']),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          // Action Buttons
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: controller.getDirections,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4BB9B3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: const Size(120, 48),
                                ),
                                child: const Text('Get Directions'),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: controller.startNavigation,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4BB9B3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: const Size(120, 48),
                                ),
                                child: const Text('Start'),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Directions and Map Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              // Google Map
                              Container(
                                height: 400,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                      target: controller.currentPosition.value,
                                      zoom: 14,
                                    ),
                                    markers: Set<Marker>.of(controller.markers),
                                    polylines: Set<Polyline>.of(controller.polylines),
                                    myLocationEnabled: true,
                                    myLocationButtonEnabled: true,
                                    onMapCreated: (GoogleMapController mapController) {
                                      // You might want to keep a reference to the map controller
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              // Save and Alert Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: controller.saveLocation,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF4BB9B3),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                      ),
                                      child: const Text('Save Location'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: controller.sendAlert,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF4BB9B3),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                      ),
                                      child: const Text('Send Alert'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Directions List
                          if (controller.steps.isNotEmpty) ...[
                             Container(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Directions:',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text('From: Your current location'),
                                    Text('To: ${controller.location.text}'),
                                    const SizedBox(height: 16),
                                    ...controller.steps.map((step) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('• '),
                                          Expanded(child: Text(step)),
                                        ],
                                      ),
                                    )).toList(),
                                    const SizedBox(height: 16),
                                    Text('Total Distance: ${controller.totalDistance}'),
                                    Text('Total Duration: ${controller.totalDuration}'),
                                  ],
                                ),
                              ),

                            const SizedBox(width: 10),
                          ],

                          // Map and Bottom Buttons

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}