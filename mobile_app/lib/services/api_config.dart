class ApiConfig {
  // Base URLs for microservices
  static const String authBaseUrl = 'http://localhost:8080';
  static const String kycBaseUrl = 'http://localhost:8081';
  
  // Auth endpoints
  static const String registerEndpoint = '/auth/register';
  static const String loginEndpoint = '/auth/login';
  static const String profileEndpoint = '/profile';
  
  // KYC endpoints
  static const String kycSubmitEndpoint = '/kyc/submit';
  static const String kycStatusEndpoint = '/kyc/status';
  
  // Full URLs
  static String get registerUrl => '$authBaseUrl$registerEndpoint';
  static String get loginUrl => '$authBaseUrl$loginEndpoint';
  static String get profileUrl => '$authBaseUrl$profileEndpoint';
  static String get kycSubmitUrl => '$kycBaseUrl$kycSubmitEndpoint';
  static String get kycStatusUrl => '$kycBaseUrl$kycStatusEndpoint';
}
