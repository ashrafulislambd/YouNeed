
import 'package:flutter/foundation.dart';

class DonationCase {
  final String id;
  final String name;
  final String story;
  final double targetAmount;
  final double currentAmount;
  final String imageUrl; // Placeholder for now or file path
  final String relationship; // e.g. "Village Uncle", "Neighbor"
  final String location;     // e.g. "Comilla", "Dhaka"
  final bool isFromContacts;
  final bool hasHelpPost;
  // Added to support requesting specific persons (max 3)
  final List<String> requestedFrom;

  DonationCase({
    required this.id,
    required this.name,
    required this.story,
    required this.targetAmount,
    required this.currentAmount,
    this.imageUrl = '',
    this.relationship = 'Community Member',
    this.location = 'Unknown',
    this.isFromContacts = false,
    this.hasHelpPost = false,

    this.requestedFrom = const [],
  });

  double get progress => (currentAmount / targetAmount).clamp(0.0, 1.0);
}

class DonationService extends ChangeNotifier {
  // Singleton pattern
  static final DonationService _instance = DonationService._internal();
  factory DonationService() => _instance;
  DonationService._internal();

  final List<DonationCase> _cases = [
    DonationCase(
      id: '1',
      name: 'Rahim Uddin',
      story: 'Struggling to pay installments for his small grocery shop loan due to recent flooding affecting his business.',
      targetAmount: 5000.0,
      currentAmount: 1500.0,
      relationship: 'Village Uncle',
      location: 'Comilla',
      isFromContacts: true,
      hasHelpPost: true,
    ),
    DonationCase(
      id: '2',
      name: 'Fatima Begum',
      story: 'Widow with two children, unable to pay for sewing machine installments due to health issues.',
      targetAmount: 8000.0,
      currentAmount: 4500.0,
      relationship: 'Distant Aunt',
      location: 'Barisal',
      isFromContacts: true,
      hasHelpPost: true,
    ),
    DonationCase(
      id: '3',
      name: 'Karim Hassan',
      story: 'Rickshaw puller needing support to clear remaining debt for his battery-operated rickshaw.',
      targetAmount: 12000.0,
      currentAmount: 3000.0,
      relationship: 'Former Neighbor',
      location: 'Dhaka',
      isFromContacts: true,
      hasHelpPost: true,
    ),
     DonationCase(
      id: '4',
      name: 'Ayesha Akter',
      story: 'Poultry farm owner facing losses from disease outbreak, needs help with verified loan payment.',
      targetAmount: 15000.0,
      currentAmount: 7500.0,
      relationship: 'Local Shopkeeper',
      location: 'Sylhet',
      isFromContacts: true,
      hasHelpPost: true,
    ),
  ];

  List<DonationCase> get cases => List.unmodifiable(_cases);

  void addCase(DonationCase newCase) {
    _cases.insert(0, newCase); // Add to top
    notifyListeners();
  }

  void updateCase(DonationCase updatedCase) {
    final index = _cases.indexWhere((c) => c.id == updatedCase.id);
    if (index != -1) {
      _cases[index] = updatedCase;
      notifyListeners();
    }
  }
}
