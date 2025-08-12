import 'dart:math';
import 'package:alcoolize/src/screens/games/cards_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization/generated/app_localizations.dart';
import '../screens/games/paranoia_screen.dart';
import '../screens/games/most_likely_to_screen.dart';
import '../screens/games/never_have_i_ever_screen.dart';
import '../screens/games/medusa_screen.dart';
import '../screens/games/forbidden_word_screen.dart';
import '../screens/games/roulette_screen.dart';
import '../screens/games/truth_or_dare_screen.dart';
import '../screens/games/drunk_trivia_screen.dart';
import '../screens/games/scratch_card_screen.dart';

class GameHandler {
  static bool _initialized = false;
  static bool _canRepeat = false;
  static List<Widget Function(BuildContext, List<String>)> activeGamesList = [];
  static Map<String, bool> _enabledGames = {};

  static final Map<String, Widget Function(BuildContext, List<String>)> allGames = {
    'PARANOIA': (context, players) => ParanoiaScreen(playersList: players),
    'MOST_LIKELY_TO': (context, players) => MostLikelyToScreen(playersList: players), 
    'NEVER_HAVE_I_EVER': (context, players) => NeverHaveIEverScreen(playersList: players),
    'MEDUSA': (context, players) => MedusaScreen(playersList: players),
    'FORBIDDEN_WORD': (context, players) => ForbiddenWordScreen(playersList: players, usedWords: GameHandler.usedWords),
    'ROULETTE': (context, players) => RouletteScreen(playersList: players),
    'CARDS': (context, players) => CardsScreen(playersList: players),
    'TRUTH_OR_DARE': (context, players) => TruthOrDareScreen(playersList: players),
    'DRUNK_TRIVIA': (context, players) => DrunkTriviaScreen(playersList: players),
    'SCRATCH_CARD': (context, players) => ScratchCardScreen(playersList: players),
  };

  // Game names and descriptions are now handled through localization
  static String getGameName(BuildContext context, String gameKey) {
    switch (gameKey) {
      case 'NEVER_HAVE_I_EVER':
        return AppLocalizations.of(context)!.neverHaveIEver;
      case 'ROULETTE':
        return AppLocalizations.of(context)!.roulette;
      case 'PARANOIA':
        return AppLocalizations.of(context)!.paranoia;
      case 'MOST_LIKELY_TO':
        return AppLocalizations.of(context)!.mostLikelyTo;
      case 'FORBIDDEN_WORD':
        return AppLocalizations.of(context)!.forbiddenWord;
      case 'MEDUSA':
        return AppLocalizations.of(context)!.medusa;
      case 'CARDS':
        return AppLocalizations.of(context)!.cards;
      case 'TRUTH_OR_DARE':
        return AppLocalizations.of(context)!.truthOrDare;
      case 'TRUTH_OR_DARE_TRUTHS':
        return '${AppLocalizations.of(context)!.truthOrDare} - ${AppLocalizations.of(context)!.truth}';
      case 'TRUTH_OR_DARE_DARES':
        return '${AppLocalizations.of(context)!.truthOrDare} - ${AppLocalizations.of(context)!.dare}';
      case 'DRUNK_TRIVIA':
        return AppLocalizations.of(context)!.drunkTrivia;
      case 'SCRATCH_CARD':
        return AppLocalizations.of(context)!.scratchCard;
      default:
        return gameKey;
    }
  }

