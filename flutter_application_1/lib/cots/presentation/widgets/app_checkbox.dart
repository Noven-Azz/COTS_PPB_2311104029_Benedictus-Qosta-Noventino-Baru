import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';

/// Custom Checkbox Widget
class AppCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? subtitle;

  const AppCheckbox({
    Key? key,
    required this.label,
    required this.value,
    this.onChanged,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Text(label, style: AppTypography.body),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          : null,
      activeColor: AppColors.primary,
      checkColor: AppColors.surface,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
