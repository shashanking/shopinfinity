import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/app_strings.dart';
import '../../../shared/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _handleVerifyOtp() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      dev.log('Verifying OTP for phone: ${widget.phoneNumber}', name: 'OtpScreen');
      final authNotifier = ref.read(authProvider.notifier);
      final response = await authNotifier.verifyOtp(widget.phoneNumber, otp);
      
      if (!mounted) return;

      if (response?.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response?.errorMessage ?? 'Invalid OTP. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        // Clear OTP fields on error
        for (var controller in _controllers) {
          controller.clear();
        }
        if (_focusNodes.isNotEmpty) {
          _focusNodes[0].requestFocus();
        }
        return;
      }

      // Check if user exists
      if (response?.responseBody?.existing == true) {
        // For existing users, we expect a token
        if (response?.responseBody?.token == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid response for existing user. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        // Existing user, go to shop
        dev.log('Existing user, navigating to shop', name: 'OtpScreen');
        if (mounted) {
          context.go('/shop');
        }
      } else {
        // New user, proceed to personal details
        // For new users, we don't expect a token yet
        dev.log('New user, navigating to personal details', name: 'OtpScreen');
        if (mounted) {
          context.push('/personal-details', extra: widget.phoneNumber);
        }
      }
    } catch (e, stack) {
      dev.log('OTP verification error: $e\n$stack', name: 'OtpScreen', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP verification failed: ${e.toString()}'),
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

  Future<void> _handleResendOtp() async {
    setState(() => _isLoading = true);
    try {
      final response = await ref.read(authProvider.notifier).sendOtp(widget.phoneNumber);
      if (!mounted) return;

      if (response?.statusCode == 200) {
        // Clear OTP fields
        for (var controller in _controllers) {
          controller.clear();
        }
        if (_focusNodes.isNotEmpty) {
          _focusNodes[0].requestFocus();
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response?.errorMessage ?? 'Failed to send OTP. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppStrings.otpVerificationTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                AppStrings.otpMessage,
                style: TextStyle(fontSize: 16, fontFamily: 'Lato'),
              ),
              const SizedBox(height: 8),
              Text(
                widget.phoneNumber,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lato',
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => SizedBox(
                    width: 64,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 24),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          _focusNodes[index + 1].requestFocus();
                        }
                      },
                    ),
                  ),
                ),
              ),
              const Spacer(),
              PrimaryButton(
                text: AppStrings.verifyOtp,
                onPressed: _isLoading ? () {} : _handleVerifyOtp,
                isEnabled: !_isLoading,
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: _isLoading ? null : _handleResendOtp,
                  child: const Text(
                    AppStrings.resendOtp,
                    style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'Lato',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
