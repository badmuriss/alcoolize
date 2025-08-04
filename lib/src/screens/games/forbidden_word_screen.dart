import 'package:alcoolize/src/screens/games/base_game_screen.dart';
import 'package:alcoolize/src/utils/game_handler.dart';
import 'package:alcoolize/src/utils/questions_manager.dart';
import 'package:alcoolize/src/constants/game_constants.dart';
import 'package:flutter/material.dart';
import '../../localization/generated/app_localizations.dart';

class ForbiddenWordScreen extends BaseGameScreen {
  final List<String> usedWords;

  const ForbiddenWordScreen({super.key, required super.playersList, required this.usedWords});

  @override
  ForbiddenWordScreenState createState() => ForbiddenWordScreenState();
}

class ForbiddenWordScreenState extends BaseGameScreenState<ForbiddenWordScreen> {
  String? forbiddenWord;
  List<String>? remainingWords;
  @override
  Color get gameColor => GameColors.forbiddenWord;

  @override
  String get gameTitle => AppLocalizations.of(context)!.forbiddenWord;

  @override
  IconData get gameIcon => Icons.not_interested;

  @override
  String get gameInstructions => AppLocalizations.of(context)!.forbiddenWordGameInfo;

  @override
  void initState() {
    super.initState();
    getWord();
  }

  Future<void> getWord() async {
    remainingWords = await QuestionsManager.loadQuestions('FORBIDDEN_WORD');
    remainingWords?.removeWhere((item) => widget.usedWords.contains(item));

    if(remainingWords!.isEmpty){
      GameHandler.resetUsedWords();
      remainingWords = await QuestionsManager.loadQuestions('FORBIDDEN_WORD');
    }

    setState(() {
      forbiddenWord = (remainingWords?..shuffle())?.first;
    });

    GameHandler.usedWords.add(forbiddenWord!);
  }

  @override
  Widget buildGameContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (forbiddenWord != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: Text(
                AppLocalizations.of(context)!.newForbiddenWord(forbiddenWord!),
                style: const TextStyle(fontSize: GameSizes.gameSubtitleFontSize, color: GameColors.gameText),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}