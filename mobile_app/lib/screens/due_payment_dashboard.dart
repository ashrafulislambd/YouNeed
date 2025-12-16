import 'package:flutter/material.dart';
import '../models/payment.dart';
import '../widgets/payment_card.dart';
import '../widgets/stat_card.dart';
import '../theme_provider.dart';


class DuePaymentDashboard extends StatefulWidget {
  const DuePaymentDashboard({super.key});

  @override
  State<DuePaymentDashboard> createState() => _DuePaymentDashboardState();
}

class _DuePaymentDashboardState extends State<DuePaymentDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Payment> _allPayments = [
    Payment(
      id: '1',
      title: 'Rice (Minket)',
      description: 'Premium quality rice 5kg',
      amount: 450.00,
      date: DateTime(2025, 12, 01),
      status: 'due',
    ),
    Payment(
      id: '2',
      title: 'Potatoes',
      description: 'Fresh organic potatoes 2kg',
      amount: 120.00,
      date: DateTime(2025, 11, 28),
      status: 'due',
    ),
    Payment(
      id: '3',
      title: 'Soybean Oil',
      description: 'Fresh soybean oil 1L',
      amount: 185.00,
      date: DateTime(2025, 11, 15),
      status: 'paid',
    ),
    Payment(
      id: '4',
      title: 'Salt',
      description: 'Iodized salt 1kg',
      amount: 45.00,
      date: DateTime(2025, 10, 01),
      status: 'paid',
    ),
    Payment(
      id: '5',
      title: 'Onions',
      description: 'Local onions 1kg',
      amount: 90.00,
      date: DateTime(2025, 12, 02),
      status: 'due',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Payment> get _duePayments => _allPayments.where((p) => p.status == 'due').toList();
  List<Payment> get _paidPayments => _allPayments.where((p) => p.status == 'paid').toList();

  double get _totalDue => _duePayments.fold(0, (sum, item) => sum + item.amount);
  double get _totalPaid => _paidPayments.fold(0, (sum, item) => sum + item.amount);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning,',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'My Groceries',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
          ],
        ),
        centerTitle: false,
        toolbarHeight: 80,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: isDark ? Colors.amber : Colors.black87,
              ),
              onPressed: () {
                themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.person_outline_rounded, color: isDark ? Colors.white : Colors.black87),
              tooltip: 'Profile / Register',
              onPressed: () => Navigator.pushNamed(context, '/register'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.receipt_long_rounded, color: isDark ? Colors.white : Colors.black87),
              tooltip: 'Transactions',
              onPressed: () => Navigator.pushNamed(context, '/'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.credit_card_rounded, color: isDark ? Colors.white : Colors.black87),
              tooltip: 'Credit Status',
              onPressed: () => Navigator.pushNamed(context, '/credit'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.verified_user_outlined, color: isDark ? Colors.white : Colors.black87),
              tooltip: 'KYC Verification',
              onPressed: () => Navigator.pushNamed(context, '/kyc'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 45,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? Colors.black26 : Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: isDark ? Colors.white : Colors.black,
                unselectedLabelColor: isDark ? Colors.white54 : Colors.grey[600],
                indicator: BoxDecoration(
                  color: isDark ? const Color(0xFF334155) : Colors.white,
                  borderRadius: BorderRadius.circular(21),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: 'All Items'),
                  Tab(text: 'To Buy'),
                  Tab(text: 'Bought'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 160,
                    child: StatCard(
                      title: 'Total Amount',
                      value: '৳${_totalDue.toStringAsFixed(0)}',
                      color: const Color(0xFFFF5252),
                      icon: Icons.shopping_cart_outlined,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 160,
                    child: StatCard(
                      title: 'Paid',
                      value: '৳${_totalPaid.toStringAsFixed(0)}',
                      color: const Color(0xFF4CAF50),
                      icon: Icons.receipt_long_rounded,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPaymentList(_allPayments),
                _buildPaymentList(_duePayments),
                _buildPaymentList(_paidPayments),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentList(List<Payment> payments) {
    if (payments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_basket_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No items found',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return PaymentCard(
          payment: payment,
          onPay: payment.status == 'due'
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Buying ${payment.title}...')),
                  );
                }
              : null,
        );
      },
    );
  }
}
