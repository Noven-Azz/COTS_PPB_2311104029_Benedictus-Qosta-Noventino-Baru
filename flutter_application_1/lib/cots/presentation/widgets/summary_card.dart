import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../design_system/typography.dart';

/// Summary Card Widget (for Dashboard)
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;

  const SummaryCard({Key? key, required this.title, required this.value})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.title.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
