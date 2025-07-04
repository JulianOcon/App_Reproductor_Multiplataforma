import 'package:flutter/material.dart';
import '../core/app_config.dart';
import '../services/api_service.dart';
import '../theme/colors.dart';
import '../utils/device_utils.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool   _loading = false;
  String _error   = '';

  /* ───────── estilos reutilizables ───────── */
  InputDecoration _dec(String label) => InputDecoration(
    labelText : label,
    labelStyle: TextStyle(color: AppColors.labelColor),
    filled    : true,
    fillColor : AppColors.fieldFill,
    border    : const OutlineInputBorder(),
  );

  /* ───────── login ───────── */
  Future<void> _doLogin() async {
    setState((){ _loading = true; _error = ''; });
    final ok = await ApiService.login(
      _userCtrl.text.trim(),
      _passCtrl.text.trim(),
      await DeviceUtils.getDeviceHash(),
    );

    if (ok && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => _error = 'Credenciales inválidas');
    }
    if (mounted) setState(() => _loading = false);
  }

  /* ───────── UI ───────── */
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            Text('Iniciar Sesión',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,
                               color: AppColors.primaryColor)),
            const SizedBox(height: 32),

            TextField(controller:_userCtrl,  decoration:_dec('Usuario o teléfono'),
                      style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 16),
            TextField(controller:_passCtrl,  decoration:_dec('Contraseña'),
                      obscureText:true, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 24),

            _loading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _doLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal:50, vertical:15),
                    shape : RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Entrar'),
                ),

            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
              child: const Text('¿No tienes cuenta? Regístrate aquí',
                                style: TextStyle(color: Colors.blueAccent)),
            ),

            if (_error.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(_error, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    ),
  );
}
