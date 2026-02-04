import 'package:dashboard/storefront/application/dto/order_dto.dart';
import 'package:dashboard/storefront/application/dto/order_response_dto.dart';

abstract class IOrderRepository {
  Future<OrderResponseDTO> makeOrder(OrderDTO orderInfo);
}
