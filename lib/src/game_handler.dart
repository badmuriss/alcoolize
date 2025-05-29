import 'dart:math';
import 'package:alcoolize/src/cards_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'paranoia_screen.dart';
import 'who_is_more_likely_screen.dart';
import 'never_have_i_ever_screen.dart';
import 'medusa_screen.dart';
import 'forbidden_word_screen.dart';
import 'tibitar_screen.dart';
import 'roulette_screen.dart';

class GameHandler {
  static bool _initialized = false;
  static bool _canRepeat = false;
  static List<Widget Function(BuildContext, List<String>)> activeGamesList = [];
  static Map<String, bool> _enabledGames = {};

  static final Map<String, Widget Function(BuildContext, List<String>)> allGames = {
    'PARANOIA': (context, players) => ParanoiaScreen(playersList: players),
    'QUEM É MAIS PROVÁVEL': (context, players) => WhoIsMoreLikelyScreen(playersList: players), 
    'EU NUNCA': (context, players) => NeverHaveIEverScreen(playersList: players),
    'MEDUSA': (context, players) => MedusaScreen(playersList: players),
    'PALAVRA PROIBIDA': (context, players) => ForbiddenWordScreen(playersList: players, usedWords: GameHandler.usedWords),
    'TIBITAR': (context, players) => TibitarScreen(playersList: players),
    'ROLETINHA': (context, players) => RouletteScreen(playersList: players),
    'CARTAS': (context, players) => CardsScreen(playersList: players),
  };

  // Lista de palavras para o jogo 'Palavra Proibida'
  static List<String> usedWords = [];

  // Pesos de cada jogo
  static Map<String, double> gameWeights = {
    'PARANOIA': 9.0,
    'QUEM É MAIS PROVÁVEL': 21.0,
    'EU NUNCA': 22.0,
    'MEDUSA': 8.0,
    'PALAVRA PROIBIDA': 2.0,
    'TIBITAR': 2.0,
    'ROLETINHA': 12.0,
    'CARTAS': 24.0,
  };

  static void resetUsedWords() {
    usedWords.clear(); // Esvazia a lista de palavras
  }

  // Método para verificar se um jogo está habilitado
  static bool isGameEnabled(String gameName) {
    return _enabledGames.containsKey(gameName) && _enabledGames[gameName] == true;
  }

  // Método para inicializar o GameHandler com dados do SharedPreferences
  static Future<void> initialize() async {
    if (!_initialized) {
      try {
        // Inicializa o mapa de jogos habilitados com valores padrão
        _enabledGames = {};
        for (var gameName in allGames.keys) {
          _enabledGames[gameName] = true;
        }

        // Carrega as configurações salvas
        await _loadSettings();
        
        // Atualiza a lista de jogos ativos
        _updateActiveGamesList();
        
        _initialized = true;
      } catch (e) {
      }
    }
  }

  // Método para carregar configurações do SharedPreferences
  static Future<void> _loadSettings() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Carrega os jogos habilitados
      _enabledGames.forEach((game, _) {
        _enabledGames[game] = prefs.getBool(game) ?? true;
      });
      
      // Carrega o valor de canRepeat
      _canRepeat = prefs.getBool('canRepeat') ?? false;
      
      // Carrega os pesos dos jogos
      for (var gameName in allGames.keys) {
        double savedWeight = prefs.getDouble('weight_$gameName') ?? gameWeights[gameName] ?? 0.0;
        gameWeights[gameName] = savedWeight;
      }
    } catch (e) {
    }
  }

  // Método para atualizar a lista de jogos ativos com base nos jogos habilitados
  static void _updateActiveGamesList() {
    activeGamesList.clear();
    
    _enabledGames.forEach((gameName, isEnabled) {
      if (isEnabled && allGames.containsKey(gameName)) {
        activeGamesList.add(allGames[gameName]!);
      }
    });

    // Se nenhum jogo estiver ativo, ativa todos
    if (activeGamesList.isEmpty) {
      for (var gameName in _enabledGames.keys) {
        if (allGames.containsKey(gameName)) {
          _enabledGames[gameName] = true;
          activeGamesList.add(allGames[gameName]!);
        }
      }
    }
  }

  // Método para atualizar a lista de jogos e salvar configurações
  static Future<void> updateGamesList(Map<String, bool> enabledGames, [bool? canRepeat]) async {
    // Atualiza o mapa de jogos habilitados
    _enabledGames = Map.from(enabledGames);
    
    // Atualiza o valor de canRepeat se fornecido
    if (canRepeat != null) {
      _canRepeat = canRepeat;
    }
    
    // Atualiza a lista de jogos ativos
    _updateActiveGamesList();
    
    // Atualiza os pesos dos jogos desabilitados para 0
    gameWeights.forEach((gameName, weight) {
      if (_enabledGames[gameName] != true) {
        gameWeights[gameName] = 0.0;
      }
    });
    
    // Salva as configurações
    await _saveSettings();
  }

  // Método para salvar configurações no SharedPreferences
  static Future<void> _saveSettings() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Salva os jogos habilitados
      _enabledGames.forEach((game, enabled) {
        prefs.setBool(game, enabled);
      });
      
      // Salva o valor de canRepeat
      prefs.setBool('canRepeat', _canRepeat);
      
      // Salva os pesos dos jogos
      gameWeights.forEach((gameName, weight) {
        prefs.setDouble('weight_$gameName', weight);
      });
    } catch (e) {
    }
  }

  // Método para atualizar os pesos dos jogos
  static Future<void> updateGameWeights(Map<String, double> newWeights) async {
    gameWeights = Map.from(newWeights);
    await _saveSettings();
  }

  static Type? lastGameType;

  static Widget chooseRandomGame(BuildContext context, List<String> playersList) {
    // Verifica se há jogos disponíveis
    if (activeGamesList.isEmpty) {
      throw Exception("Nenhum jogo está ativo.");
    }

    // Filtra os jogos ativos para garantir que não seja o mesmo tipo que o último jogo
    final availableGames = activeGamesList.where((game) {
      final gameType = game(context, playersList).runtimeType;
      return gameType != lastGameType || _canRepeat;
    }).toList();

    Widget Function(BuildContext, List<String>) randomGame;

    // Escolhe um jogo aleatoriamente, garantindo que o tipo não se repita
    if (availableGames.isNotEmpty) {
      // Escolhe aleatoriamente com base nos pesos
      final weightedGames = _getWeightedGames(availableGames);
      randomGame = weightedGames[Random().nextInt(weightedGames.length)];
    } else {
      // Se não houver mais opções, permite repetir jogos
      randomGame = activeGamesList[Random().nextInt(activeGamesList.length)];
    }

    // Atualiza o tipo do último jogo escolhido
    lastGameType = randomGame(context, playersList).runtimeType;

    // Retorna o widget do jogo escolhido
    return randomGame(context, playersList);
  }

  // Função para obter jogos baseados nos pesos
  static List<Widget Function(BuildContext, List<String>)> _getWeightedGames(List<Widget Function(BuildContext, List<String>)> availableGames) {
    List<Widget Function(BuildContext, List<String>)> weightedGames = [];

    for (var game in availableGames) {
      String gameName = allGames.entries.firstWhere((entry) => entry.value == game).key;
      double weight = gameWeights[gameName] ?? 0.0;

      // Adiciona o jogo à lista de acordo com seu peso
      for (int i = 0; i < weight; i++) {
        weightedGames.add(game);
      }
    }

    return weightedGames;
  }
}