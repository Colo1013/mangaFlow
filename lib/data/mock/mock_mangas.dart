import '../models/manga.dart';

final List<Manga> mockMangaList = [
  Manga(
    id: "m_001",
    title: "One Piece",
    coverUrl:
        "https://upload.wikimedia.org/wikipedia/it/5/5e/One_Piece_vol_1.jpg",
    totalVolume:
        108, // Aggiornato per realismo (One Piece non è ancora a 1000 volumi!)
    currentVolume: 15,
  ),
  Manga(
    id: 'm_005',
    title: 'Berserk',
    coverUrl:
        'https://upload.wikimedia.org/wikipedia/it/5/55/Berserk_60_1ed.jpg',
    totalVolume: 42,
    currentVolume: 15, // Ne hai letti un po'
  ),
  Manga(
    id: 'm_002',
    title: 'Naruto',
    coverUrl:
        'https://upload.wikimedia.org/wikipedia/it/thumb/3/3e/Naruto1.jpg/330px-Naruto1.jpg',
    totalVolume: 72,
    currentVolume: 72, // Finito!
  ),
  Manga(
    id: 'm_004',
    title: 'Death Note',
    coverUrl:
        'https://upload.wikimedia.org/wikipedia/en/6/6f/Death_Note_Vol_1.jpg',
    totalVolume: 12,
    currentVolume: 3,
  ),
  // --- Nuovi Manga Aggiunti ---
  Manga(
    id: 'm_006',
    title: 'Attack on Titan',
    coverUrl:
        'https://upload.wikimedia.org/wikipedia/en/d/d6/Shingeki_no_Kyojin_manga_volume_1.jpg',
    totalVolume: 34,
    currentVolume: 34, // Finito!
  ),
  Manga(
    id: 'm_007',
    title: 'Dragon Ball',
    coverUrl:
        'https://upload.wikimedia.org/wikipedia/it/thumb/3/3f/Dragon_Ball_cover_1.jpg/330px-Dragon_Ball_cover_1.jpg',
    totalVolume: 42,
    currentVolume: 20,
  ),
  Manga(
    id: 'm_008',
    title: 'Fullmetal Alchemist',
    coverUrl:
        'https://upload.wikimedia.org/wikipedia/it/thumb/1/1f/Fma01.jpg/330px-Fma01.jpg',
    totalVolume: 27,
    currentVolume: 10,
  ),
  Manga(
    id: 'm_009',
    title: 'Demon Slayer',
    coverUrl:
        'https://upload.wikimedia.org/wikipedia/en/0/09/Demon_Slayer_-_Kimetsu_no_Yaiba%2C_volume_1.jpg',
    totalVolume: 23,
    currentVolume: 5,
  ),
  Manga(
    id: 'm_010',
    title: 'Hunter x Hunter',
    coverUrl:
        'https://upload.wikimedia.org/wikipedia/it/thumb/7/77/Hunter_X_Hunter.jpg/330px-Hunter_X_Hunter.jpg',
    totalVolume: 38,
    currentVolume: 1, // Appena iniziato
  ),
  Manga(
    id: 'm_011',
    title: 'Bleach',
    coverUrl:
        'https://upload.wikimedia.org/wikipedia/it/thumb/e/ed/Bleachcopertina.jpg/330px-Bleachcopertina.jpg',
    totalVolume: 74,
    currentVolume: 45,
  ),
  Manga(
    id: 'm_012',
    title: 'My Hero Academia',
    coverUrl:
        'https://upload.wikimedia.org/wikipedia/en/5/5a/Boku_no_Hero_Academia_Volume_1.png',
    totalVolume: 40,
    currentVolume: 22,
  ),
];
