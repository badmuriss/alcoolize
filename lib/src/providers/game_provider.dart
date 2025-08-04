import 'package:flutter/foundation.dart';
import '../models/player_model.dart';
import '../models/game_model.dart';

class GameProvider extends ChangeNotifier {
  final PlayerList _players = PlayerList();
  GameSession? _currentSession;
  bool _isGameActive = false;
  
  PlayerList get players => _players;
  GameSession? get currentSession => _currentSession;
  bool get isGameActive => _isGameActive;
  List<String> get playerNames => _players.playerNames;
  
  void addPlayer(String name) {
    if (name.trim().isNotEmpty) {
      _players.addByName(name.trim());
      notifyListeners();
    }
  }
  
  void removePlayer(String name) {
    _players.removeByName(name);
    notifyListeners();
  }
  
  void clearPlayers() {
    _players.clear();
    notifyListeners();
  }
  
  void startGame(GameInfo gameInfo) {
    if (_players.isNotEmpty) {
      _currentSession = GameSession(
        gameInfo: gameInfo,
        players: _players.playerNames,
      );
      _isGameActive = true;
      notifyListeners();
    }
  }
  
  void endGame() {
    _currentSession = null;
    _isGameActive = false;
    notifyListeners();
  }
  
  void updateGameState(Map<String, dynamic> newState) {
    if (_currentSession != null) {
      _currentSession = _currentSession!.copyWith(gameState: newState);
      notifyListeners();
    }
  }
  
  void setCurrentPlayer(String playerName) {
    if (_currentSession != null) {
      _currentSession = _currentSession!.copyWith(currentPlayer: playerName);
      notifyListeners();
    }
  }
  
  Player? getRandomPlayer() {
    return _players.getRandomPlayer();
  }
  
  List<Player> getShuffledPlayers() {
    return _players.getShuffledPlayers();
  }
}