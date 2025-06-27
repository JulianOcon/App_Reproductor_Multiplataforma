import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  String _tipoUsuario = 'Basico';
  bool   _isLoading   = false;
  String _errorMsg    = '';

  InputDecoration _decoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: AppColors.labelColor),
    filled: true,
    fillColor: AppColors.fieldFill,
    border: const OutlineInputBorder(),
  );

  Future<void> _registrar() async {
    setState(() { _isLoading = true; _errorMsg = ''; });

    try {
      final res = await http.post(
        Uri.parse('http://192.168.1.2:3000/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre'      : _nombreCtrl.text.trim(),
          'apellidos'   : _apellidosCtrl.text.trim(),
          'telefono'    : _telefonoCtrl.text.trim(),
          'contrasena'  : _contrasenaCtrl.text.trim(),
          'tipo_usuario': _tipoUsuario,
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200 && data['success'] == true) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['mensaje'])),
          );
          Navigator.pop(context); // vuelve al login
        }
      } else {
        _errorMsg = data['mensaje'] ?? 'Error al registrar';
      }
    } catch (_) {
      _errorMsg = '❌ Error de red o servidor';
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _nombreCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _decoration('Nombre'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _apellidosCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _decoration('Apellidos'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _telefonoCtrl,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: _decoration('Teléfono'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contrasenaCtrl,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: _decoration('Contraseña'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _tipoUsuario,
              decoration: _decoration('Tipo de usuario'),
              dropdownColor: AppColors.fieldFill,
              items: ['Basico', 'Premium', 'Dedicado']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => setState(() => _tipoUsuario = v!),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _registrar,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(
                    horizontal: 50, vertical: 15),
              ),
              child: const Text('Registrar'),
            ),
            if (_errorMsg.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(_errorMsg, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
