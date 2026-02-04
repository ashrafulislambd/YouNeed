class OrderResponseDTO {
  int? orderId;
  bool? successful;

  // errorMessage is a friendly error message when order is failed
  String? errorMessage;
}
