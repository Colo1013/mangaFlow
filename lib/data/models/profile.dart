import 'dart:ui';

class Profile {
  final int totalExp;
  final String userName;
  final String id = "1";
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
    1: Color(0xFF9E9E9E), // grigio tenue
    2: Color(0xFF64B5F6), // azzurro polvere
    3: Color(0xFF81C784), // verde salvia
    4: Color(0xFFFFB74D), // arancio caldo
    5: Color(0xFFBA68C8), // viola
    6: Color(0xFFE57373), // rosso oro
  };

  String get levelName => levelNames[level] ?? "???";
  Color get levelColor => levelColors[level] ?? const Color(0xFF9E9E9E);

  Profile({required this.totalExp, required this.userName, id});

  int get level {
    int out = 0;
    for (var entry in levelMap.entries) {
      out = entry.value <= totalExp ? entry.key : out;
    }
    return out;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "totalExp": totalExp,
      "userName": userName,
      "id": id,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      totalExp: map["totalExp"],
      userName: map["userName"],
      id: map["id"],
    );
  }

  Profile copyWith({int? totalExp, String? userName}) {
    return Profile(
      totalExp: totalExp ?? this.totalExp,
      userName: userName ?? this.userName,
    );
  }
}
