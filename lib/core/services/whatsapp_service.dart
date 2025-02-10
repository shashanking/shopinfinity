import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as dev;

class WhatsAppService {
  static Future<void> openWhatsAppChat(String phoneNumber,
      {String message = ''}) async {
    try {
      // Format the phone number (remove any spaces, dashes, or other characters)
      final formattedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

      // Create the WhatsApp URL
      final whatsappUrl = Uri.parse(
          'whatsapp://send?phone=$formattedNumber${message.isNotEmpty ? '&text=${Uri.encodeComponent(message)}' : ''}');

      // Check if WhatsApp is installed
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl);
      } else {
        // If WhatsApp is not installed, try opening in browser
        final webWhatsappUrl = Uri.parse(
            'https://wa.me/$formattedNumber${message.isNotEmpty ? '?text=${Uri.encodeComponent(message)}' : ''}');
        if (await canLaunchUrl(webWhatsappUrl)) {
          await launchUrl(webWhatsappUrl);
        } else {
          throw 'Could not launch WhatsApp';
        }
      }
    } catch (e) {
      dev.log('Error opening WhatsApp: $e', name: 'WhatsAppService');
      rethrow;
    }
  }
}
