import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alcoolize/src/screens/games/scratch_card_screen.dart';
import 'package:alcoolize/src/localization/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ScratchCardScreen', () {
    late Widget testWidget;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      testWidget = MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: ScratchCardScreen(playersList: const ['Player1', 'Player2']),
      );
    });

    testFinder('should create scratch card screen', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pump();

      expect(find.byType(ScratchCardScreen), findsOneWidget);
    });

    testFinder('should display current player', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pump();

      // Should find text containing either Player1 or Player2
      final playerTextFinder = find.textContaining('Player');
      expect(playerTextFinder, findsAtLeastNWidgets(1));
    });

    testFinder('should display 4 scratch cards in grid', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pump();

      // Wait for challenges to load
      await tester.pump(const Duration(seconds: 1));

      final gridFinder = find.byType(GridView);
      expect(gridFinder, findsOneWidget);

      // Should have 4 cards
      final customPaintFinder = find.byType(CustomPaint);
      expect(customPaintFinder, findsAtLeastNWidgets(4));
    });

    testFinder('should handle pan gestures for scratching', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pump();

      // Wait for challenges to load
      await tester.pump(const Duration(seconds: 1));

      final gestureDetectorFinder = find.byType(GestureDetector);
      expect(gestureDetectorFinder, findsAtLeastNWidgets(4));

      // Test pan gesture on first card
      if (gestureDetectorFinder.evaluate().isNotEmpty) {
        await tester.startGesture(
          tester.getCenter(gestureDetectorFinder.first),
        );
        await tester.pump();
      }
    });

    testFinder('should show loading indicator when challenges are loading', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      
      // Before challenges load
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('ScratchCard model', () {
    test('should initialize with correct properties', () {
      const testChallenge = 'Test challenge';
      final scratchCard = ScratchCard(challenge: testChallenge);

      expect(scratchCard.challenge, equals(testChallenge));
      expect(scratchCard.isScratched, isFalse);
      expect(scratchCard.scratchedPoints, isEmpty);
    });

    test('should allow adding scratched points', () {
      final scratchCard = ScratchCard(challenge: 'Test');
      const testPoint = Offset(10.0, 20.0);

      scratchCard.scratchedPoints.add(testPoint);

      expect(scratchCard.scratchedPoints.length, equals(1));
      expect(scratchCard.scratchedPoints.first, equals(testPoint));
    });

    test('should allow marking as scratched', () {
      final scratchCard = ScratchCard(challenge: 'Test');

      scratchCard.isScratched = true;

      expect(scratchCard.isScratched, isTrue);
    });
  });

  group('ScratchCardPainter', () {
    test('should initialize with required properties', () {
      final painter = ScratchCardPainter(
        scratchedPoints: const [Offset(0, 0)],
        cardColor: Colors.blue,
      );

      expect(painter.scratchedPoints, isA<List<Offset>>());
      expect(painter.cardColor, equals(Colors.blue));
    });

    test('should always repaint', () {
      final painter = ScratchCardPainter(
        scratchedPoints: const [],
        cardColor: Colors.red,
      );

      expect(painter.shouldRepaint(painter), isTrue);
    });
  });
}

// Helper function for widget tests
void testFinder(String description, Future<void> Function(WidgetTester) test) {
  testWidgets(description, test);
}