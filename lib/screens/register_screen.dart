import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nombreCtrl     = TextEditingController();
  final _apellidosCtrl  = TextEditingController();
  final _telefonoCtrl   = TextEditingController();
  final _contrasenaCtrl = TextEditingController();

  String _tipo    = 'Basico';
  bool   _loading = false;
  String _error   = '';

  InputDecoration _dec(String l) => InputDecoration(
        labelText : l,
        labelStyle: TextStyle(color: AppColors.labelColor),
        filled    : true,
        fillColor : AppColors.fieldFill,
        border    : const OutlineInputBorder(),
      );

  Future<void> _registrar() async {
    setState(() { _loading = true; _error = ''; });

    final msg = await ApiService.register({
      'nombre'      : _nombreCtrl.text.trim(),
      'apellidos'   : _apellidosCtrl.text.trim(),
      'telefono'    : _telefonoCtrl.text.trim(),
      'contrasena'  : _contrasenaCtrl.text.trim(),
      'tipo_usuario': _tipo,
    });

    if (mounted) {
      if (msg?.toLowerCase().contains('correctamente') == true) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg!)));
        Navigator.pop(context);      // vuelve al login
      } else {
        setState(() => _error = msg ?? 'Error desconocido');
      }
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
            title: const Text('Registro'),
            backgroundColor: AppColors.primaryColor),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            TextField(
                controller: _nombreCtrl,
                decoration: _dec('Nombre'),
                style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 12),
            TextField(
                controller: _apellidosCtrl,
                decoration: _dec('Apellidos'),
                style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 12),
            TextField(
                controller: _telefonoCtrl,
                decoration: _dec('Teléfono'),
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 12),
            TextField(
                controller: _contrasenaCtrl,
                decoration: _dec('Contraseña'),
                obscureText: true,
                style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _tipo,
              decoration: _dec('Tipo de usuario'),
              dropdownColor: AppColors.fieldFill,
              items: ['Basico', 'Premium', 'Dedicado']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => setState(() => _tipo = v!),
            ),
            const SizedBox(height: 24),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _registrar,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15)),
                    child: const Text('Registrar')),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(_error, style: const TextStyle(color: Colors.red)),
            ],
          ]),
        ),
      );
}
