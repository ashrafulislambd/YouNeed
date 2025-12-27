import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'auth_service.dart';

class KYCService {
  final AuthService _authService = AuthService();

  /// Submit Dual KYC documents
  /// Returns: Map with 'success' (bool) and 'message' or 'data' (Map)
  Future<Map<String, dynamic>> submitDualKYC({
    required Map<String, dynamic> nidParams,
    required Map<String, dynamic> secondaryParams,
  }) async {
    // SIMULATION: Mock Submit
    await Future.delayed(const Duration(seconds: 2));
    
    return {
      'success': true,
      'message': 'Simulation: Dual KYC Documents Submitted!',
      'data': {'status': 'PENDING'},
    };
  }

  /// Submit KYC document (Deprecated, mostly replaced by dual)
  /// Returns: Map with 'success' (bool) and 'message' or 'data' (Map)
  Future<Map<String, dynamic>> submitKYC({
    required String type, // "NID" or "PASSPORT"
    required String documentNumber,
    required Uint8List imageBytes,
    required String filename,
  }) async {
    // SIMULATION: Mock Submit
    await Future.delayed(const Duration(seconds: 2));
    
    return {
      'success': true,
      'message': 'Simulation: KYC Document Submitted!',
      'data': {'status': 'PENDING'},
    };
  }

  /// Get KYC status
  /// Returns: Map with 'success' (bool) and 'message' or 'data' (Map)
  Future<Map<String, dynamic>> getKYCStatus() async {
    // SIMULATION: Mock Status
    // return {
    //   'success': true,
    //   'data': {'status': 'APPROVED', 'clarification': 'Verified on 2025-12-28'},
    // };
    
     await Future.delayed(const Duration(seconds: 1));
     
     // Randomly return different statuses for demo or just return Not Found initially
    return {
      'success': false,
      'message': 'No KYC record found',
      'notFound': true,
    };
  }
}
