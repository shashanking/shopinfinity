import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

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
          'About US',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shop Infinity - Demo App',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'This is a demonstration version of Shop Infinity, showcasing modern UI/UX design patterns for e-commerce applications. This app is intended to demonstrate the capabilities of Flutter in creating beautiful, responsive shopping experiences.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Features Demonstrated:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Modern, responsive UI design\n'
                  '• Category-based product browsing\n'
                  '• Shopping cart functionality\n'
                  '• Order management system\n'
                  '• Address management\n'
                  '• Search functionality with filters',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Note: This is a demonstration app. While the UI is fully functional, no real transactions or deliveries are processed.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
