class ApiConfig {
  // Base URLs for microservices
  static const String authBaseUrl = 'http://localhost:8080';
  static const String kycBaseUrl = 'http://localhost:8081';
  static const String otpBaseUrl = 'http://localhost:8084';
  
  // Auth endpoints
  static const String registerEndpoint = '/auth/register';
  static const String loginEndpoint = '/auth/login';
  static const String profileEndpoint = '/profile';
  
  // KYC endpoints
  static const String kycSubmitEndpoint = '/kyc/submit';
  static const String kycStatusEndpoint = '/kyc/status';

  // OTP endpoints
  static const String otpSendEndpoint = '/otp/send';
  static const String otpVerifyEndpoint = '/otp/verify';
  
  // Full URLs
  static String get registerUrl => '$authBaseUrl$registerEndpoint';
  static String get loginUrl => '$authBaseUrl$loginEndpoint';
  static String get profileUrl => '$authBaseUrl$profileEndpoint';
  static String get kycSubmitUrl => '$kycBaseUrl$kycSubmitEndpoint';
  static String get kycStatusUrl => '$kycBaseUrl$kycStatusEndpoint';
  static String get otpSendUrl => '$otpBaseUrl$otpSendEndpoint';
  static String get otpVerifyUrl => '$otpBaseUrl$otpVerifyEndpoint';
}
