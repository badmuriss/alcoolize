import 'package:alcoolize/src/game_handler.dart';
import 'package:alcoolize/src/home_screen.dart';
import 'package:alcoolize/src/questions_manager.dart';
import 'package:flutter/material.dart';

class WhoIsMoreLikelyScreen extends StatefulWidget {
  final List<String> playersList;

  const WhoIsMoreLikelyScreen({super.key, required this.playersList});

  @override
  WhoIsMoreLikelyScreenState createState() => WhoIsMoreLikelyScreenState();
}

class WhoIsMoreLikelyScreenState extends State<WhoIsMoreLikelyScreen> {
  String? question;
  static const likelyColor = Color.fromARGB(255, 49, 110, 51);

  @override
  void initState() {
    super.initState();
    getQuestion();
  }

  Future<void> getQuestion() async {
    List<String> questions = await QuestionsManager.loadQuestions('QUEM É MAIS PROVÁVEL');
    if (questions.isNotEmpty) {
      setState(() {
        question = (questions..shuffle()).first;
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

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            'Para jogar Mais Provável, o host deve ler a pergunta e, '
            'todos apontarem para quem eles acham que é a resposta certa, ' 
            'a pessoa mais apontada bebe uma dose, em caso de empate, ambos bebem.', 
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
      backgroundColor: likelyColor,
      appBar: AppBar(
        backgroundColor: likelyColor,
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
                    'MAIS PROVAVÉL',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Icon(Icons.question_mark, size: 80, color: Colors.white),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            if (question != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
                child: Text(
                  question!,
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
          foregroundColor: likelyColor,
          child: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
