import 'package:dashboard/storefront/entities/user_context.dart';

class OrderDTO {
  int? id;

  UserContext? userContext;

  // quantities of each products <product id, qty>
  Map<int, int>? quantities;

  int? totalInstallmentDays;

  int? steps;

  int? paymentTransactionId;
}
