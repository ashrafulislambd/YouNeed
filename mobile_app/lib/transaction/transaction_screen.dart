import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'mock_data.dart';
import '../theme_provider.dart'; // Import from parent folder
import 'transaction_model.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Calculate Total Costs (Debits)
    final double totalCost = mockTransactions
        .where((t) => t.type == TransactionType.debit)
        .fold(0.0, (sum, t) => sum + t.amount);

    // 2. Calculate Total Paid (Credits)
    final List<Transaction> paymentTransactions = mockTransactions
        .where((t) => t.type == TransactionType.credit)
        .toList();
    
    final double totalPaid = paymentTransactions.fold(0.0, (sum, t) => sum + t.amount);

    // 3. Calculate Net Due
    final double netDue = totalCost - totalPaid;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = isDark ? const Color(0xFF333333) : Colors.grey[300];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.green),
            tooltip: 'Due Payments',
            onPressed: () => Navigator.pushNamed(context, '/due-payment'),
          ),
          IconButton(
            icon: const Icon(Icons.credit_card, color: Colors.blueAccent),
            tooltip: 'Credit Status',
            onPressed: () => Navigator.pushNamed(context, '/credit'),
          ),
          IconButton(
            icon: const Icon(Icons.verified_user_outlined, color: Colors.orange),
            tooltip: 'KYC Verification',
            onPressed: () => Navigator.pushNamed(context, '/kyc'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline_rounded, color: Colors.deepPurple),
            tooltip: 'Profile / Register',
            onPressed: () => Navigator.pushNamed(context, '/register'),
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: mockTransactions.length,
              itemBuilder: (context, index) {
                final transaction = mockTransactions[index];
                return HoverableTransactionCard(transaction: transaction);
              },
            ),
          ),
          // Bottom Summary Section
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              boxShadow: [
                 BoxShadow(
                  color: Theme.of(context).shadowColor,
                  offset: const Offset(0, -5),
                  blurRadius: 15,
                ),
              ],
              border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
            ),
            child: Column(
              children: [
                // Total Paid Row - CLICKABLE
                InkWell(
                  onTap: () {
                    if (paymentTransactions.isEmpty) return;
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => PaymentDetailsSheet(payments: paymentTransactions),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Total Paid',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.green, 
                                decoration: TextDecoration.underline, // Visual cue for clickable
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Payment Icons
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.pink.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.pink.withValues(alpha: 0.3)),
                              ),
                              child: const Text('bKash', style: TextStyle(fontSize: 10, color: Colors.pink, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                              ),
                              child: const Text('PayPal', style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                             Text(
                              '৳${totalPaid.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.info_outline, size: 16, color: Colors.grey[500]), // Info icon
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Divider(height: 1, color: dividerColor),
                const SizedBox(height: 12),
                // Net Due Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Remaining Due',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    Text(
                      '৳${netDue.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF5252), // Vibrant Red
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Color(0x40FF5252),
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentDetailsSheet extends StatelessWidget {
  final List<Transaction> payments;

  const PaymentDetailsSheet({super.key, required this.payments});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: payments.length,
              separatorBuilder: (c, i) => const Divider(),
              itemBuilder: (context, index) {
                final p = payments[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            p.paymentMethod ?? 'Payment',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          Text(
                            '৳${p.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _detailRow('Txn ID', p.id, isDark),
                      if (p.paymentMethod == 'bKash') ...[
                         _detailRow('Merchant ID', p.merchantId ?? 'N/A', isDark),
                         _detailRow('Shop Owner ID', p.shopOwnerBkashId ?? 'N/A', isDark),
                      ],
                      _detailRow('Reference', p.reference ?? 'N/A', isDark),
                      _detailRow('Date', DateFormat('MMM d, h:mm a').format(p.date), isDark),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HoverableTransactionCard extends StatefulWidget {
  final Transaction transaction;

  const HoverableTransactionCard({super.key, required this.transaction});

  @override
  State<HoverableTransactionCard> createState() => _HoverableTransactionCardState();
}

class _HoverableTransactionCardState extends State<HoverableTransactionCard> {
  bool _isHovered = false;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.transaction;
    final isCredit = t.type == TransactionType.credit;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color creditColor = isDark ? const Color(0xFF69F0AE) : const Color(0xFF2E7D32);
    final Color debitColor = isDark ? const Color(0xFFFF5252) : const Color(0xFFD32F2F);
    final Color amountColor = isCredit ? creditColor : debitColor;
    
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subTextColor = isDark ? Colors.grey[500]! : Colors.grey[600]!;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0.0, _isHovered ? -5.0 : 0.0, 0.0),
        margin: const EdgeInsets.only(bottom: 16),
        child: Card(
          elevation: _isHovered ? 12 : 2,
          shadowColor: Theme.of(context).shadowColor,
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: _isHovered && isDark
                  ? BorderSide(color: amountColor.withValues(alpha: 0.3), width: 1) 
                  : BorderSide.none,
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(isCredit ? 'Payment' : 'Item', style: TextStyle(color: subTextColor, fontSize: 11, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Text(t.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(isCredit ? 'Method' : 'Qty', style: TextStyle(color: subTextColor, fontSize: 11, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            isCredit && t.paymentMethod != null 
                            ? Row(
                                children: [
                                  Icon(Icons.payment, size: 14, color: isDark ? Colors.white70 : Colors.black54),
                                  const SizedBox(width: 4),
                                  Text(t.paymentMethod!, style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black54)),
                                ],
                              )
                            : Text(t.quantity, style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black54)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date', style: TextStyle(color: subTextColor, fontSize: 11, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Text(DateFormat('MMM d').format(t.date), style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black54)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(isCredit ? 'Paid' : 'Cost', style: TextStyle(color: subTextColor, fontSize: 11, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Text(
                              '৳${t.amount.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: amountColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                shadows: isDark ? [Shadow(color: amountColor.withValues(alpha: 0.3), blurRadius: 8)] : [],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Divider(color: Theme.of(context).dividerColor),
                        ),
                        // ... Rest of details same as before
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Time', style: TextStyle(color: subTextColor, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text(DateFormat('h:mm a').format(t.date), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor)),
                              ],
                            ),
                            // New Due Before Column
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Due Before', style: TextStyle(color: subTextColor, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text('৳${t.balanceBefore.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Due After', style: TextStyle(color: subTextColor, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text('৳${t.balanceAfter.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor)),
                              ],
                            ),
                          ],
                        ),
                        if (t.shopName != 'N/A') ...[ 
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Shop Name', style: TextStyle(color: subTextColor, fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Text(t.shopName, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('Address', style: TextStyle(color: subTextColor, fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Text(t.shopAddress, textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
