import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceUtils {
  static const _deviceHashKey = 'device_hash';

  static Future<String> getDeviceHash() async {
    final prefs = await SharedPreferences.getInstance();
    final savedHash = prefs.getString(_deviceHashKey);

    if (savedHash != null && savedHash.isNotEmpty) {
      return savedHash;
    }

    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId = 'unknown';

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id ?? androidInfo.model ?? 'android';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? iosInfo.name ?? 'ios';
    } else {
      deviceId = defaultTargetPlatform.name;
    }

    final hash = sha256.convert(utf8.encode(deviceId)).toString();
    await prefs.setString(_deviceHashKey, hash);

    return hash;
  }
}
