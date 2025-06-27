import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../theme/colors.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  final _host = 'http://192.168.1.2:3000'; // Ajusta IP si cambias de red
  bool _loading = true;
  List<dynamic> _videos = [];
  String _mensajeErr = '';

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    setState(() { _loading = true; _mensajeErr = ''; });
    try {
      final res = await http.get(Uri.parse('$_host/api/videos'));
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        setState(() => _videos = data as List);
      } else {
        setState(() => _mensajeErr = data['mensaje'] ?? 'Error general');
      }
    } catch (_) {
      setState(() => _mensajeErr = 'Error de red');
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchVideos),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _mensajeErr.isNotEmpty
          ? Center(child: Text(_mensajeErr))
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _videos.length,
        itemBuilder: (_, i) {
          final v = _videos[i];
          return Card(
            color: const Color(0xFF1C1C1C),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Image.network(
                v['thumbnail'],
                width: 90,
                fit: BoxFit.cover,
              ),
              title: Text(
                v['titulo'],
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.play_circle_fill_rounded,
                  color: Colors.white),
              onTap: () {
                // TODO: navegar a VideoPlayerScreen
              },
            ),
          );
        },
      ),
    );
  }
}
