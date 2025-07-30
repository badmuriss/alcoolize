import 'package:alcoolize/src/game_handler.dart';
import 'package:alcoolize/src/home_screen.dart';
import 'package:alcoolize/src/questions_manager.dart';
import 'package:flutter/material.dart';

class ForbiddenWordScreen extends StatefulWidget {
  final List<String> playersList;
  final List<String> usedWords;

  const ForbiddenWordScreen({super.key, required this.playersList, required this.usedWords});

  @override
  ForbiddenWordScreenState createState() => ForbiddenWordScreenState();
}

class ForbiddenWordScreenState extends State<ForbiddenWordScreen> {
  String? forbiddenWord;
  List<String>? remainingWords;
  static const forbiddenColor = Color.fromARGB(255, 221, 15, 0);

  @override
  void initState() {
    super.initState();
    getWord();
  }

  Future<void> getWord() async {
    remainingWords = await QuestionsManager.loadQuestions('PALAVRA PROIBIDA');
    remainingWords?.removeWhere((item) => widget.usedWords.contains(item));

    if(remainingWords!.isEmpty){
      GameHandler.resetUsedWords();
      remainingWords = await QuestionsManager.loadQuestions('PALAVRA PROIBIDA');
    }

    setState(() {
      forbiddenWord = (remainingWords?..shuffle())?.first;
    });

    GameHandler.usedWords.add(forbiddenWord!);
    }

  void nextRound() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameHandler.chooseRandomGame(context, widget.playersList),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            'Para jogar Palavra Proibida, sorteie uma palavra. Quem falar a palavra proibida durante a rodada, deve beber uma dose. '
            'As palavras são removidas da lista até o fim do jogo.',
            style: TextStyle(fontSize: 18),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: forbiddenColor,
      appBar: AppBar(
        backgroundColor: forbiddenColor,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 33,),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info, color: Colors.white, size: 33),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 20),
              child: const Column(
                children: [
                  Text(
                    'PALAVRA PROIBIDA',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Icon(Icons.not_interested, size: 80, color: Colors.white),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            if (forbiddenWord != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
                child: Text(
                  "Nova palavra proibida: ${forbiddenWord!}",
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 120),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: nextRound,
          backgroundColor: Colors.white,
          foregroundColor: forbiddenColor,
          child: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
