import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      context.go('/welcome');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   AppStrings.appName,
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 48,
            //     fontWeight: FontWeight.w700,
            //     fontFamily: 'Lato',
            //     height: 1.2,
            //     letterSpacing: 0.5,
            //   ),
            // ),
            // SizedBox(height: 8),
            // Text(
            //   AppStrings.appTagline,
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 16,
            //     fontWeight: FontWeight.w400,
            //     fontFamily: 'Lato',
            //   ),
            // ),

            //image from assets
            Image.asset('assets/images/logo_splash.png', scale: 2),
          ],
        ),
      ),
    );
  }
}
