import '../models/manga.dart';

final List<Manga> mockMangaList = [
  Manga(
    id: "m_001",
    title: "One piece",
    coverUrl:
        "https://upload.wikimedia.org/wikipedia/it/5/5e/One_Piece_vol_1.jpg?_=20170115115456",
    totalVolume: 1000,
    currentVolume: 15,
  ),
  Manga(
    id: 'm_005',
    title: 'Berserk',
    coverUrl:
        'https://upload.wikimedia.org/wikipedia/it/5/55/Berserk_60_1ed.jpg',
    totalVolume: 41,
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
];
