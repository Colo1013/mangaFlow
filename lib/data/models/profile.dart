class Profile {
  final int totalExp;
  final String userName;
  final int id = 1;
  static const Map<int, int> levelMap = {
    1: 0,
    2: 100,
    3: 200,
    4: 350,
    5: 680,
    6: 1300,
  };

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
