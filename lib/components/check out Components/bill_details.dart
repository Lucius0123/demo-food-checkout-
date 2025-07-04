
import 'package:flutter/material.dart';

class PaymentSectionWidget extends StatelessWidget {
  final String selectedPaymentMethod;
  final Function(String?) onPaymentChanged;
  final TextEditingController upiController;

  const PaymentSectionWidget({
    super.key,
    required this.selectedPaymentMethod,
    required this.onPaymentChanged,
    required this.upiController,
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
                Icon(Icons.payment, color: Color(0xffB33691)),
                const SizedBox(width: 8),
                const Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            _buildPaymentOption('Google Pay', 'Pay using Google Pay', Icons.account_balance_wallet, Colors.blue),
            _buildPaymentOption('PhonePe', 'Pay using PhonePe', Icons.phone_android, Colors.purple),
            _buildPaymentOption('UPI', 'Pay using UPI ID', Icons.qr_code, Colors.green),
            if (selectedPaymentMethod == 'UPI') _buildUpiIdInput(),
            _buildPaymentOption('COD', 'Cash on Delivery', Icons.money, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String value, String title, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: selectedPaymentMethod == value ? Color(0xffB33691) : Colors.grey[300]!,
          width: selectedPaymentMethod == value ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: selectedPaymentMethod,
        onChanged: onPaymentChanged,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        secondary: Icon(icon, color: color),
        activeColor: Color(0xffB33691),
      ),
    );
  }

  Widget _buildUpiIdInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: TextFormField(
        controller: upiController,
        decoration: InputDecoration(
          labelText: 'Enter UPI ID',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          prefixIcon: const Icon(Icons.alternate_email),
        ),
        validator: (value) {
          if (selectedPaymentMethod == 'UPI' && (value == null || value.isEmpty)) {
            return 'Please enter your UPI ID';
          }
          return null;
        },
      ),
    );
  }
}
