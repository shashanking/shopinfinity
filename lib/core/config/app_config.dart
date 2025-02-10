class AppConfig {
  static const String whatsappNumber = String.fromEnvironment(
    'WHATSAPP_NUMBER',
    defaultValue: '+919876543210', // Default number for development
  );
} 