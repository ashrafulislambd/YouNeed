import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'auth_service.dart';

class KYCService {
  final AuthService _authService = AuthService();

  /// Submit KYC document
  /// Returns: Map with 'success' (bool) and 'message' or 'data' (Map)
  Future<Map<String, dynamic>> submitKYC({
    required String type, // "NID" or "PASSPORT"
    required String documentNumber,
    required Uint8List imageBytes,
    required String filename,
  }) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Not authenticated. Please login first.',
        };
      }

      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.kycSubmitUrl),
      );

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';

      // Add form fields
      request.fields['type'] = type;
      request.fields['document_number'] = documentNumber;

      // Add image file from bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'images',
        imageBytes,
        filename: filename,
      );
      request.files.add(multipartFile);

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': 'KYC submitted successfully',
          'data': data,
        };
      } else if (response.statusCode == 409) {
        return {
          'success': false,
          'message': 'KYC request already exists for this user',
        };
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['error'] ?? 'Invalid document or image rejected',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Authentication failed. Please login again.',
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['error'] ?? 'KYC submission failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Get KYC status
  /// Returns: Map with 'success' (bool) and 'message' or 'data' (Map)
  Future<Map<String, dynamic>> getKYCStatus() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Not authenticated. Please login first.',
        };
      }

      final response = await http.get(
        Uri.parse(ApiConfig.kycStatusUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'No KYC record found',
          'notFound': true,
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Authentication failed. Please login again.',
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['error'] ?? 'Failed to get KYC status',
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
