import 'package:flutter/material.dart';
import 'cots/presentation/pages/dashboard_page.dart';
import 'cots/presentation/pages/daftar_tugas_page.dart';
import 'cots/presentation/pages/detail_tugas_page.dart';
import 'cots/presentation/pages/tambah_tugas_page.dart';
import 'cots/presentation/pages/edit_tugas_page.dart';
import 'cots/models/task.dart';
import 'cots/design_system/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'SF Pro',
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const DashboardPage(),
            );
          case '/daftar-tugas':
            return MaterialPageRoute(
              builder: (context) => const DaftarTugasPage(),
            );
          case '/detail-tugas':
            final task = settings.arguments as Task;
            return MaterialPageRoute(
              builder: (context) => DetailTugasPage(task: task),
            );
          case '/tambah-tugas':
            return MaterialPageRoute(
              builder: (context) => const TambahTugasPage(),
            );
          case '/edit-tugas':
            final task = settings.arguments as Task;
            return MaterialPageRoute(
              builder: (context) => EditTugasPage(task: task),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const DashboardPage(),
            );
        }
      },
    );
  }
}
