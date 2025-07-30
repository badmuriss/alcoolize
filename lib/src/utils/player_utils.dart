import 'dart:math';
import 'package:flutter/material.dart';

class PlayerUtils {
  static String chooseRandomPlayer(List<String> players) {
    return players[Random().nextInt(players.length)];
  }

  static Widget buildPlayerDisplay(String? currentPlayer) {
    return currentPlayer != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Text(
              'Jogador da vez: $currentPlayer',
              style: const TextStyle(fontSize: 24, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          )
        : const SizedBox.shrink();
  }
}