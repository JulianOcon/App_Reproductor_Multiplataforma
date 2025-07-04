import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../core/app_config.dart';
import '../theme/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nombre     = TextEditingController();
  final _apellidos  = TextEditingController();
  final _telefono   = TextEditingController();
  final _contrasena = TextEditingController();

  String _tipo = 'Basico';
  bool   _loading = false;
  String _error   = '';

  InputDecoration _dec(String label) => InputDecoration(
    labelText : label,
    labelStyle: TextStyle(color: AppColors.labelColor),
    filled    : true,
    fillColor : AppColors.fieldFill,
    border    : const OutlineInputBorder(),
  );

  Future<void> _registrar() async {
    setState((){ _loading = true; _error = ''; });

    final res = await http.post(
      Uri.parse('${AppConfig.baseUrl}/api/register'),
      headers: {'Content-Type':'application/json'},
      body: jsonEncode({
        'nombre'      : _nombre.text.trim(),
        'apellidos'   : _apellidos.text.trim(),
        'telefono'    : _telefono.text.trim(),
        'contrasena'  : _contrasena.text.trim(),
        'tipo_usuario': _tipo,
      }),
    );

    final data = jsonDecode(res.body);
    if (res.statusCode == 200 && data['success'] == true) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data['mensaje'])));
        Navigator.pop(context);            // volver al login
      }
    } else {
      setState(() => _error = data['mensaje'] ?? 'Error al registrar');
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(title: const Text('Registro'),
                   backgroundColor: AppColors.primaryColor),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          TextField(controller:_nombre ,decoration:_dec('Nombre'   ),
                    style: const TextStyle(color: Colors.white)),
          const SizedBox(height:12),
          TextField(controller:_apellidos ,decoration:_dec('Apellidos'),
                    style: const TextStyle(color: Colors.white)),
          const SizedBox(height:12),
          TextField(controller:_telefono ,decoration:_dec('Teléfono'),
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white)),
          const SizedBox(height:12),
          TextField(controller:_contrasena ,decoration:_dec('Contraseña'),
                    obscureText:true, style: const TextStyle(color: Colors.white)),
          const SizedBox(height:12),
          DropdownButtonFormField<String>(
            value: _tipo, decoration:_dec('Tipo de usuario'),
            dropdownColor: AppColors.fieldFill,
            items: ['Basico','Premium','Dedicado']
                    .map((t)=>DropdownMenuItem(value:t, child:Text(t))).toList(),
            onChanged:(v)=>setState(()=>_tipo=v!),
          ),
          const SizedBox(height:24),
          _loading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed:_registrar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal:50,vertical:15)),
                child: const Text('Registrar')),
          if(_error.isNotEmpty)...[
            const SizedBox(height:16),
            Text(_error, style: const TextStyle(color: Colors.red)),
          ],
        ],
      ),
    ),
  );
}
