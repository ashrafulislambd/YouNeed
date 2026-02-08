import 'package:flutter/material.dart';

/// BNPL Plan entity
class BnplPlan {
  final String name;
  final String emoji;
  final int duration;
  final String durationLabel;
  final double baseInterest;
  final int spendingLimit;
  final int? spendingLimitMin;
  final String targetPurchase;
  final int pointsEarned;
  final int lateFee;
  final Color color;
  final List<Color> gradientColors;
  final String tier;
  final List<OverdueCharge> overdueCharges;
  final bool singleLoanOnly;

  const BnplPlan({
    required this.name,
    required this.emoji,
    required this.duration,
    required this.durationLabel,
    required this.baseInterest,
    required this.spendingLimit,
    this.spendingLimitMin,
    required this.targetPurchase,
    required this.pointsEarned,
    required this.lateFee,
    required this.color,
    required this.gradientColors,
    required this.tier,
    required this.overdueCharges,
    this.singleLoanOnly = false,
  });
}

/// Overdue charge model
class OverdueCharge {
  final String period;
  final String charge;

  const OverdueCharge(this.period, this.charge);
}

/// User BNPL eligibility info
class UserBnplInfo {
  final int userPoints;
  final int activeLoans;
  final String tier;
  final int maxExposure;

  const UserBnplInfo({
    required this.userPoints,
    required this.activeLoans,
    required this.tier,
    required this.maxExposure,
  });
}
