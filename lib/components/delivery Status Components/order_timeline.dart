import 'package:flutter/material.dart';

class OrderTimelineCard extends StatelessWidget {
  final List<String> statusFlow;
  final String currentStatus;
  final Map<String, Map<String, dynamic>> statusInfo;

  const OrderTimelineCard({
    super.key,
    required this.statusFlow,
    required this.currentStatus,
    required this.statusInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order Timeline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...statusFlow.asMap().entries.map((entry) {
              final index = entry.key;
              final status = entry.value;
              final statusData = statusInfo[status]!;
              final currentIndex = statusFlow.indexOf(currentStatus);
              final isCompleted = index <= currentIndex;
              final isCurrent = index == currentIndex;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isCompleted ? statusData['color'] : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isCompleted ? Icons.check : statusData['icon'],
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        if (index < statusFlow.length - 1)
                          Container(
                            width: 3,
                            height: 50,
                            color: isCompleted ? statusData['color'] : Colors.grey[300],
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isCurrent ? statusData['color'].withOpacity(0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: isCurrent ? Border.all(color: statusData['color'], width: 2) : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              statusData['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                                color: isCurrent ? statusData['color'] : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              statusData['description'],
                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
