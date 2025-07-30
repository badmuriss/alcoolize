
import 'package:alcoolize/src/game_handler.dart';
import 'package:alcoolize/src/home_screen.dart';
import 'package:alcoolize/src/questions_manager.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ParanoiaScreen extends StatefulWidget {
  final List<String> playersList;

  const ParanoiaScreen({super.key, required this.playersList});

  @override
  ParanoiaScreenState createState() => ParanoiaScreenState();
}

class ParanoiaScreenState extends State<ParanoiaScreen> {
  String? question;
  String? currentPlayer;
  static const paranoiaColor = Color.fromARGB(255, 124, 0, 93);

  @override
  void initState() {
    super.initState();
    getQuestion();
    _chooseRandomPlayer();
  }


  Future<void> getQuestion() async {
List<String> questions = await QuestionsManager.loadQuestions('PARANOIA');    
if (questions.isNotEmpty) {
      setState(() {
        question = (questions..shuffle()).first;
        while(question!.trim().isEmpty){
          question = (questions..shuffle()).first;
        }
      });
    }
  }

  void nextRound() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameHandler.chooseRandomGame(context, widget.playersList),
      ),
    );
  }

  void _chooseRandomPlayer() {
    currentPlayer = widget.playersList[Random().nextInt(widget.playersList.length)];
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            'Para jogar Paranoia, o jogador deve ler a pergunta revelada e '
            'apontar para quem acha que é a resposta. Se a pessoa apontada '
            'quiser saber a pergunta, ela deve beber duas doses. Caso a pessoa '
            'se recuse a responder, ela deve beber três doses.',
          style: TextStyle(fontSize: 18)),
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
      backgroundColor: paranoiaColor,
      appBar: AppBar(
        backgroundColor: paranoiaColor,
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
            const Text(
              'PARANOIA',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.emoji_emotions, size: 80, color: Colors.white),
            
            
            const SizedBox(height: 100),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
                child: Text(
                  'Jogador da vez: $currentPlayer',
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (question != null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(question!, style: const TextStyle(
                          fontSize: 20,
                        ),),
                        actions: [
                          TextButton(
                             child: const Text('Fechar'),
                             onPressed: () {
                              Navigator.of(context).pop();
                            },
                        )
                        ]
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: paranoiaColor, backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),

              child: const Text('Revelar Pergunta', style: TextStyle(fontSize: 18),),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: nextRound,
          backgroundColor: Colors.white,
          foregroundColor: paranoiaColor,
          child: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
