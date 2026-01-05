import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

/// Task Provider
/// State management using Provider pattern for managing tasks state
class TaskProvider extends ChangeNotifier {
  final TaskService _service = TaskService();

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Get all tasks count
  int get totalTasks => _tasks.length;

  /// Get completed tasks count
  int get completedTasksCount =>
      _tasks.where((task) => task.status == 'SELESAI').length;

  /// Get tasks by status
  List<Task> getTasksByStatus(String status) {
    if (status == 'Semua') return _tasks;
    return _tasks.where((task) => task.status == status.toUpperCase()).toList();
  }

  /// Load all tasks
  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _service.getAllTasks();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add new task
  Future<void> addTask(Task task) async {
    try {
      final newTask = await _service.addTask(task);
      _tasks.add(newTask);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Update task
  Future<void> updateTask(int id, Map<String, dynamic> updates) async {
    try {
      final updatedTask = await _service.updateTask(id, updates);
      final index = _tasks.indexWhere((task) => task.id == id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Toggle task completion
  Future<void> toggleTaskCompletion(int id, bool isDone) async {
    try {
      final updatedTask = await _service.toggleTaskCompletion(id, isDone);
      final index = _tasks.indexWhere((task) => task.id == id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Update task note
  Future<void> updateTaskNote(int id, String note) async {
    try {
      final updatedTask = await _service.updateTaskNote(id, note);
      final index = _tasks.indexWhere((task) => task.id == id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
