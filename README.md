# Task Manager App - Tugas Besar COTS

Aplikasi manajemen tugas yang terintegrasi dengan Supabase REST API untuk mengelola daftar tugas kuliah.

## 🎯 Fitur Utama

### 1. **Dashboard (Beranda)**

![alt text](image.png)

- Menampilkan ringkasan Total Tugas dan Tugas Selesai
- Menampilkan 3 tugas terdekat dengan status badge (Berjalan/Selesai/Terlambat)
- Navigasi cepat ke Daftar Tugas, Detail Tugas, dan Tambah Tugas

### 2. **Daftar Tugas**

![alt text](image-1.png)

- Filter tugas berdasarkan status: Semua, Berjalan, Selesai, Terlambat
- Pencarian tugas berdasarkan judul atau mata kuliah
- Navigasi ke Detail Tugas dan Tambah Tugas

### 3. **Detail Tugas**

![alt text](image-2.png)

- Melihat informasi lengkap tugas (judul, mata kuliah, deadline, status)
- Toggle checkbox untuk menandai tugas selesai/belum selesai
- Menambahkan atau mengedit catatan tugas
- Simpan perubahan ke database

### 4. **Tambah Tugas**

![alt text](image-3.png)

- Form input dengan validasi:
  - Judul Tugas (wajib)
  - Mata Kuliah (dropdown selection, wajib)
  - Deadline (date picker, wajib)
  - Checkbox tugas selesai
  - Catatan tambahan (opsional)
- Validasi input sebelum submit

### 5. **Edit Tugas**

![alt text](image-4.png)

- Edit tugas yang sudah ada dengan form yang sudah terisi otomatis
- Validasi data input sebelum update
- Update informasi tugas:
  - Judul Tugas
  - Mata Kuliah
  - Deadline
  - Status penyelesaian (checkbox)
  - Catatan
- Sinkronisasi perubahan dengan database
- Navigasi kembali ke Detail Tugas setelah berhasil update

## 🏗️ Arsitektur Proyek

Struktur folder mengikuti pola **COTS (Components Off-The-Shelf)**:

```
lib/
├── cots/
│   ├── design_system/          # Design tokens
│   │   ├── colors.dart         # Color palette
│   │   ├── typography.dart     # Text styles
│   │   └── spacing.dart        # Spacing & sizing
│   │
│   ├── models/                 # Data models
│   │   └── task.dart           # Task model
│   │
│   ├── presentation/           # UI Layer
│   │   ├── pages/              # Screens
│   │   │   ├── dashboard_page.dart
│   │   │   ├── daftar_tugas_page.dart
│   │   │   ├── detail_tugas_page.dart
│   │   │   └── tambah_tugas_page.dart
│   │   │
│   │   └── widgets/            # Reusable components
│   │       ├── app_button.dart
│   │       ├── app_input.dart
│   │       ├── app_checkbox.dart
│   │       ├── task_card.dart
│   │       └── summary_card.dart
│   │
│   ├── controllers/            # Business logic
│   │   ├── task_controller.dart
│   │   └── task_provider.dart   # Provider state management
│   │
│   ├── services/               # API layer
│   │   └── task_service.dart
│   │
│   └── config/                 # Configuration
│       └── api_config.dart
│
└── main.dart                   # App entry point
```

## 🎨 Design System

### Colors

- **Primary**: `#2F6BFF` (Blue)
- **Background**: `#F7F8FA` (Light Gray)
- **Surface**: `#FFFFFF` (White)
- **Text Primary**: `#0F172A` (Dark)
- **Text Secondary**: `#64748B` (Gray)
- **Danger**: `#EF4444` (Red)
- **Success**: `#10B981` (Green)

### Typography

- **Title**: 20px SemiBold
- **Section**: 16px SemiBold
- **Body**: 14px Regular
- **Caption**: 12px Regular
- **Button**: 14px SemiBold

### Layout

- **8pt Grid System**
- **Border Radius**: 12px
- **Card Padding**: 16px
- **Button/Input Height**: 48px

## 🔌 API Integration

### Base URL

```
https://rpblbedyqmnzpowbumzd.supabase.co
```

### Endpoints

#### 1. GET All Tasks

```bash
GET /rest/v1/tasks?select=*
```

#### 2. GET Tasks by Status

