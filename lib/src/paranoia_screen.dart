import 'package:alcoolize/src/base_game_screen.dart';
import 'package:alcoolize/src/questions_manager.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'localization/generated/app_localizations.dart';

class ParanoiaScreen extends BaseGameScreen {
  const ParanoiaScreen({super.key, required super.playersList});

  @override
  ParanoiaScreenState createState() => ParanoiaScreenState();
}

class ParanoiaScreenState extends BaseGameScreenState<ParanoiaScreen> {
  String? question;
  String? currentPlayer;
  static const paranoiaColor = Color.fromARGB(255, 124, 0, 93);

  @override
  Color get gameColor => paranoiaColor;

  @override
  String get gameTitle => AppLocalizations.of(context)!.paranoia;

  @override
  IconData get gameIcon => Icons.emoji_emotions;

  @override
  String get gameInstructions => AppLocalizations.of(context)!.paranoiaGameInfo;

  @override
  void initState() {
    super.initState();
    getQuestion();
    _chooseRandomPlayer();
  }

  Future<void> getQuestion() async {
    List<String> questions = await QuestionsManager.loadQuestions('PARANOIA');
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
              style: const TextStyle(fontSize: 24, color: Colors.white),
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
                        fontSize: 20,
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
              foregroundColor: paranoiaColor, backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            child: Text(AppLocalizations.of(context)!.revealQuestion, style: const TextStyle(fontSize: 18),),
          ),
        ],
      ),
    );
  }
}