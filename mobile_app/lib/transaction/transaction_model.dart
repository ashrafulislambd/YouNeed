
enum TransactionType { credit, debit }

class Transaction {
  final String id;
  final String title;
  final String quantity;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final double balanceBefore; // New field
  final double balanceAfter;
  final String shopName;
  final String shopAddress;
  final String? paymentMethod;
  final String? merchantId;
  final String? shopOwnerBkashId;
  final String? reference;

  const Transaction({
    required this.id,
    required this.title,
    required this.quantity,
    required this.amount,
    required this.date,
    required this.type,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.shopName,
    required this.shopAddress,
    this.paymentMethod,
    this.merchantId,
    this.shopOwnerBkashId,
    this.reference,
  });
}
