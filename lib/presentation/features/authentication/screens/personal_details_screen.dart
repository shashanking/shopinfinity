import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/app_strings.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../providers/auth_provider.dart';
import '../providers/personal_details_provider.dart';

class PersonalDetailsScreen extends ConsumerStatefulWidget {
  final bool isEnabled;
  final String? phoneNumber;

  const PersonalDetailsScreen({
    super.key,
    this.isEnabled = true,
    this.phoneNumber,
  });

  @override
  ConsumerState<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends ConsumerState<PersonalDetailsScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _secondaryPhoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _secondaryPhoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).register(
            phone: widget.phoneNumber ?? '',
            name: _nameController.text,
            email: _emailController.text,
            secondaryPhone: _secondaryPhoneController.text.isNotEmpty
                ? _secondaryPhoneController.text
                : null,
          );

      if (mounted) {
        context.go('/shop');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
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
    final personalDetails = ref.watch(personalDetailsProvider);
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          AppStrings.personalDetailsTitle,
          style: TextStyle(fontSize: 16, fontFamily: 'Lato'),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Almost there! Please fill in your details to complete registration.',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Lato',
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _nameController,
                label: AppStrings.nameLabel,
                hint: AppStrings.nameHint,
                enabled: widget.isEnabled,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                label: AppStrings.emailLabel,
                hint: AppStrings.emailHint,
                keyboardType: TextInputType.emailAddress,
                enabled: widget.isEnabled,
              ),
              const Spacer(),
              PrimaryButton(
                text: AppStrings.completeRegistration,
                onPressed: widget.isEnabled && !_isLoading ? _handleSubmit : () {},
                isEnabled: widget.isEnabled && !_isLoading,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
