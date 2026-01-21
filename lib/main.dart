import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'config/app_theme.dart';
import 'database/database_service.dart';

// Main function sekarang async karena perlu initialize database dulu
void main() async {
  // Ensure Flutter binding is initialized
  // Wajib dipanggil sebelum menggunakan async operations di main()
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive database
  // Ini akan setup semua Box (tables) yang dibutuhkan
  await DatabaseService().init();

  // Run aplikasi
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pengingat Jadwal Kuliah',
      theme: AppTheme.darkTheme,
      home: LoginPage(),
    );
  }
}
