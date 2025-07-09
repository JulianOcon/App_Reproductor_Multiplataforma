import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStore {
  static const _kToken = 'jwt_token';
  static late SharedPreferences _sp;

  static String? _token;
  static String? get token => _token;

  static Future<void> init() async {
    _sp = await SharedPreferences.getInstance();
    final t = _sp.getString(_kToken);

    if (t != null && !JwtDecoder.isExpired(t)) {
      _token = t;                 // válido → seguimos conectados
    } else {
      _token = null;              // expiró → forzamos login
      _sp.remove(_kToken);
    }
  }

  static Future<void> saveToken(String t) async {
    _token = t;
    await _sp.setString(_kToken, t);
  }

  static Future<void> logout() async {
    _token = null;
    await _sp.remove(_kToken);
  }

  static bool get isLoggedIn => _token != null;
}
