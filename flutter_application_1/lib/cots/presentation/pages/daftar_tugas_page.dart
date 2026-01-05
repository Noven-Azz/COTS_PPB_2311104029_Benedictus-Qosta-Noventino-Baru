import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../design_system/typography.dart';
import '../widgets/task_card.dart';
import '../../models/task.dart';
import '../../controllers/task_controller.dart';

/// Screen 2 - Daftar Tugas
class DaftarTugasPage extends StatefulWidget {
  const DaftarTugasPage({Key? key}) : super(key: key);

  @override
  State<DaftarTugasPage> createState() => _DaftarTugasPageState();
}

class _DaftarTugasPageState extends State<DaftarTugasPage> {
  final TaskController _controller = TaskController();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String _selectedFilter = 'Semua';
  List<Task> _allTasks = [];
  List<Task> _filteredTasks = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final tasks = await _controller.getAllTasks();
      setState(() {
        _allTasks = tasks;
        _applyFilter();
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

  void _applyFilter() {
    List<Task> filtered = _allTasks;

    // Apply status filter
    if (_selectedFilter != 'Semua') {
      filtered = filtered
          .where((task) => task.status == _selectedFilter.toUpperCase())
          .toList();
    }

    // Apply search filter
    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (task) =>
                task.title.toLowerCase().contains(searchQuery) ||
                task.course.toLowerCase().contains(searchQuery),
          )
          .toList();
    }

    setState(() {
      _filteredTasks = filtered;
    });
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
        title: Text('Daftar Tugas', style: AppTypography.title),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/tambah-tugas',
              ).then((_) => _loadData());
            },
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppColors.primary,
              size: 20,
            ),
            label: Text(
              'Tambah',
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: Column(
                children: [
                  // Search & Filter Section
                  Container(
                    color: AppColors.surface,
                    padding: const EdgeInsets.all(AppSpacing.pagePadding),
                    child: Column(
                      children: [
                        // Search Bar
                        TextField(
                          controller: _searchController,
                          onChanged: (_) => _applyFilter(),
                          decoration: InputDecoration(
                            hintText: 'Cari tugas atau mata kuliah...',
                            hintStyle: AppTypography.input.copyWith(
                              color: AppColors.muted,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppColors.textSecondary,
                            ),
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMedium,
                              ),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Filter Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildFilterChip('Semua'),
                              _buildFilterChip('Berjalan'),
                              _buildFilterChip('Selesai'),
                              _buildFilterChip('Terlambat'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Task List
                  Expanded(
                    child: _filteredTasks.isEmpty
                        ? Center(
                            child: Text(
                              'Tidak ada tugas',
                              style: AppTypography.body.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(
                              AppSpacing.pagePadding,
                            ),
                            itemCount: _filteredTasks.length,
                            itemBuilder: (context, index) {
                              final task = _filteredTasks[index];
                              return TaskCard(
                                task: task,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/detail-tugas',
                                    arguments: task,
                                  ).then((_) => _loadData());
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    final statusMap = {
      'Semua': 'Semua',
      'Berjalan': 'BERJALAN',
      'Selesai': 'SELESAI',
      'Terlambat': 'TERLAMBAT',
    };

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = label;
            _applyFilter();
          });
        },
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        labelStyle: AppTypography.body.copyWith(
          color: isSelected ? AppColors.surface : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
      ),
    );
  }
}
