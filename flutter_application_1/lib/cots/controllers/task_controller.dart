import '../services/task_service.dart';
import '../models/task.dart';

/// Task Controller
/// Controller untuk mengelola logika bisnis terkait tasks
class TaskController {
  final TaskService _service = TaskService();

  /// Get all tasks
  Future<List<Task>> getAllTasks() async {
    return await _service.getAllTasks();
  }

  /// Get tasks by status
  Future<List<Task>> getTasksByStatus(String status) async {
    return await _service.getTasksByStatus(status);
  }

  /// Add new task
  Future<Task> addTask(Task task) async {
    return await _service.addTask(task);
  }

  /// Update task
  Future<Task> updateTask(int id, Map<String, dynamic> updates) async {
    return await _service.updateTask(id, updates);
  }

  /// Toggle task completion
  Future<Task> toggleTaskCompletion(int id, bool isDone) async {
    return await _service.toggleTaskCompletion(id, isDone);
  }

  /// Update task note
  Future<Task> updateTaskNote(int id, String note) async {
    return await _service.updateTaskNote(id, note);
  }

  /// Validate task input
  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Judul tugas wajib diisi';
    }
    return null;
  }

  String? validateCourse(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mata kuliah wajib dipilih';
    }
    return null;
  }

  String? validateDeadline(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Deadline wajib dipilih';
    }
    return null;
  }
}
