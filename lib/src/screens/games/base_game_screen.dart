import 'package:alcoolize/src/utils/game_handler.dart';
import 'package:alcoolize/src/screens/home_screen.dart';
import 'package:alcoolize/src/constants/game_constants.dart';
import 'package:flutter/material.dart';
import '../../localization/generated/app_localizations.dart';

abstract class BaseGameScreen extends StatefulWidget {
  final List<String> playersList;

  const BaseGameScreen({super.key, required this.playersList});
}

abstract class BaseGameScreenState<T extends BaseGameScreen> extends State<T> {
  
  Color get gameColor;
  String get gameTitle; 
  IconData? get gameIcon => null;
  String get gameInstructions;

  void nextRound() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameHandler.chooseRandomGame(context, widget.playersList),
      ),
    );
  }

  void navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            gameInstructions,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Mesmerize',
              color: Color.fromARGB(255, 36, 36, 36)
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.close,
                style: const TextStyle(fontFamily: 'Mesmerize'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: gameColor,
      leading: IconButton(
        icon: Icon(Icons.close, color: Colors.white, size: GameSizes.appBarIconSize),
        onPressed: navigateToHome,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.info, color: Colors.white, size: GameSizes.appBarIconSize),
          onPressed: showInfoDialog,
        ),
      ],
    );
  }

  Widget buildGameHeader() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              gameTitle,
              style: TextStyle(fontSize: GameSizes.gameHeaderFontSize, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            if (gameIcon != null) ...[  
              const SizedBox(height: 10),
              Icon(gameIcon!, size: GameSizes.gameIconSize, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildFloatingActionButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: FloatingActionButton(
        onPressed: nextRound,
        backgroundColor: Colors.white,
        foregroundColor: gameColor,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget buildGameContent();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final offsetY = screenHeight/-14;
    
    return Scaffold(
      backgroundColor: gameColor,
      appBar: buildAppBar(),
      body: Center( 
        child: Transform.translate(
        offset: Offset(0, offsetY), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  
          children: [
            buildGameHeader(),
            const SizedBox(height: 20),
            buildGameContent(),
          ], 
        )
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: buildFloatingActionButton(),
    );
  }
}