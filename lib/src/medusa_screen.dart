import 'package:alcoolize/src/game_handler.dart';
import 'package:alcoolize/src/home_screen.dart';
import 'package:flutter/material.dart';

class MedusaScreen extends StatefulWidget {
  final List<String> playersList;

  const MedusaScreen({super.key, required this.playersList});

  @override
  _MedusaScreenState createState() => _MedusaScreenState();
}

class _MedusaScreenState extends State<MedusaScreen> {
  static const medusaColor = Color.fromARGB(255, 0, 64, 128); // Fundo azul

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
            'No jogo Medusa, todos os jogadores devem abaixar a cabeça e, '
            'ao sinal, levantar. Se você fizer contato visual com outro jogador, '
            'ambos devem beber uma dose.',
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
      backgroundColor: medusaColor, // Fundo azul
      appBar: AppBar(
        backgroundColor: medusaColor,
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
            // Container com o texto "Medusa" e o ícone
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 20), // Espaçamento inferior
              child: const Column(
                children: [
                  Text(
                    'MEDUSA',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10), // Espaçamento entre texto e ícone
                  Icon(Icons.remove_red_eye, size: 80, color: Colors.white), // Ícone de olhos
                ],
              ),
            ),
            const SizedBox(height: 40),
             const Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.0), // Define o padding desejado
                child: Text(
                  'Abaixe a cabeça e prepare-se!',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                  textAlign: TextAlign.center,
            )),
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
          foregroundColor: medusaColor, // Chama a função para ir para a próxima rodada
          child: const Icon(Icons.arrow_forward), // Cor do ícone
        ),
      ),
    );
  }
}
