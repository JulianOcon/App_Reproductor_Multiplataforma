import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../core/favorites_store.dart';

import '../../models/video.dart';
import '../../services/api_service.dart';
import '../../theme/colors.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoItem video;
  const VideoPlayerScreen({super.key, required this.video});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final VideoPlayerController _controller;
  ChewieController? _chewie;

  late bool _isFavorite;
  bool _loadingRecs = true;
  String? _error;

  List<VideoItem> _recs = [];

  @override
  void initState() {
    super.initState();
    _initPlayer();
    _loadRecs();
    _isFavorite = FavoritesStore.isFavorite(widget.video);
  }

  Future<void> _initPlayer() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video.url));

    try {
      await _controller.initialize();
      if (!mounted) return;

      _chewie = ChewieController(
        videoPlayerController: _controller,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        autoInitialize: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.blueAccent,
          handleColor: Colors.lightBlue,
          bufferedColor: Colors.blueGrey,
          backgroundColor: Colors.black26,
        ),
      );

      setState(() {});
    } catch (e) {
      if (!mounted) return;
      _error = 'No se pudo iniciar el vídeo.\n$e';
      setState(() {});
    }
  }

  Future<void> _loadRecs() async {
    try {
      final all = await ApiService.getAllVideos();
      _recs = all.where((v) => v.url != widget.video.url).take(6).toList();
    } catch (_) {}
    if (mounted) setState(() => _loadingRecs = false);
  }

  @override
  void dispose() {
    _chewie?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerArea = AspectRatio(
      aspectRatio: _controller.value.isInitialized
          ? _controller.value.aspectRatio
          : 16 / 9,
      child: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            )
          : (_chewie == null
              ? const Center(child: CircularProgressIndicator())
              : Chewie(controller: _chewie!)),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            /* ── reproductor + botón atrás ───────────── */
            Stack(
              children: [
                playerArea,
                Positioned(
                  left: 8,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),

            /* ── título + favorito ───────────── */
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: _isFavorite ? Colors.redAccent : Colors.white,
                    ),
                    onPressed: () {
                      FavoritesStore.toggle(widget.video);
                      setState(() => _isFavorite = !_isFavorite);
                    },
                  ),
                ],
              ),
            ),

            /* ── recomendados ───────────── */
            _loadingRecs
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _recs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final v = _recs[i];
                        return GestureDetector(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VideoPlayerScreen(video: v),
                            ),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  v.thumbnail,
                                  width: 120,
                                  height: 68,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  v.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
