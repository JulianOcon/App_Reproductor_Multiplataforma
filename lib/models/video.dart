class VideoItem {
  final String titulo;
  final String url;
  final String thumbnail;

  VideoItem({
    required this.titulo,
    required this.url,
    required this.thumbnail,
  });

  factory VideoItem.fromJson(Map<String, dynamic> j) => VideoItem(
    titulo: j['titulo'],
    url: j['url'],
    thumbnail: j['thumbnail'],
  );

  Map<String, dynamic> toJson() =>
      {'titulo': titulo, 'url': url, 'thumbnail': thumbnail};

  // Atajo para mostrar título en UI sin subrayados/guiones:
  String get title => titulo.replaceAll('_', ' ');
}
