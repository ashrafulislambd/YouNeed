
import 'transaction_model.dart';

// Helper to create data with correct cumulative math
final List<Transaction> mockTransactions = _generateTransactions();

List<Transaction> _generateTransactions() {
  double currentDue = 0.0; // Start with 0 debt

  final rawData = [
    // 1. Medicines (450)
    _TxnData('TXN-001', 'Medicines', '2 boxes', 450.0, const Duration(days: 5), TransactionType.debit, 'Lazz Pharma', 'Kalabagan, Dhaka'),
    
    // 2. Meat (800)
    _TxnData('TXN-002', 'Meat (Beef)', '1 kg', 800.0, const Duration(days: 4), TransactionType.debit, 'Bhai Bhai Goshto Bitan', 'Karwan Bazar, Dhaka'),
    
    // 3. Payment (500)
    _TxnData('TXN-PAY-003', 'Payment to Shop', '-', 500.0, const Duration(days: 3), TransactionType.credit, 'N/A', 'N/A', method: 'bKash', mId: 'M-29384', oId: '01711123456', ref: 'Due Clear'),
    
    // 4. Fish (1200)
    _TxnData('TXN-004', 'Fish (Hilsha)', '1.5 kg', 1200.0, const Duration(days: 2), TransactionType.debit, 'Mayer Doa Fish', 'Jatrabari, Dhaka'),
    
    // 5. Payment (1000)
    _TxnData('TXN-PAY-005', 'Partial Payment', '-', 1000.0, const Duration(days: 1), TransactionType.credit, 'N/A', 'N/A', method: 'PayPal', mId: 'PAY-8822', ref: 'Monthly Installment'),
    
    // 6. Rice (750)
    _TxnData('TXN-006', 'Rice (Miniket)', '10 kg', 750.0, const Duration(hours: 5), TransactionType.debit, 'Mayer Doa Rice Agency', 'Badamtoli, Dhaka'),
  ];

  List<Transaction> list = [];
  for (var data in rawData) {
    // Capture state BEFORE transaction
    double dueBefore = currentDue;

    if (data.type == TransactionType.debit) {
      currentDue += data.amount; // Debt increases
    } else {
      currentDue -= data.amount; // Debt decreases
    }
    
    // Capture state AFTER transaction
    double dueAfter = currentDue;
    
    list.add(Transaction(
      id: data.id,
      title: data.title,
      quantity: data.qty,
      amount: data.amount,
      date: DateTime.now().subtract(data.age),
      type: data.type,
      balanceBefore: dueBefore, // New field assigned
      balanceAfter: dueAfter,
      shopName: data.shop,
      shopAddress: data.addr,
      paymentMethod: data.method,
      merchantId: data.mId,
      shopOwnerBkashId: data.oId,
      reference: data.ref,
    ));
  }
  return list;
}

class _TxnData {
  final String id, title, qty, shop, addr;
  final double amount;
  final Duration age;
  final TransactionType type;
  final String? method, mId, oId, ref;

  _TxnData(this.id, this.title, this.qty, this.amount, this.age, this.type, this.shop, this.addr, {this.method, this.mId, this.oId, this.ref});
}
