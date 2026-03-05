import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/payment.dart';

class PaymentCard extends StatelessWidget {
  final Payment payment;
  final VoidCallback? onPay;

  const PaymentCard({
    super.key,
    required this.payment,
    this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    final isDue = payment.status == 'due';
    final dateFormat = DateFormat('MMM d, yyyy');
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            _showOrderDetails(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isDue 
                      ? (isDark ? const Color(0xFF451B1B) : const Color(0xFFFFEBEB))
                      : (isDark ? const Color(0xFF1B3320) : const Color(0xFFE8F5E9)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isDue ? Icons.shopping_bag_outlined : Icons.check_circle_outline_rounded,
                    color: isDue ? const Color(0xFFFF5252) : const Color(0xFF4CAF50),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dateFormat.format(payment.date),
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '৳${payment.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    if (isDue && onPay != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: SizedBox(
                          height: 36,
                          child: ElevatedButton(
                            onPressed: onPay,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Pay',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOrderDetails(BuildContext context) {
    final isDue = payment.status == 'due';
    final dateFormat = DateFormat('MMM d, yyyy');
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.45,
          minChildSize: 0.3,
          maxChildSize: 0.7,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ListView(
                controller: scrollController,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    payment.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    payment.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Status & Amount
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDue ? Colors.red.shade50 : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isDue ? 'Due' : 'Paid',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: isDue ? Colors.red : Colors.green,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '৳${payment.amount.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Due date
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 16, color: isDark ? Colors.white54 : Colors.black45),
                      const SizedBox(width: 8),
                      Text(
                        isDue ? 'Due by ${dateFormat.format(payment.date)}' : 'Paid on ${dateFormat.format(payment.date)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Products
                  if (payment.productNames != null && payment.productNames!.isNotEmpty) ...[
                    Text(
                      'Products',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...payment.productNames!.map((name) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.grey.shade200,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF4CAF50), size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                          ),
                          Icon(Icons.check_circle, color: const Color(0xFF4CAF50), size: 18),
                        ],
                      ),
                    )),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 18, color: isDark ? Colors.white38 : Colors.grey),
                          const SizedBox(width: 10),
                          Text(
                            'Product details not available',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white38 : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
