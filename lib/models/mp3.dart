class Mp3Item {
  final String titulo;
  final String url;
  final String? cover;
  final String? autor; // Nuevo campo agregado

  Mp3Item({
    required this.titulo,
    required this.url,
    this.cover,
    this.autor,
  });

  factory Mp3Item.fromJson(Map<String, dynamic> j) => Mp3Item(
        titulo: j['titulo'],
        url: j['url'],
        cover: j['cover'],
        autor: j['autor'], // Asegúrate que tu JSON tenga esta clave
      );

  Map<String, dynamic> toJson() => {
        'titulo': titulo,
        'url': url,
        'cover': cover,
        'autor': autor,
      };
}
