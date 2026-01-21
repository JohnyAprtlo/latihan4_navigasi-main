import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'config/app_theme.dart';

void main() {
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
