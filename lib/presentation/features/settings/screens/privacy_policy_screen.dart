import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy & Terms',
          style: TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lato',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Last updated: January 10, 2025',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Lato',
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Information We Collect',
              'We collect information you provide directly to us, including your name, phone number, email address, delivery addresses, and order history.',
            ),
            _buildSection(
              'How We Use Your Information',
              'We use the information we collect to process your orders, provide customer support, send you promotional messages (with your consent), and improve our services.',
            ),
            _buildSection(
              'Data Security',
              'We implement appropriate security measures to protect your personal information from unauthorized access, alteration, or disclosure.',
            ),
            const SizedBox(height: 32),
            const Text(
              'Terms & Conditions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lato',
              ),
            ),
            _buildSection(
              'Account Creation',
              'You must provide accurate and complete information when creating an account. You are responsible for maintaining the security of your account credentials.',
            ),
            _buildSection(
              'Order Placement',
              'By placing an order, you agree to pay the specified amount and provide accurate delivery information. We reserve the right to refuse or cancel orders at our discretion.',
            ),
            _buildSection(
              'Delivery',
              'Delivery times are estimates and may vary based on location and other factors. We are not responsible for delays caused by external circumstances.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Lato',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
              fontFamily: 'Lato',
            ),
          ),
        ],
      ),
    );
  }
}
