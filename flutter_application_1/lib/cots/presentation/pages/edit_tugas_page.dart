import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../design_system/typography.dart';
import '../widgets/app_button.dart';
import '../widgets/app_input.dart';
import '../widgets/app_checkbox.dart';
import '../../models/task.dart';
import '../../controllers/task_controller.dart';

/// Screen - Edit Tugas
class EditTugasPage extends StatefulWidget {
  final Task task;

  const EditTugasPage({Key? key, required this.task}) : super(key: key);

  @override
  State<EditTugasPage> createState() => _EditTugasPageState();
}

class _EditTugasPageState extends State<EditTugasPage> {
  final TaskController _controller = TaskController();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _noteController;

  String? _selectedCourse;
  DateTime? _selectedDeadline;
  bool _isDone = false;
  bool _isSaving = false;

  final List<String> _courses = [
    'Pemrograman Lanjut',
    'Rekayasa Perangkat Lunak',
    'UI Engineering',
    'Metodologi Penelitian',
    'KKN Tematik',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill form dengan data task yang ada
    _titleController = TextEditingController(text: widget.task.title);
    _noteController = TextEditingController(text: widget.task.note ?? '');

    // Set selectedCourse only if it exists in the courses list
    if (_courses.contains(widget.task.course)) {
      _selectedCourse = widget.task.course;
    }

    _isDone = widget.task.isDone;

    // Parse deadline dari string ke DateTime
    try {
      final parts = widget.task.deadline.split('-');
      _selectedDeadline = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    } catch (e) {
      _selectedDeadline = DateTime.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDeadline = picked;
      });
    }
  }

  Future<void> _updateTask() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua field yang wajib')),
      );
      return;
    }

    if (_selectedCourse == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mohon pilih mata kuliah')));
      return;
    }

    if (_selectedDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih tanggal deadline')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Format deadline as YYYY-MM-DD
      final deadlineStr =
          '${_selectedDeadline!.year}-${_selectedDeadline!.month.toString().padLeft(2, '0')}-${_selectedDeadline!.day.toString().padLeft(2, '0')}';

      // Prepare updates map
      final updates = {
        'title': _titleController.text.trim(),
        'course': _selectedCourse!,
        'deadline': deadlineStr,
        'status': _isDone ? 'SELESAI' : 'BERJALAN',
        'note': _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        'is_done': _isDone,
      };

      final updatedTask = await _controller.updateTask(
        widget.task.id!,
        updates,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tugas berhasil diperbarui')),
        );
        Navigator.pop(context, updatedTask); // Return updated task
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

  String _formatDate(DateTime date) {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
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
        title: Text('Edit Tugas', style: AppTypography.title),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // White Container for Form
              Container(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Input
                    AppInput(
                      label: 'Judul Tugas',
                      hint: 'Masukkan judul tugas',
                      controller: _titleController,
                      validator: _controller.validateTitle,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Course Dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mata Kuliah',
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMedium,
                            ),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedCourse,
                            hint: Text(
                              'Pilih mata kuliah',
                              style: AppTypography.input.copyWith(
                                color: AppColors.muted,
                              ),
                            ),
                            items: _courses.map((course) {
                              return DropdownMenuItem(
                                value: course,
                                child: Text(course, style: AppTypography.input),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCourse = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.md,
                              ),
                            ),
                            icon: const Icon(Icons.arrow_drop_down),
                            dropdownColor: AppColors.surface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Deadline Picker
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deadline',
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        InkWell(
                          onTap: _selectDeadline,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMedium,
                              ),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _selectedDeadline == null
                                        ? 'Pilih tanggal'
                                        : _formatDate(_selectedDeadline!),
                                    style: AppTypography.input.copyWith(
                                      color: _selectedDeadline == null
                                          ? AppColors.muted
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  color: AppColors.textSecondary,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Completion Checkbox
                    AppCheckbox(
                      label: 'Tugas sudah selesai',
                      value: _isDone,
                      onChanged: (value) {
                        setState(() {
                          _isDone = value ?? false;
                        });
                      },
                      subtitle: null,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Notes Input
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Catatan',
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: _noteController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Catatan tambahan (opsional)',
                            hintStyle: AppTypography.input.copyWith(
                              color: AppColors.muted,
                            ),
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMedium,
                              ),
                              borderSide: const BorderSide(
                                color: AppColors.border,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMedium,
                              ),
                              borderSide: const BorderSide(
                                color: AppColors.border,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMedium,
                              ),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(AppSpacing.md),
                          ),
                          style: AppTypography.input,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Buttons Row
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Batal',
                      onPressed: () => Navigator.pop(context),
                      isOutline: true,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppButton(
                      text: 'Simpan',
                      onPressed: _updateTask,
                      isDisabled: _isSaving,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
