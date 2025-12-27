import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePin = true;
  String _selectedPhoneCode = '+880';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Call auth API
      final authService = AuthService();
      final result = await authService.login(
        phone: _phoneController.text,
        pin: _pinController.text, // Assuming login uses PIN now
      );
      
      if (mounted) {
        setState(() => _isLoading = false);
        
        if (result['success'] == true) {
          // Show success
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Login Successful!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
          // Navigate to due payment dashboard
          Navigator.pushReplacementNamed(context, '/due-payment');
        } else {
          // Show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Login failed'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    
    // Premium Vibrant Gradients
    final gradientColors = isDark 
      ? [const Color(0xFF1A2980), const Color(0xFF26D0CE)] // Dark: Deep Blue to Cyan
      : [const Color(0xFF8E2DE2), const Color(0xFF4A00E0)]; // Light: Purple to Deep Blue

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Welcome Back'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? Colors.black45 : Colors.white54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, size: 20),
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
              icon: const Icon(Icons.receipt_long_rounded, size: 20),
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
              icon: const Icon(Icons.credit_card_rounded, size: 20),
              tooltip: 'Credit Status',
              onPressed: () => Navigator.pushNamed(context, '/credit'),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? Colors.black45 : Colors.white54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.verified_user_outlined, size: 20),
              tooltip: 'KYC Verification',
              onPressed: () => Navigator.pushNamed(context, '/kyc'),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 480),
                      padding: const EdgeInsets.all(40.0),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.lock_open_rounded,
                                size: 48,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Login to YouNeed',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : Colors.black87,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Enter your phone number and PIN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 40),
                            
                            // Phone Field
                             Container(
                              decoration: BoxDecoration(
                                color: isDark ? Colors.black.withOpacity(0.2) : Colors.grey.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.1),
                                        ),
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedPhoneCode,
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: isDark ? Colors.white54 : Colors.black38,
                                        ),
                                        dropdownColor: isDark ? Colors.grey[900] : Colors.white,
                                        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                                        items: ['+880', '+1', '+44', '+92', '+86']
                                            .map((code) => DropdownMenuItem(value: code, child: Text(code)))
                                            .toList(),
                                        onChanged: (value) => setState(() => _selectedPhoneCode = value!),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                                      decoration: InputDecoration(
                                        hintText: 'Phone Number',
                                        hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.black26),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                      ),
                                      validator: (v) => v!.isEmpty ? 'Phone number is required' : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // PIN Field
                            TextFormField(
                              controller: _pinController,
                              obscureText: _obscurePin,
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                labelText: 'PIN',
                                labelStyle: TextStyle(color: isDark ? Colors.white60 : Colors.black45, fontSize: 14),
                                prefixIcon: Icon(Icons.lock_outline_rounded, color: isDark ? Colors.white54 : Colors.black38, size: 22),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePin ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(() => _obscurePin = !_obscurePin),
                                  color: isDark ? Colors.white60 : Colors.black54,
                                ),
                                filled: true,
                                fillColor: isDark ? Colors.black.withOpacity(0.2) : Colors.grey.withOpacity(0.05),
                                contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Colors.redAccent, width: 1),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Colors.redAccent, width: 2),
                                ),
                              ),
                              validator: (v) => v!.isEmpty ? 'PIN is required' : null,
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Login Button
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: isDark 
                                    ? [primaryColor, primaryColor.withOpacity(0.8)]
                                    : [primaryColor, primaryColor.withBlue(255)],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: _isLoading 
                                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text(
                                      'LOGIN', 
                                      style: TextStyle(
                                        fontSize: 16, 
                                        fontWeight: FontWeight.bold, 
                                        letterSpacing: 1.2,
                                        color: Colors.white,
                                      ),
                                    ),
                              ),
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Register Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/register');
                                  },
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
