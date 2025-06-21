import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl = 'http://192.168.1.30:3000';

  static Future<bool> login(String usuario, String password, String deviceHash) async {
    final url = Uri.parse('$_baseUrl/api/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuario': usuario,'contrasena': password,
        'device_hash': deviceHash,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('nombre', data['nombre']);
      await prefs.setInt('id_usuario', data['id_usuario']);
      return true;
    } else {
      return false;
    }
  }

  static Future<List<dynamic>> fetchMp3List() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse('$_baseUrl/api/mp3');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Beaner $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener Mp3: ${response.statusCode}');
    }
  }

  static Future<List<dynamic>> fetchVideoList() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse('$_baseUrl/api/videos');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener videos: ${response.statusCode}');
    }
  }
}