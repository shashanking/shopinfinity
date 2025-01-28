class ApiConfig {
  static const String baseUrl =
      'https://server.mitraconsultancy.co.in'; // Production URL
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 60000; // 60 seconds

  // API Endpoints
  static const String loginPrefix = '/login/v1';
  static const String productPrefix = '/v1/product';
  static const String orderPrefix = '/v1/order';
  static const String cartPrefix = '/v1/cart';

  // Auth Endpoints
  static const String sendOtp = '$loginPrefix/send-otp';
  static const String verifyOtp = '$loginPrefix/verify-otp';
  static const String logout = '$loginPrefix/logout';
  static const String login = '$loginPrefix/login';
  static const String register =
      '$loginPrefix/signup'; // Changed from register to signup
  static const String fetchUserProfile = '$loginPrefix/profile/user/fetch';

  // Product Endpoints
  static const String listProducts = '/v1/product/list'; // Corrected endpoint
  static const String addProduct = '$productPrefix/add';
  static const String deleteProduct = '$productPrefix/delete';

  // Cart Endpoints
  static const String fetchCart = '$cartPrefix/list';
  static const String updateCart = '$cartPrefix/create-or-update';

  // Order Endpoints
  static const String createOrder = '$orderPrefix/create';
  static const String updateOrder = '$orderPrefix/update';
  static const String cancelOrder = '$orderPrefix/cancel';
  static const String fetchOrders = '$orderPrefix/fetch';
}
