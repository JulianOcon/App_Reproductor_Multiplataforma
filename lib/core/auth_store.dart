import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStore {
  static const _kToken = 'jwt_token';
  static late SharedPreferences _sp;

  static String? _token;
  static String? get token => _token;

  /// Lee de disco y comprueba expiración.
  static Future<void> init() async {
    _sp = await SharedPreferences.getInstance();
    final t = _sp.getString(_kToken);

    if (t != null && !JwtDecoder.isExpired(t)) {
      _token = t;
    } else {
      _token = null;
      _sp.remove(_kToken);
    }
  }

  static Future<void> saveToken(String token) async {
    _token = token;
    await _sp.setString(_kToken, token);
  }

  static Future<void> logout() async {
    _token = null;
    await _sp.remove(_kToken);
  }

  static bool get isLoggedIn => _token != null;
}
