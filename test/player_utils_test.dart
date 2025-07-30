import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:alcoolize/src/utils/player_utils.dart';

void main() {
  group('PlayerUtils', () {
    group('chooseRandomPlayer', () {
      test('should return a player from the list', () {
        final players = ['Alice', 'Bob', 'Charlie'];
        
        final selectedPlayer = PlayerUtils.chooseRandomPlayer(players);
        
        expect(players.contains(selectedPlayer), isTrue);
      });

      test('should handle single player list', () {
        final players = ['OnlyPlayer'];
        
        final selectedPlayer = PlayerUtils.chooseRandomPlayer(players);
        
        expect(selectedPlayer, equals('OnlyPlayer'));
      });

      test('should return different players on multiple calls', () {
        final players = ['Alice', 'Bob', 'Charlie', 'David', 'Eve'];
        final selectedPlayers = <String>{};
        
        // Call multiple times to check randomness
        for (int i = 0; i < 20; i++) {
          selectedPlayers.add(PlayerUtils.chooseRandomPlayer(players));
        }
        
        // Should have selected more than one unique player (with high probability)
        expect(selectedPlayers.length, greaterThan(1));
      });

      test('should throw when given empty list', () {
        final emptyPlayers = <String>[];
        
        expect(() => PlayerUtils.chooseRandomPlayer(emptyPlayers), throwsA(isA<RangeError>()));
      });
    });

    group('buildPlayerDisplay', () {
      testWidgets('should return player widget when player is provided', (WidgetTester tester) async {
        const testPlayer = 'TestPlayer';
        
        final widget = PlayerUtils.buildPlayerDisplay(testPlayer);
        
        expect(widget, isA<Padding>());
        
        // Build the widget to test its content
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: widget,
            ),
          ),
        );
        
        expect(find.text('Jogador da vez: TestPlayer'), findsOneWidget);
      });

      testWidgets('should return empty widget when player is null', (WidgetTester tester) async {
        final widget = PlayerUtils.buildPlayerDisplay(null);
        
        expect(widget, isA<SizedBox>());
        
        // Build the widget to verify it's empty
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: widget,
            ),
          ),
        );
        
        // Should not find any text
        expect(find.byType(Text), findsNothing);
      });

      testWidgets('should have correct styling and layout', (WidgetTester tester) async {
        const testPlayer = 'StyledPlayer';
        
        final widget = PlayerUtils.buildPlayerDisplay(testPlayer);
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: widget,
            ),
          ),
        );
        
        // Verify the text widget exists and has correct properties
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.textAlign, equals(TextAlign.center));
        expect(textWidget.style?.fontSize, equals(24));
        expect(textWidget.style?.color, equals(Colors.white));
        
        // Verify padding
        final paddingWidget = tester.widget<Padding>(find.byType(Padding));
        expect(paddingWidget.padding, equals(const EdgeInsets.symmetric(horizontal: 60.0)));
      });

      testWidgets('should handle empty string player name', (WidgetTester tester) async {
        const emptyPlayer = '';
        
        final widget = PlayerUtils.buildPlayerDisplay(emptyPlayer);
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: widget,
            ),
          ),
        );
        
        expect(find.text('Jogador da vez: '), findsOneWidget);
      });

      testWidgets('should handle special characters in player name', (WidgetTester tester) async {
        const specialPlayer = 'José-André & María';
        
        final widget = PlayerUtils.buildPlayerDisplay(specialPlayer);
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: widget,
            ),
          ),
        );
        
        expect(find.text('Jogador da vez: José-André & María'), findsOneWidget);
      });
    });
  });
}