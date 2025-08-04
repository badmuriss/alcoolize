import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/game_handler.dart';
import '../localization/generated/app_localizations.dart';

class GameWeightsScreen extends StatefulWidget {
  const GameWeightsScreen({super.key});

  @override
  GameWeightsScreenState createState() => GameWeightsScreenState();
}

class GameWeightsScreenState extends State<GameWeightsScreen> {
  final Color settingsColor = const Color(0xFF6A0DAD);
  late Map<String, double> weights;
  double totalWeight = 0;
  bool isLoading = true;
  bool isWeightValid = true;

  @override
  void initState() {
    super.initState();
    _initWeights();
  }

  Future<void> _initWeights() async {
    // Set isLoading to true at the beginning of initWeights
    // to show loading indicator while calculations are made.
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    // Create a copy of the weights from GameHandler
    weights = Map.from(GameHandler.gameWeights);

    // Ensure all active games have at least 1% weight
    // Use activeGamesList to determine which games are active
    Set<String> activeGames = _getActiveGameNames();

    for (var gameName in activeGames) {
      if (weights[gameName] == null || weights[gameName]! < 1.0) {
        weights[gameName] = 1.0;
      }
    }

    _calculateTotalWeight(); // Calculate total initially

    // Normalize to 100%
    if (totalWeight != 100.0) {
      // Normalize proportionally
      double factor = 100.0 / totalWeight;
      weights.updateAll((key, value) => value * factor);

      // Round to nearest whole number and ensure 1.0 minimum
      weights.updateAll((key, value) {
        double roundedValue = value.roundToDouble(); // Round to nearest whole number
        return max(1.0, roundedValue); // Ensure it's at least 1.0
      });

      // Recalculate total after rounding
      _calculateTotalWeight();

      // Final adjustment on game with highest weight to ensure 100.0
      // This adjustment should only occur if total is still not 100.0
      if (totalWeight != 100.0) {
        // Find the active game with highest weight to adjust
        String? gameToAdjust;
        double maxWeight = -1.0;

        // Iterate only through active games to find the one with max weight
        for (var entry in weights.entries) {
          if (activeGames.contains(entry.key) && entry.value > maxWeight) {
            maxWeight = entry.value;
            gameToAdjust = entry.key;
          }
        }

        if (gameToAdjust != null) {
          weights[gameToAdjust] = weights[gameToAdjust]! + (100.0 - totalWeight);
          // Ensure it doesn't go below 1.0 after adjustment
          weights[gameToAdjust] = max(1.0, weights[gameToAdjust]!);
        }
      }
    }

    _calculateTotalWeight(); // Final recalculation to confirm 100%

    if (mounted) {
      setState(() {
        isLoading = false; // Set isLoading to false after all calculations are done
      });
    }
  }

  // Method to get active game names
  Set<String> _getActiveGameNames() {
    Set<String> activeGames = {};

    // Iterate through active games list and get their names
    for (var gameFunction in GameHandler.activeGamesList) {
      for (var entry in GameHandler.allGames.entries) {
        if (entry.value == gameFunction) {
          activeGames.add(entry.key);
          break;
        }
      }
    }

    return activeGames;
  }

  void _calculateTotalWeight() {
    totalWeight = weights.values.fold(0, (sum, weight) => sum + weight);
    // No need to call setState here, as this method is frequently called within another setState
    // or before a final setState in _initWeights.
    // If you need to update UI immediately after this, call setState explicitly.
    isWeightValid = totalWeight == 100;
  }

  Future<void> _saveWeights() async {
    // Don't allow saving if total weight is greater than 100
    if (totalWeight > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.weightExceedError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      for (var entry in weights.entries) {
        await prefs.setDouble('weight_${entry.key}', entry.value);
      }

      // Update weights in GameHandler
      GameHandler.gameWeights = Map.from(weights);
    } catch (e) {
      // Handle errors, for example by showing a SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.saveWeightsError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        Navigator.pop(context); // Return to previous screen after saving
      }
    }
  }

  Future<void> _resetWeights() async {
    // Set isLoading to true immediately to show feedback
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    final prefs = await SharedPreferences.getInstance();
    Set<String> activeGames = _getActiveGameNames();

    // Remove all saved weights from SharedPreferences for active games
    for (var gameName in activeGames) {
      await prefs.remove('weight_$gameName');
    }

    // Reset GameHandler weights to initial default state
    GameHandler.resetGameWeightsToDefault();

    // Call _initWeights() which will load default weights from GameHandler,
    // apply 1% minimum, normalize and finally set isLoading to false.
    await _initWeights(); // Wait for _initWeights to ensure it completes and updates state

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.probabilitiesReset),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: settingsColor,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: settingsColor,
        title:
            Text(AppLocalizations.of(context)!.configureProbabilities, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: !isWeightValid ? Colors.red.withValues(alpha: 0.3) : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.totalWeight(totalWeight.toStringAsFixed(1)),
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      if (!isWeightValid)
                        Text(
                          AppLocalizations.of(context)!.mustBe100Percent,
                          style: const TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom: 80), // Margem inferior para o botão
                    children: _getActiveGameNames().map((gameName) {
                      // Ensure weight is never less than 1
                      // This check is also in _initWeights, but good to have here for slider display
                      if (weights[gameName] == null || weights[gameName]! < 1.0) {
                        weights[gameName] = 1.0;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(GameHandler.getGameName(context, gameName),
                              style: const TextStyle(color: Colors.white, fontSize: 16)),
                          Row(
                            children: [
                              Expanded(
                                child: Slider(
                                  value: weights[gameName] ?? 1.0,
                                  min: 1.0, // Minimum of 1%
                                  max: 100,
                                  divisions: 99, // 1 to 100 in increments of 1
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.white.withValues(alpha: 0.3),
                                  onChanged: (value) {
                                    setState(() {
                                      weights[gameName] = value;
                                      _calculateTotalWeight();
                                    });
                                  },
                                ),
                              ),
                              Container(
                                width: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  '${(weights[gameName] ?? 1.0).toStringAsFixed(0)}%',
                                  style: const TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white30),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                // Additional space to ensure buttons don't stay under floating button
                const SizedBox(height: 100),
              ],
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0), // Adjust bottom padding for both buttons
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "resetBtn", // Unique tag for multiple FABs
              onPressed: isLoading ? null : _resetWeights, // Disable if loading
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              child: const Icon(Icons.refresh),
            ),
            const SizedBox(width: 16), // Space between buttons
            FloatingActionButton(
              heroTag: "saveBtn", // Unique tag for multiple FABs
              onPressed: isWeightValid && !isLoading ? _saveWeights : null, // Disable if invalid or loading
              backgroundColor: Colors.white,
              foregroundColor: settingsColor,
              child: const Icon(Icons.check),
            ),
          ],
        ),
      ),
    );
  }
}