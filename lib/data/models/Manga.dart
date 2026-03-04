class Manga {
  final String id;
  final String title;
  final String coverUrl;

  int currentVolume;
  int totalVolume;

  Manga({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.totalVolume,
    this.currentVolume = 0,
  });
}
