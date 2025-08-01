import 'package:alcoolize/src/base_game_screen.dart';
import 'package:flutter/material.dart';
import 'localization/generated/app_localizations.dart';

class MedusaScreen extends BaseGameScreen {
  const MedusaScreen({super.key, required super.playersList});

  @override
  MedusaScreenState createState() => MedusaScreenState();
}

class MedusaScreenState extends BaseGameScreenState<MedusaScreen> {
  static const medusaColor = Color.fromARGB(255, 0, 64, 128);

  @override
  Color get gameColor => medusaColor;

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
              style: const TextStyle(fontSize: 28, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
