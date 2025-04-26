import 'package:alcoolize/src/game_handler.dart';
import 'package:alcoolize/src/home_screen.dart';
import 'package:alcoolize/src/questions_manager.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CardsScreen extends StatefulWidget {
  final List<String> playersList;

  const CardsScreen({super.key, required this.playersList});

  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  String? currentPlayer;
  String? challenge;
  bool? isSinglePlayerChallenge; // Indica se o desafio é para um único jogador
  static const cardsColor = Color.fromARGB(255, 0, 189, 196); // Cor do fundo

  @override
  void initState() {
    super.initState();
    _chooseRandomPlayer();
    getChallenge(); // Carrega um desafio ao iniciar
  }

  // Carrega os desafios a partir de um arquivo .txt
  Future<List<Map<String, dynamic>>> loadChallenges() async {
    List<String> questions = await QuestionsManager.loadQuestions('CARTAS');
    return questions.map((line) {
      var parts = line.split(','); // Separa a linha pelo separador ","
      return {
        'challenge': parts[0],
        'isSinglePlayer': parts[1].trim() == 'true', // Verifica se o desafio é individual
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
        builder: (context) => GameHandler.chooseRandomGame(context, widget.playersList), // Reinicia a tela com novo desafio
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
      backgroundColor: cardsColor, // Cor do fundo
      appBar: AppBar(
        backgroundColor: cardsColor,
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
              margin: const EdgeInsets.only(bottom: 20), // Espaçamento inferior
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
            // Mostra o nome do jogador da vez se o desafio for individual
            isSinglePlayerChallenge == true ? 
              Text(
                'Jogador da vez: $currentPlayer',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ) : const SizedBox(height: 10),
            const SizedBox(height: 20),
            // Exibe o desafio como uma "carta"
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Localização do botão
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20), // Margem inferior
        child: FloatingActionButton(
          onPressed: nextRound, // Ícone para o botão
          backgroundColor: Colors.white,
          foregroundColor: cardsColor, // Chama a função para ir para a próxima rodada
          child: const Icon(Icons.arrow_forward), // Cor do ícone
        ),
      ),
    );
  }
}