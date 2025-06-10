import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'theme/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reproductor de Videos',
      theme: appTheme,
      home: LoginScreen(), // Puedes cambiar esta referencia a otra pantalla después
    );
  }
}
