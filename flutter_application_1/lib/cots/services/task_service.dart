import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';
import '../config/api_config.dart';

/// Task Service
/// Service untuk mengelola operasi CRUD tasks melalui Supabase REST API
class TaskService {
  /// GET - Ambil semua tasks
  Future<List<Task>> getAllTasks() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.tasksEndpoint}?select=*'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  /// GET - Ambil tasks berdasarkan status
  /// status: BERJALAN, SELESAI, TERLAMBAT
  Future<List<Task>> getTasksByStatus(String status) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}${ApiConfig.tasksEndpoint}?select=*&status=eq.$status',
        ),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load tasks by status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching tasks by status: $e');
    }
  }

  /// POST - Tambah task baru
  Future<Task> addTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.tasksEndpoint}'),
        headers: ApiConfig.headers,
        body: json.encode(task.toJson()),
      );

      if (response.statusCode == 201) {
        final List<dynamic> jsonData = json.decode(response.body);
        return Task.fromJson(jsonData.first);
      } else {
        throw Exception('Failed to add task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding task: $e');
    }
  }

  /// PATCH - Update task
  Future<Task> updateTask(int id, Map<String, dynamic> updates) async {
    try {
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.tasksEndpoint}?id=eq.$id'),
        headers: ApiConfig.headers,
        body: json.encode(updates),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return Task.fromJson(jsonData.first);
      } else {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }

  /// PATCH - Toggle task completion
  Future<Task> toggleTaskCompletion(int id, bool isDone) async {
    final updates = {
      'is_done': isDone,
      'status': isDone ? 'SELESAI' : 'BERJALAN',
    };
    return updateTask(id, updates);
  }

  /// PATCH - Update task note
  Future<Task> updateTaskNote(int id, String note) async {
    final updates = {'note': note};
    return updateTask(id, updates);
  }
}
