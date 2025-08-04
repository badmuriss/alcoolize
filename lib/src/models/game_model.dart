import 'package:flutter/material.dart';

enum GameType {
  roulette,
  cards,
  dice,
  kingsCup,
  mostLikely,
  neverHaveIEver,
  wouldYouRather,
}

class GameInfo {
  final GameType type;
  final String name;
  final String description;
  final Color color;
  final IconData? icon;
  final int minPlayers;
  final int maxPlayers;
  final Duration? estimatedDuration;
  
  const GameInfo({
    required this.type,
    required this.name,
    required this.description,
    required this.color,
    this.icon,
    this.minPlayers = 2,
    this.maxPlayers = 20,
    this.estimatedDuration,
  });
  
  @override
  String toString() => 'GameInfo(type: $type, name: $name)';
}

class GameSession {
  final GameInfo gameInfo;
  final List<String> players;
  final DateTime startTime;
  final String? currentPlayer;
  final Map<String, dynamic> gameState;
  
  GameSession({
    required this.gameInfo,
    required this.players,
    DateTime? startTime,
    this.currentPlayer,
    Map<String, dynamic>? gameState,
  }) : startTime = startTime ?? DateTime.now(),
       gameState = gameState ?? {};
  
  Duration get elapsedTime => DateTime.now().difference(startTime);
  
  GameSession copyWith({
    GameInfo? gameInfo,
    List<String>? players,
    DateTime? startTime,
    String? currentPlayer,
    Map<String, dynamic>? gameState,
  }) {
    return GameSession(
      gameInfo: gameInfo ?? this.gameInfo,
      players: players ?? this.players,
      startTime: startTime ?? this.startTime,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      gameState: gameState ?? this.gameState,
    );
  }
  
  @override
  String toString() => 'GameSession(game: ${gameInfo.name}, players: ${players.length})';
}