import 'package:flutter/material.dart';

class DonationCreditPage extends StatelessWidget {
  const DonationCreditPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo values 
    const int donationsDone = 3;
    const int donationsRequired = 5;

    final double progress = donationsDone / donationsRequired;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Credit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your progress',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(value: progress),
            ),
            const SizedBox(height: 8),
            Text('$donationsDone of $donationsRequired donations completed'),
            const SizedBox(height: 24),

            if (donationsDone >= donationsRequired)
              Card(
                child: ListTile(
                  title: const Text('🎁 You earned a Gift Voucher!'),
                  subtitle: const Text('Use it at Shopno and other partner shops.'),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: const Text('View'),
                  ),
                ),
              )
            else
              Card(
                child: ListTile(
                  title: const Text('Keep donating!'),
                  subtitle: Text(
                    'Donate ${donationsRequired - donationsDone} more times to get a voucher.',
                  ),
                ),
              ),

            const SizedBox(height: 24),
            Text(
              'Partner shops',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(leading: Icon(Icons.store), title: Text('Shopno')),
                  ListTile(leading: Icon(Icons.store), title: Text('Meena Bazar')),
                  ListTile(leading: Icon(Icons.store), title: Text('Agora')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
