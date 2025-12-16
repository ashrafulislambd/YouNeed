import 'package:flutter/material.dart';
import 'theme_provider.dart';
import 'transaction/transaction_screen.dart';
import 'auth/register_screen.dart';

import 'credit/credit_screen.dart';

void main() {
  runApp(const YouNeedApp());
}

class YouNeedApp extends StatelessWidget {
  const YouNeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'YouNeed Dashboard',
          themeMode: currentMode,
          // Define Light Theme
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF5F7FA),
            primaryColor: Colors.deepPurple,
            cardColor: Colors.white,
            shadowColor: Colors.black12,
            dividerColor: Colors.grey[300],
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            useMaterial3: true,
            fontFamily: 'Roboto',
          ),
          // Define Dark Theme
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
            primaryColor: Colors.deepPurpleAccent,
            cardColor: const Color(0xFF1E1E1E),
            shadowColor: Colors.black54,
            dividerColor: const Color(0xFF333333),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF121212),
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            useMaterial3: true,
            fontFamily: 'Roboto',
          ),
          // Define Routes
          initialRoute: '/register',
          routes: {
            '/': (context) => const TransactionScreen(),
            '/register': (context) => const RegisterScreen(),
            '/credit': (context) => const CreditScreen(),
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
