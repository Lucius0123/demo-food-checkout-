// checkout_page.dart
import 'package:flutter/material.dart';
import 'components/check out Components/address_section.dart';
import 'components/check out Components/bill_details.dart';
import 'components/check out Components/bill_summary.dart';
import 'components/check out Components/cart_summery.dart';
import 'components/check out Components/special_intruction.dart';
import 'delivery_status_page.dart';
import 'firebase_service.dart';
import 'model/food_order.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _phoneController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _upiIdController = TextEditingController();

  String selectedPaymentMethod = 'COD';
  String selectedAddressType = 'Home';
  bool _isLoading = false;

  double get subtotal => cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get deliveryFee => 49.0;
  double get tax => subtotal * 0.05;
  double get total => subtotal + deliveryFee + tax;

  @override
  void initState() {
    super.initState();
    _testFirebaseConnection();
  }

  Future<void> _testFirebaseConnection() async {
    bool isConnected = await FirebaseService.testConnection();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              isConnected ? 'Firebase connected successfully' : 'Firebase not connected - using offline mode'),
          backgroundColor: isConnected ? Colors.green : Color(0xffB33691),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CartSummaryWidget(cartItems: cartItems),
              const SizedBox(height: 20),
              AddressSectionWidget(
                addressController: _addressController,
                landmarkController: _landmarkController,
                phoneController: _phoneController,
                selectedAddressType: selectedAddressType,
                onAddressTypeChanged: (type) => setState(() => selectedAddressType = type),
              ),
              const SizedBox(height: 20),
              PaymentSectionWidget(
                selectedPaymentMethod: selectedPaymentMethod,
                onPaymentChanged: (value) => setState(() => selectedPaymentMethod = value!),
                upiController: _upiIdController,
              ),
              const SizedBox(height: 20),
              SpecialInstructionsWidget(instructionsController: _instructionsController),
              const SizedBox(height: 20),
              BillDetailsWidget(
                subtotal: subtotal,
                deliveryFee: deliveryFee,
                tax: tax,
                total: total,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildPlaceOrderButton(),
    );
  }

  Widget _buildPlaceOrderButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _placeOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xffB33691),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag, color: Colors.white),
            const SizedBox(width: 8),
            Text('Place Order • ₹${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final deliveryAddress = DeliveryAddress(
        fullAddress: _addressController.text.trim(),
        landmark: _landmarkController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        addressType: selectedAddressType,
      );

      final order = FoodOrder(
        id: '',
        items: cartItems,
        deliveryAddress: deliveryAddress,
        paymentMethod: selectedPaymentMethod,
        upiId: selectedPaymentMethod == 'UPI' ? _upiIdController.text.trim() : null,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        tax: tax,
        total: total,
        status: 'placed',
        createdAt: DateTime.now(),
        specialInstructions: _instructionsController.text.trim().isEmpty ? null : _instructionsController.text.trim(),
      );

      final orderId = await FirebaseService.createOrder(order);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DeliveryStatusPage(orderId: orderId, orderData: order.toMap()),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place order: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _landmarkController.dispose();
    _phoneController.dispose();
    _instructionsController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }
}
