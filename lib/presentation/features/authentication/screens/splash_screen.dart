import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/providers.dart';
import 'dart:developer' as dev;

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Show splash screen for minimum 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    try {
      final storage = ref.read(storageServiceProvider);
      final isLoggedIn = await storage.isLoggedIn();
      // dev.log('Splash: isLoggedIn = $isLoggedIn', name: 'SplashScreen');

      if (!mounted) return;

      if (isLoggedIn) {
        // dev.log('Splash: Navigating to shop', name: 'SplashScreen');
        context.go('/shop');
      } else {
        final prefs = await SharedPreferences.getInstance();
        final hasLaunchedBefore = prefs.getBool('has_launched_before') ?? false;

        if (!mounted) return;

        if (!hasLaunchedBefore) {
          await prefs.setBool('has_launched_before', true);
        }
        // dev.log('Splash: Navigating to welcome', name: 'SplashScreen');
        context.go('/welcome');
      }
    } catch (e) {
      dev.log('Splash: Error during initialization: $e', name: 'SplashScreen');
      if (!mounted) return;
      context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_splash.png',
              scale: 2,
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
