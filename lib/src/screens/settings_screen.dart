import 'package:alcoolize/src/screens/edit_questions_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/game_handler.dart';
import 'game_weights_screen.dart';
import '../localization/generated/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final Color settingsColor = const Color(0xFF6A0DAD);
  Map<String, bool> gamesEnabled = {}; // Initialize as empty Map
  bool isLoading = true; // State for loading control
  bool canRepeat = false; // Initial value for canRepeat

  @override
  void initState() {
    super.initState();
    _initializeGamesEnabled();
  }

  Future<void> _initializeGamesEnabled() async {
    // Define default values here using English game keys
    gamesEnabled = {
      'MYSTERY_VERB': true,
      'NEVER_HAVE_I_EVER': true,
      'ROULETTE': true,
      'PARANOIA': true,
      'MOST_LIKELY_TO': true,
      'FORBIDDEN_WORD': true,
      'MEDUSA': true,
      'CARDS': true,
      'TRUTH_OR_DARE': true,
    };

    await _loadGameSettings();
  }

  Future<void> _loadGameSettings() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      gamesEnabled.forEach((game, _) {
        gamesEnabled[game] = prefs.getBool(game) ?? true; // Load stored value
      });
      
      // Load canRepeat value
      canRepeat = prefs.getBool('canRepeat') ?? false;
    } catch (e) {
      // Handle error loading settings - use default values
    } finally {
      setState(() {
        isLoading = false; // Update loading state
      });
    }
  }

  Future<void> _saveGameSettings() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      gamesEnabled.forEach((game, enabled) {
        prefs.setBool(game, enabled);
      });
      
      // Save canRepeat value
      prefs.setBool('canRepeat', canRepeat);
    } catch (e) {
      // Handle error loading settings - use default values
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: settingsColor,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: settingsColor,
        title: Text(AppLocalizations.of(context)!.activateDeactivateGames, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info, color: Colors.white, size: 33),
            onPressed: () {
              _showGameInfoDialog(context);
            }, // Information button
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        children: [
          // Games list (your existing code)
          ...isLoading
              ? [const Center(child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(color: Colors.white),
                ))]
              : gamesEnabled.isEmpty
                  ? [Center(child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(AppLocalizations.of(context)!.noGamesAvailable, style: const TextStyle(color: Colors.white)),
                    ))]
                  : gamesEnabled.keys.map((String game) {
                      return SwitchListTile(
                        activeTrackColor: const Color.fromARGB(255, 29, 255, 9),
                        title: Text(GameHandler.getGameName(context, game), style: const TextStyle(color: Colors.white)),
                        value: gamesEnabled[game]!,
                        onChanged: (bool value) {
                          setState(() {
                            if (!value) {
                              int enabledCount = gamesEnabled.values.where((enabled) => enabled).length;
                              if (enabledCount <= 1) {
                                return;
                              }
                            }
                            gamesEnabled[game] = value;
                          });
                        },
                      );
                    }).toList(),

          // Increased space between list and buttons
          const SizedBox(height: 30),

          // Repeat button (canRepeat)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton.icon(
              icon: Icon(
                Icons.repeat,
                color: canRepeat ? Colors.green : settingsColor,
              ),
              label: Text(
                canRepeat ? (AppLocalizations.of(context)!.repeatContinuouslyOn) : (AppLocalizations.of(context)!.repeatContinuouslyOff),
                style: TextStyle(
                  color: settingsColor,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                setState(() {
                  canRepeat = !canRepeat;
                });
              },
            ),
          ),

          // Probabilities button (your existing code)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.percent, color: Color(0xFF6A0DAD)),
              label: Text(
                AppLocalizations.of(context)!.adjustProbabilities,
                style: TextStyle(color: Color(0xFF6A0DAD)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                GameHandler.updateGamesList(gamesEnabled, canRepeat);
                _saveGameSettings();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GameWeightsScreen(),
                  ),
                );
              },
            ),
          ),

          // Edit questions button (your existing code)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.edit_note, color: Color(0xFF6A0DAD)),
              label: Text(
                AppLocalizations.of(context)!.editQuestions,
                style: TextStyle(color: Color(0xFF6A0DAD)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                GameHandler.updateGamesList(gamesEnabled, canRepeat);
                _saveGameSettings();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditQuestionsScreen(),
                  ),
                );
              },
            ),
          ),

          // Additional space to ensure buttons don't stay under floating button
          const SizedBox(height: 100),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: () {
            GameHandler.updateGamesList(gamesEnabled, canRepeat);
            _saveGameSettings();
            Navigator.pop(context);
          },
          backgroundColor: Colors.white,
          foregroundColor: settingsColor,
          child: const Icon(Icons.check),
        ),
      ),
    );
  }

  void _showGameInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: settingsColor, // AlertDialog background
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            AppLocalizations.of(context)!.gameInformation,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: GameHandler.allGames.keys.map((gameKey) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        GameHandler.getGameName(context, gameKey), // Game name
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        GameHandler.getGameDescription(context, gameKey), // Game description
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.close, style: const TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
  // --- FIM DO NOVO MÉTODO ---
}