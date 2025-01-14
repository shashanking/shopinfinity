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
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/settings');
            }
          },
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
                  'Shop Infinity',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Welcome to Shop Infinity, your ultimate destination for groceries and daily essentials. We are more than just a shopping app; we are your reliable partner in simplifying your everyday needs. Operational in ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Our Mission',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'At Shop Infinity, we believe that convenience, quality, and affordability should go hand in hand. Our mission is to bring your favorite products to your doorstep with just a few taps, saving you time and effort. Whether it\'s fresh produce, household supplies, or your favorite snacks, we\'ve got it all covered.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Our Products',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'We take pride in curating a wide range of high-quality products to cater to every lifestyle and preference. From locally-sourced goods to trusted global brands, Shop Infinity ensures that you have access to everything you need, whenever you need it.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Our Journey',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Our journey started with a vision to make shopping hassle-free and enjoyable. Through innovative technology and a user-friendly interface, we\'ve created an app that\'s easy to navigate and efficient to use.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Customer Commitment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Customer satisfaction is at the heart of everything we do. We are committed to providing prompt deliveries, exceptional service, and a seamless shopping experience every time you use our app.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Thank you for choosing Shop Infinity as your trusted shopping companion. Together, let\'s redefine the way you shop for your everyday essentials!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                    fontStyle: FontStyle.italic,
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
