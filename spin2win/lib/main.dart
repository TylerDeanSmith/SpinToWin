import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SpinToWinApp());
}

class SpinToWinApp extends StatelessWidget {
  const SpinToWinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spin to Win',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
