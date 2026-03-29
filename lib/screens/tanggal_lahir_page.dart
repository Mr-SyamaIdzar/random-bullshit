import 'package:flutter/material.dart';

class TanggalLahirPage extends StatefulWidget {
  const TanggalLahirPage({super.key});

  @override
  State<TanggalLahirPage> createState() => _TanggalLahirPageState();
}

class _TanggalLahirPageState extends State<TanggalLahirPage> {

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String? weton;
  String? hijriah;

  //  Tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;

        // Hitung weton & hijriah
        weton = _getWeton(picked);
        hijriah = _convertToHijriah(picked);
      });
    }
  }

  // Waktu
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // Weton
  String _getWeton(DateTime date) {
    List<String> hari = [
      "Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"
    ];

    List<String> pasaran = [
      "Legi", "Pahing", "Pon", "Wage", "Kliwon"
    ];

    DateTime baseDate = DateTime(1900, 1, 1);
    int selisihHari = date.difference(baseDate).inDays;

    String namaHari = hari[date.weekday % 7];
    String namaPasaran = pasaran[selisihHari % 5];

    return "$namaHari $namaPasaran";
  }

  // hijriah
  String _convertToHijriah(DateTime date) {
    int day = date.day;
    int month = date.month;
    int year = date.year;

    if (month < 3) {
      year -= 1;
      month += 12;
    }

    int a = year ~/ 100;
    int b = 2 - a + (a ~/ 4);

    int jd = (365.25 * (year + 4716)).floor() +
        (30.6001 * (month + 1)).floor() +
        day + b - 1524;

    int l = jd - 1948440 + 10632;
    int n = ((l - 1) / 10631).floor();
    l = l - 10631 * n + 354;
    int j = ((10985 - l) / 5316).floor() *
            ((50 * l) / 17719).floor() +
        (l / 5670).floor() *
            ((43 * l) / 15238).floor();
    l = l -
        ((30 - j) / 15).floor() *
            ((17719 * j) / 50).floor() -
        (j / 16).floor() *
            ((15238 * j) / 43).floor() +
        29;

    int m = (24 * l / 709).floor();
    int d = l - (709 * m / 24).floor();
    int y = 30 * n + j - 30;

    List<String> bulanHijriah = [
      "Muharram", "Safar", "Rabiul Awal", "Rabiul Akhir",
      "Jumadil Awal", "Jumadil Akhir", "Rajab", "Syaban",
      "Ramadhan", "Syawal", "Dzulqaidah", "Dzulhijjah"
    ];

    return "$d ${bulanHijriah[m - 1]} $y H";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Tanggal Lahir'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            const Text(
              'Silakan masukkan tanggal dan waktu lahirmu:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // tgl
            ElevatedButton.icon(
              onPressed: () => _selectDate(context),
              icon: const Icon(Icons.calendar_today),
              label: const Text('Pilih Tanggal Lahir'),
            ),

            const SizedBox(height: 10),

            Text(
              selectedDate == null
                  ? 'Format: Tahun - Bulan - Hari'
                  : 'Terpilih: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // waktu
            ElevatedButton.icon(
              onPressed: () => _selectTime(context),
              icon: const Icon(Icons.access_time),
              label: const Text('Pilih Waktu Lahir'),
            ),

            const SizedBox(height: 10),

            Text(
              selectedTime == null
                  ? 'Format: Jam : Menit'
                  : 'Terpilih: ${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // weton
            if (weton != null) ...[
              const Text(
                "Weton:",
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                weton!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue[700]),
              ),
              const SizedBox(height: 20),
            ],

            // hijriah
            if (hijriah != null) ...[
              const Text(
                "Tanggal Hijriah:",
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                hijriah!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green[700]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
