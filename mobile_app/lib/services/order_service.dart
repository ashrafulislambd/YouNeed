import 'package:flutter/foundation.dart';
import '../models/payment.dart';

/// Singleton service that stores placed orders as Payment objects.
/// Shared between BNPL confirmation and Due Payment Dashboard.
class OrderService {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  final List<Payment> _orders = [];

  /// Notifier so the dashboard can reactively update.
  final ValueNotifier<int> orderCountNotifier = ValueNotifier<int>(0);

  /// All orders (newest first).
  List<Payment> get orders => List.unmodifiable(_orders.reversed);

  /// Add a new order.
  void addOrder(Payment payment) {
    _orders.add(payment);
    orderCountNotifier.value = _orders.length;
  }

  /// Mark an order as paid.
  void markAsPaid(String id) {
    final index = _orders.indexWhere((o) => o.id == id);
    if (index != -1) {
      final old = _orders[index];
      _orders[index] = Payment(
        id: old.id,
        title: old.title,
        description: old.description,
        amount: old.amount,
        date: old.date,
        status: 'paid',
        productNames: old.productNames,
      );
      orderCountNotifier.value = _orders.length;
    }
  }
}
