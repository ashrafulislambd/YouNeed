import 'package:flutter/material.dart';
import 'donation_dashboard/donation_dashboard_screen.dart';

void main() {
  runApp(const DonationApp());
}

class DonationApp extends StatefulWidget {
  const DonationApp({super.key});

  @override
  State<DonationApp> createState() => _DonationAppState();
}

class _DonationAppState extends State<DonationApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donation Dashboard Demo',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: const DonationDashboardScreen(),
        floatingActionButton: FloatingActionButton(
          onPressed: _toggleTheme,
          child: Icon(_themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
        ),
      ),
    );
  }
}
