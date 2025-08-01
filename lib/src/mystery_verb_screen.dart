import 'package:alcoolize/src/base_game_screen.dart';
import 'package:alcoolize/src/questions_manager.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'localization/generated/app_localizations.dart';

class MysteryVerbScreen extends BaseGameScreen {
  const MysteryVerbScreen({super.key, required super.playersList});

  @override
  MysteryVerbScreenState createState() => MysteryVerbScreenState();
}

class MysteryVerbScreenState extends BaseGameScreenState<MysteryVerbScreen> {
  String? hiddenVerb;
  String? currentPlayer;
  static const mysteryVerbColor = Colors.pink;

  @override
  Color get gameColor => mysteryVerbColor;

  @override
  String get gameTitle => AppLocalizations.of(context)!.mysteryVerb;

  @override
  IconData get gameIcon => Icons.question_mark;

  @override
  String get gameInstructions => AppLocalizations.of(context)!.mysteryVerbGameInfo;

  @override
  void initState() {
    super.initState();
    getVerb();
    choosePlayer();
  }

  Future<void> getVerb() async {
    List<String> verbs = await QuestionsManager.loadQuestions('MYSTERY_VERB');    
    setState(() {
      hiddenVerb = (verbs..shuffle()).first;
       while(hiddenVerb!.trim().isEmpty){
           hiddenVerb = (verbs..shuffle()).first;
        }
    });
  }

  void choosePlayer() {
    final random = Random();
    setState(() {
      currentPlayer = widget.playersList[random.nextInt(widget.playersList.length)];
    });
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
              if (hiddenVerb != null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text(
                        hiddenVerb!,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text(AppLocalizations.of(context)!.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: mysteryVerbColor, backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            child: Text(AppLocalizations.of(context)!.revealVerb, style: const TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}