import 'dart:math';
import 'package:flutter/material.dart';
import 'package:alcoolize/src/base_game_screen.dart';
import 'localization/generated/app_localizations.dart';

class RouletteScreen extends BaseGameScreen {
  const RouletteScreen({super.key, required super.playersList});

  @override
  RouletteScreenState createState() => RouletteScreenState();
}

class RouletteScreenState extends BaseGameScreenState<RouletteScreen> with SingleTickerProviderStateMixin {
  String? currentPlayer;
  String? result;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool canSpinAgain = true;
  bool showFab = false;
  static const rouletteColor = Colors.black;

  @override
  Color get gameColor => rouletteColor;

  @override
  String get gameTitle => AppLocalizations.of(context)!.roulette;

  @override
  IconData? get gameIcon => null;

  @override
  String get gameInstructions => AppLocalizations.of(context)!.rouletteGameInfo;

  List<String> get options => [
    AppLocalizations.of(context)!.drinkOneShot,
    AppLocalizations.of(context)!.drinkWithFriend,
    AppLocalizations.of(context)!.passTurn,
    AppLocalizations.of(context)!.drinkAndSpinAgain,
    AppLocalizations.of(context)!.drinkDouble,
    AppLocalizations.of(context)!.chooseSomeoneToDrink
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
        if (result == AppLocalizations.of(context)!.drinkAndSpinAgain) {
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
  Widget buildFloatingActionButton() {
    return showFab && !canSpinAgain
        ? Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: FloatingActionButton(
              onPressed: nextRound,
              backgroundColor: Colors.white,
              foregroundColor: rouletteColor,
              child: const Icon(Icons.arrow_forward),
            ),
          )
        : const SizedBox.shrink();
  }

  @override
  Widget buildGameContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Text(
              AppLocalizations.of(context)!.currentPlayer(currentPlayer!),
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
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: Text(AppLocalizations.of(context)!.spinRoulette, style: const TextStyle(fontSize: 18)),
              )
            : const SizedBox(height: 50),
        ],
      ),
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