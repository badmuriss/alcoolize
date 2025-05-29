import 'dart:math';
import 'package:flutter/material.dart';
import 'package:alcoolize/src/game_handler.dart';
import 'package:alcoolize/src/home_screen.dart';

class RouletteScreen extends StatefulWidget {
  final List<String> playersList;

  const RouletteScreen({super.key, required this.playersList});

  @override
  _RouletteScreenState createState() => _RouletteScreenState();
}

class _RouletteScreenState extends State<RouletteScreen> with SingleTickerProviderStateMixin {
  String? currentPlayer;
  String? result;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool canSpinAgain = true;
  bool showFab = false; // Nova variável para controlar a visibilidade do FAB
  static const rouletteColor = Colors.black;

  final List<String> options = [
    "Beba uma dose",
    "Beba com um amigo",
    "Passe a vez",
    "Beba e gire de novo",
    "Beba em dobro",
    "Escolha alguém para beber"
  ];

  @override
  void initState() {
    super.initState();
    _chooseRandomPlayer();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut)
    );
  }

  void nextRound() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameHandler.chooseRandomGame(context, widget.playersList),
      ),
    );
  }

  void _chooseRandomPlayer() {
    currentPlayer = widget.playersList[Random().nextInt(widget.playersList.length)];
  }

  void spinWheel() {
    setState(() {
      result = null; // Limpa o resultado anterior
      canSpinAgain = false;
      showFab = false; // Oculta o FAB durante a animação
    });

    final randomSpin = ((Random().nextInt(25) + 25) * (1 * pi / 3)) + (2 * pi); // Define um giro aleatório
    final animationSpin = randomSpin / (2 * pi); // Adiciona rotação extra

    _controller.reset();
    _animation = Tween<double>(begin: 0, end: animationSpin).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward().then((_) {
      // O ângulo final após a rotação
      double endAngle = randomSpin % (2 * pi); // ângulo final

      // Defina os ângulos estáticos
      List<double> segmentAngles = [
        0,              // 0 graus
        (1 * pi / 3),  // 60 graus
        (2 * pi / 3),  // 120 graus
        (3 * pi / 3),  // 180 graus
        (4 * pi / 3),  // 240 graus
        (5 * pi / 3),  // 300 graus
      ];

      // Encontre o segmento correspondente
      int selectedIndex = segmentAngles.indexWhere((angle) => endAngle < angle);
      
      // Se o endAngle estiver em um segmento, ele será o último índice
      if (selectedIndex == -1) {
        selectedIndex = segmentAngles.length - 1; // Último segmento
      }

      setState(() {
        result = options[selectedIndex];
        if (result == "Beba e gire de novo") {
          canSpinAgain = true;
        }
        showFab = true; // Mostra o FAB após a animação
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: rouletteColor,
      appBar: AppBar(
        backgroundColor: rouletteColor,
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
              'ROLETINHA',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0), // Define o padding desejado
              child: Text(
                'Jogador da vez: $currentPlayer', // Nome do jogador aleatório
                style: const TextStyle(fontSize: 24, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
           Container(
              width: 300, // Largura do container
              height: 400, // Altura do container
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Camada da roleta
                  Center(
                    child: SizedBox(
                      height: 300,
                      width: 300,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          RotationTransition(
                            turns: _animation,
                            child: CustomPaint(
                              painter: RoletaPainter(options.length, options.reversed.toList()),
                              child: Container(width: 300, height: 300),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Seta na parte superior da roleta
                  const Positioned(
                    top: -5, // Ajuste a posição da seta conforme necessário
                    child: Icon(Icons.arrow_drop_down, size: 100, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            canSpinAgain 
            ? ElevatedButton(
              onPressed: spinWheel,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Girar a roleta', style: TextStyle(fontSize: 18)),
            )
          : const SizedBox(height: 55),
          const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, 
      floatingActionButton: showFab && !canSpinAgain // Exibe o FAB somente se showFab for true
      ? Container(
        margin: const EdgeInsets.only(bottom: 20), 
        child: FloatingActionButton(
          onPressed: nextRound,
          backgroundColor: Colors.white,
          foregroundColor: rouletteColor, 
          child: const Icon(Icons.arrow_forward), 
        ),
      ) 
      : const SizedBox(height: 20),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            'Rode a roleta e veja o que o destino te aguarda.',
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
}

class RoletaPainter extends CustomPainter {
  final int numOptions;
  final List<String> options;

  RoletaPainter(this.numOptions, this.options);

  @override
  void paint(Canvas canvas, Size size) {
    final double anglePerSegment = 2 * pi / numOptions;
    final double radius = size.width / 2;
    final Paint paint = Paint();

    // Desenhar os segmentos da roleta
    for (int i = 0; i < numOptions; i++) {
      paint.color = i.isEven ? Colors.red : Colors.black;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        i * anglePerSegment,
        anglePerSegment,
        true,
        paint,
      );
    }

    // Agora desenhe o texto em cima dos segmentos
    for (int i = 0; i < numOptions; i++) {
      final String optionText = options[i].toUpperCase();
      final TextSpan textSpan = TextSpan(
        text: optionText,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      );

      final TextPainter textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      double textWidth = textPainter.width;
      double maxFontSize = radius * 0.119; 
      double fontSize = maxFontSize * (radius / textWidth); 

      final TextSpan adjustedTextSpan = TextSpan(
        text: optionText,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: fontSize.clamp(10.0, maxFontSize),
        ),
      );

      textPainter.text = adjustedTextSpan;
      textPainter.layout(
        minWidth: 0,
        maxWidth: radius * 0.45,
      );

      // Salva o estado do canvas antes da transformação
      canvas.save();
      // Translada o canvas para o centro da roleta
      canvas.translate(radius, radius);
      // Rotaciona o canvas para posicionar o texto corretamente
      canvas.rotate(i * anglePerSegment + anglePerSegment);

      // Define o deslocamento para o texto
      double textRadius = radius * 0.65; 
      Offset textOffset = Offset(
        -textPainter.width / 2,
        -textPainter.height / 2 - textRadius, // Ajuste para evitar sobreposição
      );

      textPainter.paint(canvas, textOffset);
      // Restaura o estado do canvas
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
