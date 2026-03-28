import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({Key? key}) : super(key: key);

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {

  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;

  String _displayTime = "00:00:00:00";
  List<String> _records = [];

  void _start() {
    _stopwatch.start();

    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        int elapsed = _stopwatch.elapsedMilliseconds;

        // Jika lebih dari 24 jam → reset ke 0
        if (elapsed >= 24 * 60 * 60 * 1000) {
          _stopwatch.reset();
          elapsed = 0;
        }

        _displayTime = _formatTime(elapsed);
      });
    });
  }

  void _pause() {
    _stopwatch.stop();
    _timer.cancel();
  }

  void _reset() {
    _stopwatch.reset();
    _timer.cancel();

    setState(() {
      _displayTime = "00:00:00:00";
      _records.clear();
    });
  }

  void _record() {
    if (_records.length < 10) {
      setState(() {
        _records.add(_displayTime);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Maksimal 10 catatan waktu"),
        ),
      );
    }
  }

  String _formatTime(int milliseconds) {
    int hours = (milliseconds ~/ (1000 * 60 * 60)) % 24;
    int minutes = (milliseconds ~/ (1000 * 60)) % 60;
    int seconds = (milliseconds ~/ 1000) % 60;
    int ms = (milliseconds ~/ 10) % 100;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    String msStr = ms.toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr:$msStr";
  }

  @override
  void dispose() {
    if (_stopwatch.isRunning) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stopwatch"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const SizedBox(height: 20),

            /// Time
            Text(
              _displayTime,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 30),

            /// Tombol
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                ElevatedButton(
                  onPressed: _start,
                  child: const Text("Mulai"),
                ),

                ElevatedButton(
                  onPressed: _pause,
                  child: const Text("Pause"),
                ),

                ElevatedButton(
                  onPressed: _reset,
                  child: const Text("Reset"),
                ),

                ElevatedButton(
                  onPressed: _record,
                  child: const Text("Catat"),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Catatan Waktu (Max 10)",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            /// List Catatan
            Expanded(
              child: ListView.builder(
                itemCount: _records.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Text("#${index + 1}"),
                      title: Text(_records[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
