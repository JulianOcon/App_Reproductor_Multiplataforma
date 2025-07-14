import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:blur/blur.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:marquee/marquee.dart'; // <-- Import marquee
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
  Color _dominantColor = AppColors.primaryColor;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _currentIndex = widget.initialIndex;
    _init();
  }

  Future<void> _init() async {
    final sources = widget.playlist.map((s) {
      return AudioSource.uri(Uri.parse(s.url), tag: s.titulo);
    }).toList();

    await _player.setAudioSource(
      ConcatenatingAudioSource(children: sources),
      initialIndex: _currentIndex,
    );

    _extractDominantColor();
    _player.play();

    _player.currentIndexStream.listen((i) {
      if (i != null && mounted) {
        setState(() => _currentIndex = i);
        _extractDominantColor();
      }
    });
  }

  Future<void> _extractDominantColor() async {
    final current = widget.playlist[_currentIndex];
    if (current.cover == null) return;

    final imageProvider = NetworkImage(current.cover!);
    final palette = await PaletteGenerator.fromImageProvider(imageProvider);

    setState(() {
      _dominantColor = palette.dominantColor?.color ?? AppColors.primaryColor;
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

    final background = current.cover != null
        ? Image.network(current.cover!, fit: BoxFit.cover)
        : Container(color: _dominantColor);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Blur(
              blur: 40,
              colorOpacity: 0.5,
              overlay: Container(color: _dominantColor.withOpacity(0.6)),
              child: background,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            // AppBar
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Carátula
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: current.cover != null
                                  ? Hero(
                                      tag: current.cover!,
                                      child: ClipRRect(
                                        key: ValueKey(current.cover),
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          current.cover!,
                                          width: 320,
                                          height: 320,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : const Icon(Icons.music_note,
                                      key: ValueKey('default-icon'),
                                      size: 180,
                                      color: Colors.white70),
                            ),

                            const SizedBox(height: 24),

                            // Título y artista con scroll automático si es muy largo
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Column(
                                key: ValueKey(current.titulo),
                                children: [
                                  SizedBox(
                                    height: 30,
                                    child: current.titulo.length > 30
                                        ? Marquee(
                                            text: current.titulo,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            scrollAxis: Axis.horizontal,
                                            blankSpace: 60,
                                            velocity: 30.0,
                                            pauseAfterRound: const Duration(seconds: 1),
                                            startPadding: 10,
                                            accelerationDuration: const Duration(seconds: 1),
                                            accelerationCurve: Curves.linear,
                                            decelerationDuration: const Duration(seconds: 1),
                                            decelerationCurve: Curves.easeOut,
                                          )
                                        : Text(
                                            current.titulo,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    height: 20,
                                    child: (current.autor ?? '').length > 30
                                        ? Marquee(
                                            text: current.autor ?? 'Artista desconocido',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white70,
                                            ),
                                            scrollAxis: Axis.horizontal,
                                            blankSpace: 40,
                                            velocity: 25.0,
                                            pauseAfterRound: const Duration(seconds: 1),
                                            startPadding: 10,
                                            accelerationDuration: const Duration(seconds: 1),
                                            accelerationCurve: Curves.linear,
                                            decelerationDuration: const Duration(seconds: 1),
                                            decelerationCurve: Curves.easeOut,
                                          )
                                        : Text(
                                            current.autor ?? 'Artista desconocido',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white70,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Botones sociales
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.thumb_up_alt_outlined),
                                  onPressed: () {},
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 24),
                                IconButton(
                                  icon: const Icon(Icons.playlist_add),
                                  onPressed: () {},
                                  color: Colors.white,
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Slider + Duración
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
                                          value: position.inSeconds.clamp(0, duration.inSeconds).toDouble(),
                                          max: duration.inSeconds.toDouble(),
                                          onChanged: (v) => _player.seek(Duration(seconds: v.toInt())),
                                          activeColor: _dominantColor,
                                          inactiveColor: Colors.white24,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(_formatTime(position),
                                                style: const TextStyle(color: Colors.white70)),
                                            Text(_formatTime(duration),
                                                style: const TextStyle(color: Colors.white70)),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),

                            const SizedBox(height: 20),

                            // Shuffle & Repeat
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    _player.shuffleModeEnabled ? Icons.shuffle_on : Icons.shuffle,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    final enable = !_player.shuffleModeEnabled;
                                    _player.setShuffleModeEnabled(enable);
                                    setState(() {});
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    _repeatIcon(_player.loopMode),
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    final next = _nextRepeatMode(_player.loopMode);
                                    _player.setLoopMode(next);
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),

                            const Spacer(),

                            // Controles de reproducción
                            StreamBuilder<PlayerState>(
                              stream: _player.playerStateStream,
                              builder: (_, snapshot) {
                                final playing = snapshot.data?.playing ?? false;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.skip_previous),
                                      onPressed: _player.hasPrevious ? _player.seekToPrevious : null,
                                      iconSize: 36,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 24),
                                    GestureDetector(
                                      onTap: playing ? _player.pause : _player.play,
                                      child: Container(
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _dominantColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color: _dominantColor.withOpacity(0.5),
                                              blurRadius: 20,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          playing ? Icons.pause : Icons.play_arrow,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    IconButton(
                                      icon: const Icon(Icons.skip_next),
                                      onPressed: _player.hasNext ? _player.seekToNext : null,
                                      iconSize: 36,
                                      color: Colors.white,
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  IconData _repeatIcon(LoopMode mode) {
    switch (mode) {
      case LoopMode.one:
        return Icons.repeat_one;
      case LoopMode.all:
        return Icons.repeat;
      case LoopMode.off:
      default:
        return Icons.repeat;
    }
  }

  LoopMode _nextRepeatMode(LoopMode current) {
    switch (current) {
      case LoopMode.off:
        return LoopMode.all;
      case LoopMode.all:
        return LoopMode.one;
      case LoopMode.one:
        return LoopMode.off;
    }
  }
}
