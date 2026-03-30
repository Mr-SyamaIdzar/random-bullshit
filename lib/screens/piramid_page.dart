import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Menu 4: Hitung luas dan volume limas segi empat (piramid).
///
/// Rumus:
/// - Luas Alas       = s × s
/// - Luas Selimut    = 4 × (½ × s × l) = 2 × s × l
/// - Luas Permukaan  = Luas Alas + Luas Selimut
/// - Volume          = ⅓ × Luas Alas × t
/// - Tinggi sisi (l) = √((s/2)² + t²)  ← apotema segitiga
class PiramidPage extends StatefulWidget {
  const PiramidPage({super.key});

  @override
  State<PiramidPage> createState() => _PiramidPageState();
}

class _PiramidPageState extends State<PiramidPage> {
  final _sCtrl = TextEditingController(); // sisi alas
  final _tCtrl = TextEditingController(); // tinggi limas

  double? _luasAlas;
  double? _luasSelimut;
  double? _luasPermukaan;
  double? _volume;
  bool _sudahHitung = false;

  void _hitung() {
    final s = double.tryParse(_sCtrl.text.trim());
    final t = double.tryParse(_tCtrl.text.trim());

    if (s == null || t == null || s <= 0 || t <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan nilai sisi dan tinggi yang valid!'),
        ),
      );
      return;
    }

    // Tinggi sisi miring segitiga (apotema)
    final l = sqrt(pow(s / 2, 2) + pow(t, 2));

    setState(() {
      _luasAlas = s * s;
      _luasSelimut = 2 * s * l;
      _luasPermukaan = _luasAlas! + _luasSelimut!;
      _volume = (1 / 3) * _luasAlas! * t;
      _sudahHitung = true;
    });
    FocusScope.of(context).unfocus();
  }

  void _reset() {
    _sCtrl.clear();
    _tCtrl.clear();
    setState(() => _sudahHitung = false);
  }

  String _fmt(double n) =>
      double.parse(n.toStringAsFixed(2)) == n.truncateToDouble()
          ? n.toInt().toString()
          : n.toStringAsFixed(2);

  @override
  void dispose() {
    _sCtrl.dispose();
    _tCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF9C27B0);

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
          'Limas Segi Empat',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Deskripsi
            const Text(
              'Masukkan panjang sisi alas dan tinggi limas untuk menghitung luas dan volume.',
              style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 20),

            // Ilustrasi rumus
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: primary.withOpacity(0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rumus',
                    style: TextStyle(
                      color: primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _rumus('Luas Alas', 's × s'),
                  _rumus('Luas Selimut', '2 × s × l  (l = √((s/2)² + t²))'),
                  _rumus('Luas Permukaan', 'Luas Alas + Luas Selimut'),
                  _rumus('Volume', '⅓ × Luas Alas × t'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Input sisi alas
            _InputField(
              controller: _sCtrl,
              label: 'Sisi Alas (s)',
              hint: 'Contoh: 6',
              satuan: 'cm',
              onChanged: () => setState(() => _sudahHitung = false),
            ),
            const SizedBox(height: 14),

            // Input tinggi
            _InputField(
              controller: _tCtrl,
              label: 'Tinggi Limas (t)',
              hint: 'Contoh: 9',
              satuan: 'cm',
              onChanged: () => setState(() => _sudahHitung = false),
            ),
            const SizedBox(height: 20),

            // Tombol
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: _hitung,
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
                      'HITUNG',
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
            if (_sudahHitung) ...[
              const SizedBox(height: 28),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: [
                  _HasilCard(
                    'Luas Alas',
                    _fmt(_luasAlas!),
                    'cm²',
                    const Color(0xFF667EEA),
                  ),
                  _HasilCard(
                    'Luas Selimut',
                    _fmt(_luasSelimut!),
                    'cm²',
                    const Color(0xFF11998E),
                  ),
                  _HasilCard(
                    'Luas Permukaan',
                    _fmt(_luasPermukaan!),
                    'cm²',
                    const Color(0xFFFF9800),
                  ),
                  _HasilCard('Volume', _fmt(_volume!), 'cm³', primary),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _rumus(String nama, String formula) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 12, height: 1.6),
          children: [
            TextSpan(
              text: '$nama  ',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: formula,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget input field dengan label dan satuan di kanan.
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String satuan;
  final VoidCallback onChanged;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.satuan,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF9C27B0);
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: satuan,
        suffixStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}

/// Card hasil perhitungan individual.
class _HasilCard extends StatelessWidget {
  final String label;
  final String nilai;
  final String satuan;
  final Color warna;

  const _HasilCard(this.label, this.nilai, this.satuan, this.warna);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: warna.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: warna.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    nilai,
                    style: TextStyle(
                      color: warna,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                satuan,
                style: TextStyle(color: warna.withOpacity(0.7), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
