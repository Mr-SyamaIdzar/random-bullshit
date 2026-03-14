import 'package:flutter/material.dart';
import 'screens/home_page.dart'; // Memanggil HomePage yang ada di folder screens

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
      debugShowCheckedModeBanner: false, // Menghilangkan tulisan "DEBUG" di pojok
      
      // Aplikasi akan langsung membuka HomePage saat pertama kali dijalankan
      home: const HomePage(), 
    );
  }
}