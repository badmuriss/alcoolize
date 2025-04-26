
import 'package:alcoolize/src/game_handler.dart';
import 'package:alcoolize/src/home_screen.dart';
import 'package:alcoolize/src/questions_manager.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ParanoiaScreen extends StatefulWidget {
  final List<String> playersList;

  const ParanoiaScreen({super.key, required this.playersList});

  @override
  _ParanoiaScreenState createState() => _ParanoiaScreenState();
}

class _ParanoiaScreenState extends State<ParanoiaScreen> {
  String? question; // Para armazenar a pergunta revelada
  String? currentPlayer; // Para armazenar o jogador atual
  static const paranoiaColor = Color.fromARGB(255, 124, 0, 93);

  @override
  void initState() {
    super.initState();
    getQuestion(); // Carregar perguntas ao iniciar
    _chooseRandomPlayer(); // Escolher um jogador aleatório
  }


  Future<void> getQuestion() async {
List<String> questions = await QuestionsManager.loadQuestions('PARANOIA');    
if (questions.isNotEmpty) {
      setState(() {
        question = (questions..shuffle()).first; // Seleciona uma pergunta aleatória
        while(question!.trim().isEmpty){
          question = (questions..shuffle()).first; // Seleciona uma pergunta aleatória
        }
      });
    }
  }

  void nextRound() {
    // Chama um handler que escolhe aleatoriamente entre jogos
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameHandler.chooseRandomGame(context, widget.playersList), // Chama a função que escolhe aleatoriamente o jogo
      ),
    );
  }

  void _chooseRandomPlayer() {
    currentPlayer = widget.playersList[Random().nextInt(widget.playersList.length)];
  }

  void _showInfoDialog() {
    // Exibe um diálogo com informações sobre o jogo
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
      backgroundColor: paranoiaColor, // Fundo vermelho escuro
      appBar: AppBar(
        backgroundColor: paranoiaColor,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 33,), // Cor do ícone de voltar
          onPressed: () {
            // Navega para a Home Screen e remove todas as outras telas da pilha
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()), // Substitua pela sua tela inicial
              (Route<dynamic> route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info, color: Colors.white, size: 33),
            onPressed: _showInfoDialog, // Botão de informações
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
            const Icon(Icons.emoji_emotions, size: 80, color: Colors.white), // Ícone
            
            // Texto "Paranoia" centralizado
            
            const SizedBox(height: 100),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0), // Define o padding desejado
                child: Text(
                  'Jogador da vez: $currentPlayer', // Nome do jogador aleatório
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (question != null) {
                  // Mostra a pergunta revelada
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
      
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Localização do botão
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20), // Margem inferior
        child: FloatingActionButton(
          onPressed: nextRound, // Ícone para o botão
          backgroundColor: Colors.white,
          foregroundColor: paranoiaColor, // Chama a função para ir para a próxima rodada
          child: const Icon(Icons.arrow_forward), // Cor do ícone
        ),
      ),
    );
  }
}
