import 'package:alcoolize/src/screens/games/base_game_screen.dart';
import 'package:alcoolize/src/services/game_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alcoolize/src/constants/game_constants.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../../localization/generated/app_localizations.dart';

class ParanoiaScreen extends BaseGameScreen {
  const ParanoiaScreen({super.key, required super.playersList});

  @override
  ParanoiaScreenState createState() => ParanoiaScreenState();
}

class ParanoiaScreenState extends BaseGameScreenState<ParanoiaScreen> {
  String? question;
  String? currentPlayer;
  @override
  Color get gameColor => GameColors.paranoia;

  @override
  String get gameTitle => AppLocalizations.of(context)!.paranoia;

  @override
  IconData get gameIcon => Icons.emoji_emotions;

  @override
  String get gameInstructions => AppLocalizations.of(context)!.paranoiaGameInfo;

  Future<List<String>> _loadFromRepository(String gameType) async {
    try {
      final repository = await GameRepository.create();
      final prefs = await SharedPreferences.getInstance();
      final locale = prefs.getString('selected_language') ?? 'pt';
      final items = await repository.getGameItems(gameType.toLowerCase(), locale);
      return items.map((item) => item.getText()).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    getQuestion();
    _chooseRandomPlayer();
  }

  Future<void> getQuestion() async {
    List<String> questions = await _loadFromRepository('PARANOIA');
    if (questions.isNotEmpty) {
      setState(() {
        question = (questions..shuffle()).first;
        while(question!.trim().isEmpty){
          question = (questions..shuffle()).first;
        }
      });
    }
  }

  void _chooseRandomPlayer() {
    currentPlayer = widget.playersList[Random().nextInt(widget.playersList.length)];
  }

  @override
  Widget buildGameContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Text(
              AppLocalizations.of(context)!.currentPlayer(currentPlayer!),
              style: const TextStyle(fontSize: GameSizes.gameSubtitleFontSize, color: GameColors.gameText),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              if (question != null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text(question!, style: const TextStyle(
                        fontSize: GameSizes.gameContentFontSize,
                      ),),
                      actions: [
                        TextButton(
                           child: Text(AppLocalizations.of(context)!.close),
                           onPressed: () {
                            Navigator.of(context).pop();
                          },
                      )
                      ]
                    );
                  },
                );
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: GameColors.paranoia, backgroundColor: GameColors.buttonBackground,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            child: Text(AppLocalizations.of(context)!.revealQuestion, style: const TextStyle(fontSize: GameSizes.buttonTextFontSize),),
          ),
        ],
      ),
    );
  }
}