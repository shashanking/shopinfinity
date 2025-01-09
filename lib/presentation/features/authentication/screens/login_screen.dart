import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopinfinity/core/network/api_exception.dart';
import '../../../shared/constants/app_strings.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp() async {
    if (_phoneController.text.isEmpty || _phoneController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      dev.log('Sending OTP for phone: ${_phoneController.text}', name: 'LoginScreen');
      final response = await ref.read(authProvider.notifier).sendOtp(_phoneController.text);
      dev.log('Send OTP response: ${response?.toJson()}', name: 'LoginScreen');
      
      if (mounted) {
        if (response?.statusCode == 200) {
          context.replace('/otp', extra: _phoneController.text);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response?.errorMessage ?? 'Failed to send OTP. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e, stack) {
      dev.log('Error sending OTP: $e\n$stack', name: 'LoginScreen', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e is ApiException ? e.message : 'Failed to send OTP. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 430,
        height: 932,
        color: const Color(0xFFFCFCFC),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      "Your Favorites, Delivered Fast!",
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Enter your phone number to receive an OTP.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Lato',
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomTextField(
                      controller: _phoneController,
                      label: AppStrings.phoneNumberHint,
                      hint: AppStrings.phoneNumberHint,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      prefix: '+91 ',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const Spacer(),
                    PrimaryButton(
                      text: AppStrings.continueText,
                      onPressed: _isLoading ? () {} : _handleSendOtp,
                      isEnabled: !_isLoading,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
