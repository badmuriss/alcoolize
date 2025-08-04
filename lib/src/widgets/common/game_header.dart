import 'package:flutter/material.dart';
import '../../constants/game_constants.dart';

class GameHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  
  const GameHeader({
    super.key,
    required this.title,
    this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: GameSizes.gameHeaderFontSize, 
                fontWeight: FontWeight.bold, 
                color: Colors.white
              ),
              textAlign: TextAlign.center,
            ),
            if (icon != null) ...[  
              const SizedBox(height: 10),
              Icon(icon!, size: GameSizes.gameIconSize, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }
}