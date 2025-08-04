class Player {
  final String name;
  final int id;
  final DateTime joinedAt;
  
  Player({
    required this.name,
    required this.id,
    DateTime? joinedAt,
  }) : joinedAt = joinedAt ?? DateTime.now();
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Player && other.id == id && other.name == name;
  }
  
  @override
  int get hashCode => Object.hash(id, name);
  
  @override
  String toString() => 'Player(id: $id, name: $name)';
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
    'joinedAt': joinedAt.toIso8601String(),
  };
  
  factory Player.fromJson(Map<String, dynamic> json) => Player(
    name: json['name'] as String,
    id: json['id'] as int,
    joinedAt: DateTime.parse(json['joinedAt'] as String),
  );
}

class PlayerList {
  final List<Player> _players;
  
  PlayerList([List<Player>? players]) : _players = players ?? [];
  
  List<Player> get players => List.unmodifiable(_players);
  List<String> get playerNames => _players.map((p) => p.name).toList();
  
  int get length => _players.length;
  bool get isEmpty => _players.isEmpty;
  bool get isNotEmpty => _players.isNotEmpty;
  
  Player operator [](int index) => _players[index];
  
  void add(Player player) {
    if (!_players.contains(player)) {
      _players.add(player);
    }
  }
  
  void addByName(String name) {
    final player = Player(
      name: name,
      id: _players.length,
    );
    add(player);
  }
  
  void remove(Player player) {
    _players.remove(player);
  }
  
  void removeByName(String name) {
    _players.removeWhere((player) => player.name == name);
  }
  
  void clear() {
    _players.clear();
  }
  
  Player? getRandomPlayer() {
    if (_players.isEmpty) return null;
    final random = DateTime.now().millisecondsSinceEpoch % _players.length;
    return _players[random];
  }
  
  List<Player> getShuffledPlayers() {
    final shuffled = List<Player>.from(_players);
    shuffled.shuffle();
    return shuffled;
  }
  
  @override
  String toString() => 'PlayerList(${_players.length} players)';
}