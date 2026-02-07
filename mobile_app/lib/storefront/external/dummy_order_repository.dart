import 'dart:math';
import 'package:dashboard/storefront/application/dto/order_dto.dart';
import 'package:dashboard/storefront/application/dto/order_response_dto.dart';
import 'package:dashboard/storefront/application/interfaces/order_repository.dart';

class DummyOrderRepository implements IOrderRepository {
  final Random _random = Random();

  @override
  Future<OrderResponseDTO> makeOrder(OrderDTO orderInfo) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1 + _random.nextInt(2)));

    // Fail naturally ~30% of the time
    if (_random.nextDouble() < 0.3) {
      final errorMessages = [
        "Payment gateway timeout",
        "Insufficient funds",
        "Product out of stock",
        "Network connection lost",
        "Invalid user context",
      ];
      return OrderResponseDTO()
        ..successful = false
        ..errorMessage = errorMessages[_random.nextInt(errorMessages.length)];
    }

    // Success case
    return OrderResponseDTO()
      ..successful = true
      ..orderId =
          1000 + _random.nextInt(9000); // Random ID between 1000 and 9999
  }
}
