class Payment {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final String status; // 'due', 'paid', 'pending'

  Payment({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.status,
  });
}
