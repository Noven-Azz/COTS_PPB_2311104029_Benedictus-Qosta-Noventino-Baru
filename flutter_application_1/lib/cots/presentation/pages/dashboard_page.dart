import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../design_system/typography.dart';
import '../widgets/summary_card.dart';
import '../widgets/task_card.dart';
import '../../models/task.dart';
import '../../controllers/task_controller.dart';

/// Screen 1 - Beranda (Dashboard)
class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TaskController _controller = TaskController();
  bool _isLoading = true;
  List<Task> _allTasks = [];
  List<Task> _completedTasks = [];
  List<Task> _nearestTasks = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final allTasks = await _controller.getAllTasks();
      final completedTasks = await _controller.getTasksByStatus('SELESAI');

      // Get nearest 3 tasks (not completed)
      final nearestTasks = allTasks
          .where((task) => task.status != 'SELESAI')
          .take(3)
          .toList();

      setState(() {
        _allTasks = allTasks;
        _completedTasks = completedTasks;
        _nearestTasks = nearestTasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.xl),
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tugas Besar', style: AppTypography.title),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/daftar-tugas',
                            ).then((_) => _loadData());
                          },
                          child: Text(
                            'Daftar Tugas',
                            style: AppTypography.body.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Summary Cards
                    Row(
                      children: [
                        Expanded(
                          child: SummaryCard(
                            title: 'Total Tugas',
                            value: '${_allTasks.length}',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: SummaryCard(
                            title: 'Selesai',
                            value: '${_completedTasks.length}',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Tugas Terdekat Section
                    Text('Tugas Terdekat', style: AppTypography.section),
                    const SizedBox(height: AppSpacing.md),

                    // Task List
                    if (_nearestTasks.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          child: Text(
                            'Tidak ada tugas',
                            style: AppTypography.body.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      )
                    else
                      ..._nearestTasks.map(
                        (task) => TaskCard(
                          task: task,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/detail-tugas',
                              arguments: task,
                            ).then((_) => _loadData());
                          },
                        ),
                      ),

                    const SizedBox(height: AppSpacing.xl),

                    // Add Task Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/tambah-tugas',
                        ).then((_) => _loadData());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: Size(
                          double.infinity,
                          AppSpacing.buttonHeight,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMedium,
                          ),
                        ),
                      ),
                      child: Text('Tambah Tugas', style: AppTypography.button),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