```bash
GET /rest/v1/tasks?select=*&status=eq.BERJALAN
GET /rest/v1/tasks?select=*&status=eq.SELESAI
GET /rest/v1/tasks?select=*&status=eq.TERLAMBAT
```

#### 3. POST Add Task

```bash
POST /rest/v1/tasks
Body: {
  "title": "string",
  "course": "string",
  "deadline": "YYYY-MM-DD",
  "status": "BERJALAN|SELESAI|TERLAMBAT",
  "note": "string",
  "is_done": boolean
}
```

#### 4. PATCH Update Task

```bash
PATCH /rest/v1/tasks?id=eq.{id}
Body: {
  "note": "string",           // Update note
  "is_done": boolean,          // Toggle completion
  "status": "SELESAI|BERJALAN" // Update status
}
```

## 🛠️ State Management

Aplikasi menggunakan **2 pendekatan state management**:

### 1. Local State (setState)

Digunakan pada setiap halaman untuk:

- Loading states
- Form inputs
- Filter selections
- Search queries

### 2. Provider (Optional)

File `task_provider.dart` telah disediakan untuk state management global. Untuk menggunakannya:

```dart
// Wrap MaterialApp dengan Provider di main.dart
return ChangeNotifierProvider(
  create: (context) => TaskProvider(),
  child: MaterialApp(...),
);

// Gunakan di widget
final provider = Provider.of<TaskProvider>(context);
await provider.loadTasks();
```

## 🚀 Cara Menjalankan

### 1. Install Dependencies

```bash
cd 16_Tugas_Besar_dan_COTS/flutter_application_1
flutter pub get
```

### 2. Run App

```bash
flutter run
```

### 3. Build APK (Optional)

```bash
flutter build apk --release
```

## 📱 Navigasi

Navigasi menggunakan **Named Routes**:

```
/ (root)              → Dashboard
/daftar-tugas         → Daftar Tugas Page
/detail-tugas         → Detail Tugas Page (dengan Task argument)
/tambah-tugas         → Tambah Tugas Page
```

### Flow Navigasi:

1. **Dashboard → Daftar Tugas**
2. **Dashboard → Detail Tugas** (dari task card)
3. **Dashboard → Tambah Tugas**
4. **Daftar Tugas → Detail Tugas**
5. **Daftar Tugas → Tambah Tugas**

## ✅ Validasi

### Input Validation:

- ✓ Judul tugas tidak boleh kosong
- ✓ Mata kuliah harus dipilih
- ✓ Deadline harus dipilih
- ✓ Form validation sebelum submit

### Navigation Validation:

- ✓ Semua navigasi berfungsi tanpa error
- ✓ Data task diteruskan dengan benar via arguments

### UI Validation:

- ✓ Design konsisten dengan mockup
- ✓ Warna dan typography sesuai design system
- ✓ Responsive layout
- ✓ Loading states dan error handling

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.2.0 # HTTP client untuk API calls
  provider: ^6.1.1 # State management (optional)
```

## 🧪 Testing & Debugging

### Pull to Refresh

Semua halaman dengan data list mendukung pull-to-refresh untuk reload data.

### Error Handling

- Network errors ditampilkan via SnackBar
- Form validation mencegah invalid input
- Loading states untuk UX yang lebih baik

### Debug Mode

- Hot Reload ✓
- Debug banner dapat dimatikan dengan `debugShowCheckedModeBanner: false`

## 📝 Catatan Pengembangan

### Completed Features ✅

- [x] Struktur folder COTS
- [x] Design system (colors, typography, spacing)
- [x] Task model & API service
- [x] 4 halaman utama (Dashboard, Daftar, Detail, Tambah)
- [x] Reusable widgets (Button, Input, Card, Checkbox)
- [x] API integration (GET, POST, PATCH)
- [x] State management (setState + Provider)
- [x] Navigation & routing
- [x] Form validation
- [x] Error handling

### Best Practices

- Clean Architecture dengan separation of concerns
- Reusable components untuk consistency
- Type safety dengan proper models
- Error handling dan user feedback
- Code documentation

## 👨‍💻 Developer

**Benedictus Qosta Noventino**  
NPM: 2311104029  
Praktikum Pemrograman Perangkat Bergerak

---

**Selamat menggunakan Task Manager App! 🎉**
