import 'package:flutter/material.dart';

class ProgressTrackerCard extends StatelessWidget {
  final double progress;

  const ProgressTrackerCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Order Progress', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${(progress * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffB33691)),
              minHeight: 8,
            ),
          ],
        ),
      ),
    );
  }
}
