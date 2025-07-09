import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static const _prefKey = 'base_url';

  static String? _baseUrl;           // se resuelve una sola vez
  static String  get baseUrl => _baseUrl!;

  /* ───────────────────────────────────────────── */
  static Future<void> init() async {
    final sp = await SharedPreferences.getInstance();

    // 1 ▸ ¿Ya teníamos una URL almacenada que siga respondiendo?
    _baseUrl = sp.getString(_prefKey);
    if (_baseUrl != null && await _isAlive(_baseUrl!)) return;

    // 2 ▸ Barrido automático por la sub‑red Wi‑Fi (192.168.x.x)
    final subnet = await _localSubnet();          // ej. «192.168.1»
    if (subnet != null) {
      final found = await _scanSubnet(subnet);
      if (found != null) {
        _baseUrl = found;
        await sp.setString(_prefKey, _baseUrl!);
        return;
      }
    }

    // 3 ▸ Último recurso: usa un valor por defecto y deja que falle
    //     (el error se mostrará en la UI y el dev sabrá ajustar).
    _baseUrl = 'http://192.168.1.2:3000';
  }

  /* ───────── helpers ───────── */

  /// Devuelve «192.168.1» a partir de la IP del teléfono, o `null`.
  static Future<String?> _localSubnet() async {
    final ip = await NetworkInfo().getWifiIP();   // p.e. 192.168.1.13
    if (ip == null || !ip.contains('.')) return null;
    final p = ip.split('.');
    return '${p[0]}.${p[1]}.${p[2]}';
  }

  /// Escanea 192.168.1.2‑254:3000 buscando `/api/ip`.
  static Future<String?> _scanSubnet(String subnet) async {
    for (var i = 2; i <= 254; i++) {
      final url = 'http://$subnet.$i:3000';
      if (await _isAlive(url)) return url;
    }
    return null;
  }

  /// Petición muy rápida; true si responde OK en < 800 ms.
  static Future<bool> _isAlive(String url) async {
    try {
      final res = await http
          .get(Uri.parse('$url/api/ip'))
          .timeout(const Duration(milliseconds: 800));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
