import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../design_system/typography.dart';
import '../../models/task.dart';

/// Task Card Widget
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskCard({Key? key, required this.task, this.onTap}) : super(key: key);

  Color _getStatusColor() {
    switch (task.status) {
      case 'BERJALAN':
        return AppColors.primary;
      case 'SELESAI':
        return AppColors.success;
      case 'TERLAMBAT':
        return AppColors.danger;
      default:
        return AppColors.muted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Row(
            children: [
              // Colored Dot Indicator
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      task.course,
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Date
              Text(
                _formatDate(task.deadline),
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Arrow
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final parts = date.split('-');
      final day = parts[2];
      final month = _getMonthName(int.parse(parts[1]));
      final year = parts[0];
      return '$day $month $year';
    } catch (e) {
      return date;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return months[month - 1];
  }
}
