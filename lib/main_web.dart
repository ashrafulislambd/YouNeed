import 'package:flutter/material.dart';

void main() {
  runApp(const YouNeedWebApp());
}

class YouNeedWebApp extends StatelessWidget {
  const YouNeedWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouNeed - QR Payments',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('YouNeed'),
          backgroundColor: Colors.blue[800],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_scanner,
                size: 100,
                color: Colors.blue[800],
              ),
              const SizedBox(height: 20),
              const Text(
                'YouNeed QR Payment App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Scan to pay merchants instantly',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}