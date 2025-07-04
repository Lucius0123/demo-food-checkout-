import 'package:flutter/material.dart';
import '../../model/food_order.dart';

class CartSummaryWidget extends StatelessWidget {
  final List<CartItem> cartItems;

  const CartSummaryWidget({super.key, required this.cartItems});

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
                Icon(Icons.shopping_cart, color: Color(0xffB33691)),
                const SizedBox(width: 8),
                const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            ...cartItems.map((item) => _buildCartItem(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.orange[100],
            ),
            child: Icon(Icons.fastfood, color: Color(0xffB33691)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                Text(item.restaurant, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                Text('₹${item.price.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xffB33691))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffB33691)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text('Qty: ${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}