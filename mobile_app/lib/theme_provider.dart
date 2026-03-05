
import 'package:flutter/material.dart';

// Global Notifier for Theme Toggle
// Moved here to avoid circular imports between main.dart and transaction_screen.dart
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);
