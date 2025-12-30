import 'package:flutter/material.dart';
import 'donation_model.dart';
import 'donation_card.dart';
import 'donation_payment_screen.dart';

class DonationDashboardScreen extends StatefulWidget {
  const DonationDashboardScreen({Key? key}) : super(key: key);

  @override
  State<DonationDashboardScreen> createState() => _DonationDashboardScreenState();
}

class _DonationDashboardScreenState extends State<DonationDashboardScreen> {
  // Using a local list to simulate state updates when donating
  late List<DonationCase> _cases;

  @override
  void initState() {
    super.initState();
    _cases = List.from(kMockDonationCases);
  }

  void _handleDonate(DonationCase item) async {
    // Navigate to payment screen and wait for result (donated amount)
    final donatedAmount = await Navigator.push<double>(
      context,
      MaterialPageRoute(
        builder: (context) => DonationPaymentScreen(donationCase: item),
      ),
    );

    if (donatedAmount != null && donatedAmount > 0) {
      _processDonation(item, donatedAmount);
    }
  }

  void _processDonation(DonationCase item, double amount) {
    if (amount <= 0) return;

    setState(() {
      final index = _cases.indexWhere((c) => c.id == item.id);
      if (index != -1) {
        // Create a new updated object
        final current = _cases[index];
        _cases[index] = DonationCase(
            id: current.id,
            name: current.name,
            story: current.story,
            targetAmount: current.targetAmount,
            currentAmount: current.currentAmount + amount,
            imageUrl: current.imageUrl
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Thank you! You donated ৳${amount.toStringAsFixed(0)} to ${item.name}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Support'),
        centerTitle: true,
        // Remove hardcoded colors to allow Theme to handle it
        elevation: 0,
      ),
      // Remove hardcoded container color, let Scaffold background color take over (which varies by theme)
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _cases.length,
        itemBuilder: (context, index) {
          final item = _cases[index];
          return DonationCard(
            donationCase: item,
            onDonate: () => _handleDonate(item),
          );
        },
      ),
    );
  }
}
