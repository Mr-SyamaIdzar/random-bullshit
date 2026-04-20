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
  String? saka;
  Map<String, int>? umur;

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
        weton = _getWeton(picked);
        hijriah = _convertToHijriah(picked);
        saka = _convertToSaka(picked);
        umur = _hitungUmur(picked);
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
      "Senin",
      "Selasa",
      "Rabu",
      "Kamis",
      "Jumat",
      "Sabtu",
      "Minggu"
    ];

    List<String> pasaran = ["Pahing", "Pon", "Wage", "Kliwon", "Legi"];

    // DateTime baseDate = DateTime(1900, 1, 1);
    DateTime baseDate = DateTime(1899, 12, 31);
    int selisihHari = date.difference(baseDate).inDays;

    // date.weekday di Flutter/Dart mengembalikan 1=Senin, 7=Minggu, bukan 0=Minggu seperti diasumsikan.
    // String namaHari = hari[date.weekday % 7];
    String namaHari = hari[date.weekday - 1]; // langsung, tidak perlu % 7
    String namaPasaran = pasaran[selisihHari % 5];

    return "$namaHari $namaPasaran";
  }

  // Hijriah
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
        day +
        b -
        1524;

    int l = jd - 1948440 + 10632;
    int n = ((l - 1) / 10631).floor();
    l = l - 10631 * n + 354;
    int j = ((10985 - l) / 5316).floor() * ((50 * l) / 17719).floor() +
        (l / 5670).floor() * ((43 * l) / 15238).floor();
    l = l -
        ((30 - j) / 15).floor() * ((17719 * j) / 50).floor() -
        (j / 16).floor() * ((15238 * j) / 43).floor() +
        29;

    int m = (24 * l / 709).floor();
    int d = l - (709 * m / 24).floor();
    int y = 30 * n + j - 30;

    List<String> bulanHijriah = [
      "Muharram",
      "Safar",
      "Rabiul Awal",
      "Rabiul Akhir",
      "Jumadil Awal",
      "Jumadil Akhir",
      "Rajab",
      "Syaban",
      "Ramadhan",
      "Syawal",
      "Dzulqaidah",
      "Dzulhijjah"
    ];

    return "$d ${bulanHijriah[m - 1]} $y H";
  }

  bool _isGregorianLeap(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  // Saka
  String _convertToSaka(DateTime date) {
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
        day +
        b -
        1524;

    int sakaJD = jd - 1749615;

    int sakaYear = ((sakaJD - 1) / 365.25).floor();
    int remaining = sakaJD - (sakaYear * 365 + (sakaYear ~/ 4));

    if (remaining <= 0) {
      sakaYear -= 1;
      remaining = sakaJD - (sakaYear * 365 + (sakaYear ~/ 4));
    }

    // Tahun kabisat jika (sakaYear + 78) adalah kabisat Gregorian
    bool isKabisat = _isGregorianLeap(sakaYear + 78);

    List<int> panjangBulan = isKabisat
        ? [31, 29, 31, 31, 31, 31, 30, 30, 30, 30, 30, 30] // kabisat
        : [30, 31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 30]; // biasa

    int sakaMonth = 0;
    int sakaDay = remaining;

    for (int i = 0; i < 12; i++) {
      if (sakaDay <= panjangBulan[i]) {
        sakaMonth = i + 1;
        break;
      }
      sakaDay -= panjangBulan[i];
    }

    if (sakaMonth == 0) {
      sakaMonth = 12;
      sakaDay = remaining;
    }

    List<String> bulanSaka = [
      "Caitra",
      "Waisaka",
      "Jyaistha",
      "Asadha",
      "Srawana",
      "Bhadra",
      "Aswina",
      "Kartika",
      "Margasira",
      "Pausha",
      "Magha",
      "Phalguna"
    ];

    return "$sakaDay ${bulanSaka[sakaMonth - 1]} $sakaYear Saka";
  }

  // Kalkulasi umur
  Map<String, int> _hitungUmur(DateTime lahir) {
    DateTime sekarang = DateTime.now();

    int tahun = sekarang.year - lahir.year;
    int bulan = sekarang.month - lahir.month;
    int hari = sekarang.day - lahir.day;

    if (hari < 0) {
      bulan -= 1;
      // Ambil jumlah hari dari bulan sebelumnya
      DateTime bulanLalu = DateTime(sekarang.year, sekarang.month - 1);
      hari += DateTime(bulanLalu.year, bulanLalu.month + 1, 0).day;
    }

    if (bulan < 0) {
      tahun -= 1;
      bulan += 12;
    }

    return {"tahun": tahun, "bulan": bulan, "hari": hari};
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

            // Tgl
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

            // Waktu
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

            // Weton
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

            // Hijriah
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
              const SizedBox(height: 20),
            ],

            // Saka
            if (saka != null) ...[
              const Text(
                "Tanggal Saka:",
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                saka!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.orange[700]),
              ),
            ],

            // Umur
            if (umur != null) ...[
              const SizedBox(height: 20),
              const Text(
                "Umur:",
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                "${umur!['tahun']} tahun, ${umur!['bulan']} bulan, ${umur!['hari']} hari",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.purple[700]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
