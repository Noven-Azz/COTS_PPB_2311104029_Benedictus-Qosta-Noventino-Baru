# 📋 Quick Reference Guide - Task Manager App

## File Structure Summary

### ✅ Design System (lib/cots/design_system/)

- `colors.dart` - Color palette sesuai design (#2F6BFF, #F7F8FA, dll)
- `typography.dart` - Text styles (Title 20, Section 16, Body 14, Caption 12, Button 14)
- `spacing.dart` - Spacing constants (8pt grid, radius 12, padding 16, height 48)

### ✅ Models (lib/cots/models/)

- `task.dart` - Task model dengan fields: id, title, course, deadline, status, note, isDone

### ✅ Config & Services (lib/cots/config/, lib/cots/services/)

- `api_config.dart` - Base URL dan headers Supabase
- `task_service.dart` - HTTP service untuk GET/POST/PATCH tasks

### ✅ Controllers (lib/cots/controllers/)

- `task_controller.dart` - Business logic dan validasi
- `task_provider.dart` - Provider untuk state management (optional)

### ✅ Widgets (lib/cots/presentation/widgets/)

- `app_button.dart` - Custom button (primary/outline)
- `app_input.dart` - Custom text input dengan validation
- `app_checkbox.dart` - Custom checkbox
- `task_card.dart` - Card untuk menampilkan task
- `summary_card.dart` - Card untuk summary di dashboard

### ✅ Pages (lib/cots/presentation/pages/)

1. `dashboard_page.dart` - Screen 1: Beranda
2. `daftar_tugas_page.dart` - Screen 2: Daftar Tugas
3. `detail_tugas_page.dart` - Screen 3: Detail Tugas
4. `tambah_tugas_page.dart` - Screen 4: Tambah Tugas

## API Endpoints Quick Reference

```dart
// GET all tasks
GET /rest/v1/tasks?select=*

// GET by status
GET /rest/v1/tasks?select=*&status=eq.BERJALAN
GET /rest/v1/tasks?select=*&status=eq.SELESAI
GET /rest/v1/tasks?select=*&status=eq.TERLAMBAT

// POST new task
POST /rest/v1/tasks
Body: {
  "title": "string",
  "course": "string",
  "deadline": "2026-01-18",
  "status": "BERJALAN",
  "note": "string",
  "is_done": false
}

// PATCH update task
PATCH /rest/v1/tasks?id=eq.1
Body: {
  "note": "updated note",
  "is_done": true,
  "status": "SELESAI"
}
```

## Navigation Routes

```dart
Navigator.pushNamed(context, '/');              // Dashboard
Navigator.pushNamed(context, '/daftar-tugas'); // Daftar Tugas
Navigator.pushNamed(context, '/tambah-tugas'); // Tambah Tugas
Navigator.pushNamed(context, '/detail-tugas', arguments: task); // Detail
```

## State Management Options

### Option 1: Local State (setState) ✓ Currently Used

```dart
setState(() {
  _tasks = updatedTasks;
});
```

### Option 2: Provider (Available, Not Active)

```dart
// To activate, wrap main.dart MaterialApp with:
ChangeNotifierProvider(
  create: (context) => TaskProvider(),
  child: MaterialApp(...)
)

// Then use in widgets:
final provider = Provider.of<TaskProvider>(context);
await provider.loadTasks();
```

## Common Tasks

### Load Data

```dart
final controller = TaskController();
final tasks = await controller.getAllTasks();
```

### Add Task

```dart
final newTask = Task(
  title: "New Task",
  course: "Pemrograman Lanjut",
  deadline: "2026-01-18",
  status: "BERJALAN",
  isDone: false,
);
await controller.addTask(newTask);
```

### Update Task

```dart
await controller.updateTaskNote(taskId, "Updated note");
await controller.toggleTaskCompletion(taskId, true);
```

### Validation

```dart
// In form
validator: controller.validateTitle,
validator: controller.validateCourse,
validator: controller.validateDeadline,
```

## Design System Usage

```dart
// Colors
AppColors.primary
AppColors.background
AppColors.surface
AppColors.textPrimary
AppColors.danger
AppColors.success

// Typography
AppTypography.title
AppTypography.section
AppTypography.body
AppTypography.caption
AppTypography.button

// Spacing
AppSpacing.sm   // 8
AppSpacing.md   // 12
AppSpacing.lg   // 16
AppSpacing.xl   // 24
AppSpacing.buttonHeight  // 48
AppSpacing.radiusMedium  // 12
```

## Widget Usage Examples

### AppButton

```dart
AppButton(
  text: 'Simpan',
  onPressed: () => _saveTask(),
  isDisabled: _isSaving,
)

AppButton(
  text: 'Batal',
  onPressed: () => Navigator.pop(context),
  isOutline: true,
)
```

### AppInput

```dart
AppInput(
  label: 'Judul Tugas',
  hint: 'Masukkan judul tugas',
  controller: _titleController,
  validator: controller.validateTitle,
)
```

### TaskCard

```dart
TaskCard(
  task: task,
  onTap: () {
    Navigator.pushNamed(context, '/detail-tugas', arguments: task);
  },
)
```

## Troubleshooting

### API Not Working?

- Check internet connection
- Verify Supabase URL and API key in `api_config.dart`
- Check API response in debug console

### Navigation Error?

- Ensure task is passed as argument for `/detail-tugas` route
- Check route names match exactly

### Form Validation Not Working?

- Ensure `_formKey.currentState!.validate()` is called
- Check validator functions return null for valid input

## Run Commands

```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Build APK
flutter build apk --release

# Clean build
flutter clean
flutter pub get
flutter run
```

## Checklist Before Submission

- [ ] All 4 pages implemented and working
- [ ] Navigation flows correctly between pages
- [ ] API integration working (GET, POST, PATCH)
- [ ] Form validation functional
- [ ] Design matches mockup
- [ ] setState or Provider used for state management
- [ ] Error handling implemented
- [ ] No compilation errors
- [ ] App runs without crashes

---

🎉 **All features implemented successfully!**
