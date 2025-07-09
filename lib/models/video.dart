class VideoItem {
  final String id;
  final String title;
  final String url;
  final String thumbnail;

  VideoItem({
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnail,
  });

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    // Debug temporal para ver qué trae el json
    print('JSON recibido para VideoItem: $json');

    final id = (json['id'] != null)
        ? json['id'].toString()
        : (json['url'] != null)
            ? json['url'].toString()
            : 'sin-id';

    final title = (json['titulo'] != null && json['titulo'].toString().trim().isNotEmpty)
        ? json['titulo'].toString()
        : 'Sin título';

    final url = (json['url'] != null) ? json['url'].toString() : '';

    final thumbnail = (json['thumbnail'] != null) ? json['thumbnail'].toString() : '';

    return VideoItem(id: id, title: title, url: url, thumbnail: thumbnail);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': title,  // aquí también si quieres que el JSON tenga "titulo"
        'url': url,
        'thumbnail': thumbnail,
      };
}
