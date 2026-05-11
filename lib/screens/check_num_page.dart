import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Menu 2: Cek apakah bilangan ganjil/genap dan prima/bukan prima.
class CheckNumPage extends StatefulWidget {
  const CheckNumPage({super.key});

  @override
  State<CheckNumPage> createState() => _CheckNumPageState();
}

class _CheckNumPageState extends State<CheckNumPage> {
  final _controllerReal = TextEditingController();
  final _controllerInt = TextEditingController();

  String _ganjilGenap = '';
  String _prima = '';
  String _positifNegatif = '';
  bool _sudahCek = false;

  // Cek apakah bilangan prima (trial division O(√n))
  bool _isPrima(BigInt n) {
    if (n < BigInt.two) return false;
    if (n == BigInt.two) return true;
    if (n % BigInt.two == BigInt.zero) return false;
    for (BigInt i = BigInt.from(3); i * i <= n; i += BigInt.two) {
      if (n % i == BigInt.zero) return false;
    }
    return true;
  }

  void _cek() {
    final textReal = _controllerReal.text.trim();
    final textInt = _controllerInt.text.trim();

    final d = double.tryParse(textReal);
    final n = BigInt.tryParse(textInt);

    if (textReal.isEmpty && textInt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan minimal satu bilangan!')),
      );
      return;
    }

    if (textReal.isNotEmpty && d == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bilangan real tidak valid!')),
      );
      return;
    }

    if (textInt.isNotEmpty && n == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bilangan bulat tidak valid!')),
      );
      return;
    }

    setState(() {
      _positifNegatif = '';
      _ganjilGenap = '';
      _prima = '';

      if (textReal.isNotEmpty && d != null) {
        if (d > 0) {
          _positifNegatif = '$textReal adalah Bilangan Positif';
        } else if (d < 0) {
          _positifNegatif = '$textReal adalah Bilangan Negatif';
        } else {
          _positifNegatif = '$textReal adalah Nol';
        }
      }

      if (textInt.isNotEmpty && n != null) {
        _ganjilGenap = n % BigInt.two != BigInt.zero
            ? '$n adalah Bilangan Ganjil'
            : '$n adalah Bilangan Genap';
        _prima = _isPrima(n)
            ? '$n adalah Bilangan Prima'
            : '$n bukan Bilangan Prima';
      }

      _sudahCek = true;
    });
    FocusScope.of(context).unfocus();
  }

  void _reset() {
    _controllerReal.clear();
    _controllerInt.clear();
    setState(() => _sudahCek = false);
  }

  @override
  void dispose() {
    _controllerReal.dispose();
    _controllerInt.dispose();
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Deskripsi Real
            const Text(
              'Cek Positif / Negatif (Bilangan Real)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            // Input Real
            TextField(
              controller: _controllerReal,
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
              ],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                hintText: 'Contoh: -3.14',
                hintStyle: const TextStyle(
                  color: Color(0xFFDDDDDD),
                  fontSize: 24,
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
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onChanged: (val) {
                if (val.isNotEmpty && _controllerInt.text.isNotEmpty) {
                  _controllerInt.clear();
                }
                setState(() => _sudahCek = false);
              },
            ),
            const SizedBox(height: 20),

            // Deskripsi Int
            const Text(
              'Cek Ganjil / Genap & Prima (Bilangan Bulat)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            // Input Int
            TextField(
              controller: _controllerInt,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')),
              ],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                hintText: 'Contoh: 7',
                hintStyle: const TextStyle(
                  color: Color(0xFFDDDDDD),
                  fontSize: 24,
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
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onChanged: (val) {
                if (val.isNotEmpty && _controllerReal.text.isNotEmpty) {
                  _controllerReal.clear();
                }
                setState(() => _sudahCek = false);
              },
            ),
            const SizedBox(height: 24),

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
              if (_positifNegatif.isNotEmpty) ...[
                _HasilCard(
                  label: 'Positif / Negatif',
                  hasil: _positifNegatif,
                  warna: const Color(0xFF4CAF50),
                  icon: Icons.calculate_rounded,
                ),
                const SizedBox(height: 12),
              ],
              if (_ganjilGenap.isNotEmpty) ...[
                _HasilCard(
                  label: 'Ganjil / Genap',
                  hasil: _ganjilGenap,
                  warna: const Color(0xFF667EEA),
                  icon: Icons.swap_horiz_rounded,
                ),
                const SizedBox(height: 12),
              ],
              if (_prima.isNotEmpty) ...[
                _HasilCard(
                  label: 'Bilangan Prima',
                  hasil: _prima,
                  warna: const Color(0xFFFF9800),
                  icon: Icons.star_rounded,
                ),
              ],
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: warna, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
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
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
