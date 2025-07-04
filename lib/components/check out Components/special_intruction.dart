// special_instructions_widget.dart
import 'package:flutter/material.dart';

class SpecialInstructionsWidget extends StatelessWidget {
  final TextEditingController instructionsController;

  const SpecialInstructionsWidget({
    super.key,
    required this.instructionsController,
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
            Row(
              children: [
                Icon(Icons.note, color: Color(0xffB33691)),
                const SizedBox(width: 8),
                const Text(
                  'Special Instructions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: instructionsController,
              decoration: InputDecoration(
                labelText: 'Any special requests? (Optional)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.edit_note),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}