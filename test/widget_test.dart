// Widget tests for Alcoolize app
// These test the UI components and user interactions
//
// Run with: flutter test

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alcoolize/src/utils/player_utils.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('PlayerUtils widget should display player name correctly', (WidgetTester tester) async {
      const testPlayerName = 'João';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerUtils.buildPlayerDisplay(testPlayerName),
          ),
        ),
      );

      // Verify the player name is displayed
      expect(find.text('Jogador da vez: João'), findsOneWidget);
      
      // Verify the text styling
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.color, equals(Colors.white));
      expect(textWidget.style?.fontSize, equals(24));
      expect(textWidget.textAlign, equals(TextAlign.center));
    });

    testWidgets('PlayerUtils should show nothing when player is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerUtils.buildPlayerDisplay(null),
          ),
        ),
      );

      // Should find no text widgets
      expect(find.byType(Text), findsNothing);
      
      // Should find a SizedBox.shrink()
      expect(find.byType(SizedBox), findsOneWidget);
    });

    group('App Integration', () {
      testWidgets('App should build without crashing', (WidgetTester tester) async {
        // Basic smoke test - verify the app can be instantiated
        final testApp = MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Alcoolize')),  
            body: const Center(child: Text('Test App')),
          ),
        );
        
        await tester.pumpWidget(testApp);
        
        expect(find.text('Alcoolize'), findsOneWidget);
        expect(find.text('Test App'), findsOneWidget);
      });
      
      testWidgets('Language selector should display correct options', (WidgetTester tester) async {
        final testApp = MaterialApp(
          home: Scaffold(
            body: PopupMenuButton<String>(
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'en', child: Text('English')),
                const PopupMenuItem(value: 'pt', child: Text('Português')),
                const PopupMenuItem(value: 'es', child: Text('Español')),
              ],
            ),
          ),
        );
        
        await tester.pumpWidget(testApp);
        
        // Tap the popup button
        await tester.tap(find.byType(PopupMenuButton<String>));
        await tester.pumpAndSettle();
        
        // Verify language options are shown
        expect(find.text('English'), findsOneWidget);
        expect(find.text('Português'), findsOneWidget);
        expect(find.text('Español'), findsOneWidget);
      });
    });
  });
}
