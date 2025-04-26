import 'package:alcoolize/src/game_handler.dart';
import 'package:alcoolize/src/home_screen.dart';
import 'package:alcoolize/src/questions_manager.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class TibitarScreen extends StatefulWidget {
  final List<String> playersList;

  const TibitarScreen({super.key, required this.playersList});

  @override
  _TibitarScreenState createState() => _TibitarScreenState();
}

class _TibitarScreenState extends State<TibitarScreen> {
  String? hiddenVerb; // Armazena o verbo escondido
  String? currentPlayer; // Armazena o jogador da vez
  static const tibitarColor = Colors.pink; // Cor de fundo azul

  @override
  void initState() {
    super.initState();
    getVerb(); // Carrega um verbo ao iniciar
    choosePlayer(); // Escolhe um jogador ao iniciar
  }


  Future<void> getVerb() async {
    List<String> verbs = await QuestionsManager.loadQuestions('TIBITAR');    
    setState(() {
      hiddenVerb = (verbs..shuffle()).first; // Seleciona um verbo aleatoriamente
       while(hiddenVerb!.trim().isEmpty){
           hiddenVerb = (verbs..shuffle()).first; // Seleciona um verbo aleatoriamente
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
      backgroundColor: tibitarColor, // Fundo azul
      appBar: AppBar(
        backgroundColor: tibitarColor,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 33,), // Cor do ícone de voltar
          onPressed: () {
            // Navega para a Home Screen e remove todas as outras telas da pilha
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()), // Substitua pela sua tela inicial
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
                  Icon(Icons.question_mark, size: 80, color: Colors.white), // Ícone
                ],
              ),
            ),
            const SizedBox(height: 40),
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
                if (hiddenVerb != null) {
                  // Mostra o verbo revelado em um AlertDialog
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
                              Navigator.of(context).pop(); // Fecha o diálogo
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: tibitarColor, backgroundColor: Colors.white, // Cor do texto do botão
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Revelar Verbo', style: TextStyle(fontSize: 18)),
            ),

            const SizedBox(height: 120),
            
            
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Localização do botão
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20), // Margem inferior
        child: FloatingActionButton(
          onPressed: nextRound, // Ícone para o botão
          backgroundColor: Colors.white,
          foregroundColor: tibitarColor, // Chama a função para ir para a próxima rodada
          child: const Icon(Icons.arrow_forward), // Cor do ícone
        ),
      ),
    );
  }
}
