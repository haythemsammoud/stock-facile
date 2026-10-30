import 'package:flutter/material.dart';

void main() {
  runApp(const StockFacileApp());
}

class StockFacileApp extends StatelessWidget {
  const StockFacileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockFacile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal, // couleur de thème de votre choix
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('StockFacile'),
        ),
        body: const Center(
          child: Text('Bienvenue dans StockFacile'),
        ),
      ),
    );
  }
}