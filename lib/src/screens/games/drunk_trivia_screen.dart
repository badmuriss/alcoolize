import 'package:alcoolize/src/screens/games/base_game_screen.dart';
import 'package:alcoolize/src/utils/questions_manager.dart';
import 'package:alcoolize/src/constants/game_constants.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../../localization/generated/app_localizations.dart';

class DrunkTriviaScreen extends BaseGameScreen {
  const DrunkTriviaScreen({super.key, required super.playersList});

  @override
  DrunkTriviaScreenState createState() => DrunkTriviaScreenState();
}

class TriviaQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;

  TriviaQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory TriviaQuestion.fromString(String questionData) {
    final parts = questionData.split(',');
    if (parts.length < 6) {
      throw Exception('Invalid question format');
    }
    
    return TriviaQuestion(
      question: parts[0].trim(),
      options: [parts[1].trim(), parts[2].trim(), parts[3].trim(), parts[4].trim()],
      correctAnswer: int.parse(parts[5].trim()),
    );
  }
}

class DrunkTriviaScreenState extends BaseGameScreenState<DrunkTriviaScreen> {
  String? currentPlayer;
  TriviaQuestion? currentQuestion;
  bool isAnswerRevealed = false;
  
  @override
  Color get gameColor => GameColors.drunkTrivia;

  @override
  String get gameTitle => AppLocalizations.of(context)!.drunkTrivia;

  @override
  String get gameInstructions => AppLocalizations.of(context)!.drunkTriviaGameInfo;

  @override
  void initState() {
    super.initState();
    _chooseRandomPlayer();
    _loadRandomQuestion();
  }

  void _chooseRandomPlayer() {
    currentPlayer = widget.playersList[Random().nextInt(widget.playersList.length)];
  }

  Future<void> _loadRandomQuestion() async {
    final questions = await QuestionsManager.loadQuestions('DRUNK_TRIVIA');
    
    if (questions.isNotEmpty) {
      final randomQuestion = questions[Random().nextInt(questions.length)];
      try {
        setState(() {
          currentQuestion = TriviaQuestion.fromString(randomQuestion);
          isAnswerRevealed = false;
        });
      } catch (e) {
        // Handle error silently
      }
    }
  }

  void _revealAnswer() {
    setState(() {
      isAnswerRevealed = true;
    });
  }

  void _hideAnswer() {
    setState(() {
      isAnswerRevealed = false;
    });
  }

  String _getOptionLabel(int index) {
    const labels = ['A', 'B', 'C', 'D'];
    return labels[index];
  }

  @override
  Widget buildGameContent() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth * 0.7).clamp(320.0, 500.0);
    final cardHeight = (screenHeight * 0.75).clamp(350.0, 450.0);
    
    if (currentQuestion == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.currentPlayer(currentPlayer!),
            style: TextStyle(
              fontSize: (screenHeight * 0.03).clamp(18.0, 24.0),
              color: GameColors.gameText,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: (screenHeight * 0.03).clamp(15.0, 25.0)),
          Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              color: GameColors.cardBackground,
              borderRadius: BorderRadius.circular(GameSizes.cardBorderRadius),
              boxShadow: const [
                BoxShadow(
                  color: GameColors.shadowColor,
                  blurRadius: GameSizes.shadowBlurRadius,
                  spreadRadius: GameSizes.shadowSpreadRadius,
                )
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all((cardWidth * 0.05).clamp(15.0, 25.0)),
              child: Column(
                children: [
                  // Question
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      currentQuestion!.question,
                      style: TextStyle(
                        fontSize: (cardHeight * 0.04).clamp(16.0, 20.0),
                        color: const Color.fromARGB(255, 60, 60, 60),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  SizedBox(height: (cardHeight * 0.04).clamp(10.0, 20.0)),
                  
                  // Options
                  Expanded(
                    child: Column(
                      children: [
                        for (int i = 0; i < currentQuestion!.options.length; i++)
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              width: double.infinity,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _getOptionColor(i),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: gameColor.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: gameColor,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _getOptionLabel(i),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        currentQuestion!.options[i],
                                        style: TextStyle(
                                          fontSize: (cardHeight * 0.032).clamp(13.0, 16.0),
                                          color: const Color.fromARGB(255, 60, 60, 60),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: (cardHeight * 0.04).clamp(10.0, 15.0)),
                  
                  // Reveal/Hide Toggle Button
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: isAnswerRevealed ? _hideAnswer : _revealAnswer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAnswerRevealed ? Colors.grey[600] : gameColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        isAnswerRevealed 
                            ? AppLocalizations.of(context)!.hideAnswer
                            : AppLocalizations.of(context)!.revealAnswer,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getOptionColor(int index) {
    if (isAnswerRevealed) {
      return index == currentQuestion!.correctAnswer
          ? gameColor.withValues(alpha: 0.3)
          : Colors.grey.withValues(alpha: 0.1);
    }
    return gameColor.withValues(alpha: 0.02);
  }
}