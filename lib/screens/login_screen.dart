import 'package:flutter/material.dart';
import 'package:app_reproductor_multiplataforma/theme/colors.dart'; // solo este

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor, // ✅ reemplaza 'primary'
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {},
          child: const Text("Iniciar sesión"),
        ),
      ),
    );
  }
}
