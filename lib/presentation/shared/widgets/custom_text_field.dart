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
  final TextStyle style;
  final bool enabled;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.style,
    this.prefix = '',
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.enabled = true,
    this.errorText,
    this.onChanged,
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
          onChanged: onChanged,
          style: style,
          decoration: InputDecoration(
            prefix: prefix.isEmpty
                ? null
                : Text(
                    prefix,
                    style: style.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                    ),
                  ),
            hintText: hint,
            hintStyle: style.copyWith(color: AppColors.textGrey, fontSize: 16),
            filled: true,
            fillColor: enabled ? Colors.white : AppColors.background,
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : Colors.grey,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
