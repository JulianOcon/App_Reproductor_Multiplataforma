import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/video.dart';
import '../models/mp3.dart';

class ApiService {
  static const String _base = 'http://192.168.1.7:3000/api';

  /* ─────────── Helpers ─────────── */

  static Future<SharedPreferences> _prefs() =>
      SharedPreferences.getInstance();

  static Future<String> _token() async =>
      (await _prefs()).getString('token') ?? '';

  static Map<String, String> _authHeaders(String token) =>
      {'Authorization': 'Bearer $token'};

  /* ─────────── Login ─────────── */

  static Future<bool> login(
      String usuario, String contrasena, String dispositivoHash) async {
    final res = await http.post(
      Uri.parse('$_base/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuario': usuario,
        'contrasena': contrasena,
        'dispositivo_hash': dispositivoHash,
      }),
    );

    if (res.statusCode != 200) return false;
    final data = jsonDecode(res.body);
    if (data['success'] != true) return false;

    final sp = await _prefs();
    await sp.setString('token', data['token']);
    await sp.setString('usuario', data['usuario']);
    await sp.setString('tipo_usuario', data['tipo_usuario']);
    return true;
  }

  static Future<void> logout() async {
    final sp = await _prefs();
    await sp.remove('token');
    await sp.remove('usuario');
    await sp.remove('tipo_usuario');
  }

  /* ─────────── Videos ─────────── */

  static Future<List<VideoItem>> getAllVideos() async {
    final res = await http.get(
      Uri.parse('$_base/videos'),
      headers: _authHeaders(await _token()),
    );
    if (res.statusCode != 200) {
      throw Exception('Error ${res.statusCode} al obtener videos');
    }
    final List<dynamic> jsonList = jsonDecode(res.body);
    return jsonList.map((e) => VideoItem.fromJson(e)).toList();
  }

  /* ─────────── MP3 ─────────── */

  static Future<List<Mp3Item>> getAllMp3() async {
    final res = await http.get(
      Uri.parse('$_base/mp3'),
      headers: _authHeaders(await _token()),
    );
    if (res.statusCode != 200) {
      throw Exception('Error ${res.statusCode} al obtener MP3');
    }
    final List<dynamic> jsonList = jsonDecode(res.body);
    return jsonList.map((e) => Mp3Item.fromJson(e)).toList();
  }
}
