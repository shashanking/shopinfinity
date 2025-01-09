import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final String prefix;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final int? maxLength;

  const CustomTextField({
    super.key,
    this.label = '',
    required this.hint,
    this.prefix = '',
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.enabled = true,
    this.errorText,
    this.onChanged,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label.isEmpty
            ? const SizedBox.shrink()
            : Text(
                label,
                style: TextStyle(
                  color: enabled ? AppColors.textPrimary : AppColors.textGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Lato',
                ),
              ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          enabled: enabled,
          maxLength: maxLength,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Lato',
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            errorText: errorText,
            counterText: '',
            filled: true,
            fillColor: enabled ? AppColors.inputBackground : AppColors.inputDisabled,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
