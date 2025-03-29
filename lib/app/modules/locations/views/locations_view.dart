import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/locations_controller.dart';

class LocationsView extends GetView<LocationsController> {
  const LocationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationsController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Saved Locations'),
            centerTitle: true,
            actions: [
              GestureDetector(
                onTap: () {
                  Get.toNamed('/profile');
                },
                child: const CircleAvatar(
                  backgroundColor: Color(0xFF4BB9B3),
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header and Edit section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Locations',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        // Edit functionality
                      },
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Locations List
                if (controller.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: controller.locations.length,
                      itemBuilder: (context, index) {
                        final location = controller.locations[index];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                location['title'] ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(location['location'] ?? ''),
                              const Spacer(),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  controller.distances[location['id']] ?? 'Calculating...',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: controller.openAddLocationDialog,
            backgroundColor: const Color(0xFF4BB9B3),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }
}