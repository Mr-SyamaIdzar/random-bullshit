import 'package:flutter/material.dart';

/// Menu 1: Kalkulator penjumlahan & pengurangan (hanya + - AC DEL).
class SumSubtractPage extends StatefulWidget {
  const SumSubtractPage({super.key});

  @override
  State<SumSubtractPage> createState() => _SumSubtractPageState();
}

class _SumSubtractPageState extends State<SumSubtractPage> {
  String _ekspresi = '';
  String _hasil = '';

  void _tekan(String nilai) => setState(() {
        _hasil = '';

        // Jika input operator dan karakter terakhir juga operator, ganti
        if ((nilai == '+' || nilai == '-') &&
            _ekspresi.isNotEmpty &&
            (_ekspresi.endsWith('+') || _ekspresi.endsWith('-'))) {
          _ekspresi = _ekspresi.substring(0, _ekspresi.length - 1) + nilai;
          return;
        }

        // Guard desimal: jangan tambah titik jika angka terakhir sudah punya titik
        if (nilai == '.') {
          // Cari angka terakhir (setelah + atau -)
          final lastOp = _ekspresi.lastIndexOf(RegExp(r'[+\-](?!^)'));
          final lastNum =
              lastOp == -1 ? _ekspresi : _ekspresi.substring(lastOp + 1);
          if (lastNum.contains('.')) return; // sudah ada titik, skip
          if (lastNum.isEmpty) {
            _ekspresi += '0'; // otomatis tambah 0 sebelum titik
          }
        }

        _ekspresi += nilai;
      });

  void _toggleSign() {
    if (_ekspresi.isEmpty) return;
    setState(() {
      _hasil = '';

      // Cari posisi operator terakhir (bukan di index 0)
      int lastOp = -1;
      for (int i = _ekspresi.length - 1; i > 0; i--) {
        if (_ekspresi[i] == '+' || _ekspresi[i] == '-') {
          lastOp = i;
          break;
        }
      }

      if (lastOp == -1) {
        // Hanya satu angka, toggle tanda di depan
        if (_ekspresi.startsWith('-')) {
          _ekspresi = _ekspresi.substring(1);
        } else {
          _ekspresi = '-$_ekspresi';
        }
      } else {
        // Ambil angka terakhir setelah operator
        final beforeOp = _ekspresi.substring(0, lastOp);
        final op = _ekspresi[lastOp];
        final afterOp = _ekspresi.substring(lastOp + 1);

        if (afterOp.isEmpty) return;

        // Toggle: jika operator adalah + ganti ke -, dan sebaliknya
        if (op == '+') {
          _ekspresi = '$beforeOp-$afterOp';
        } else {
          _ekspresi = '$beforeOp+$afterOp';
        }
      }
    });
  }

  void _ac() => setState(() {
        _ekspresi = '';
        _hasil = '';
      });

  void _del() {
    if (_ekspresi.isEmpty) return;
    setState(() {
      _hasil = '';
      _ekspresi = _ekspresi.substring(0, _ekspresi.length - 1);
    });
  }

  void _hitung() {
    if (_ekspresi.isEmpty) return;
    try {
      setState(() => _hasil = _format(_evaluasi(_ekspresi)));
    } catch (_) {
      setState(() => _hasil = 'Error');
    }
  }

  double _evaluasi(String expr) {
    final parts = <double>[];
    final ops = <String>[];
    int i = 0;
    while (i < expr.length) {
      String num = '';
      // Tanda di awal atau setelah operator
      if ((i == 0 || ops.isNotEmpty) && (expr[i] == '+' || expr[i] == '-')) {
        num += expr[i++];
      }
      while (i < expr.length && (expr[i] == '.' || _isDigit(expr[i]))) {
        num += expr[i++];
      }
      if (num.isNotEmpty && num != '+' && num != '-') {
        parts.add(double.parse(num));
      }
      if (i < expr.length) ops.add(expr[i++]);
    }
    if (parts.isEmpty) return 0;
    double total = parts[0];
    for (int j = 0; j < ops.length; j++) {
      if (j + 1 < parts.length) {
        total += ops[j] == '+' ? parts[j + 1] : -parts[j + 1];
      }
    }
    return total;
  }

