import 'dart:math';
import 'package:flutter/material.dart';
import 'package:alcoolize/src/game_handler.dart';
import 'package:alcoolize/src/home_screen.dart';

class RouletteScreen extends StatefulWidget {
  final List<String> playersList;

  const RouletteScreen({super.key, required this.playersList});

  @override
  RouletteScreenState createState() => RouletteScreenState();
}

class RouletteScreenState extends State<RouletteScreen> with SingleTickerProviderStateMixin {
  String? currentPlayer;
  String? result;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool canSpinAgain = true;
  bool showFab = false;
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
      result = null;
      canSpinAgain = false;
      showFab = false;
    });

    final randomSpin = ((Random().nextInt(25) + 25) * (1 * pi / 3)) + (2 * pi);
    final animationSpin = randomSpin / (2 * pi);

    _controller.reset();
    _animation = Tween<double>(begin: 0, end: animationSpin).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward().then((_) {
      double endAngle = randomSpin % (2 * pi);

      // Static segment angles
      List<double> segmentAngles = [
        0,
        (1 * pi / 3),
        (2 * pi / 3),
        (3 * pi / 3),
        (4 * pi / 3),
        (5 * pi / 3),
      ];

      int selectedIndex = segmentAngles.indexWhere((angle) => endAngle < angle);
      
      if (selectedIndex == -1) {
        selectedIndex = segmentAngles.length - 1;
      }

      setState(() {
        result = options[selectedIndex];
        if (result == "Beba e gire de novo") {
          canSpinAgain = true;
        }
        showFab = true;
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
            const Text(
              'ROLETINHA',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: Text(
                'Jogador da vez: $currentPlayer',
                style: const TextStyle(fontSize: 24, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
           SizedBox(
              width: 300,
              height: 400,
              child: Stack(
                alignment: Alignment.center,
                children: [
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
                              child: const SizedBox(width: 300, height: 300),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    top: -5,
                    child: Icon(Icons.arrow_drop_down, size: 100, color: Colors.white),
                  ),
                ],
              ),
            ),

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
          const SizedBox(height: 160),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, 
      floatingActionButton: showFab && !canSpinAgain
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

      canvas.save();
      canvas.translate(radius, radius);
      canvas.rotate(i * anglePerSegment + anglePerSegment);

      double textRadius = radius * 0.65; 
      Offset textOffset = Offset(
        -textPainter.width / 2,
        -textPainter.height / 2 - textRadius,
      );

      textPainter.paint(canvas, textOffset);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
