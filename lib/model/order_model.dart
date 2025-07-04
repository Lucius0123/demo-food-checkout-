import 'food_order.dart';

class FoodOrder {
  final String id;
  final List<CartItem> items;
  final DeliveryAddress deliveryAddress;
  final String paymentMethod;
  final String? upiId;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final String status;
  final DateTime createdAt;
  final String? specialInstructions;

  FoodOrder({
    required this.id,
    required this.items,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.upiId,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.status,
    required this.createdAt,
    this.specialInstructions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((item) => item.toMap()).toList(),
      'deliveryAddress': deliveryAddress.toMap(),
      'paymentMethod': paymentMethod,
      'upiId': upiId,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'tax': tax,
      'total': total,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'specialInstructions': specialInstructions,
    };
  }

  factory FoodOrder.fromMap(Map<String, dynamic> map) {
    return FoodOrder(
      id: map['id'] ?? '',
      items: (map['items'] as List<dynamic>?)
          ?.map((item) => CartItem.fromMap(item as Map<String, dynamic>))
          .toList() ?? [],
      deliveryAddress: DeliveryAddress.fromMap(map['deliveryAddress'] as Map<String, dynamic>),
      paymentMethod: map['paymentMethod'] ?? '',
      upiId: map['upiId'],
      subtotal: map['subtotal']?.toDouble() ?? 0.0,
      deliveryFee: map['deliveryFee']?.toDouble() ?? 0.0,
      tax: map['tax']?.toDouble() ?? 0.0,
      total: map['total']?.toDouble() ?? 0.0,
      status: map['status'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      specialInstructions: map['specialInstructions'],
    );
  }
}

class DeliveryAddress {
  final String fullAddress;
  final String landmark;
  final String phoneNumber;
  final String addressType;

  DeliveryAddress({
    required this.fullAddress,
    required this.landmark,
    required this.phoneNumber,
    required this.addressType,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullAddress': fullAddress,
      'landmark': landmark,
      'phoneNumber': phoneNumber,
      'addressType': addressType,
    };
  }

  factory DeliveryAddress.fromMap(Map<String, dynamic> map) {
    return DeliveryAddress(
      fullAddress: map['fullAddress'] ?? '',
      landmark: map['landmark'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      addressType: map['addressType'] ?? '',
    );
  }
}
