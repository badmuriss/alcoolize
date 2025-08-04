import 'dart:math';
import 'package:flutter/material.dart';
import 'package:alcoolize/src/screens/games/base_game_screen.dart';
import 'package:alcoolize/src/constants/game_constants.dart';
import '../../localization/generated/app_localizations.dart';

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
  @override
  Color get gameColor => GameColors.roulette;

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
      duration: GameConstants.spinDuration,
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
              backgroundColor: GameColors.buttonBackground,
              foregroundColor: GameColors.roulette,
              child: const Icon(Icons.arrow_forward),
            ),
          )
        : const SizedBox.shrink();
  }

  @override
  Widget buildGameContent() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Calculate responsive wheel size
    final maxWheelSize = (screenHeight * 0.35).clamp(200.0, 300.0);
    final wheelSize = (screenWidth * 0.75).clamp(200.0, maxWheelSize);
    final containerHeight = wheelSize + 100;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              AppLocalizations.of(context)!.currentPlayer(currentPlayer!),
              style: TextStyle(
                fontSize: (screenHeight * 0.028).clamp(18.0, 24.0), 
                color: GameColors.gameText
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: (screenHeight * 0.025).clamp(10.0, 20.0)),
          SizedBox(
            width: wheelSize,
            height: containerHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: wheelSize,
                    width: wheelSize,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        RotationTransition(
                          turns: _animation,
                          child: CustomPaint(
                            painter: RoletaPainter(options.length, options.reversed.toList()),
                            child: SizedBox(width: wheelSize, height: wheelSize),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -5,
                  child: Icon(
                    Icons.arrow_drop_down, 
                    size: (wheelSize * 0.33).clamp(60.0, 100.0), 
                    color: GameColors.gameText
                  ),
                ),
              ],
            ),
          ),
          canSpinAgain 
              ? ElevatedButton(
                onPressed: spinWheel,
                style: ElevatedButton.styleFrom(
                  foregroundColor: GameColors.gameText, backgroundColor: GameColors.spinButtonBackground,
                  padding: EdgeInsets.symmetric(
                    horizontal: (screenWidth * 0.1).clamp(20.0, 40.0), 
                    vertical: (screenHeight * 0.025).clamp(15.0, 20.0)
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.spinRoulette, 
                  style: TextStyle(fontSize: (screenHeight * 0.021).clamp(14.0, 18.0))
                ),
              )
            : SizedBox(height: (screenHeight * 0.06).clamp(30.0, 50.0)),
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
      paint.color = i.isEven ? GameColors.spinButtonBackground : GameColors.roulette;
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
        style: const TextStyle(color: GameColors.gameText, fontWeight: FontWeight.w700),
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
          color: GameColors.gameText,
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