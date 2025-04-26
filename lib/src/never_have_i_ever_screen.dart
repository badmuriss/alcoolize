import 'package:alcoolize/src/game_handler.dart';
import 'package:alcoolize/src/home_screen.dart';
import 'package:alcoolize/src/questions_manager.dart';
import 'package:flutter/material.dart';

class NeverHaveIEverScreen extends StatefulWidget {
  final List<String> playersList;

  const NeverHaveIEverScreen({super.key, required this.playersList});

  @override
  _NeverHaveIEverScreenState createState() => _NeverHaveIEverScreenState();
}

class _NeverHaveIEverScreenState extends State<NeverHaveIEverScreen> {
  String? question; // Para armazenar a pergunta revelada
  static const neverColor = Color.fromARGB(255, 85, 0, 0); // Fundo vermelho

  @override
  void initState() {
    super.initState();
    getQuestion(); // Carregar perguntas ao iniciar
  }

  Future<void> getQuestion() async {
    List<String> questions = await QuestionsManager.loadQuestions('EU NUNCA');
    if (questions.isNotEmpty) {
      setState(() {
        question = (questions..shuffle()).first; // Seleciona uma pergunta aleatória
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

  void _showInfoDialog() {
    // Exibe um diálogo com informações sobre o jogo
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
      backgroundColor: neverColor, // Fundo vermelho
      appBar: AppBar(
        backgroundColor: neverColor,
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
            // Container com o texto "Eu Nunca" e o ícone
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 20), // Espaçamento inferior
              child: const Column(
                children: [
                  Text(
                    'EU NUNCA',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10), // Espaçamento entre texto e ícone
                  Icon(Icons.adjust_sharp, size: 80, color: Colors.white), // Ícone
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0), // Define o padding desejado
              child: Text(
                question ?? 'Carregando...', // Exibe "Carregando..." enquanto a pergunta não está disponível
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
          onPressed: question != null ? nextRound : null, // Ícone para o botão
          backgroundColor: Colors.white,
          foregroundColor: neverColor, // Habilita o botão apenas se a pergunta não for nula
          child: const Icon(Icons.arrow_forward), // Cor do ícone
        ),
      ),
    );
  }
}
