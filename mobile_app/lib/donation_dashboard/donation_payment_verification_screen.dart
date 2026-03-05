import 'package:flutter/material.dart';
import '../services/otp_service.dart';

class DonationPaymentVerificationScreen extends StatefulWidget {
  final double amount;
  final String paymentMethod;
  final String paymentMethodTitle;

  const DonationPaymentVerificationScreen({
    Key? key,
    required this.amount,
    required this.paymentMethod,
    required this.paymentMethodTitle,
  }) : super(key: key);

  @override
  State<DonationPaymentVerificationScreen> createState() => _DonationPaymentVerificationScreenState();
}

class _DonationPaymentVerificationScreenState extends State<DonationPaymentVerificationScreen> {
  int _currentStep = 0; // 0: Phone, 1: OTP, 2: PIN
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _pinController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() => _errorMessage = 'Please enter your phone number');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await OtpService.sendOtp(phone);

    if (!mounted) return;

    if (result['success'] == true) {
      setState(() {
        _isLoading = false;
        _currentStep = 1;
        _errorMessage = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'OTP sent!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = result['message'] ?? 'Failed to send OTP';
      });
    }
  }

  void _verifyOtp() async {
    final phone = _phoneController.text.trim();
    final code = _otpController.text.trim();

    if (code.isEmpty) {
      setState(() => _errorMessage = 'Please enter the OTP code');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await OtpService.verifyOtp(phone, code);

    if (!mounted) return;

    if (result['verified'] == true) {
      setState(() {
        _isLoading = false;
        _currentStep = 2;
        _errorMessage = null;
      });
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = result['message'] ?? 'Invalid OTP';
      });
    }
  }

  void _confirmPayment() async {
    final pin = _pinController.text.trim();
    if (pin.isEmpty) {
      setState(() => _errorMessage = 'Please enter your PIN');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate PIN validation (this remains local)
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    Navigator.pop(context, true); // Return true to indicate success
  }

  void _nextStep() {
    switch (_currentStep) {
      case 0:
        _sendOtp();
        break;
      case 1:
        _verifyOtp();
        break;
      case 2:
        _confirmPayment();
        break;
    }
  }

  void _resendOtp() {
    _otpController.clear();
    _sendOtp();
  }

  Widget _buildPhoneStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter your mobile number',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'We will send a verification code to this number',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: '01XXXXXXXXX',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
          autofocus: true,
        ),
      ],
    );
  }

  Widget _buildOtpStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter verification code',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Code sent to ${_phoneController.text}',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          style: const TextStyle(letterSpacing: 8, fontSize: 18),
          decoration: const InputDecoration(
            hintText: 'X X X X X X',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.message),
            counterText: "",
          ),
          autofocus: true,
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _isLoading ? null : _resendOtp,
            child: const Text('Resend Code'),
          ),
        ),
      ],
    );
  }

  Widget _buildPinStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter your PIN to confirm',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _pinController,
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 5,
          decoration: const InputDecoration(
             hintText: '*****',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
             counterText: "",
          ),
          autofocus: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine brand color
    final isBkash = widget.paymentMethod == 'bkash';
    final brandColor = isBkash ? Colors.pink : Colors.blue[800]!;
    
    // Determine content based on step
    Widget content;
    String buttonText;

    switch (_currentStep) {
      case 0:
        content = _buildPhoneStep();
        buttonText = 'Send OTP';
        break;
      case 1:
        content = _buildOtpStep();
        buttonText = 'Verify OTP';
        break;
      case 2:
        content = _buildPinStep();
        buttonText = 'Confirm Payment';
        break;
      default:
        content = const SizedBox.shrink();
        buttonText = 'Next';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.paymentMethodTitle} Payment'),
        backgroundColor: brandColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Amount Summary
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: brandColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: brandColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    '৳${widget.amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: brandColor,
                    ),
                  ),
                  Text(
                    'Total Payable',
                    style: TextStyle(
                       color: brandColor.withOpacity(0.8),
                       fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (isBkash) 
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.payment, size: 16, color: Colors.pink),
                        SizedBox(width: 4),
                        Text('bKash Payment', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // Error Message
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Step Content
            Expanded(child: content),
            
            // Action Button
             SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isLoading ? null : _nextStep,
                 style: FilledButton.styleFrom(
                  backgroundColor: brandColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(buttonText, style: const TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
