import 'package:flutter/material.dart';
import 'package:random_bull_application/screens/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Kelompok',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner:
          false, // Menghilangkan tulisan "DEBUG" di pojok
      // Aplikasi akan langsung membuka LoginPage saat pertama kali dijalankan
      home: const LoginPage(),
    );
  }
}
