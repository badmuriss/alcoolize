import 'package:alcoolize/src/game_handler.dart';
import 'package:alcoolize/src/home_screen.dart';
import 'package:alcoolize/src/questions_manager.dart';
import 'package:flutter/material.dart';

class ForbiddenWordScreen extends StatefulWidget {
  final List<String> playersList;
  final List<String> usedWords;

  const ForbiddenWordScreen({super.key, required this.playersList, required this.usedWords});

  @override
  _ForbiddenWordScreenState createState() => _ForbiddenWordScreenState();
}

class _ForbiddenWordScreenState extends State<ForbiddenWordScreen> {
  String? forbiddenWord; // Para armazenar a palavra proibida
  List<String>? remainingWords;
  static const forbiddenColor = Color.fromARGB(255, 221, 15, 0); // Fundo vermelho

  @override
  void initState() {
    super.initState();
    getWord(); // Carregar palavras ao iniciar
  }

  Future<void> getWord() async {
    remainingWords = await QuestionsManager.loadQuestions('PALAVRA PROIBIDA');
    remainingWords?.removeWhere((item) => widget.usedWords.contains(item));

    if(remainingWords!.isEmpty){
      GameHandler.resetUsedWords();
      remainingWords = await QuestionsManager.loadQuestions('PALAVRA PROIBIDA');
    }

    setState(() {
      forbiddenWord = (remainingWords?..shuffle())?.first; // Seleciona uma palavra aleatória
    });

    GameHandler.usedWords.add(forbiddenWord!);
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

  void _showInfoDialog() {
    // Exibe um diálogo com informações sobre o jogo
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
      backgroundColor: forbiddenColor, // Fundo vermelho
      appBar: AppBar(
        backgroundColor: forbiddenColor,
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
            // Container com o texto "Palavra Proibida" e o ícone
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 20), // Espaçamento inferior
              child: const Column(
                children: [
                  Text(
                    'PALAVRA PROIBIDA',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10), // Espaçamento entre texto e ícone
                  Icon(Icons.not_interested, size: 80, color: Colors.white), // Mesmo ícone do "Eu Nunca"
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            if (forbiddenWord != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0), // Define o padding desejado
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

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Localização do botão
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20), // Margem inferior
        child: FloatingActionButton(
          onPressed: nextRound, // Ícone para o botão
          backgroundColor: Colors.white,
          foregroundColor: forbiddenColor, // Chama a função para ir para a próxima rodada
          child: const Icon(Icons.arrow_forward), // Cor do ícone
        ),
      ),
    );
  }
}
