import '../../entities/bnpl_plan.dart';

/// Interface for BNPL repository - abstracts data source
/// Replace mock implementation with API calls when backend is ready
abstract class IBnplRepository {
  /// Get all available BNPL plans
  Future<List<BnplPlan>> getPlans();
  
  /// Get user's BNPL eligibility info
  Future<UserBnplInfo> getUserInfo();
  
  /// Check if user can access a specific plan based on their tier
  bool canAccessPlan(String userTier, String planTier);
  
  /// Check if user is eligible for a plan
  bool isPlanEligible({
    required BnplPlan plan,
    required String userTier,
    required int cartTotal,
    required int activeLoans,
  });
  
  /// Calculate interest and total payable
  Map<String, int> calculatePayment({
    required int cartTotal,
    required double interestRate,
  });
  
  /// Confirm a BNPL plan selection (would call API in real implementation)
  Future<bool> confirmPlan({
    required BnplPlan plan,
    required int cartTotal,
    required Map<int, int> cartItems,
  });
}
