import 'package:flutter/material.dart';

class KalkulatorPage extends StatefulWidget {
  const KalkulatorPage({Key? key}) : super(key: key);

  @override
  State<KalkulatorPage> createState() => _KalkulatorPageState();
}

class _KalkulatorPageState extends State<KalkulatorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator'),
      ),
      body: const Center(
        child: Text('Kalkulator Page'),
      ),
    );
  }
}
