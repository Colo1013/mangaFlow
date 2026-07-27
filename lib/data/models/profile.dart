import 'dart:ui';

class Profile {
  final String id;
  final String userName;
  final int totalExp;
  final String avatarPath;
  final int createdAt;

  static const Map<int, int> levelMap = {
    1: 0,
    2: 100,
    3: 200,
    4: 350,
    5: 680,
    6: 1300,
  };

  static const Map<int, String> levelNames = {
    1: "Novizio",
    2: "Lettore",
    3: "Appassionato",
    4: "Veterano",
    5: "Maestro",
    6: "Leggenda",
  };

  static const Map<int, Color> levelColors = {
    1: Color(0xFF9E9E9E),
    2: Color(0xFF64B5F6),
    3: Color(0xFF81C784),
    4: Color(0xFFFFB74D),
    5: Color(0xFFBA68C8),
    6: Color(0xFFE57373),
  };

  String get levelName => levelNames[level] ?? "???";
  Color get levelColor => levelColors[level] ?? const Color(0xFF9E9E9E);

  Profile({
    this.id = "1",
    required this.userName,
    required this.totalExp,
    this.avatarPath = 'assets/images/avatars/default.webp', // Default avatar
    required this.createdAt,
  });

  int get level {
    int out = 0;
    for (var entry in levelMap.entries) {
      out = entry.value <= totalExp ? entry.key : out;
    }
    return out;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "userName": userName,
      "totalExp": totalExp,
      "avatarPath": avatarPath,
      "createdAt": createdAt,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map["id"] ?? "1",
      userName: map["userName"] ?? "Utente",
      totalExp: map["totalExp"] ?? 0,
      avatarPath: map["avatarPath"] ?? 'assets/images/avatars/default.webp',
      createdAt: map["createdAt"] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Profile copyWith({
    String? id,
    String? userName,
    int? totalExp,
    String? avatarPath,
    int? createdAt,
  }) {
    return Profile(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      totalExp: totalExp ?? this.totalExp,
      avatarPath: avatarPath ?? this.avatarPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
