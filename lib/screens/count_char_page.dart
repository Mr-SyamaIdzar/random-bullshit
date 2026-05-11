import 'package:flutter/material.dart';

/// Menu 3: Analisis teks — hitung total karakter, huruf, angka, simbol, kata, spasi.
class CountCharPage extends StatefulWidget {
  const CountCharPage({super.key});

  @override
  State<CountCharPage> createState() => _CountCharPageState();
}

class _CountCharPageState extends State<CountCharPage> {
  final _controller = TextEditingController();
  bool _sudahHitung = false;

  int _total = 0, _huruf = 0, _angka = 0, _simbol = 0, _spasi = 0, _kata = 0;

  void _hitung() {
    final teks = _controller.text;
    if (teks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan teks terlebih dahulu!')),
      );
      return;
    }

    int h = 0, s = 0, sp = 0;

    for (final c in teks.split('')) {
      if (RegExp(r'[a-zA-Z]').hasMatch(c))
        h++;
      else if (c == ' ' || c == '\n' || c == '\t')
        sp++;
      else if (!RegExp(r'[0-9.,]').hasMatch(c)) s++;
      // digit, titik, koma → tidak dihitung per karakter di sini
    }

    // Hitung angka per token: pisah by spasi & simbol kecuali . dan ,
    // Contoh: "200.000" = 1 angka, "2026" = 1 angka, "25" = 1 angka
    final tokenAngka = RegExp(r'[0-9][0-9.,]*').allMatches(teks).length;

    // Hitung kata: hanya token yang mengandung huruf
    final kata = RegExp(r'[a-zA-Z]+').allMatches(teks).length;

    setState(() {
      _total = teks.length;
      _huruf = h;
      _angka = tokenAngka;
      _simbol = s;
      _spasi = sp;
      _kata = kata;
      _sudahHitung = true;
    });
    FocusScope.of(context).unfocus();
  }

  void _reset() {
    _controller.clear();
    setState(() => _sudahHitung = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFFFF6B6B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Analisis Karakter',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Deskripsi
            const Text(
              'Masukkan teks apapun untuk menganalisis komposisi karakternya.',
              style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 20),

            // Input teks
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Ketik teks di sini...',
                hintStyle: const TextStyle(color: Color(0xFFCCCCCC)),
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
                contentPadding: const EdgeInsets.all(16),
              ),
              onChanged: (_) => setState(() => _sudahHitung = false),
            ),
            const SizedBox(height: 16),

            // Tombol
            Row(children: [
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: _hitung,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('ANALISIS',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, letterSpacing: 1)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: _reset,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(color: Color(0xFFDDDDDD)),
                  ),
                  child: const Icon(Icons.refresh_rounded, color: Colors.grey),
                ),
              ),
            ]),

            // Hasil
            if (_sudahHitung) ...[
              const SizedBox(height: 28),

              // Total karakter (highlight utama)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: primary.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    const Text('Total Karakter',
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text('$_total',
                        style: TextStyle(
                            color: primary,
                            fontSize: 48,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Grid 2 kolom — sekarang 6 item (3 baris)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.2,
                children: [
                  _StatTile('Huruf', _huruf, const Color(0xFF667EEA)),
                  _StatTile('Angka', _angka, const Color(0xFF11998E)),
                  _StatTile('Simbol', _simbol, const Color(0xFFFF9800)),
                  _StatTile('Spasi', _spasi, const Color(0xFF9C27B0)),
                  _StatTile('Kata', _kata, const Color(0xFFE53935)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Tile statistik individual untuk grid hasil.
class _StatTile extends StatelessWidget {
  final String label;
  final int nilai;
  final Color warna;

  const _StatTile(this.label, this.nilai, this.warna);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: warna.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: warna.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Text('$nilai',
              style: TextStyle(
                  color: warna, fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }
}
