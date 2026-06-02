import 'package:flutter/material.dart';
import 'symptom_selector.dart';

void main() {
  runApp(const DiseasePredictionApp());
}

class DiseasePredictionApp extends StatelessWidget {
  const DiseasePredictionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Disease Predictor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D15),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C63FF),
          secondary: Color(0xFF00FFC2),
          surface: Color(0xFF1E1E2C),
          background: Color(0xFF0D0D15),
        ),
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ),
      home: const SymptomSelectorScreen(),
    );
  }
}
