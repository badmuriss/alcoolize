import 'package:alcoolize/src/screens/games/base_game_screen.dart';
import 'package:alcoolize/src/utils/questions_manager.dart';
import 'package:alcoolize/src/constants/game_constants.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../../localization/generated/app_localizations.dart';

class CardsScreen extends BaseGameScreen {
  const CardsScreen({super.key, required super.playersList});

  @override
  CardsScreenState createState() => CardsScreenState();
}

class CardsScreenState extends BaseGameScreenState<CardsScreen> {
  String? currentPlayer;
  String? challenge;
  bool? isSinglePlayerChallenge; // Indicates if the challenge is for a single player
  @override
  Color get gameColor => GameColors.cards;

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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Calculate responsive card size
    final cardWidth = (screenWidth * 0.80).clamp(120.0, 320.0);
    final cardHeight = (screenHeight * 0.5).clamp(300.0, 450.0);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isSinglePlayerChallenge == true ? 
            Text(
              AppLocalizations.of(context)!.currentPlayer(currentPlayer!),
              style: TextStyle(
                fontSize: (screenHeight * 0.028).clamp(18.0, 24.0), 
                color: GameColors.gameText
              ),
            ) : const SizedBox(height: 5),
          SizedBox(height: (screenHeight * 0.025).clamp(10.0, 20.0)),
          Container(
            width: cardWidth,
            height: cardHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: GameColors.cardBackground,
              borderRadius: BorderRadius.circular(GameSizes.cardBorderRadius),
              boxShadow: const [
                BoxShadow(color: GameColors.shadowColor, blurRadius: GameSizes.shadowBlurRadius, spreadRadius: GameSizes.shadowSpreadRadius)
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all((cardWidth * 0.07).clamp(15.0, 25.0)),
              child: Text(
                challenge ?? AppLocalizations.of(context)!.loading,
                style: TextStyle(
                  fontSize: (cardHeight * 0.055).clamp(18.0, 26.0), 
                  color: GameColors.cards
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}