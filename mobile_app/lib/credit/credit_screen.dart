import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme_provider.dart';

class CreditScreen extends StatefulWidget {
  const CreditScreen({super.key});

  @override
  State<CreditScreen> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isBlocked = false;  // State to simulate blocked account

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
        
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Mock Data
    final double totalLimit = 50000.0;
    final double usedAmount = 15450.0;
    final double available = totalLimit - usedAmount;
    final double progress = usedAmount / totalLimit;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Credit Status'),
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
        actions: [
          Container(
             margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.black45 : Colors.white54,
                borderRadius: BorderRadius.circular(12),
              ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart_outlined, color: isDark ? Colors.white : Colors.black, size: 20),
              tooltip: 'Due Payments',
              onPressed: () => Navigator.pushNamed(context, '/due-payment'),
            ),
          ),
          Container(
             margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.black45 : Colors.white54,
                borderRadius: BorderRadius.circular(12),
              ),
            child: IconButton(
              icon: Icon(Icons.receipt_long_rounded, color: isDark ? Colors.white : Colors.black, size: 20),
              tooltip: 'Transactions',
              onPressed: () => Navigator.pushNamed(context, '/'),
            ),
          ),
          Container(
             margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.black45 : Colors.white54,
                borderRadius: BorderRadius.circular(12),
              ),
            child: IconButton(
              icon: Icon(Icons.verified_user_outlined, color: isDark ? Colors.white : Colors.black, size: 20),
              tooltip: 'KYC Verification',
              onPressed: () => Navigator.pushNamed(context, '/kyc'),
            ),
          ),
          Container(
             margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.black45 : Colors.white54,
                borderRadius: BorderRadius.circular(12),
              ),
            child: IconButton(
              icon: Icon(Icons.person_outline_rounded, color: isDark ? Colors.white : Colors.black, size: 20),
              tooltip: 'Profile / Register',
              onPressed: () => Navigator.pushNamed(context, '/register'),
            ),
          ),
          Container(
             margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.black45 : Colors.white54,
                borderRadius: BorderRadius.circular(12),
              ),
            child: IconButton(
              icon: Icon(Icons.warning_amber_rounded, color: _isBlocked ? Colors.red : (isDark ? Colors.white : Colors.black), size: 20),
              tooltip: 'Simulate Block',
              onPressed: () => setState(() => _isBlocked = !_isBlocked),
            ),
          ),
          Container(
             margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.black45 : Colors.white54,
                borderRadius: BorderRadius.circular(12),
              ),
            child: IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, size: 20),
              onPressed: () => themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark,
            ),
          ),
        ],
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
        child: SafeArea( // Using SafeArea to avoid overlap with system UI
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    // 1. Credit Overview Card
                    _buildCreditCard(context, totalLimit, usedAmount, available, progress, isDark, _isBlocked),
                    
                    const SizedBox(height: 30),
                    
                    // 2. Restrictions Header
                    Row(
                      children: [
                        Icon(
                          _isBlocked ? Icons.gpp_bad_outlined : Icons.gpp_good_outlined, 
                          color: _isBlocked ? Colors.red : Colors.redAccent
                        ), 
                        const SizedBox(width: 8),
                        Text(
                          _isBlocked ? 'Account Blocked' : 'Active Restrictions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // 3. Grid of Restrictions
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                        children: [
                           _buildRestrictionCard(
                             context,
                             'Max Payment',
                             '৳20,000',
                             'Per Transaction',
                             Icons.payment,
                             Colors.redAccent, // Red
                             isDark,
                             'Maximum amount allowed for a single transaction.',
                           ),
                           _buildRestrictionCard(
                             context,
                             'Daily Limit',
                             '5',
                             'Transactions/Day',
                             Icons.calendar_today,
                             Colors.redAccent, // Red
                             isDark,
                             'Maximum number of transactions allowed per day.',
                           ),
                           _buildRestrictionCard(
                             context,
                             'Monthly Limit',
                             '৳1,00,000',
                             'Total Spend',
                             Icons.calendar_month,
                             Colors.redAccent, // Red
                             isDark,
                             'Total spending limit for the current calendar month.',
                           ),
                           _buildRestrictionCard(
                             context,
                             'Status',
                             _isBlocked ? 'Blocked' : 'Active',
                             _isBlocked ? 'Contact Support' : 'Account Good',
                             _isBlocked ? Icons.block : Icons.verified_user,
                             _isBlocked ? Colors.red : Colors.green, // Red if blocked
                             isDark,
                             _isBlocked 
                               ? 'Your account has been temporarily blocked due to suspicious activity. Please contact support.'
                               : 'Your account is in good standing. No blocks.',
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

  Widget _buildCreditCard(BuildContext context, double total, double used, double available, double progress, bool isDark, bool isBlocked) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isBlocked 
            ? [const Color(0xFFD31027), const Color(0xFFEA384D)] // Red Gradient for Blocked
            : [const Color(0xFF11998e), const Color(0xFF38ef7d)], // Premium Green Gradient
        ),
        boxShadow: [
          BoxShadow(
            color: (isBlocked ? const Color(0xFFEA384D) : const Color(0xFF38ef7d)).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isBlocked ? 'Account Suspended' : 'Available Credit',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(isBlocked ? 'BLOCKED' : 'PREMIUM', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isBlocked ? '৳0' : '৳${available.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Used: ৳${(isBlocked ? total : used).toStringAsFixed(0)}', style: TextStyle(color: Colors.white.withOpacity(0.9))),
                  Text('Limit: ৳${total.toStringAsFixed(0)}', style: TextStyle(color: Colors.white.withOpacity(0.9))),
                ],
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeOutCubic,
                    height: 8,
                    width: MediaQuery.of(context).size.width * 0.8 * (isBlocked ? 1.0 : progress), // Full bar if blocked
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(color: Colors.white.withOpacity(0.5), blurRadius: 6),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRestrictionCard(
      BuildContext context, 
      String title, 
      String value, 
      String sub, 
      IconData icon, 
      Color color, 
      bool isDark,
      String detailText,
      ) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(color: isDark ? Colors.white12 : Colors.grey[200]!),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                         Text(
                          value,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  detailText,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Got it', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? Colors.white12 : Colors.white),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                 Text(
                  sub,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
