import 'package:alcoolize/src/screens/games/base_game_screen.dart';
import 'package:alcoolize/src/utils/questions_manager.dart';
import 'package:alcoolize/src/constants/game_constants.dart';
import 'package:flutter/material.dart';
import '../../localization/generated/app_localizations.dart';

class NeverHaveIEverScreen extends BaseGameScreen {
  const NeverHaveIEverScreen({super.key, required super.playersList});

  @override
  NeverHaveIEverScreenState createState() => NeverHaveIEverScreenState();
}

class NeverHaveIEverScreenState extends BaseGameScreenState<NeverHaveIEverScreen> {
  String? question;
  @override
  Color get gameColor => GameColors.neverHaveIEver;

  @override
  String get gameTitle => AppLocalizations.of(context)!.neverHaveIEver;

  @override
  IconData get gameIcon => Icons.block;

  @override
  String get gameInstructions => AppLocalizations.of(context)!.neverHaveIEverGameInfo;

  @override
  void initState() {
    super.initState();
    getQuestion();
  }

  Future<void> getQuestion() async {
    List<String> questions = await QuestionsManager.loadQuestions('NEVER_HAVE_I_EVER');
    if (questions.isNotEmpty) {
      setState(() {
        question = (questions..shuffle()).first;
      });
    }
  }

  @override
  Widget buildFloatingActionButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: FloatingActionButton(
        onPressed: question != null ? nextRound : null,
        backgroundColor: GameColors.buttonBackground,
        foregroundColor: GameColors.neverHaveIEver,
        child: const Icon(Icons.arrow_forward),
      ),
    );
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
              question ?? AppLocalizations.of(context)!.loading,
              style: const TextStyle(fontSize: GameSizes.gameSubtitleFontSize, color: GameColors.gameText),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}