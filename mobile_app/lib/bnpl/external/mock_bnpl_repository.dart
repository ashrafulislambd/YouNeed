import 'package:flutter/material.dart';
import '../application/interfaces/bnpl_repository.dart';
import '../entities/bnpl_plan.dart';

/// Mock implementation of IBnplRepository
/// Replace with API implementation when backend is ready
class MockBnplRepository implements IBnplRepository {
  /// Mock BNPL plans
  /// Plan A: Up to Tk 5,000 (Groceries, essentials) - Bronze+
  /// Plan B: Up to Tk 15,000 (Clothes, accessories) - Silver+
  /// Plan C: Up to Tk 40,000 (Phones, appliances) - Gold+
  /// Plan D: Tk 25,000 - 80,000 (Laptop, furniture) - Platinum only
  static const List<BnplPlan> _plans = [
    BnplPlan(
      name: 'Plan A',
      emoji: '🟢',
      duration: 7,
      durationLabel: '7 Days',
      baseInterest: 0.0,
      spendingLimit: 5000,
      targetPurchase: 'Groceries, essentials',
      pointsEarned: 25,
      lateFee: 100,
      color: Color(0xFF4CAF50),
      gradientColors: [Color(0xFF43A047), Color(0xFF66BB6A)],
      tier: 'Bronze',
      overdueCharges: [
        OverdueCharge('1-7 days', 'Tk 100 late fee'),
        OverdueCharge('8-15 days', 'Tk 100 + 2% of principal'),
        OverdueCharge('16-30 days', 'Tk 100 + 4% of principal'),
        OverdueCharge('>30 days', 'Default / collections'),
      ],
    ),
    BnplPlan(
      name: 'Plan B',
      emoji: '🟡',
      duration: 15,
      durationLabel: '15 Days',
      baseInterest: 1.0,
      spendingLimit: 15000,
      targetPurchase: 'Clothes, accessories',
      pointsEarned: 15,
      lateFee: 200,
      color: Color(0xFFFFC107),
      gradientColors: [Color(0xFFFFB300), Color(0xFFFFD54F)],
      tier: 'Silver',
      overdueCharges: [
        OverdueCharge('1-7 days', 'Tk 200 + daily 0.5%'),
        OverdueCharge('8-15 days', 'Tk 200 + 3% principal'),
        OverdueCharge('16-30 days', 'Tk 200 + 5% principal'),
        OverdueCharge('>30 days', 'Account freeze'),
      ],
    ),
    BnplPlan(
      name: 'Plan C',
      emoji: '🟠',
      duration: 30,
      durationLabel: '30 Days',
      baseInterest: 2.0,
      spendingLimit: 40000,
      targetPurchase: 'Phones, appliances',
      pointsEarned: 10,
      lateFee: 500,
      color: Color(0xFFFF9800),
      gradientColors: [Color(0xFFF57C00), Color(0xFFFFB74D)],
      tier: 'Gold',
      overdueCharges: [
        OverdueCharge('1-7 days', 'Tk 500 + 1% daily'),
        OverdueCharge('8-15 days', 'Tk 500 + 4% principal'),
        OverdueCharge('16-30 days', 'Tk 500 + 6% principal'),
        OverdueCharge('>30 days', 'Collections initiated'),
      ],
    ),
    BnplPlan(
      name: 'Plan D',
      emoji: '🔴',
      duration: 60,
      durationLabel: '60 Days',
      baseInterest: 4.5,
      spendingLimit: 80000,
      spendingLimitMin: 25000,
      targetPurchase: 'Laptop, furniture',
      pointsEarned: 8,
      lateFee: 800,
      color: Color(0xFFF44336),
      gradientColors: [Color(0xFFD32F2F), Color(0xFFE57373)],
      tier: 'Platinum',
      overdueCharges: [
        OverdueCharge('1-7 days', 'Tk 800 + weekly 1.5%'),
        OverdueCharge('8-15 days', 'Tk 800 + 7% principal'),
        OverdueCharge('16-30 days', 'Tk 800 + 10% principal'),
        OverdueCharge('>30 days', 'Legal recovery / blacklist'),
      ],
      singleLoanOnly: true,
    ),
  ];

  /// Mock user data - in production, this would come from user service/API
  static const int _mockUserPoints = 85; // Silver tier (30-99 points)
  static const int _mockActiveLoans = 1;

  @override
  Future<List<BnplPlan>> getPlans() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _plans;
  }

  @override
  Future<UserBnplInfo> getUserInfo() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return UserBnplInfo(
      userPoints: _mockUserPoints,
      activeLoans: _mockActiveLoans,
      tier: _getTierFromPoints(_mockUserPoints),
      maxExposure: _getMaxExposure(_mockUserPoints),
    );
  }

  String _getTierFromPoints(int points) {
    if (points >= 180) return 'Platinum';
    if (points >= 100) return 'Gold';
    if (points >= 30) return 'Silver';
    return 'Bronze';
  }

  int _getMaxExposure(int points) {
    if (points >= 180) return 80000;
    if (points >= 100) return 40000;
    if (points >= 30) return 15000;
    return 5000;
  }

  @override
  bool canAccessPlan(String userTier, String planTier) {
    final tierOrder = ['Bronze', 'Silver', 'Gold', 'Platinum'];
    final userTierIndex = tierOrder.indexOf(userTier);
    final planTierIndex = tierOrder.indexOf(planTier);
    return userTierIndex >= planTierIndex;
  }

  @override
  bool isPlanEligible({
    required BnplPlan plan,
    required String userTier,
    required int cartTotal,
    required int activeLoans,
  }) {
    if (!canAccessPlan(userTier, plan.tier)) return false;
    if (cartTotal > plan.spendingLimit) return false;
    if (plan.spendingLimitMin != null && cartTotal < plan.spendingLimitMin!) return false;
    if (plan.singleLoanOnly && activeLoans >= 1) return false;
    if (activeLoans >= 2) return false;
    return true;
  }

  @override
  Map<String, int> calculatePayment({
    required int cartTotal,
    required double interestRate,
  }) {
    final interest = (cartTotal * interestRate / 100).round();
    final totalPayable = cartTotal + interest;
    return {
      'interest': interest,
      'totalPayable': totalPayable,
    };
  }

  @override
  Future<bool> confirmPlan({
    required BnplPlan plan,
    required int cartTotal,
    required Map<int, int> cartItems,
  }) async {
    // In production, this would call the API to create the BNPL order
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock success
    return true;
  }
}