  bool _isDigit(String c) => c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57;

  String _format(double n) =>
      n == n.truncateToDouble() ? n.toInt().toString() : n.toString();

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF667EEA);
    const red = Color(0xFFE53935);
    const orange = Color(0xFFFF7043);
    const green = Color(0xFF11998E);
    const purple = Color(0xFF8E24AA);

    const double btnH = 72;
    const double gap = 12;
    const double equalH = btnH * 3 + gap * 2;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Kalkulator',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
      ),
      body: Column(
        children: [
          // ── Display ──────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Masukkan angka dan operasi penjumlahan atau pengurangan.',
                    style: TextStyle(
                        color: Colors.grey, fontSize: 13, height: 1.5),
                  ),
                  const Spacer(),
                  Text(
                    _ekspresi.isEmpty ? '0' : _ekspresi,
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 28,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _hasil.isEmpty ? '' : '= $_hasil',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontSize: 48, fontWeight: FontWeight.w800, height: 1),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── Keypad ───────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.04),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(top: BorderSide(color: primary.withOpacity(0.1))),
            ),
            child: Column(
              children: [
                // Baris 1: AC DEL + -
                Row(children: [
                  _btn('AC', h: btnH, color: red, onTap: _ac),
                  _btn('DEL', h: btnH, color: orange, onTap: _del),
                  _btn('+', h: btnH, color: primary, onTap: () => _tekan('+')),
                  _btn('-',
                      h: btnH,
                      color: primary,
                      onTap: () => _tekan('-'),
                      last: true),
                ]),
                const SizedBox(height: gap),

                // Baris 2–4: angka 7-9, 4-6, 1-3 + tombol =
                Stack(
                  children: [
                    Column(
                      children: [
                        Row(children: [
                          _btn('7', h: btnH, onTap: () => _tekan('7')),
                          _btn('8', h: btnH, onTap: () => _tekan('8')),
                          _btn('9', h: btnH, onTap: () => _tekan('9')),
                          const Expanded(child: SizedBox()),
                        ]),
                        const SizedBox(height: gap),
                        Row(children: [
                          _btn('4', h: btnH, onTap: () => _tekan('4')),
                          _btn('5', h: btnH, onTap: () => _tekan('5')),
                          _btn('6', h: btnH, onTap: () => _tekan('6')),
                          const Expanded(child: SizedBox()),
                        ]),
                        const SizedBox(height: gap),
                        Row(children: [
                          _btn('1', h: btnH, onTap: () => _tekan('1')),
                          _btn('2', h: btnH, onTap: () => _tekan('2')),
                          _btn('3', h: btnH, onTap: () => _tekan('3')),
                          const Expanded(child: SizedBox()),
                        ]),
                      ],
                    ),

                    // Tombol = membentang 3 baris
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: _hitung,
                        child: Container(
                          width:
                              (MediaQuery.of(context).size.width - 40 - 30) / 4,
                          height: equalH,
                          decoration: BoxDecoration(
                            color: green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: green.withOpacity(0.25)),
                          ),
                          child: Center(
                            child: Text('=',
                                style: TextStyle(
                                    color: green,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: gap),

                // Baris 5: 0 (lebar 2) + . + +/-
                Row(children: [
                  _btn('0', h: btnH, flex: 2, onTap: () => _tekan('0')),
                  _btn('.', h: btnH, onTap: () => _tekan('.')),
                  _btn('+/-',
                      h: btnH, color: purple, onTap: _toggleSign, last: true),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _btn(String label,
      {required double h,
      required VoidCallback onTap,
      Color? color,
      int flex = 1,
      bool last = false}) {
    final bg = color ?? const Color(0xFF667EEA);
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.only(right: last ? 0 : 12),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: h,
            decoration: BoxDecoration(
              color: bg.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: bg.withOpacity(0.25)),
            ),
            child: Center(
              child: Text(label,
                  style: TextStyle(
                      color: bg, fontSize: 22, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ),
    );
  }
}
