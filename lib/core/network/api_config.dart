class ApiConfig {
  static const String baseUrl = 'https://api.kaserag.com'; // Production URL
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 60000; // 60 seconds

  // API Endpoints
  static const String loginPrefix = '/login/v1';
  static const String productPrefix = '/v1/product';
  static const String orderPrefix = '/v1/order';

  // Auth Endpoints
  static const String sendOtp = '$loginPrefix/send-otp';
  static const String verifyOtp = '$loginPrefix/verify-otp';
  static const String logout = '$loginPrefix/logout';
  static const String login = '$loginPrefix/login';
  static const String register = '$loginPrefix/signup';  // Changed from register to signup

  // Product Endpoints
  static const String listProducts = '/v1/product/list'; // Corrected endpoint
  static const String addProduct = '$productPrefix/add';
  static const String deleteProduct = '$productPrefix/delete';

  // Order Endpoints
  static const String createOrder = '$orderPrefix/create';
  static const String updateOrder = '$orderPrefix/update';
  static const String cancelOrder = '$orderPrefix/cancel';
  static const String fetchOrders = '$orderPrefix/fetch';
}
