import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/about_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String about = '/about';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      about: (context) => const AboutScreen(),
    };
  }
}
