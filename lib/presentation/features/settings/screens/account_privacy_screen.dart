import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountPrivacyScreen extends StatelessWidget {
  const AccountPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF111827)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Account Privacy',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF111827),
                      ),
                      children: [
                        TextSpan(
                          text: 'At ',
                        ),
                        TextSpan(
                          text: 'Shop Infinity',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: ', we are dedicated to safeguarding your privacy and ensuring the security of your personal information. This policy explains how we collect, use, and protect your data when you create an account and use our app.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'When you create an account, we may collect personal details such as your name, email address, phone number, and delivery address. We also collect payment information, order details, and device information to ensure seamless service delivery and improve your app experience.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your data is used to manage your account, process orders, provide customer support, send updates, and enhance our app features. We may also use your information to comply with legal requirements and protect the security of our users.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'We do not sell or rent your personal information to third parties. However, we may share it with trusted service providers for payment processing, delivery services, or legal compliance.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'To ensure your data is secure, we use encryption, regular security audits, and access controls. Despite these measures, we urge you to keep your account credentials safe and report any unauthorized access immediately.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF111827),
                      ),
                      children: [
                        TextSpan(
                          text: 'You have the right to access, update, or delete your account information at any time. You can also opt out of promotional communications or request a copy of the data we hold about you by contacting us at ',
                        ),
                        TextSpan(
                          text: 'support@shopinfinity.com',
                          style: TextStyle(color: Color(0xFF4F46E5)),
                        ),
                        TextSpan(text: '.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'We retain your personal information for as long as necessary to provide our services or as required by law. If you choose to delete your account, we will remove your data as per our retention policies.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'From time to time, we may update this privacy policy to reflect changes in our services or legal requirements. Any updates will be communicated through email or app notifications.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF111827),
                      ),
                      children: [
                        TextSpan(
                          text: 'If you have any questions or concerns about this policy, please reach out to us at ',
                        ),
                        TextSpan(
                          text: 'support@shopinfinity.com',
                          style: TextStyle(color: Color(0xFF4F46E5)),
                        ),
                        TextSpan(text: ' or call us at '),
                        TextSpan(
                          text: '+1-800-555-1234',
                          style: TextStyle(color: Color(0xFF4F46E5)),
                        ),
                        TextSpan(text: '.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'By using Shop Infinity, you agree to the terms outlined in this policy. Thank you for trusting us with your information.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: TextButton(
                onPressed: () {
                  // TODO: Implement account deletion
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Delete Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
