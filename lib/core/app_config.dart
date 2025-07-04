import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static const _prefKey = 'base_url';
  static String? _baseUrl;

  static String get baseUrl => _baseUrl!;   // ¡ya no es nullable cuando se usa!

  ///  Intenta encontrar el backend, guarda la URL y termina el arranque.
  static Future<void> init() async {
    final sp = await SharedPreferences.getInstance();

    // 1 · ¿Ya la conocíamos?
    _baseUrl = sp.getString(_prefKey);
    if (_baseUrl != null) return;

    // 2 · Intentamos la red local 192.168.1.x:3000  (ajusta si tu sub‑red es otra)
    final futures = <Future<String?>>[];
    for (var i = 2; i <= 254; i++) {
      final ip = 'http://192.168.1.$i:3000';
      futures.add(_ping(ip));
    }

    final firstAlive = (await Future.wait(futures)).firstWhere(
      (url) => url != null,
      orElse: () => null,
    );

    if (firstAlive == null) {
      throw Exception('No se localizó el backend en la red.');
    }

    _baseUrl = firstAlive;
    await sp.setString(_prefKey, _baseUrl!);
  }

  ///  Hace un GET muy rápido a /api/ip → si responde en < 800 ms devolvemos la URL.
  static Future<String?> _ping(String url) async {
    try {
      final res = await http
          .get(Uri.parse('$url/api/ip'))
          .timeout(const Duration(milliseconds: 800));
      if (res.statusCode == 200) return url;
    } catch (_) {}
    return null;
  }
}
