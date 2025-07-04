class CartItem {
  final String id;
  final String name;
  final String restaurant;
  final double price;
  int quantity; // Remove final to make it mutable

  CartItem({
    required this.id,
    required this.name,
    required this.restaurant,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'restaurant': restaurant,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      restaurant: map['restaurant'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 1,
    );
  }

  // Calculate total price for this item
  double get totalPrice => price * quantity;
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
      addressType: map['addressType'] ?? 'Home',
    );
  }
}

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
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      deliveryFee: (map['deliveryFee'] ?? 0).toDouble(),
      tax: (map['tax'] ?? 0).toDouble(),
      total: (map['total'] ?? 0).toDouble(),
      status: map['status'] ?? 'placed',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      specialInstructions: map['specialInstructions'],
    );
  }
}
final List<CartItem> cartItems = [
  CartItem(
    id: '1',
    name: 'Chicken Biryani',
    restaurant: 'Spice Paradise',
    price: 299.0,
    quantity: 2,
  ),
  CartItem(
    id: '2',
    name: 'Paneer Butter Masala',
    restaurant: 'Curry House',
    price: 249.0,
    quantity: 1,
  ),
  CartItem(
    id: '3',
    name: 'Garlic Naan',
    restaurant: 'Curry House',
    price: 89.0,
    quantity: 3,
  ),
];