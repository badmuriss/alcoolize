import 'package:alcoolize/src/screens/games/base_game_screen.dart';
import 'package:alcoolize/src/utils/questions_manager.dart';
import 'package:alcoolize/src/constants/game_constants.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../../localization/generated/app_localizations.dart';

class TruthOrDareScreen extends BaseGameScreen {
  const TruthOrDareScreen({super.key, required super.playersList});

  @override
  TruthOrDareScreenState createState() => TruthOrDareScreenState();
}

class TruthOrDareScreenState extends BaseGameScreenState<TruthOrDareScreen> {
  String? currentPlayer;
  String? currentQuestion;
  bool? isShowingQuestion;
  String? selectedChoice; // 'truth' or 'dare'
  
  @override
  Color get gameColor => GameColors.truthOrDare;

  @override
  String get gameTitle => AppLocalizations.of(context)!.truthOrDare;

  @override
  IconData? get gameIcon => isShowingQuestion == true ? null : Icons.quiz;

  @override
  String get gameInstructions => AppLocalizations.of(context)!.truthOrDareGameInfo;

  @override
  void initState() {
    super.initState();
    _chooseRandomPlayer();
    isShowingQuestion = false;
  }

  void _chooseRandomPlayer() {
    currentPlayer = widget.playersList[Random().nextInt(widget.playersList.length)];
  }

  Future<void> _onChoiceSelected(String choice) async {
    setState(() {
      selectedChoice = choice;
    });
    
    await _loadQuestion(choice);
  }

  Future<void> _loadQuestion(String choice) async {
    List<String> questions;
    
    if (choice == 'truth') {
      questions = await QuestionsManager.loadQuestions('TRUTH_OR_DARE_TRUTHS');
    } else {
      questions = await QuestionsManager.loadQuestions('TRUTH_OR_DARE_DARES');
    }
    
    if (questions.isNotEmpty) {
      setState(() {
        currentQuestion = questions[Random().nextInt(questions.length)];
        isShowingQuestion = true;
      });
    }
  }

  Color _getChoiceColor(String choice) {
    if (choice == 'truth') {
      return const Color(0xFF2196F3); // Blue
    } else {
      return const Color(0xFFE91E63); // Pink
    }
  }

  @override
  Widget buildGameContent() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (isShowingQuestion == false) {
      // Show player selection and choice buttons
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.currentPlayer(currentPlayer!),
              style: TextStyle(
                fontSize: (screenHeight * 0.035).clamp(22.0, 28.0),
                color: GameColors.gameText,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: (screenHeight * 0.05).clamp(30.0, 40.0)),
            Text(
              AppLocalizations.of(context)!.truthOrDareChoosePrompt,
              style: TextStyle(
                fontSize: (screenHeight * 0.025).clamp(16.0, 20.0),
                color: GameColors.gameText,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: (screenHeight * 0.04).clamp(25.0, 35.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildChoiceButton('truth', AppLocalizations.of(context)!.truth, screenWidth, screenHeight),
                SizedBox(width: (screenWidth * 0.06).clamp(20.0, 30.0)),
                _buildChoiceButton('dare', AppLocalizations.of(context)!.dare, screenWidth, screenHeight),
              ],
            ),
          ],
        ),
      );
    } else {
      // Show the question/dare
      final cardWidth = (screenWidth * 0.65).clamp(280.0, 400.0);
      final cardHeight = (screenHeight * 0.45).clamp(300.0, 400.0);
      
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
            ),
            SizedBox(height: (screenHeight * 0.05).clamp(25.0, 35.0)),
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
                padding: EdgeInsets.all((cardWidth * 0.06).clamp(15.0, 25.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getChoiceColor(selectedChoice!),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        selectedChoice == 'truth' ? AppLocalizations.of(context)!.truth.toUpperCase() : AppLocalizations.of(context)!.dare.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: (cardHeight * 0.08).clamp(15.0, 25.0)),
                    Expanded(
                      child: Center(
                        child: Text(
                          currentQuestion ?? AppLocalizations.of(context)!.loading,
                          style: TextStyle(
                            fontSize: (cardHeight * 0.05).clamp(16.0, 22.0),
                            color: _getChoiceColor(selectedChoice!),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
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
  }

  Widget _buildChoiceButton(String choice, String label, double screenWidth, double screenHeight) {
    final buttonWidth = (screenWidth * 0.45).clamp(120.0, 160.0);
    final buttonHeight = (screenHeight * 0.08).clamp(50.0, 70.0);
    
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: () => _onChoiceSelected(choice),
        style: ElevatedButton.styleFrom(
          backgroundColor: _getChoiceColor(choice),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: (screenHeight * 0.025).clamp(16.0, 20.0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}