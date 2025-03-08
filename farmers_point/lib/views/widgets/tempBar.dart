import 'package:cropunity/controller/plantController.dart';
import 'package:flutter/material.dart';

class TempBar extends StatelessWidget {
  final PlantController controller;
  const TempBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('${controller.tooLowTemp}°'),
        const SizedBox(width: 10,),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              final totalRange = controller.tooHighTemp - controller.tooLowTemp;

              // Calculate the position and width of the optimal range in pixels
              final optimalStartPercentage = (controller.optimalMin - controller.tooLowTemp) / totalRange;
              final optimalEndPercentage = (controller.optimalMax - controller.tooLowTemp) / totalRange;
              final currentTempPercentage = (controller.currentTemp - controller.tooLowTemp) / totalRange;

              final optimalStart = optimalStartPercentage * availableWidth;
              final optimalWidth = (optimalEndPercentage - optimalStartPercentage) * availableWidth;
              final currentTempPosition = currentTempPercentage * availableWidth;

              return Stack(
                children: [
                  // Background bar (unfilled)
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Optimal range (yellow highlight)
                  Positioned(
                    left: optimalStart,
                    width: optimalWidth,
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFCC00),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  // Current temperature dot
                  Positioned(
                    left: currentTempPosition - 10, // Centering the dot
                    child: Container(
                      height: 10,
                      width:10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 10,),
        Text('${controller.tooHighTemp}°'),
      ],
    );
  }
}
