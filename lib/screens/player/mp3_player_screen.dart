import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../../theme/colors.dart';
import '../../models/mp3.dart';

class Mp3PlayerScreen extends StatefulWidget {
  final List<Mp3Item> playlist;
  final int initialIndex;

  const Mp3PlayerScreen({
    super.key,
    required this.playlist,
    required this.initialIndex,
  });

  @override
  State<Mp3PlayerScreen> createState() => _Mp3PlayerScreenState();
}

class _Mp3PlayerScreenState extends State<Mp3PlayerScreen> {
  late AudioPlayer _player;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _currentIndex = widget.initialIndex;
    _init();
  }

  Future<void> _init() async {
    final sources = widget.playlist.map((s) {
      return AudioSource.uri(
        Uri.parse(s.url),
        tag: s.titulo,
      );
    }).toList();

    await _player.setAudioSource(
      ConcatenatingAudioSource(children: sources),
      initialIndex: _currentIndex,
    );

    _player.play();

    _player.currentIndexStream.listen((i) {
      if (i != null && mounted) {
        setState(() => _currentIndex = i);
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.playlist[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reproducción MP3'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          children: [
            if (current.cover != null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    current.cover!,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              const Icon(Icons.music_note, color: Colors.white, size: 180),
            const SizedBox(height: 30),
            Text(
              current.titulo,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 40),
            StreamBuilder<PlayerState>(
              stream: _player.playerStateStream,
              builder: (_, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous, color: Colors.white),
                      iconSize: 40,
                      onPressed: _player.hasPrevious ? _player.seekToPrevious : null,
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: playing ? _player.pause : _player.play,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          playing ? Icons.pause : Icons.play_arrow,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white),
                      iconSize: 40,
                      onPressed: _player.hasNext ? _player.seekToNext : null,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 30),
            StreamBuilder<Duration?>(
              stream: _player.durationStream,
              builder: (_, snapshot) {
                final duration = snapshot.data ?? Duration.zero;
                return StreamBuilder<Duration>(
                  stream: _player.positionStream,
                  builder: (_, snap) {
                    final position = snap.data ?? Duration.zero;
                    return Column(
                      children: [
                        Slider(
                          activeColor: AppColors.primaryColor,
                          inactiveColor: Colors.grey[800],
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          value: position.inSeconds.clamp(0, duration.inSeconds).toDouble(),
                          onChanged: (v) =>
                              _player.seek(Duration(seconds: v.toInt())),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatTime(position),
                              style: const TextStyle(color: Colors.white70),
                            ),
                            Text(
                              _formatTime(duration),
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
