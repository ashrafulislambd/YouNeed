import 'package:flutter/material.dart';
import 'donation_model.dart';
import 'donation_payment_verification_screen.dart';
import '../donation_credit/pages/donation_credit_page.dart';

class DonationPaymentScreen extends StatefulWidget {
  final DonationCase donationCase;

  const DonationPaymentScreen({Key? key, required this.donationCase}) : super(key: key);

  @override
  State<DonationPaymentScreen> createState() => _DonationPaymentScreenState();
}

class _DonationPaymentScreenState extends State<DonationPaymentScreen> {
  final _amountController = TextEditingController();
  String _selectedMethod = 'bkash'; // 'bkash' or 'paypal'
  // Removed _isLoading as we are navigating now

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _processPayment() async {
    final amountText = _amountController.text;
    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    // Navigate to Verification Screen
    final success = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => DonationPaymentVerificationScreen(
          amount: amount,
          paymentMethod: _selectedMethod,
          paymentMethodTitle: _selectedMethod == 'bkash' ? 'bKash' : 'PayPal',
        ),
      ),
    );

    if (success == true && mounted) {
       // Show Success/Credit Screen
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => _DonationSuccessScreen(
            amount: amount,
            donationCase: widget.donationCase,
            paymentMethodTitle: _selectedMethod == 'bkash' ? 'bKash' : 'PayPal',
          ),
        ),
      );

      if (mounted) {
         // Return the successfully processed amount to the dashboard
        Navigator.pop(context, amount);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make a Donation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Case Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Supporting ${widget.donationCase.name}',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.donationCase.story,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Amount Input
            Text(
              'Donation Amount',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: theme.textTheme.headlineMedium,
              decoration: const InputDecoration(
                prefixText: '৳ ',
                hintText: '0',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Payment Method Selection
            Text(
              'Select Payment Method',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Payment Methods
            Row(
              children: [
                Expanded(
                  child: _PaymentMethodCard(
                    title: 'bKash',
                    isSelected: _selectedMethod == 'bkash',
                    onTap: () => setState(() => _selectedMethod = 'bkash'),
                    color: Colors.pink,
                    icon: Icons.payments_outlined, 
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _PaymentMethodCard(
                    title: 'PayPal',
                    isSelected: _selectedMethod == 'paypal',
                    onTap: () => setState(() => _selectedMethod = 'paypal'),
                    color: Colors.blue[800]!,
                    icon: Icons.paypal,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Pay Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _processPayment,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                        'Pay Now',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Simulation Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _simulateSuccess,
                child: const Text('Simulate Credit Screen'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _simulateSuccess() {
     Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DonationCreditPage(),
        ),
      );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;
  final IconData icon;

  const _PaymentMethodCard({
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : theme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? color : theme.colorScheme.onSurface,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DonationSuccessScreen extends StatelessWidget {
  final double amount;
  final DonationCase donationCase;
  final String paymentMethodTitle;

  const _DonationSuccessScreen({
    Key? key,
    required this.amount,
    required this.donationCase,
    required this.paymentMethodTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal, // Success color background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              const Text(
                'Donation Successful!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Thank you for your generosity.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Amount Donated',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      '৳${amount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Divider(height: 32),
                    _buildDetailRow('To', donationCase.name),
                    const SizedBox(height: 8),
                    _buildDetailRow('Method', paymentMethodTitle),
                    const SizedBox(height: 8),
                    _buildDetailRow('Status', 'Credited'),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: () => Navigator.pop(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }
}
