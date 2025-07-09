import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/app_config.dart';
import '../core/auth_store.dart';
import '../models/video.dart';
import '../models/mp3.dart';

class ApiService {
  /* ───────── login ───────── */
  static Future<bool> login(
      String usuario, String pass, String deviceHash) async {
    final res = await http.post(
      Uri.parse('${AppConfig.baseUrl}/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuario'          : usuario,
        'contrasena'       : pass,
        'dispositivo_hash' : deviceHash,
      }),
    );

    if (res.statusCode != 200) return false;
    final data = jsonDecode(res.body);
    if (data['success'] != true) return false;

    await AuthStore.saveToken(data['token']);
    return true;
  }

  /* ───────── registro ───────── */
  static Future<String?> register(Map<String, dynamic> payload) async {
    final res = await http.post(
      Uri.parse('${AppConfig.baseUrl}/api/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    final data = jsonDecode(res.body);
    return data['mensaje'];
  }

  /* ───────── helpers ───────── */
  static Map<String, String> get _auth =>
      {'Authorization': 'Bearer ${AuthStore.token}'};

  /* ───────── endpoints ───────── */
  static Future<List<VideoItem>> getAllVideos() async {
    final res = await http.get(
      Uri.parse('${AppConfig.baseUrl}/api/videos'),
      headers: _auth,
    );
    if (res.statusCode != 200) {
      throw Exception('Error ${res.statusCode} al obtener videos');
    }
    return (jsonDecode(res.body) as List)
        .map((e) => VideoItem.fromJson(e))
        .toList();
  }

  static Future<List<Mp3Item>> getAllMp3() async {
    final res = await http.get(
      Uri.parse('${AppConfig.baseUrl}/api/mp3'),
      headers: _auth,
    );
    if (res.statusCode != 200) {
      throw Exception('Error ${res.statusCode} al obtener MP3');
    }
    return (jsonDecode(res.body) as List)
        .map((e) => Mp3Item.fromJson(e))
        .toList();
  }
}