  static String getGameDescription(BuildContext context, String gameKey) {
    switch (gameKey) {
      case 'NEVER_HAVE_I_EVER':
        return AppLocalizations.of(context)!.neverHaveIEverGameInfo;
      case 'ROULETTE':
        return AppLocalizations.of(context)!.rouletteGameInfo;
      case 'PARANOIA':
        return AppLocalizations.of(context)!.paranoiaGameInfo;
      case 'MOST_LIKELY_TO':
        return AppLocalizations.of(context)!.mostLikelyGameInfo;
      case 'FORBIDDEN_WORD':
        return AppLocalizations.of(context)!.forbiddenWordGameInfo;
      case 'MEDUSA':
        return AppLocalizations.of(context)!.medusaGameInfo;
      case 'CARDS':
        return AppLocalizations.of(context)!.cardsGameInfo;
      case 'TRUTH_OR_DARE':
        return AppLocalizations.of(context)!.truthOrDareGameInfo;
      case 'DRUNK_TRIVIA':
        return AppLocalizations.of(context)!.drunkTriviaGameInfo;
      case 'SCRATCH_CARD':
        return AppLocalizations.of(context)!.scratchCardGameInfo;
      default:
        return '';
    }
  }

  // Word list for 'Forbidden Word' game
  static List<String> usedWords = [];

