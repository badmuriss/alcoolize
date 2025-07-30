import 'package:alcoolize/src/game_handler.dart';
import 'package:alcoolize/src/home_screen.dart';
import 'package:flutter/material.dart';

abstract class BaseGameScreen extends StatefulWidget {
  final List<String> playersList;

  const BaseGameScreen({super.key, required this.playersList});
}

abstract class BaseGameScreenState<T extends BaseGameScreen> extends State<T> {
  
  Color get gameColor;
  String get gameTitle; 
  IconData get gameIcon;
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
            style: const TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              child: const Text('Fechar'),
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
        icon: const Icon(Icons.close, color: Colors.white, size: 33),
        onPressed: navigateToHome,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info, color: Colors.white, size: 33),
          onPressed: showInfoDialog,
        ),
      ],
    );
  }

  Widget buildGameHeader() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Text(
            gameTitle,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Icon(gameIcon, size: 80, color: Colors.white),
        ],
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
    return Scaffold(
      backgroundColor: gameColor,
      appBar: buildAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildGameHeader(),
            const SizedBox(height: 40),
            Expanded(
              child: buildGameContent(),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: buildFloatingActionButton(),
    );
  }
}