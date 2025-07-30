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

  // Detailed descriptions of each game
  static final Map<String, String> gameDescriptions = {
    'TIBITAR': 'A roda deve fazer perguntas para o jogador sobre o verbo usando "tibitar" para substituí-lo. '
               'Exemplo: "É fácil tibitar?", "Onde se tibita com frequência?". '
               'Revele o verbo escondido ao final. A roda tem 3 chances de adivinhar o verbo, cada um que errar bebe uma dose, '
               'caso alguém acerte, o jogador da vez deve beber 1 dose.',
    'EU NUNCA': 'Para jogar Eu Nunca, o host deve ler a afirmação. Quem já fez a ação deve beber uma dose.',
    'ROLETINHA': 'Rode a roleta e veja o que o destino te aguarda.',
    'PARANOIA': 'Para jogar Paranoia, o jogador deve ler a pergunta revelada e '
                'apontar para quem acha que é a resposta. Se a pessoa apontada '
                'quiser saber a pergunta, ela deve beber duas doses. Caso a pessoa '
                'se recuse a responder, ela deve beber três doses.',
    'QUEM É MAIS PROVÁVEL': 'Para jogar Mais Provável, o host deve ler a pergunta e, '
                            'todos apontarem para quem eles acham que é a resposta certa, '
                            'a pessoa mais apontada bebe uma dose, em caso de empate, ambos bebem.',
    'PALAVRA PROIBIDA': 'Para jogar Palavra Proibida, sorteie uma palavra. Quem falar a palavra proibida durante a rodada, '
                        'deve beber uma dose. As palavras são removidas da lista até o fim do jogo.',
    'MEDUSA': 'No jogo Medusa, todos os jogadores devem abaixar a cabeça e, '
              'ao sinal, levantar. Se você fizer contato visual com outro jogador, '
              'ambos devem beber uma dose.',
    'CARTAS': 'Neste jogo, uma carta com um desafio será revelada. Se o desafio for individual, o jogador da vez deve realizá-lo.',
  };

  // Word list for 'Palavra Proibida' game
  static List<String> usedWords = [];

  // Define default weights for each game.
  // These are the values that will be used when probabilities are reset.
  static final Map<String, double> _defaultGameWeights = {
    'PARANOIA': 9.0,
    'QUEM É MAIS PROVÁVEL': 21.0,
    'EU NUNCA': 22.0,
    'MEDUSA': 8.0,
    'PALAVRA PROIBIDA': 2.0,
    'TIBITAR': 2.0,
    'ROLETINHA': 12.0,
    'CARTAS': 24.0,
  };

  // Weight of each game (this is the map that will be modified and saved)
  static Map<String, double> gameWeights = {};

  static void resetUsedWords() {
    usedWords.clear(); // Empty the word list
  }

  // Method to check if a game is enabled
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
        // Handle initialization error
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
      // Primeiro, inicializa gameWeights com os valores padrão
      gameWeights = Map.from(_defaultGameWeights);
      
      // Em seguida, sobrescreve com os valores salvos, se existirem
      for (var gameName in allGames.keys) {
        double? savedWeight = prefs.getDouble('weight_$gameName');
        if (savedWeight != null) {
          gameWeights[gameName] = savedWeight;
        } else {
          // Se não houver peso salvo, usa o peso padrão, mas considera se o jogo está desativado.
          // Isso garante que, mesmo sem um peso salvo, o peso padrão seja definido.
          gameWeights[gameName] = _defaultGameWeights[gameName] ?? 0.0;
        }

        // IMPORTANTE: Se um jogo estiver desativado no momento, seu peso DEVE ser 0.0
        if (!isGameEnabled(gameName)) {
          gameWeights[gameName] = 0.0;
        }
      }
    } catch (e) {
      // Handle loading error
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
      // Handle saving error
    }
  }

  // Método para atualizar os pesos dos jogos
  static Future<void> updateGameWeights(Map<String, double> newWeights) async {
    gameWeights = Map.from(newWeights);
    await _saveSettings();
  }

  static void resetGameWeightsToDefault() {
    // Cria um novo mapa para armazenar os pesos resetados
    Map<String, double> newGameWeights = {};

    // Itera por todos os jogos conhecidos
    for (var gameName in allGames.keys) {
      if (isGameEnabled(gameName)) {
        // Se o jogo estiver atualmente habilitado, reseta seu peso para o valor padrão
        newGameWeights[gameName] = _defaultGameWeights[gameName] ?? 0.0;
      } else {
        // Se o jogo estiver atualmente desabilitado, garante que seu peso permaneça 0.0
        newGameWeights[gameName] = 0.0;
      }
    }

    gameWeights = newGameWeights;
  }

  static Type? lastGameType;

  static Widget chooseRandomGame(BuildContext context, List<String> playersList) {
    // Verifica se há jogos disponíveis
    if (activeGamesList.isEmpty) {
      _updateActiveGamesList();
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