import 'package:alcoolize/src/screens/games/base_game_screen.dart';
import 'package:alcoolize/src/utils/questions_manager.dart';
import 'package:alcoolize/src/constants/game_constants.dart';
import 'package:flutter/material.dart';
import '../../localization/generated/app_localizations.dart';

class MostLikelyToScreen extends BaseGameScreen {
  const MostLikelyToScreen({super.key, required super.playersList});

  @override
  MostLikelyToScreenState createState() => MostLikelyToScreenState();
}

class MostLikelyToScreenState extends BaseGameScreenState<MostLikelyToScreen> {
  String? question;
  @override
  Color get gameColor => GameColors.mostLikely;

  @override
  String get gameTitle => AppLocalizations.of(context)!.mostLikelyTitle;

  @override
  IconData get gameIcon => Icons.question_mark;

  @override
  String get gameInstructions => AppLocalizations.of(context)!.mostLikelyGameInfo;

  @override
  void initState() {
    super.initState();
    getQuestion();
  }

  Future<void> getQuestion() async {
    List<String> questions = await QuestionsManager.loadQuestions('MOST_LIKELY_TO');
    if (questions.isNotEmpty) {
      setState(() {
        question = (questions..shuffle()).first;
      });
    }
  }

  @override
  Widget buildGameContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (question != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: Text(
                question!,
                style: const TextStyle(fontSize: GameSizes.gameSubtitleFontSize, color: GameColors.gameText),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}