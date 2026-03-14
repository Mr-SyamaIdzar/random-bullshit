import 'package:flutter/material.dart';

class DataKelompokPage extends StatelessWidget {
  const DataKelompokPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Kita siapkan datanya terlebih dahulu menggunakan List of Maps
    final List<Map<String, String>> members = [
      {'name': 'Rasyid Tri Sasongko', 'nim': '123230043'},
      {'name': 'Aidan Mahesa Manacika Nugroho', 'nim': '123230065'},
      {'name': 'Muhammad Raihan Syamaidzar', 'nim': '123230072'},
      {'name': 'Adhitya Izam Fauztamam', 'nim': '123230193'},
    ];

    // Data kelas dan mata kuliah yang sama untuk semua anggota
    const String className = 'IF-A';
    const String courseName = 'Teknologi Pemrograman Mobile';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Kelompok'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // 2. Menggunakan ListView.builder untuk menampilkan data sebagai List
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: members.length, // Jumlah item sesuai banyak anggota
        itemBuilder: (context, index) {
          final member = members[index];
          
          // 3. Menggunakan Card untuk membungkus tiap profil
          return Card(
            elevation: 4, // Memberikan efek bayangan
            margin: const EdgeInsets.only(bottom: 16.0), // Jarak antar kartu
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              // 4. Menggunakan Column untuk menyusun teks secara vertikal
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
                children: [
                  Text(
                    member['name']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8), // Memberi sedikit jarak
                  Text(
                    'NIM: ${member['nim']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Kelas: $className',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Mata Kuliah: $courseName',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
