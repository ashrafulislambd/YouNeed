import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

/// Service for sending and verifying OTPs via the backend OTP microservice.
/// The backend handles the actual delivery method (WhatsApp, console, etc.)
/// — the Flutter app is decoupled from the provider choice.
class OtpService {
  /// Sends an OTP to the given phone number.
  /// Returns a map with 'success' (bool) and 'message' (String).
  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.otpSendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'message': data['message'] ?? 'OTP sent'};
      } else {
        return {
          'success': false,
          'message': data['error'] ?? data['message'] ?? 'Failed to send OTP',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  /// Verifies the OTP code for the given phone number.
  /// Returns a map with 'verified' (bool) and 'message' (String).
  static Future<Map<String, dynamic>> verifyOtp(
    String phone,
    String code,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.otpVerifyUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'code': code}),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && data['verified'] == true) {
        return {'verified': true, 'message': data['message'] ?? 'Verified'};
      } else {
        return {
          'verified': false,
          'message':
              data['error'] ?? data['message'] ?? 'Verification failed',
        };
      }
    } catch (e) {
      return {'verified': false, 'message': 'Network error: $e'};
    }
  }
}
