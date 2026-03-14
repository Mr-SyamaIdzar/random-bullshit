import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Menu 2: Cek apakah bilangan ganjil/genap dan prima/bukan prima.
class CheckNumPage extends StatefulWidget {
  const CheckNumPage({super.key});

  @override
  State<CheckNumPage> createState() => _CheckNumPageState();
}

class _CheckNumPageState extends State<CheckNumPage> {
  final _controller = TextEditingController();

  String _ganjilGenap = '';
  String _prima = '';
  bool _sudahCek = false;

  // Cek apakah bilangan prima (trial division O(√n))
  bool _isPrima(int n) {
    if (n < 2) return false;
    if (n == 2) return true;
    if (n % 2 == 0) return false;
    for (int i = 3; i * i <= n; i += 2) {
      if (n % i == 0) return false;
    }
    return true;
  }

  void _cek() {
    final n = int.tryParse(_controller.text.trim());
    if (n == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan bilangan bulat yang valid!')),
      );
      return;
    }
    setState(() {
      _ganjilGenap = n % 2 != 0
          ? '$n adalah Bilangan Ganjil'
          : '$n adalah Bilangan Genap';
      _prima = _isPrima(n)
          ? '$n adalah Bilangan Prima'
          : '$n bukan Bilangan Prima';
      _sudahCek = true;
    });
    FocusScope.of(context).unfocus();
  }

  void _reset() {
    _controller.clear();
    setState(() => _sudahCek = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF11998E);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cek Bilangan',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Deskripsi
            const Text(
              'Masukkan bilangan bulat untuk dicek apakah ganjil/genap dan prima/bukan.',
              style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 24),

            // Input
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: const TextStyle(
                  color: Color(0xFFDDDDDD),
                  fontSize: 32,
                ),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
              ),
              onChanged: (_) => setState(() => _sudahCek = false),
            ),
            const SizedBox(height: 16),

            // Tombol CEK & Reset
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: _cek,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'CEK',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reset,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Color(0xFFDDDDDD)),
                    ),
                    child: const Icon(
                      Icons.refresh_rounded,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),

            // Hasil
            if (_sudahCek) ...[
              const SizedBox(height: 28),
              _HasilCard(
                label: 'Ganjil / Genap',
                hasil: _ganjilGenap,
                warna: const Color(0xFF667EEA),
                icon: Icons.swap_horiz_rounded,
              ),
              const SizedBox(height: 12),
              _HasilCard(
                label: 'Bilangan Prima',
                hasil: _prima,
                warna: const Color(0xFFFF9800),
                icon: Icons.star_rounded,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Card hasil sederhana dengan label, ikon, dan teks hasil.
class _HasilCard extends StatelessWidget {
  final String label;
  final String hasil;
  final Color warna;
  final IconData icon;

  const _HasilCard({
    required this.label,
    required this.hasil,
    required this.warna,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: warna.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: warna.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: warna, size: 28),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: warna,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                hasil,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
