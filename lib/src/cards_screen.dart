import 'package:alcoolize/src/base_game_screen.dart';
import 'package:alcoolize/src/questions_manager.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'localization/generated/app_localizations.dart';

class CardsScreen extends BaseGameScreen {
  const CardsScreen({super.key, required super.playersList});

  @override
  CardsScreenState createState() => CardsScreenState();
}

class CardsScreenState extends BaseGameScreenState<CardsScreen> {
  String? currentPlayer;
  String? challenge;
  bool? isSinglePlayerChallenge; // Indicates if the challenge is for a single player
  static const cardsColor = Color.fromARGB(255, 0, 189, 196);

  @override
  Color get gameColor => cardsColor;

  @override
  String get gameTitle => AppLocalizations.of(context)!.cards;

  @override
  IconData? get gameIcon => null;

  @override
  String get gameInstructions => AppLocalizations.of(context)!.cardsGameInfo;

  @override
  void initState() {
    super.initState();
    _chooseRandomPlayer();
    getChallenge();
  }

  Future<List<Map<String, dynamic>>> loadChallenges() async {
    List<String> questions = await QuestionsManager.loadQuestions('CARDS');
    return questions.map((line) {
      var parts = line.split(',');
      return {
        'challenge': parts[0],
        'isSinglePlayer': parts[1].trim() == 'true',
      };
    }).toList();
  }

  Future<void> getChallenge() async {
    List<Map<String, dynamic>> challenges = await loadChallenges();
    if (challenges.isNotEmpty) {
      setState(() {
        var selectedChallenge = (challenges..shuffle()).first;
        challenge = selectedChallenge['challenge'];
        isSinglePlayerChallenge = selectedChallenge['isSinglePlayer'];
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
          isSinglePlayerChallenge == true ? 
            Text(
              AppLocalizations.of(context)!.currentPlayer(currentPlayer!),
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ) : const SizedBox(height: 5),
          const SizedBox(height: 20),
          Container(
            width: 280,
            height: 420,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 4)
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                challenge ?? AppLocalizations.of(context)!.loading,
                style: const TextStyle(fontSize: 24, color: cardsColor),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}