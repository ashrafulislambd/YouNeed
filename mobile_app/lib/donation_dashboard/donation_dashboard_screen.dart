import 'package:flutter/material.dart';
import 'donation_model.dart';
import 'donation_card.dart';
import 'donation_payment_screen.dart';
import 'create_donation_screen.dart';

class DonationDashboardScreen extends StatefulWidget {
  const DonationDashboardScreen({Key? key}) : super(key: key);

  @override
  State<DonationDashboardScreen> createState() => _DonationDashboardScreenState();
}

class _DonationDashboardScreenState extends State<DonationDashboardScreen> {
  final _donationService = DonationService();

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

    // Update the case in the service
    final updatedCase = DonationCase(
        id: item.id,
        name: item.name,
        story: item.story,
        targetAmount: item.targetAmount,
        currentAmount: item.currentAmount + amount,
        imageUrl: item.imageUrl,
        relationship: item.relationship,
        location: item.location,
        isFromContacts: item.isFromContacts,
        hasHelpPost: item.hasHelpPost,
        requestedFrom: item.requestedFrom,
    );
    
    _donationService.updateCase(updatedCase);

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
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'Request Donation',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateDonationScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateDonationScreen()),
          );
        },
        label: const Text('Request Money'),
        icon: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListenableBuilder(
        listenable: _donationService,
        builder: (context, child) {
          final cases = _donationService.cases;
          if (cases.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.volunteer_activism, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No donation requests yet.',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CreateDonationScreen()),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Request'),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 80), // Add bottom padding for FAB
            itemCount: cases.length,
            itemBuilder: (context, index) {
              final item = cases[index];
              return DonationCard(
                donationCase: item,
                onDonate: () => _handleDonate(item),
                onCardClick: () => _showCaseDetails(item),
              );
            },
          );
        },
      ),
    );
  }

  void _showCaseDetails(DonationCase item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.isFromContacts)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.people, size: 16, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Relationship: ${item.relationship}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                   Icon(Icons.location_on, size: 16, color: Theme.of(context).colorScheme.secondary),
                   const SizedBox(width: 8),
                   Text('Location: ${item.location}'),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(item.story),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _handleDonate(item);
            },
            child: const Text('Donate'),
          ),
        ],
      ),
    );
  }
}
