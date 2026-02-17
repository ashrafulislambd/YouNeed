import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';
import 'package:dashboard/notifications/notification_service.dart';
import 'package:dashboard/notifications/notification_model.dart';
import 'package:dashboard/services/order_service.dart';
import 'package:dashboard/models/payment.dart';
import 'application/interfaces/bnpl_repository.dart';
import 'entities/bnpl_plan.dart';
import 'external/mock_bnpl_repository.dart';

/// BNPL (Buy Now Pay Later) Plans Selection Screen
/// Uses dependency injection for BNPL repository - follows clean architecture
class BnplPlansScreen extends StatefulWidget {
  final int cartTotal;
  final Map<int, int> cartItems;
  final List<String>? productNames;
  final VoidCallback? onPlanSelected;
  final IBnplRepository? bnplRepository;

  const BnplPlansScreen({
    super.key,
    required this.cartTotal,
    required this.cartItems,
    this.productNames,
    this.onPlanSelected,
    this.bnplRepository,
  });

  @override
  State<BnplPlansScreen> createState() => _BnplPlansScreenState();
}

class _BnplPlansScreenState extends State<BnplPlansScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late IBnplRepository _repository;
  
  List<BnplPlan> _plans = [];
  UserBnplInfo? _userInfo;
  int? _selectedPlanIndex;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _repository = widget.bnplRepository ?? MockBnplRepository();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final plans = await _repository.getPlans();
      final userInfo = await _repository.getUserInfo();
      setState(() {
        _plans = plans;
        _userInfo = userInfo;
        _isLoading = false;
      });
      _controller.forward();
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  bool _isPlanEligible(BnplPlan plan) {
    if (_userInfo == null) return false;
    return _repository.isPlanEligible(
      plan: plan,
      userTier: _userInfo!.tier,
      cartTotal: widget.cartTotal,
      activeLoans: _userInfo!.activeLoans,
    );
  }

  bool _canAccessPlan(BnplPlan plan) {
    if (_userInfo == null) return false;
    return _repository.canAccessPlan(_userInfo!.tier, plan.tier);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)]
                  : [const Color(0xFFE0EAFC), const Color(0xFFCFDEF3)],
            ),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Choose Payment Plan'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? Colors.black45 : Colors.white54,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)]
                : [const Color(0xFFE0EAFC), const Color(0xFFCFDEF3)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // User tier & credit info
                _buildUserInfoCard(isDark),
                const SizedBox(height: 12),
                
                // Cart total
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cart Total:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      Text(
                        'Tk${widget.cartTotal}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Plans list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _plans.length,
                    itemBuilder: (context, index) {
                      return _buildPlanCard(_plans[index], index, isDark);
                    },
                  ),
                ),
                
                // Anti-gaming rules
                _buildAntiGamingRules(isDark),
                
                // Confirm button
                if (_selectedPlanIndex != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => _confirmPlan(_plans[_selectedPlanIndex!]),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _plans[_selectedPlanIndex!].color,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          shadowColor: _plans[_selectedPlanIndex!].color.withOpacity(0.5),
                        ),
                        child: Text(
                          'Confirm ${_plans[_selectedPlanIndex!].name}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(bool isDark) {
    if (_userInfo == null) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.deepPurple.shade900, Colors.deepPurple.shade700]
              : [Colors.deepPurple.shade400, Colors.deepPurple.shade300],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getTierIcon(_userInfo!.tier),
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_userInfo!.tier} Member',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Credit Points: ${_userInfo!.userPoints}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Max Limit',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
              Text(
                'Tk${_userInfo!.maxExposure}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getTierIcon(String tier) {
    switch (tier) {
      case 'Platinum':
        return Icons.diamond;
      case 'Gold':
        return Icons.star;
      case 'Silver':
        return Icons.workspace_premium;
      default:
        return Icons.military_tech;
    }
  }

  Widget _buildPlanCard(BnplPlan plan, int index, bool isDark) {
    final isSelected = _selectedPlanIndex == index;
    final isEligible = _isPlanEligible(plan);
    final canAccess = _canAccessPlan(plan);

    return GestureDetector(
      onTap: isEligible
          ? () => setState(() => _selectedPlanIndex = index)
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isSelected
              ? LinearGradient(colors: plan.gradientColors)
              : null,
          color: isSelected
              ? null
              : (isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.white.withOpacity(0.9)),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isEligible
                    ? plan.color.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.3)),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: plan.color.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  )
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Opacity(
              opacity: isEligible ? 1.0 : 0.5,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Plan header
                    Row(
                      children: [
                        Text(
                          plan.emoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plan.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark ? Colors.white : Colors.black87),
                                ),
                              ),
                              Text(
                                plan.targetPurchase,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected
                                      ? Colors.white70
                                      : (isDark ? Colors.white60 : Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!canAccess)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${plan.tier}+',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )
                        else if (isSelected)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Plan details row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildPlanDetail(
                          plan.durationLabel,
                          'Duration',
                          Icons.schedule,
                          isSelected,
                          isDark,
                        ),
                        _buildPlanDetail(
                          '${plan.baseInterest}%',
                          'Interest',
                          Icons.percent,
                          isSelected,
                          isDark,
                        ),
                        _buildPlanDetail(
                          plan.spendingLimitMin != null
                              ? 'Tk${plan.spendingLimitMin! ~/ 1000}k-${plan.spendingLimit ~/ 1000}k'
                              : 'Tk${plan.spendingLimit ~/ 1000}k',
                          'Limit',
                          Icons.account_balance_wallet,
                          isSelected,
                          isDark,
                        ),
                        _buildPlanDetail(
                          '+${plan.pointsEarned}',
                          'Points',
                          Icons.star,
                          isSelected,
                          isDark,
                        ),
                      ],
                    ),
                    
                    // Expandable late fee details
                    Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        title: Text(
                          'Late Fee: Tk${plan.lateFee}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? Colors.white70 : Colors.black54),
                          ),
                        ),
                        trailing: Icon(
                          Icons.expand_more,
                          color: isSelected
                              ? Colors.white70
                              : (isDark ? Colors.white54 : Colors.black38),
                        ),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.black.withOpacity(0.2)
                                  : (isDark
                                      ? Colors.black.withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.1)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: plan.overdueCharges
                                  .map((charge) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              charge.period,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: isSelected
                                                    ? Colors.white70
                                                    : (isDark
                                                        ? Colors.white60
                                                        : Colors.black54),
                                              ),
                                            ),
                                            Text(
                                              charge.charge,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: isSelected
                                                    ? Colors.white
                                                    : (isDark
                                                        ? Colors.white
                                                        : Colors.black87),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    if (plan.singleLoanOnly)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: isSelected ? Colors.white : Colors.orange,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Only 1 active 60-day loan allowed',
                              style: TextStyle(
                                fontSize: 11,
                                color: isSelected ? Colors.white : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanDetail(
    String value,
    String label,
    IconData icon,
    bool isSelected,
    bool isDark,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 18,
          color: isSelected
              ? Colors.white70
              : (isDark ? Colors.white54 : Colors.black38),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white : Colors.black87),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isSelected
                ? Colors.white70
                : (isDark ? Colors.white54 : Colors.black45),
          ),
        ),
      ],
    );
  }

  Widget _buildAntiGamingRules(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.red.withOpacity(0.1)
            : Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.security,
            color: isDark ? Colors.redAccent : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Cannot switch plans • Max 2 active loans • New loan blocked if overdue',
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.redAccent : Colors.red.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmPlan(BnplPlan plan) async {
    // Calculate interest using repository
    final payment = _repository.calculatePayment(
      cartTotal: widget.cartTotal,
      interestRate: plan.baseInterest,
    );
    final interest = payment['interest']!;
    final totalPayable = payment['totalPayable']!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Text(plan.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Text('Confirm ${plan.name}'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConfirmRow('Cart Total', 'Tk${widget.cartTotal}'),
            _buildConfirmRow('Interest (${plan.baseInterest}%)', 'Tk$interest'),
            const Divider(),
            _buildConfirmRow('Total Payable', 'Tk$totalPayable', bold: true),
            const SizedBox(height: 8),
            _buildConfirmRow('Due Date', '${plan.duration} days from today'),
            _buildConfirmRow('Points Earned', '+${plan.pointsEarned}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Confirm plan via repository
              final success = await _repository.confirmPlan(
                plan: plan,
                cartTotal: widget.cartTotal,
                cartItems: widget.cartItems,
              );
              
              if (success && mounted) {
                // Generate dynamic order ID
                final orderId = 1000 + Random().nextInt(9000);
                final paymentDeadline = DateTime.now().add(Duration(days: plan.duration));
                final deadlineStr = '${paymentDeadline.day}/${paymentDeadline.month}/${paymentDeadline.year}';

                // Notification 1: Order placed
                NotificationService().addNotification(
                  title: 'Order #$orderId Placed Successfully',
                  message: 'Your order has been confirmed! Estimated delivery within ${plan.duration} days. Pay ৳$totalPayable by $deadlineStr.',
                  type: NotificationType.orderPlaced,
                );

                // Notification 2: Payment deadline reminder (fires after 15s to simulate)
                NotificationService().scheduleNotification(
                  title: 'Payment Reminder - Order #$orderId',
                  message: 'Reminder: ৳$totalPayable is due for Order #$orderId by $deadlineStr. Please complete your payment to avoid cancellation.',
                  delay: const Duration(seconds: 15),
                  type: NotificationType.paymentReminder,
                );

                // Add order to Due Payment Dashboard
                OrderService().addOrder(Payment(
                  id: orderId.toString(),
                  title: 'Order #$orderId',
                  description: '${plan.name} — Pay ৳$totalPayable by $deadlineStr',
                  amount: totalPayable.toDouble(),
                  date: paymentDeadline,
                  status: 'due',
                  productNames: widget.productNames,
                ));

                Navigator.pop(context); // Close dialog
                Navigator.pop(context, plan); // Return to cart with selected plan
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '${plan.name} selected! Pay Tk$totalPayable in ${plan.duration} days.'),
                    backgroundColor: plan.color,
                  ),
                );
                widget.onPlanSelected?.call();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: plan.color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
