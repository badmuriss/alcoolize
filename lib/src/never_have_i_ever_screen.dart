import 'package:alcoolize/src/game_handler.dart';
import 'package:alcoolize/src/home_screen.dart';
import 'package:alcoolize/src/questions_manager.dart';
import 'package:flutter/material.dart';

class NeverHaveIEverScreen extends StatefulWidget {
  final List<String> playersList;

  const NeverHaveIEverScreen({super.key, required this.playersList});

  @override
  NeverHaveIEverScreenState createState() => NeverHaveIEverScreenState();
}

class NeverHaveIEverScreenState extends State<NeverHaveIEverScreen> {
  String? question;
  static const neverColor = Color.fromARGB(255, 85, 0, 0);

  @override
  void initState() {
    super.initState();
    getQuestion();
  }

  Future<void> getQuestion() async {
    List<String> questions = await QuestionsManager.loadQuestions('EU NUNCA');
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
            'Para jogar Eu Nunca, o host deve ler a afirmação. Quem já fez a ação deve beber uma dose.',
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
      backgroundColor: neverColor,
      appBar: AppBar(
        backgroundColor: neverColor,
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
                    'EU NUNCA',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Icon(Icons.adjust_sharp, size: 80, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: Text(
                question ?? 'Carregando...',
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
          onPressed: question != null ? nextRound : null,
          backgroundColor: Colors.white,
          foregroundColor: neverColor,
          child: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