  // Define default weights for each game.
  // These are the values that will be used when probabilities are reset.
  static final Map<String, double> _defaultGameWeights = {
    'PARANOIA': 6.0,
    'MOST_LIKELY_TO': 15.0,
    'NEVER_HAVE_I_EVER': 15.0,
    'MEDUSA': 5.0,
    'FORBIDDEN_WORD': 4.0,
    'ROULETTE': 11.0,
    'CARDS': 16.0,
    'TRUTH_OR_DARE': 15.0,
    'DRUNK_TRIVIA': 8.0,
    'SCRATCH_CARD': 7.0,
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

  // Method to initialize GameHandler with SharedPreferences data
  static Future<void> initialize() async {
    if (!_initialized) {
      try {
        // Initialize enabled games map with default values
        _enabledGames = {};
        for (var gameName in allGames.keys) {
          _enabledGames[gameName] = true;
        }

        // Load saved settings
        await _loadSettings();
        
        // Update active games list
        _updateActiveGamesList();
        
        _initialized = true;
      } catch (e) {
        // Handle initialization error
      }
    }
  }

  // Method to load settings from SharedPreferences
  static Future<void> _loadSettings() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Load enabled games
      _enabledGames.forEach((game, _) {
        _enabledGames[game] = prefs.getBool(game) ?? true;
      });
      
      // Load canRepeat value
      _canRepeat = prefs.getBool('canRepeat') ?? false;
      
      // Load game weights
      // First, initialize gameWeights with default values
      gameWeights = Map.from(_defaultGameWeights);
      
      // Then, overwrite with saved values, if they exist
      for (var gameName in allGames.keys) {
        double? savedWeight = prefs.getDouble('weight_$gameName');
        if (savedWeight != null) {
          gameWeights[gameName] = savedWeight;
        } else {
          // If there's no saved weight, use default weight, but consider if the game is disabled.
          // This ensures that, even without a saved weight, the default weight is set.
          gameWeights[gameName] = _defaultGameWeights[gameName] ?? 0.0;
        }

        // IMPORTANT: If a game is currently disabled, its weight MUST be 0.0
        if (!isGameEnabled(gameName)) {
          gameWeights[gameName] = 0.0;
        }
      }
    } catch (e) {
      // Handle loading error
    }
  }

  // Method to update active games list based on enabled games
  static void _updateActiveGamesList() {
    activeGamesList.clear();
    
    _enabledGames.forEach((gameName, isEnabled) {
      if (isEnabled && allGames.containsKey(gameName)) {
        activeGamesList.add(allGames[gameName]!);
      }
    });

    // If no games are active, enable all
    if (activeGamesList.isEmpty) {
      for (var gameName in _enabledGames.keys) {
        if (allGames.containsKey(gameName)) {
          _enabledGames[gameName] = true;
          activeGamesList.add(allGames[gameName]!);
        }
      }
    }
  }

  // Method to update games list and save settings
  static Future<void> updateGamesList(Map<String, bool> enabledGames, [bool? canRepeat]) async {
    // Update enabled games map
    _enabledGames = Map.from(enabledGames);
    
    // Update canRepeat value if provided
    if (canRepeat != null) {
      _canRepeat = canRepeat;
    }
    
    // Update active games list
    _updateActiveGamesList();
    
    // Update disabled games weights to 0
    gameWeights.forEach((gameName, weight) {
      if (_enabledGames[gameName] != true) {
        gameWeights[gameName] = 0.0;
      }
    });
    
    // Save settings
    await _saveSettings();
  }

  // Method to save settings to SharedPreferences
  static Future<void> _saveSettings() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Save enabled games
      _enabledGames.forEach((game, enabled) {
        prefs.setBool(game, enabled);
      });
      
      // Save canRepeat value
      prefs.setBool('canRepeat', _canRepeat);
      
      // Save game weights
      gameWeights.forEach((gameName, weight) {
        prefs.setDouble('weight_$gameName', weight);
      });
    } catch (e) {
      // Handle saving error
    }
  }

  // Method to update game weights
  static Future<void> updateGameWeights(Map<String, double> newWeights) async {
    gameWeights = Map.from(newWeights);
    await _saveSettings();
  }

  static void resetGameWeightsToDefault() {
    // Create a new map to store reset weights
    Map<String, double> newGameWeights = {};

    // Iterate through all known games
    for (var gameName in allGames.keys) {
      if (isGameEnabled(gameName)) {
        // If the game is currently enabled, reset its weight to default value
        newGameWeights[gameName] = _defaultGameWeights[gameName] ?? 0.0;
      } else {
        // If the game is currently disabled, ensure its weight remains 0.0
        newGameWeights[gameName] = 0.0;
      }
    }

    gameWeights = newGameWeights;
  }

  static Type? lastGameType;

  static Widget chooseRandomGame(BuildContext context, List<String> playersList) {
    // Check if there are available games
    if (activeGamesList.isEmpty) {
      _updateActiveGamesList();
    }

    // Additional safety: if still empty after update, enable all games
    if (activeGamesList.isEmpty) {
      // Emergency fallback: enable all games with default weights
      for (var gameName in allGames.keys) {
        _enabledGames[gameName] = true;
        gameWeights[gameName] = _defaultGameWeights[gameName] ?? 10.0;
      }
      _updateActiveGamesList();
      // Save the emergency settings
      _saveSettings();
    }

    // Filter active games to ensure it's not the same type as the last game
    final availableGames = activeGamesList.where((game) {
      final gameType = game(context, playersList).runtimeType;
      return gameType != lastGameType || _canRepeat;
    }).toList();

    Widget Function(BuildContext, List<String>) randomGame;

    // Choose a game randomly, ensuring the type doesn't repeat
    if (availableGames.isNotEmpty) {
      // Choose randomly based on weights
      final weightedGames = _getWeightedGames(availableGames);
      randomGame = weightedGames[Random().nextInt(weightedGames.length)];
    } else if (activeGamesList.isNotEmpty) {
      // If there are no more options, allow repeating games
      randomGame = activeGamesList[Random().nextInt(activeGamesList.length)];
    } else {
      // Final fallback: this should never happen after the safety checks above
      throw StateError('Critical error: No games available after emergency activation. Please check game initialization.');
    }

    // Update the type of the last chosen game
    lastGameType = randomGame(context, playersList).runtimeType;

    // Return the chosen game widget
    return randomGame(context, playersList);
  }

  // Function to get games based on weights
  static List<Widget Function(BuildContext, List<String>)> _getWeightedGames(List<Widget Function(BuildContext, List<String>)> availableGames) {
    List<Widget Function(BuildContext, List<String>)> weightedGames = [];

    for (var game in availableGames) {
      String gameName = allGames.entries.firstWhere((entry) => entry.value == game).key;
      double weight = gameWeights[gameName] ?? 0.0;

      // Add the game to the list according to its weight
      for (int i = 0; i < weight; i++) {
        weightedGames.add(game);
      }
    }

    // If no games were added based on weights (all weights < 1), add all available games once
    if (weightedGames.isEmpty && availableGames.isNotEmpty) {
      weightedGames.addAll(availableGames);
    }

    return weightedGames;
  }
}