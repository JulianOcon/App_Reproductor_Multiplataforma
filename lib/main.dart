import 'package:flutter/material.dart';
import 'core/app_config.dart';
import 'core/auth_store.dart';
import 'theme/theme.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.init(); // 🔍 IP dinámica
  await AuthStore.init(); // 🔒 carga / valida token
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Reproductor Multimedia',
    theme: AppTheme.lightTheme,
    home:
        AuthStore
            .isLoggedIn // ← decide pantalla inicial
        ? const HomeScreen()
        : const LoginScreen(),
    routes: {
      '/register': (_) => const RegisterScreen(),
      '/home': (_) => const HomeScreen(),
    },
  );
}
