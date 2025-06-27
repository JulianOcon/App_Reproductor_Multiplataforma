import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/colors.dart';
import '../utils/device_utils.dart';
import 'register_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usuarioCtrl    = TextEditingController();
  final _contrasenaCtrl = TextEditingController();

  bool   _isLoading   = false;
  String _errorMsg    = '';

  /// ========= helpers =========
  InputDecoration _decoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: AppColors.labelColor),
    filled: true,
    fillColor: AppColors.fieldFill,
    border: const OutlineInputBorder(),
  );

  Future<void> _login() async {
    setState(() {
      _isLoading  = true;
      _errorMsg   = '';
    });

    final usuario      = _usuarioCtrl.text.trim();
    final contrasena   = _contrasenaCtrl.text.trim();
    final deviceHash   = await DeviceUtils.getDeviceHash();

    try {
      final res = await http.post(
        Uri.parse('http://192.168.1.2:3000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuario'          : usuario,
          'contrasena'       : contrasena,
          'dispositivo_hash' : deviceHash,
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200 && data['success'] == true) {
        // ✨ feedback
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('✅ Bienvenido, ${data['usuario']}')),
          );
          // Navegar a la pantalla principal
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        _errorMsg = data['mensaje'] ?? 'Credenciales inválidas';
      }
    } catch (_) {
      _errorMsg = '❌ Error de red o servidor';
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  /// ========= UI =========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  )),
              const SizedBox(height: 32),

              // ── Usuario ──────────────────────────────
              TextField(
                controller: _usuarioCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: _decoration('Usuario o teléfono'),
              ),
              const SizedBox(height: 16),

              // ── Contraseña ──────────────────────────
              TextField(
                controller: _contrasenaCtrl,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: _decoration('Contraseña'),
              ),
              const SizedBox(height: 24),

              // ── Botón ───────────────────────────────
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Entrar'),
              ),

              // ── Registro ────────────────────────────
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
                child: const Text(
                  '¿No tienes cuenta? Regístrate aquí',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),

              // ── Error ───────────────────────────────
              if (_errorMsg.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(_errorMsg, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
