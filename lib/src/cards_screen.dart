import 'package:alcoolize/src/game_handler.dart';
import 'package:alcoolize/src/home_screen.dart';
import 'package:alcoolize/src/questions_manager.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CardsScreen extends StatefulWidget {
  final List<String> playersList;

  const CardsScreen({super.key, required this.playersList});

  @override
  CardsScreenState createState() => CardsScreenState();
}

class CardsScreenState extends State<CardsScreen> {
  String? currentPlayer;
  String? challenge;
  bool? isSinglePlayerChallenge; // Indicates if the challenge is for a single player
  static const cardsColor = Color.fromARGB(255, 0, 189, 196);

  @override
  void initState() {
    super.initState();
    _chooseRandomPlayer();
    getChallenge();
  }

  Future<List<Map<String, dynamic>>> loadChallenges() async {
    List<String> questions = await QuestionsManager.loadQuestions('CARTAS');
    return questions.map((line) {
      var parts = line.split(',');
      return {
        'challenge': parts[0],
        'isSinglePlayer': parts[1].trim() == 'true',
      };
    }).toList();
  }

  Future<void> getChallenge() async {
    List<Map<String, dynamic>> challenges = await loadChallenges();
    if (challenges.isNotEmpty) {
      setState(() {
        var selectedChallenge = (challenges..shuffle()).first;
        challenge = selectedChallenge['challenge'];
        isSinglePlayerChallenge = selectedChallenge['isSinglePlayer'];
      });
    }
  }

  void _chooseRandomPlayer() {
    currentPlayer = widget.playersList[Random().nextInt(widget.playersList.length)];
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
            'Neste jogo, uma carta com um desafio será revelada. Se o desafio for individual, o jogador da vez deve realizá-lo.',
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
      backgroundColor: cardsColor,
      appBar: AppBar(
        backgroundColor: cardsColor,
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
                    'CARTAS',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            isSinglePlayerChallenge == true ? 
              Text(
                'Jogador da vez: $currentPlayer',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ) : const SizedBox(height: 10),
            const SizedBox(height: 20),
            Container(
              width: 280,
              height: 420,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 4)
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  challenge ?? 'Carregando...',
                  style: const TextStyle(fontSize: 24, color: cardsColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 150),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: nextRound,
          backgroundColor: Colors.white,
          foregroundColor: cardsColor,
          child: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}