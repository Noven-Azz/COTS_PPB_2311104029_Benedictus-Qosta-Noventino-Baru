import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../design_system/typography.dart';
import '../widgets/app_button.dart';
import '../widgets/app_checkbox.dart';
import '../../models/task.dart';
import '../../controllers/task_controller.dart';

/// Screen 3 - Detail Tugas
class DetailTugasPage extends StatefulWidget {
  final Task task;

  const DetailTugasPage({Key? key, required this.task}) : super(key: key);

  @override
  State<DetailTugasPage> createState() => _DetailTugasPageState();
}

class _DetailTugasPageState extends State<DetailTugasPage> {
  final TaskController _controller = TaskController();
  final TextEditingController _noteController = TextEditingController();

  late Task _currentTask;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
    _noteController.text = _currentTask.note ?? '';
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _toggleCompletion(bool? value) async {
    if (value == null || _currentTask.id == null) return;

    try {
      final updatedTask = await _controller.toggleTaskCompletion(
        _currentTask.id!,
        value,
      );

      setState(() {
        _currentTask = updatedTask;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              value ? 'Tugas ditandai selesai' : 'Tugas dibuka kembali',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _saveNote() async {
    if (_currentTask.id == null) return;

    setState(() => _isSaving = true);

    try {
      final updatedTask = await _controller.updateTaskNote(
        _currentTask.id!,
        _noteController.text,
      );

      setState(() {
        _currentTask = updatedTask;
        _isSaving = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Catatan berhasil disimpan')),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Color _getStatusColor() {
    switch (_currentTask.status) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Detail Tugas', style: AppTypography.title),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              // Navigate to Edit page
              final result = await Navigator.pushNamed(
                context,
                '/edit-tugas',
                arguments: _currentTask,
              );

              // Refresh data if task was updated
              if (result != null && result is Task) {
                setState(() {
                  _currentTask = result;
                  _noteController.text = _currentTask.note ?? '';
                });
              }
            },
            child: Text(
              'Edit',
              style: AppTypography.body.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Info Card (White Background)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Section
                  Text(
                    'Judul Tugas',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _currentTask.title,
                    style: AppTypography.body.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Course Section
                  Text(
                    'Mata Kuliah',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _currentTask.course,
                    style: AppTypography.body.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Deadline Section
                  Text(
                    'Deadline',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _formatDate(_currentTask.deadline),
                    style: AppTypography.body.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Status Section
                  Text(
                    'Status',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _currentTask.status == 'BERJALAN'
                            ? 'Berjalan'
                            : _currentTask.status == 'SELESAI'
                            ? 'Selesai'
                            : _currentTask.status == 'TERLAMBAT'
                            ? 'Terlambat'
                            : _currentTask.status,
                        style: AppTypography.body.copyWith(
                          color: AppColors.surface,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Penyelesaian Section (Background follows page color)
            Text(
              'Penyelesaian',
              style: AppTypography.title.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppCheckbox(
              label: 'Tugas sudah selesai',
              value: _currentTask.isDone,
              onChanged: _toggleCompletion,
              subtitle: 'Centang jika tugas sudah final.',
            ),
            const SizedBox(height: AppSpacing.xl),

            // Catatan Section (Background follows page color)
            Text(
              'Catatan',
              style: AppTypography.title.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Catatan Content (White Background, Read-only)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              ),
              child: Text(
                _currentTask.note ??
                    'Pisahkan Controller, Service, dan Config untuk konsumsi API.',
                style: AppTypography.body.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Save Button
            AppButton(
              text: 'Simpan Perubahan',
              onPressed: _saveNote,
              isDisabled: _isSaving,
            ),
          ],
        ),
      ),
    );
  }
}
