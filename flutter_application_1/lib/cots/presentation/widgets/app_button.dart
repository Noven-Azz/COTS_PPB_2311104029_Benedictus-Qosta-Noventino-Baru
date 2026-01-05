import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../design_system/typography.dart';

/// Custom Button Widget
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isOutline;
  final bool isDisabled;
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isOutline = false,
    this.isDisabled = false,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.buttonHeight,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutline
              ? Colors.transparent
              : (backgroundColor ?? AppColors.primary),
          foregroundColor: isOutline
              ? AppColors.primary
              : (textColor ?? AppColors.surface),
          side: isOutline
              ? const BorderSide(color: AppColors.primary, width: 1)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          elevation: isOutline ? 0 : 2,
          disabledBackgroundColor: AppColors.primary.withOpacity(
            AppColors.disabledOpacity,
          ),
        ),
        child: Text(
          text,
          style: AppTypography.button.copyWith(
            color: isOutline
                ? AppColors.primary
                : (textColor ?? AppColors.surface),
          ),
        ),
      ),
    );
  }
}
