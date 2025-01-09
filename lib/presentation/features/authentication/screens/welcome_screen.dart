import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/app_strings.dart';
import '../../../shared/widgets/primary_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _handleGetStarted(BuildContext context) {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.welcomeTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  AppStrings.welcomeSubtitle,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 40),
                PrimaryButton(
                  text: AppStrings.continueButton,
                  onPressed: () {
                    _handleGetStarted(context);
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
