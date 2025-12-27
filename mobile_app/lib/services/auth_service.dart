import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  /// Register a new user
  /// Returns: Map with 'success' (bool) and 'message' or 'token' (String)
  Future<Map<String, dynamic>> register({
    required String phone,
    required String pin,
  }) async {
    // SIMULATION: Mock Registration
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    final token = 'mock_token_$phone';
    await saveToken(token);
    return {
      'success': true,
      'token': token,
      'message': 'Simulation: Registration Successful!',
    };
  }

  /// Login user
  /// Returns: Map with 'success' (bool) and 'message' or 'token' (String)
  Future<Map<String, dynamic>> login({
    required String phone,
    required String pin,
  }) async {
    // SIMULATION: Mock Login
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    final token = 'mock_token_$phone';
    await saveToken(token);
    return {
      'success': true,
      'token': token,
      'message': 'Simulation: Login Successful!',
    };
  }

  /// Send OTP to phone (Mocked)
  Future<bool> sendOtp(String phone) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return true;
  }

  /// Verify OTP (Mocked)
  Future<bool> verifyOtp(String phone, String otp) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return true; // Accept any OTP
  }

  /// Save JWT token to local storage
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Get saved JWT token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) ?? 'mock_token_12345'; // Return mock token if null for testing
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Logout user (clear token)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
  }

  /// Get user profile
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Not authenticated',
        };
      }

      final response = await http.get(
        Uri.parse(ApiConfig.profileUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'profile': data,
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['error'] ?? 'Failed to get profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}
