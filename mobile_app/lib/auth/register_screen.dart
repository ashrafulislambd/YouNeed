import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  // State
  int _currentStep = 0; // 0: Phone, 1: OTP, 2: PIN
  bool _isLoading = false;
  bool _acceptedTerms = false;
  String _selectedPhoneCode = '+880';
  
  // Animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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
    _otpController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _nextStep() async {
    if (_currentStep == 0) {
      // Step 1: Validate Phone and Send OTP
      if (_phoneController.text.isEmpty || _phoneController.text.length < 10) {
        _showError('Please enter a valid phone number');
        return;
      }
      
      setState(() => _isLoading = true);
      final success = await AuthService().sendOtp(_phoneController.text);
      setState(() => _isLoading = false);
      
      if (success) {
        setState(() {
          _currentStep = 1;
          _animationController.reset();
          _animationController.forward();
        });
      } else {
        _showError('Failed to send OTP. Please try again.');
      }
    } else if (_currentStep == 1) {
      // Step 2: Verify OTP
      if (_otpController.text.length < 4) {
        _showError('Please enter a valid OTP');
        return;
      }
      
      setState(() => _isLoading = true);
      final success = await AuthService().verifyOtp(_phoneController.text, _otpController.text);
      setState(() => _isLoading = false);
      
      if (success) {
        setState(() {
          _currentStep = 2;
          _animationController.reset();
          _animationController.forward();
        });
      } else {
        _showError('Invalid OTP');
      }
    } else if (_currentStep == 2) {
      // Step 3: Set PIN and Register
      if (_pinController.text.length < 4) {
        _showError('PIN must be at least 4 digits');
        return;
      }
      if (_pinController.text != _confirmPinController.text) {
        _showError('PINs do not match');
        return;
      }
      if (!_acceptedTerms) {
        _showError('Please accept the Terms and Conditions');
        return;
      }
      
      setState(() => _isLoading = true);
      
      final result = await AuthService().register(
        phone: _phoneController.text,
        pin: _pinController.text,
      );
      
      if (mounted) {
        setState(() => _isLoading = false);
        
        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration Successful!'), backgroundColor: Colors.green),
          );
          Navigator.pushReplacementNamed(context, '/due-payment');
        } else {
          _showError(result['message'] ?? 'Registration failed');
        }
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    
    // Premium Vibrant Gradients
    final gradientColors = isDark 
      ? [const Color(0xFF1A2980), const Color(0xFF26D0CE)] // Dark: Deep Blue to Cyan
      : [const Color(0xFF8E2DE2), const Color(0xFF4A00E0)]; // Light: Purple to Deep Blue (Vibrant)

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: _currentStep > 0 
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                setState(() {
                  _currentStep--;
                  _animationController.reset();
                  _animationController.forward();
                });
              },
            )
          : IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Progress Indicator
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildStepIndicator(0, isDark),
                              _buildStepLine(0, isDark),
                              _buildStepIndicator(1, isDark),
                              _buildStepLine(1, isDark),
                              _buildStepIndicator(2, isDark),
                            ],
                          ),
                          const SizedBox(height: 32),
                          
                          // Dynamic Content
                          _buildStepContent(context, isDark, primaryColor),

                          const SizedBox(height: 32),
                          
                          // Action Button
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
                              onPressed: _isLoading ? null : _nextStep,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _isLoading 
                                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : Text(
                                    _currentStep == 0 ? 'SEND OTP' : (_currentStep == 1 ? 'VERIFY' : 'REGISTER'), 
                                    style: const TextStyle(
                                      fontSize: 16, 
                                      fontWeight: FontWeight.bold, 
                                      letterSpacing: 1.2,
                                      color: Colors.white,
                                    ),
                                  ),
                            ),
                          ),
                          
                           if (_currentStep == 0) ...[
                             const SizedBox(height: 32),
                            // Login Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?',
                                  style: TextStyle(
                                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                           ],
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
    );
  }

  Widget _buildStepIndicator(int step, bool isDark) {
    bool isActive = _currentStep >= step;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor : (isDark ? Colors.white10 : Colors.black12),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isActive 
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : Text(
              (step + 1).toString(),
              style: TextStyle(
                color: isDark ? Colors.white38 : Colors.black38,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
    );
  }

  Widget _buildStepLine(int step, bool isDark) {
    bool isActive = _currentStep > step;
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? Theme.of(context).primaryColor : (isDark ? Colors.white10 : Colors.black12),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, bool isDark, Color primaryColor) {
    switch (_currentStep) {
      case 0:
        return _buildPhoneStep(context, isDark);
      case 1:
        return _buildOtpStep(context, isDark, primaryColor);
      case 2:
        return _buildPinStep(context, isDark, primaryColor);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPhoneStep(BuildContext context, bool isDark) {
    return Column(
      children: [
        Icon(Icons.phone_android_rounded, size: 48, color: Theme.of(context).primaryColor),
        const SizedBox(height: 16),
        Text(
          'Mobile Number',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'We need your phone number to verify your identity',
          textAlign: TextAlign.center,
          style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
        ),
        const SizedBox(height: 32),
        _buildPhoneField(context, isDark),
      ],
    );
  }

  Widget _buildOtpStep(BuildContext context, bool isDark, Color primaryColor) {
    return Column(
      children: [
        Icon(Icons.mark_email_read_rounded, size: 48, color: primaryColor),
        const SizedBox(height: 16),
        Text(
          'Enter OTP',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'A verification code has been sent to your phone',
          textAlign: TextAlign.center,
          style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
        ),
        const SizedBox(height: 32),
        TextFormField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 8,
             color: isDark ? Colors.white : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: '0000',
            filled: true,
            fillColor: isDark ? Colors.black.withOpacity(0.2) : Colors.grey.withOpacity(0.05),
             border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
             focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(6),
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ],
    );
  }

  Widget _buildPinStep(BuildContext context, bool isDark, Color primaryColor) {
    return Column(
      children: [
        Icon(Icons.lock_rounded, size: 48, color: primaryColor),
        const SizedBox(height: 16),
        Text(
          'Set PIN',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Create a secure PIN for your account',
          textAlign: TextAlign.center,
          style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
        ),
        const SizedBox(height: 32),
        _buildPinField(context, _pinController, 'Enter PIN', isDark),
        const SizedBox(height: 16),
        _buildPinField(context, _confirmPinController, 'Confirm PIN', isDark),
        const SizedBox(height: 24),
         // Terms Checkbox
        Theme(
          data: Theme.of(context).copyWith(
            checkboxTheme: CheckboxThemeData(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ),
          child: CheckboxListTile(
            value: _acceptedTerms,
            onChanged: (v) => setState(() => _acceptedTerms = v!),
            title: Text(
              'I agree to the Terms & Conditions',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            activeColor: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField(BuildContext context, bool isDark) {
    return Container(
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
                hintText: '1234567890',
                hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.black26),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinField(BuildContext context, TextEditingController controller, String label, bool isDark) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      obscureText: true,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87, letterSpacing: 4),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? Colors.white60 : Colors.black45),
        filled: true,
        fillColor: isDark ? Colors.black.withOpacity(0.2) : Colors.grey.withOpacity(0.05),
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
        prefixIcon: Icon(Icons.lock_outline, color: isDark ? Colors.white54 : Colors.black38),
      ),
       inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}
