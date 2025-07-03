class Mp3Item {
  final String titulo;
  final String url;
  final String? cover;

  Mp3Item({required this.titulo, required this.url, this.cover});

  factory Mp3Item.fromJson(Map<String, dynamic> j) => Mp3Item(
    titulo: j['titulo'],
    url: j['url'],
    cover: j['cover'],
  );

  Map<String, dynamic> toJson() => {'titulo': titulo, 'url': url, 'cover': cover};

  String get artist => ''; // si tu backend trae artista añádelo
}
