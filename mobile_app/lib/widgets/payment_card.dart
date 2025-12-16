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
          onTap: () {},
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
                              backgroundColor: isDark ? Colors.white : Colors.black,
                              foregroundColor: isDark ? Colors.black : Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Buy',
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
}
