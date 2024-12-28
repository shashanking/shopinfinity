import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/app_strings.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../providers/personal_details_provider.dart';

class PersonalDetailsScreen extends ConsumerStatefulWidget {
  final bool isEnabled;

  const PersonalDetailsScreen({super.key, this.isEnabled = true});

  @override
  ConsumerState<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends ConsumerState<PersonalDetailsScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
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
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CustomTextField(
                      label: AppStrings.nameLabel,
                      hint: AppStrings.nameHint,
                      controller: _nameController,
                      enabled: widget.isEnabled,
                      errorText: personalDetails.nameError,
                      style: const TextStyle(fontSize: 16, fontFamily: 'Lato'),
                      onChanged: (value) {
                        ref.read(personalDetailsProvider.notifier).updateName(value.trim());
                      },
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: AppStrings.emailLabel,
                      hint: AppStrings.emailHint,
                      controller: _emailController,
                      errorText: personalDetails.emailError,
                      keyboardType: TextInputType.emailAddress,
                      enabled: widget.isEnabled,
                      style: const TextStyle(fontSize: 16, fontFamily: 'Lato'),
                      onChanged: (value) {
                        ref.read(personalDetailsProvider.notifier).updateEmail(value.trim());
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                height: 122,
                color: Colors.white,
                child: Column(
                  children: [
                    if (widget.isEnabled)
                      PrimaryButton(
                        text: AppStrings.continueButton,
                        onPressed: () => context.go('/shop'),
                        isEnabled: personalDetails.isValid,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
