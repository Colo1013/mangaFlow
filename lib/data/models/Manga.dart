class Manga {
  final String id;
  final String title;
  final String coverUrl;
  final int currentVolume;
  final int totalVolume;
  final bool isFavorite;

  Manga({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.totalVolume,
    this.currentVolume = 0,
    this.isFavorite = false,
  });

  Manga copyWith({
    String? id,
    String? title,
    String? coverUrl,
    int? currentVolume,
    int? totalVolume,
    bool? isFavorite,
  }) {
    return Manga(
      id: id ?? this.id,
      title: title ?? this.title,
      coverUrl: coverUrl ?? this.coverUrl,
      totalVolume: totalVolume ?? this.totalVolume,
      currentVolume: currentVolume ?? this.currentVolume,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
