import 'package:flutter/material.dart';

class CurrentStatusCard extends StatelessWidget {
  final Map<String, dynamic> statusData;
  final Animation<double> pulseAnimation;
  final bool isDelivered;

  const CurrentStatusCard({
    super.key,
    required this.statusData,
    required this.pulseAnimation,
    required this.isDelivered,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: statusData['color'].withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AnimatedBuilder(
              animation: pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: isDelivered ? 1.0 : pulseAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: statusData['color'],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(statusData['icon'], color: Colors.white, size: 40),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              statusData['title'],
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: statusData['color']),
            ),
            const SizedBox(height: 8),
            Text(
              statusData['description'],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
