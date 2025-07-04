// address_section_widget.dart
import 'package:flutter/material.dart';

class AddressSectionWidget extends StatelessWidget {
  final TextEditingController addressController;
  final TextEditingController landmarkController;
  final TextEditingController phoneController;
  final String selectedAddressType;
  final Function(String) onAddressTypeChanged;

  const AddressSectionWidget({
    super.key,
    required this.addressController,
    required this.landmarkController,
    required this.phoneController,
    required this.selectedAddressType,
    required this.onAddressTypeChanged,
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
                Icon(Icons.location_on, color: Color(0xffB33691)),
                const SizedBox(width: 8),
                const Text('Delivery Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Full Address *',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.home),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Please enter your address' : null,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: landmarkController,
              decoration: InputDecoration(
                labelText: 'Landmark (Optional)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.place),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number *',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter your phone number';
                if (value.length < 10) return 'Please enter a valid phone number';
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text('Address Type:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildAddressTypeChip('Home', Icons.home),
                const SizedBox(width: 8),
                _buildAddressTypeChip('Office', Icons.business),
                const SizedBox(width: 8),
                _buildAddressTypeChip('Other', Icons.location_on),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressTypeChip(String type, IconData icon) {
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 16), const SizedBox(width: 4), Text(type)],
      ),
      selected: selectedAddressType == type,
      onSelected: (selected) => selected ? onAddressTypeChanged(type) : null,
      selectedColor: Color(0xffB33691),
    );
  }
}