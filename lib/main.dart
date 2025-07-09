import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_config.dart';
import 'core/auth_store.dart';
import 'theme/theme.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';
import 'core/favorites_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.init();
  await AuthStore.init();
  await FavoritesStore.init(); // ✅ NO OLVIDAR ESTO

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reproductor Multimedia',
      theme: AppTheme.lightTheme,
      home: AuthStore.isLoggedIn
          ? const HomeScreen()
          : const LoginScreen(),
      routes: {
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}
