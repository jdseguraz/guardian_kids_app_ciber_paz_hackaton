class UserProfile {
  final String name;
  final int points;
  final int gamesWon;
  final int gamesLost;
  final int totalGames;

  UserProfile({
    required this.name,
    required this.points,
    required this.gamesWon,
    required this.gamesLost,
  }) : totalGames = gamesWon + gamesLost;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'points': points,
      'gamesWon': gamesWon,
      'gamesLost': gamesLost,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? 'Usuario',
      points: json['points'] ?? 0,
      gamesWon: json['gamesWon'] ?? 0,
      gamesLost: json['gamesLost'] ?? 0,
    );
  }

  UserProfile copyWith({
    String? name,
    int? points,
    int? gamesWon,
    int? gamesLost,
  }) {
    return UserProfile(
      name: name ?? this.name,
      points: points ?? this.points,
      gamesWon: gamesWon ?? this.gamesWon,
      gamesLost: gamesLost ?? this.gamesLost,
    );
  }
}
