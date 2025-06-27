import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../theme/colors.dart';

class Mp3ListScreen extends StatefulWidget {
  const Mp3ListScreen({super.key});

  @override
  State<Mp3ListScreen> createState() => _Mp3ListScreenState();
}

class _Mp3ListScreenState extends State<Mp3ListScreen> {
  final _host = 'http://192.168.1.2:3000';
  bool _loading = true;
  List<dynamic> _songs = [];
  String _err = '';

  @override
  void initState() {
    super.initState();
    _fetchMp3();
  }

  Future<void> _fetchMp3() async {
    setState(() { _loading = true; _err = ''; });
    try {
      final res = await http.get(Uri.parse('$_host/api/mp3'));
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        setState(() => _songs = data as List);
      } else {
        setState(() => _err = data['mensaje'] ?? 'Error general');
      }
    } catch (_) {
      setState(() => _err = 'Error de red');
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MP3'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchMp3),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _err.isNotEmpty
          ? Center(child: Text(_err))
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _songs.length,
        itemBuilder: (_, i) {
          final s = _songs[i];
          return Card(
            color: const Color(0xFF1C1C1C),
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: s['cover'] != null
                  ? Image.network(s['cover']!, width: 56, height: 56, fit: BoxFit.cover)
                  : const Icon(Icons.music_note, color: Colors.white, size: 40),
              title: Text(
                s['titulo'],
                style: const TextStyle(color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.play_arrow, color: Colors.white),
              onTap: () {
                // TODO: navegar a Mp3PlayerScreen
              },
            ),
          );
        },
      ),
    );
  }
}
