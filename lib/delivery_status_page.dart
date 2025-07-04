import 'package:flutter/material.dart';
import 'dart:async';
import 'components/delivery Status Components/current_status_card.dart';
import 'components/delivery Status Components/delivery_info_card.dart';
import 'components/delivery Status Components/order_info_card.dart';
import 'components/delivery Status Components/order_item_card.dart';
import 'components/delivery Status Components/order_timeline.dart';
import 'components/delivery Status Components/progress_tracker card.dart';
import 'firebase_service.dart';

class DeliveryStatusPage extends StatefulWidget {
  final String orderId;
  final Map<String, dynamic> orderData;

  const DeliveryStatusPage({
    super.key,
    required this.orderId,
    required this.orderData,
  });

  @override
  State<DeliveryStatusPage> createState() => _DeliveryStatusPageState();
}

class _DeliveryStatusPageState extends State<DeliveryStatusPage>
    with TickerProviderStateMixin {
  Timer? _statusUpdateTimer;
  String currentStatus = 'placed';
  Map<String, dynamic>? orderData;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<String> statusFlow = [
    'placed',
    'preparing',
    'pickedUp',
    'onTheWay',
    'delivered'
  ];

  final Map<String, Map<String, dynamic>> statusInfo = {
    'placed': {
      'title': 'Order Placed',
      'description': 'Your order has been placed successfully',
      'icon': Icons.check_circle,
      'color': Colors.green,
    },
    'preparing': {
      'title': 'Preparing',
      'description': 'Restaurant is preparing your delicious meal',
      'icon': Icons.restaurant_menu,
      'color': Color(0xffB33691),
    },
    'pickedUp': {
      'title': 'Picked by Delivery Partner',
      'description': 'Your order has been picked up for delivery',
      'icon': Icons.directions_bike,
      'color': Colors.blue,
    },
    'onTheWay': {
      'title': 'On the Way',
      'description': 'Your order is on its way to you',
      'icon': Icons.local_shipping,
      'color': Colors.purple,
    },
    'delivered': {
      'title': 'Delivered',
      'description': 'Your order has been delivered. Enjoy your meal!',
      'icon': Icons.home_filled,
      'color': Colors.green,
    },
  };

  @override
  void initState() {
    super.initState();
    orderData = widget.orderData;
    currentStatus = orderData!['status'] ?? 'placed';

    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    _startStatusUpdates();
  }

  void _startStatusUpdates() {
    _statusUpdateTimer = Timer.periodic(const Duration(seconds: 12), (timer) {
      if (currentStatus != 'delivered') {
        _updateToNextStatus();
      } else {
        timer.cancel();
        _pulseController.stop();
      }
    });
  }

  void _updateToNextStatus() {
    final currentIndex = statusFlow.indexOf(currentStatus);
    if (currentIndex < statusFlow.length - 1) {
      final nextStatus = statusFlow[currentIndex + 1];
      setState(() {
        currentStatus = nextStatus;
        orderData!['status'] = nextStatus;
      });

      FirebaseService.updateOrderStatus(widget.orderId, nextStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusData = statusInfo[currentStatus]!;
    final currentIndex = statusFlow.indexOf(currentStatus);
    final progress = (currentIndex + 1) / statusFlow.length;
    final items = orderData!['items'] as List<dynamic>;
    final address = orderData!['deliveryAddress'];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Order Status', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (currentStatus == 'placed') _buildSuccessHeader(),
            if (currentStatus == 'placed') const SizedBox(height: 20),
            OrderInfoCard(orderId: widget.orderId, total: orderData!['total']),
            const SizedBox(height: 20),
            CurrentStatusCard(
              statusData: statusData,
              pulseAnimation: _pulseAnimation,
              isDelivered: currentStatus == 'delivered',
            ),
            const SizedBox(height: 20),
            ProgressTrackerCard(progress: progress),
            const SizedBox(height: 20),
            OrderTimelineCard(
              statusFlow: statusFlow,
              currentStatus: currentStatus,
              statusInfo: statusInfo,
            ),
            const SizedBox(height: 20),
            OrderItemsCard(items: items),
            const SizedBox(height: 20),
            DeliveryInfoCard(address: address),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildSuccessHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'Order Placed Successfully!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              'Your order #${widget.orderId.substring(0, 8).toUpperCase()} has been confirmed',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
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
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: const Icon(Icons.home),
              label: const Text('Continue Shopping'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: Color(0xffB33691)),
                foregroundColor: const Color(0xffB33691),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _showTrackingOptions,
              icon: const Icon(Icons.track_changes),
              label: const Text('Track Order'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffB33691),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTrackingOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Track Your Order', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.phone, color: Color(0xffB33691)),
              title: const Text('Call Restaurant'),
              subtitle: const Text('Get updates directly from restaurant'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: Color(0xffB33691)),
              title: const Text('Chat with Support'),
              subtitle: const Text('Get help from our support team'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: Color(0xffB33691)),
              title: const Text('Live Tracking'),
              subtitle: const Text('Track delivery partner location'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _statusUpdateTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }
}
