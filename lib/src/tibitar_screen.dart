import 'package:alcoolize/src/game_handler.dart';
import 'package:alcoolize/src/home_screen.dart';
import 'package:alcoolize/src/questions_manager.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class TibitarScreen extends StatefulWidget {
  final List<String> playersList;

  const TibitarScreen({super.key, required this.playersList});

  @override
  TibitarScreenState createState() => TibitarScreenState();
}

class TibitarScreenState extends State<TibitarScreen> {
  String? hiddenVerb;
  String? currentPlayer;
  static const tibitarColor = Colors.pink;

  @override
  void initState() {
    super.initState();
    getVerb();
    choosePlayer();
  }


  Future<void> getVerb() async {
    List<String> verbs = await QuestionsManager.loadQuestions('TIBITAR');    
    setState(() {
      hiddenVerb = (verbs..shuffle()).first;
       while(hiddenVerb!.trim().isEmpty){
           hiddenVerb = (verbs..shuffle()).first;
        }
    
    });
    
   
  }

  void choosePlayer() {
    final random = Random();
    setState(() {
      currentPlayer = widget.playersList[random.nextInt(widget.playersList.length)];
    });
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
            'A roda deve fazer perguntas para o jogador sobre o verbo usando "tibitar" para substituí-lo. '
            'Exemplo: "É fácil tibitar?", "Onde se tibita com frequência?". '
            'Revele o verbo escondido ao final. A roda tem 3 chances de adivinhar o verbo, cada um que errar bebe uma dose'
            ', caso alguem acerte, o jogador da vez deve beber 1 dose.',
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
      backgroundColor: tibitarColor,
      appBar: AppBar(
        backgroundColor: tibitarColor,
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
                    'TIBITAR',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Icon(Icons.question_mark, size: 80, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 40),
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
                if (hiddenVerb != null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(
                          hiddenVerb!,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
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
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: tibitarColor, backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Revelar Verbo', style: TextStyle(fontSize: 18)),
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
          foregroundColor: tibitarColor,
          child: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
