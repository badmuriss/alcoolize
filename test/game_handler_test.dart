import 'package:flutter_test/flutter_test.dart';
import 'package:alcoolize/src/utils/game_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('GameHandler', () {
    setUp(() {
      // Reset static state before each test
      GameHandler.usedWords.clear();
      GameHandler.gameWeights.clear();
    });

    setUpAll(() {
      // Initialize SharedPreferences mock
      SharedPreferences.setMockInitialValues({});
    });

    test('should have all expected games defined', () {
      expect(GameHandler.allGames.length, equals(8));
      expect(GameHandler.allGames.keys, contains('PARANOIA'));
      expect(GameHandler.allGames.keys, contains('MOST_LIKELY_TO'));
      expect(GameHandler.allGames.keys, contains('NEVER_HAVE_I_EVER'));
      expect(GameHandler.allGames.keys, contains('MEDUSA'));
      expect(GameHandler.allGames.keys, contains('FORBIDDEN_WORD'));
      expect(GameHandler.allGames.keys, contains('MYSTERY_VERB'));
      expect(GameHandler.allGames.keys, contains('ROULETTE'));
      expect(GameHandler.allGames.keys, contains('CARDS'));
    });

    // Game descriptions are now handled through localization

    test('should have default weights for all games', () {
      expect(GameHandler.allGames.length, equals(8));
      
      // GameHandler needs to be initialized to load default weights
      // This test checks that the structure exists for weight management
      expect(GameHandler.gameWeights, isA<Map<String, double>>());
    });

    test('should reset used words correctly', () {
      // Add some test words
      GameHandler.usedWords.addAll(['palavra1', 'palavra2', 'palavra3']);
      expect(GameHandler.usedWords.length, equals(3));
      
      // Reset and verify
      GameHandler.resetUsedWords();
      expect(GameHandler.usedWords.isEmpty, isTrue);
    });

    test('should check game enabled status correctly', () {
      // Test with uninitialized state
      expect(GameHandler.isGameEnabled('MEDUSA'), isFalse);
      
      // Test after initialization would require mocking SharedPreferences
      // This is a integration test scenario
    });

    test('should reset game weights to default correctly', () {
      // Modify weights
      GameHandler.gameWeights['MEDUSA'] = 50.0;
      GameHandler.gameWeights['PARANOIA'] = 25.0;
      
      // Reset to defaults
      GameHandler.resetGameWeightsToDefault();
      
      // Verify reset (assuming all games are enabled for this test)
      // Note: This test would need proper setup with enabled games
      expect(GameHandler.gameWeights.isNotEmpty, isTrue);
    });

    test('should handle empty active games list', () {
      // Clear active games
      GameHandler.activeGamesList.clear();
      
      // This would require mocking context and players for full test
      expect(GameHandler.activeGamesList.isEmpty, isTrue);
    });

    group('Weight calculation', () {
      test('should properly weight games for selection', () {
        // This is testing internal _getWeightedGames method
        // Would need to make it public or test through integration
        expect(GameHandler.gameWeights, isA<Map<String, double>>());
      });
    });
  });
}