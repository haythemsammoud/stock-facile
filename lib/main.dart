import 'package:flutter/material.dart';
// main.dart – début du fichier
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Windows / Linux : SQLite passe par FFI
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const StockFacileApp());
}
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