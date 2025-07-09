import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/video.dart';

class FavoritesStore {
  static const _key = 'favorite_videos';
  static final List<VideoItem> _favorites = [];

  static List<VideoItem> get all => List.unmodifiable(_favorites);

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];

    _favorites.clear();
    for (final jsonStr in jsonList) {
      try {
        final map = json.decode(jsonStr);
        final video = VideoItem.fromJson(map);

        // ✅ Solo guardar favoritos completos
        if (video.id.isNotEmpty && video.title.isNotEmpty && video.url.isNotEmpty) {
          _favorites.add(video);
        }
      } catch (_) {
        // Ignorar errores de parsing
      }
    }
  }

  static bool isFavorite(VideoItem video) {
    return _favorites.any((v) => v.id == video.id);
  }

  static void toggle(VideoItem video) async {
    final index = _favorites.indexWhere((v) => v.id == video.id);
    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      // ✅ Aseguramos guardar datos válidos
      if (video.id.isEmpty || video.title.isEmpty || video.url.isEmpty) return;
      _favorites.add(video);
    }
    await _save();
  }

  static Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _favorites.map((v) => json.encode(v.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }
}
