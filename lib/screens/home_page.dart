import 'package:flutter/material.dart';
import 'package:random_bull_application/screens/check_num_page.dart';
import 'package:random_bull_application/screens/count_char_page.dart';
import 'package:random_bull_application/screens/sum_subtract_page.dart';
import 'data_kelompok_page.dart';
import 'stopwatch_page.dart';
import 'piramid_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Utama'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.dashboard_rounded,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Aplikasi Kelompok',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Kelompok: IF-A | Teknologi Pemrograman Mobile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Menu Items
              // _buildMenuCard(
              //   context,
              //   icon: Icons.login_rounded,
              //   title: 'Login',
              //   description: 'Masuk dengan username & password',
              //   difficulty: '⭐⭐',
              //   color: Colors.blue,
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const LoginPage(),
              //       ),
              //     );
              //   },
              // ),
              // const SizedBox(height: 16),

              _buildMenuCard(
                context,
                icon: Icons.group_rounded,
                title: 'Data Kelompok',
                description: 'Lihat profil anggota kelompok',
                difficulty: '⭐',
                color: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DataKelompokPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              _buildMenuCard(
                context,
                icon: Icons.timer_rounded,
                title: 'Stopwatch',
                description: 'Hitung waktu dengan start, stop, reset',
                difficulty: '⭐⭐⭐',
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StopwatchPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              _buildMenuCard(
                context,
                icon: Icons.calculate_rounded,
                title: 'Kalkulator',
                description: 'Hitung penjumlahan & pengurangan sederhana',
                difficulty: '⭐⭐⭐⭐',
                color: Colors.purple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SumSubtractPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              _buildMenuCard(
                context,
                icon: Icons.calculate_rounded,
                title: 'Penentuan Ganjil Genap & Prima',
                description:
                    'Cek apakah angka ganjil/genap dan prima/bukan prima',
                difficulty: '⭐⭐⭐⭐',
                color: Colors.purple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckNumPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              _buildMenuCard(
                context,
                icon: Icons.calculate_rounded,
                title: 'Deteksi Karakter',
                description:
                    'Hitung total karakter, huruf, angka, simbol, kata, spasi',
                difficulty: '⭐⭐⭐⭐',
                color: Colors.purple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CountCharPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              _buildMenuCard(
                context,
                icon: Icons.architecture_rounded,
                title: 'Piramid',
                description: 'Hitung luas & volume piramid',
                difficulty: '⭐⭐⭐⭐',
                color: Colors.red,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PiramidPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String difficulty,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border(
                left: BorderSide(
                  color: color,
                  width: 5,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      Text(
                        difficulty,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
