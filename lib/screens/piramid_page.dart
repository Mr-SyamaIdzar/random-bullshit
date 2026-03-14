import 'package:flutter/material.dart';

class PiramidPage extends StatefulWidget {
  const PiramidPage({Key? key}) : super(key: key);

  @override
  State<PiramidPage> createState() => _PiramidPageState();
}

class _PiramidPageState extends State<PiramidPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Piramid'),
      ),
      body: const Center(
        child: Text('Piramid Page'),
      ),
    );
  }
}
