import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../design_system/typography.dart';

/// Custom Input Widget
class AppInput extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final int maxLines;
  final bool isRequired;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AppInput({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.maxLines = 1,
    this.isRequired = false,
    this.keyboardType,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.input.copyWith(color: AppColors.muted),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              borderSide: const BorderSide(color: AppColors.danger),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
          ),
          style: AppTypography.input,
        ),
        if (isRequired)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              'Judul tugas wajib diisi',
              style: AppTypography.caption.copyWith(color: AppColors.danger),
            ),
          ),
      ],
    );
  }
}
