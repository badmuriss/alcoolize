import 'package:alcoolize/src/screens/games/base_game_screen.dart';
import 'package:alcoolize/src/services/game_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alcoolize/src/constants/game_constants.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../../localization/generated/app_localizations.dart';

class ScratchCardScreen extends BaseGameScreen {
  const ScratchCardScreen({super.key, required super.playersList});

  @override
  ScratchCardScreenState createState() => ScratchCardScreenState();
}

class ScratchCard {
  final String challenge;
  final List<Offset> scratchedPoints;
  bool isScratched;

  ScratchCard({
    required this.challenge,
    this.isScratched = false,
  }) : scratchedPoints = [];
}

class ScratchCardScreenState extends BaseGameScreenState<ScratchCardScreen> {
  String? currentPlayer;
  List<ScratchCard> scratchCards = [];
  
  @override
  Color get gameColor => GameColors.scratchCard;

  @override
  String get gameTitle => AppLocalizations.of(context)!.scratchCard;

  @override
  String get gameInstructions => AppLocalizations.of(context)!.scratchCardGameInfo;

  @override
  void initState() {
    super.initState();
    _chooseRandomPlayer();
    _loadChallenges();
  }

  void _chooseRandomPlayer() {
    currentPlayer = widget.playersList[Random().nextInt(widget.playersList.length)];
  }

  Future<void> _loadChallenges() async {
    try {
      final repository = await GameRepository.create();
      final prefs = await SharedPreferences.getInstance();
      final locale = prefs.getString('selected_language') ?? 'pt';
      final items = await repository.getGameItems('scratch_card', locale);

      final challenges = items.map((item) => item.getText()).toList();

      if (challenges.isNotEmpty) {
        setState(() {
          scratchCards = List.generate(4, (index) {
            final randomChallenge = challenges[Random().nextInt(challenges.length)];
            return ScratchCard(challenge: randomChallenge);
          });
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }



  @override
  Widget buildGameContent() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (scratchCards.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.currentPlayer(currentPlayer!),
            style: TextStyle(
              fontSize: (screenHeight * 0.03).clamp(18.0, 24.0),
              color: GameColors.gameText,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: (screenHeight * 0.03).clamp(15.0, 25.0)),
          
          
          // Scratch Cards Grid
          SizedBox(
            width: (screenWidth * 0.8).clamp(300.0, 450.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return _buildScratchCard(index, screenWidth, screenHeight);
              },
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _buildScratchCard(int index, double screenWidth, double screenHeight) {
    final card = scratchCards[index];
    final cardSize = (screenWidth * 0.36).clamp(130.0, 190.0);
    
    return SizedBox(
      width: cardSize,
      height: cardSize / 1.2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Background with challenge text
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 6),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    card.challenge,
                    style: TextStyle(
                      fontSize: (cardSize * 0.15).clamp(12.0, 16.0),
                      color: gameColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            
            // Scratch overlay
            GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  card.scratchedPoints.add(details.localPosition);
                });
              },
              onPanStart: (details) {
                setState(() {
                  card.scratchedPoints.add(details.localPosition);
                });
              },
              child: CustomPaint(
                painter: ScratchCardPainter(
                  scratchedPoints: card.scratchedPoints,
                  cardColor: Colors.amber[400]!,
                ),
                child: const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScratchCardPainter extends CustomPainter {
  final List<Offset> scratchedPoints;
  final Color cardColor;

  ScratchCardPainter({
    required this.scratchedPoints,
    required this.cardColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Save the canvas layer for proper blending
    canvas.saveLayer(Offset.zero & size, Paint());

    // Draw the scratch overlay background with rounded corners
    final paint = Paint()
      ..color = cardColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(12),
      ),
      paint,
    );
    
    // Draw white border on scratch overlay with rounded corners
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(12),
      ),
      borderPaint,
    );

    // Draw question mark
    final textPainter = TextPainter(
      text: TextSpan(
        text: '?',
        style: TextStyle(
          color: Colors.white,
          fontSize: size.width * 0.4,
          fontWeight: FontWeight.bold,
          
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );

    // Draw scratched areas to create holes
    if (scratchedPoints.isNotEmpty) {
      final scratchPaint = Paint()
        ..blendMode = BlendMode.dstOut
        ..strokeWidth = 30.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      // Draw lines between consecutive points
      final path = Path();
      if (scratchedPoints.isNotEmpty) {
        path.moveTo(scratchedPoints.first.dx, scratchedPoints.first.dy);
        for (int i = 1; i < scratchedPoints.length; i++) {
          path.lineTo(scratchedPoints[i].dx, scratchedPoints[i].dy);
        }
      }
      canvas.drawPath(path, scratchPaint);

      // Draw circles at each point for better coverage
      final circlePaint = Paint()
        ..blendMode = BlendMode.dstOut
        ..style = PaintingStyle.fill;

      for (final point in scratchedPoints) {
        canvas.drawCircle(point, 15.0, circlePaint);
      }
    }

    // Restore the canvas
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}