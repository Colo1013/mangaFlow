class Session {
  final int startTimestamp;
  final int endTimestamp;
  final String mangaId;
  final int expGained;

  Session({
    required this.startTimestamp,
    required this.endTimestamp,
    required this.mangaId,
    required this.expGained,
  });

  Session copyWith({
    int? startTimestamp,
    int? endTimestamp,
    String? mangaId,
    int? expGained,
  }) {
    return Session(
      startTimestamp: startTimestamp ?? this.startTimestamp,
      endTimestamp: endTimestamp ?? this.endTimestamp,
      mangaId: mangaId ?? this.mangaId,
      expGained: expGained ?? this.expGained,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "startTimestamp": startTimestamp,
      "endTimestamp": endTimestamp,
      "mangaId": mangaId,
      "expGained": expGained,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      startTimestamp: map["startTimestamp"],
      endTimestamp: map["endTimestamp"],
      mangaId: map["mangaId"],
      expGained: map["expGained"],
    );
  }
}
