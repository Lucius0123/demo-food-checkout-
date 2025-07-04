import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/food_order.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String ordersCollection = 'food_orders';

  static Future<String> createOrder(FoodOrder order) async {
    try {
      print('Creating order in Firebase...');

      // Create the order document
      DocumentReference docRef = await _firestore
          .collection(ordersCollection)
          .add(order.toMap());

      print('Order created with ID: ${docRef.id}');

      // Update the order with the generated ID
      await docRef.update({'id': docRef.id});

      print('Order ID updated successfully');
      return docRef.id;
    } catch (e) {
      print('Error creating order in Firebase: $e');
      // Return a mock ID for testing without Firebase
      String mockId = 'order_${DateTime.now().millisecondsSinceEpoch}';
      print('Using mock order ID: $mockId');
      return mockId;
    }
  }

  static Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      print('Updating order status: $orderId -> $status');

      await _firestore
          .collection(ordersCollection)
          .doc(orderId)
          .update({
        'status': status,
        'lastUpdated': DateTime.now().toIso8601String(),
      });

      print('Order status updated successfully');
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  static Stream<DocumentSnapshot> getOrderStream(String orderId) {
    try {
      print('Getting order stream for: $orderId');
      return _firestore
          .collection(ordersCollection)
          .doc(orderId)
          .snapshots();
    } catch (e) {
      print('Error getting order stream: $e');
      // Return empty stream for testing
      return const Stream.empty();
    }
  }

  static Future<Map<String, dynamic>?> getOrder(String orderId) async {
    try {
      print('Getting order: $orderId');

      DocumentSnapshot doc = await _firestore
          .collection(ordersCollection)
          .doc(orderId)
          .get();

      if (doc.exists) {
        print('Order found');
        return doc.data() as Map<String, dynamic>;
      } else {
        print('Order not found');
        return null;
      }
    } catch (e) {
      print('Error getting order: $e');
      return null;
    }
  }

  // Test Firebase connection
  static Future<bool> testConnection() async {
    try {
      await _firestore.collection('test').doc('connection').set({
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'connected'
      });
      print('Firebase connection test successful');
      return true;
    } catch (e) {
      print('Firebase connection test failed: $e');
      return false;
    }
  }
}