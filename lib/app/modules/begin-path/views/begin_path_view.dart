import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/begin_path_controller.dart';

class BeginPathView extends GetView<BeginPathController> {
  const BeginPathView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BeginPathController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Begin Path'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Begin path',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Path Information
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Path Steps
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Path Location',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          if (controller.steps.isEmpty)
                            const Text('Loading directions...')
                          else
                            Column(
                              children: controller.steps.map((step) {
                                // Determine the direction image
                                String direction = '';
                                Widget directionImage = Container();

                                if (step.toLowerCase().contains('left')) {
                                  direction = 'left';
                                  directionImage = Image.asset('assets/images/arrow-left.png', width: 24, height: 24);
                                } else if (step.toLowerCase().contains('right')) {
                                  direction = 'right';
                                  directionImage = Image.asset('assets/images/arrow-right.png', width: 24, height: 24);
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF4BB9B3).withOpacity(0.9),
                                          shape: BoxShape.circle,
                                        ),
                                        child: directionImage,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          step,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total distance: ${controller.totalDistance}'),
                              Text('Total duration: ${controller.totalDuration}'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 20),

                    // Detected Obstacles
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Detected Obstacles',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: [
                              'Pothole',
                              'Construction',
                              'Roadblock',
                              'Traffic Jam',
                              'Accident',
                            ].map((obstacle) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4BB9B3).withOpacity(0.9),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      obstacle,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
