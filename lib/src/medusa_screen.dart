import 'package:alcoolize/src/base_game_screen.dart';
import 'package:flutter/material.dart';

class MedusaScreen extends BaseGameScreen {
  const MedusaScreen({super.key, required super.playersList});

  @override
  MedusaScreenState createState() => MedusaScreenState();
}

class MedusaScreenState extends BaseGameScreenState<MedusaScreen> {
  static const medusaColor = Color.fromARGB(255, 0, 64, 128);

  @override
  Color get gameColor => medusaColor;

  @override
  String get gameTitle => 'MEDUSA';

  @override
  IconData get gameIcon => Icons.remove_red_eye;

  @override
  String get gameInstructions => 'No jogo Medusa, todos os jogadores devem abaixar a cabeça e, '
      'ao sinal, levantar. Se você fizer contato visual com outro jogador, '
      'ambos devem beber uma dose.';

  @override
  Widget buildGameContent() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 60.0),
          child: Text(
            'Abaixe a cabeça e prepare-se!',
            style: TextStyle(fontSize: 28, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 120),
      ],
    );
  }
}
