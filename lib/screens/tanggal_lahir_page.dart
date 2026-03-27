import 'package:flutter/material.dart';

class TanggalLahirPage extends StatefulWidget {
  const TanggalLahirPage({super.key});

  @override
  State<TanggalLahirPage> createState() => _TanggalLahirPageState();
}

class _TanggalLahirPageState extends State<TanggalLahirPage> {
  // Variabel untuk menyimpan data yang dipilih pengguna
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Fungsi untuk memunculkan kalender (Tahun, Bulan, Hari)
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Tanggal default saat dibuka
      firstDate: DateTime(1900),   // Batas tahun paling bawah
      lastDate: DateTime.now(),    // Batas tahun paling atas (hari ini)
    );
    
    // Jika user memilih tanggal, simpan ke variabel
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Fungsi untuk memunculkan jam (Jam, Menit)
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), // Waktu default saat dibuka
    );
    
    // Jika user memilih waktu, simpan ke variabel
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
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
            
            // --- Tombol & Info Tanggal ---
            ElevatedButton.icon(
              onPressed: () => _selectDate(context),
              icon: const Icon(Icons.calendar_today),
              label: const Text('Pilih Tanggal Lahir'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              selectedDate == null 
                  ? 'Format: Tahun - Bulan - Hari' 
                  : 'Terpilih: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // --- Tombol & Info Waktu ---
            ElevatedButton.icon(
              onPressed: () => _selectTime(context),
              icon: const Icon(Icons.access_time),
              label: const Text('Pilih Waktu Lahir'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              selectedTime == null 
                  ? 'Format: Jam : Menit' 
                  // padLeft digunakan agar angka 5 menjadi "05"
                  : 'Terpilih: ${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}