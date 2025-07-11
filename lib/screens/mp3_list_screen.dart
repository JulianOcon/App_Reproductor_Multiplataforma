import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../models/mp3.dart';
import '../services/api_service.dart';
import 'player/mp3_player_screen.dart';

class Mp3ListScreen extends StatefulWidget {
  const Mp3ListScreen({super.key});

  @override
  State<Mp3ListScreen> createState() => _Mp3ListScreenState();
}

class _Mp3ListScreenState extends State<Mp3ListScreen> {
  bool _loading = true;
  List<Mp3Item> _mp3List = [];
  String _err = '';

  @override
  void initState() {
    super.initState();
    _fetchMp3();
  }

  Future<void> _fetchMp3() async {
    setState(() {
      _loading = true;
      _err = '';
    });
    try {
      final items = await ApiService.getAllMp3();
      _mp3List = items;
    } catch (e) {
      _err = 'Error: $e';
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MP3'),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchMp3),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _err.isNotEmpty
              ? Center(child: Text(_err, style: const TextStyle(color: Colors.white)))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _mp3List.length,
                  itemBuilder: (_, i) {
                    final s = _mp3List[i];
                    return Card(
                      color: const Color(0xFF1C1C1C),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: s.cover != null
                            ? Image.network(
                                s.cover!,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.music_note,
                                color: Colors.white, size: 40),
                        title: Text(
                          s.titulo,
                          style: const TextStyle(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(Icons.play_arrow, color: Colors.white),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Mp3PlayerScreen(
                                playlist: _mp3List,
                                initialIndex: i,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
