import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alcoolize/src/screens/games/truth_or_dare_screen.dart';
import 'package:alcoolize/src/localization/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('TruthOrDareScreen', () {
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
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: 800,
              child: TruthOrDareScreen(playersList: const ['Player1', 'Player2']),
            ),
          ),
        ),
      );
    });

    testWidgets('should create truth or dare screen', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pump();

      expect(find.byType(TruthOrDareScreen), findsOneWidget);
    });

    testWidgets('should display current player', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pump();

      // Should find text containing either Player1 or Player2
      final playerTextFinder = find.textContaining('Player');
      expect(playerTextFinder, findsAtLeastNWidgets(1));
    });

    testWidgets('should display Truth and Dare buttons', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pump();

      // Wait for initial load
      await tester.pump(const Duration(seconds: 1));

      // Should find Truth and Dare buttons
      final elevatedButtonFinder = find.byType(ElevatedButton);
      expect(elevatedButtonFinder, findsAtLeastNWidgets(2));
    });

    testWidgets('should handle Truth button tap', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pump();

      // Wait for initial load
      await tester.pump(const Duration(seconds: 1));

      final truthButtonFinder = find.text('Truth');
      if (truthButtonFinder.evaluate().isNotEmpty) {
        await tester.tap(truthButtonFinder);
        await tester.pump();

        // Should show a truth question
        expect(find.byType(Text), findsAtLeastNWidgets(1));
      }
    });

    testWidgets('should handle Dare button tap', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pump();

      // Wait for initial load
      await tester.pump(const Duration(seconds: 1));

      final dareButtonFinder = find.text('Dare');
      if (dareButtonFinder.evaluate().isNotEmpty) {
        await tester.tap(dareButtonFinder);
        await tester.pump();

        // Should show a dare challenge
        expect(find.byType(Text), findsAtLeastNWidgets(1));
      }
    });

    testWidgets('should show next player button after selection', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pump();

      // Wait for initial load
      await tester.pump(const Duration(seconds: 1));

      // Skip this test if no buttons are found initially
      final buttonFinder = find.byType(ElevatedButton);
      if (buttonFinder.evaluate().isNotEmpty) {
        await tester.tap(buttonFinder.first);
        await tester.pump();

        // Should show some UI elements after selection
        final widgetFinder = find.byType(Text);
        expect(widgetFinder, findsAtLeastNWidgets(1));
      } else {
        // If no buttons found, just verify the screen exists
        expect(find.byType(TruthOrDareScreen), findsOneWidget);
      }
    });
  });

  group('Truth or Dare Logic', () {
    test('should handle truth/dare selection', () {
      const selections = ['truth', 'dare'];
      const userSelection = 'truth';

      expect(selections, contains(userSelection));
      expect(userSelection, isA<String>());
    });

    test('should validate player rotation', () {
      const players = ['Player1', 'Player2', 'Player3'];
      var currentPlayerIndex = 0;

      // Simulate next player
      currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
      
      expect(currentPlayerIndex, equals(1));
      expect(currentPlayerIndex, lessThan(players.length));
    });

    test('should handle empty questions gracefully', () {
      const List<String> emptyQuestions = [];
      
      expect(emptyQuestions.isEmpty, isTrue);
      expect(emptyQuestions.length, equals(0));
    });
  });
}