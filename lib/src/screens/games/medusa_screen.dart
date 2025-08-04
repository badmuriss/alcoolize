import 'package:alcoolize/src/screens/games/base_game_screen.dart';
import 'package:alcoolize/src/constants/game_constants.dart';
import 'package:flutter/material.dart';
import '../../localization/generated/app_localizations.dart';

class MedusaScreen extends BaseGameScreen {
  const MedusaScreen({super.key, required super.playersList});

  @override
  MedusaScreenState createState() => MedusaScreenState();
}

class MedusaScreenState extends BaseGameScreenState<MedusaScreen> {
  @override
  Color get gameColor => GameColors.medusa;

  @override
  String get gameTitle => AppLocalizations.of(context)!.medusa;

  @override
  IconData get gameIcon => Icons.remove_red_eye;

  @override
  String get gameInstructions => AppLocalizations.of(context)!.medusaGameInfo;

  @override
  Widget buildGameContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Text(
              AppLocalizations.of(context)!.medusaGameText,
              style: const TextStyle(fontSize: GameSizes.medusaTextFontSize, color: GameColors.gameText),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
