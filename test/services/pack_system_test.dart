import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alcoolize/src/services/game_repository.dart';
import 'package:alcoolize/src/services/game_picker.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Pack System Tests', () {
    late GameRepository repository;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
    });

    setUp(() async {
      repository = await GameRepository.create();
      await repository.initializeDefaults();
    });

    test('should load universal packs', () async {
      final packs = await repository.getAllPacks();
      expect(packs, isNotEmpty);
      
      // Check that packs have the required structure
      for (final pack in packs) {
        expect(pack.manifest.name, isNotEmpty);
        expect(pack.manifest.spice, inInclusiveRange(0, 3));
        expect(pack.games, isNotEmpty);
      }
    });

    test('should return all packs regardless of spice level', () async {
      // Set max spice to 1
      await repository.setMaxSpiceLevel(1);

      final availablePacks = await repository.getAvailablePacks();
      final allPacks = await repository.getAllPacks();

      // All packs should be available (no filtering)
      expect(availablePacks.length, equals(allPacks.length));
    });

    test('should return all packs including premium', () async {
      // Set premium unlocked status
      await repository.setPremiumUnlocked(false);

      final availablePacks = await repository.getAvailablePacks();

      // All packs should be available (all users have premium access)
      expect(availablePacks, isNotEmpty);
    });

    test('should get game items from enabled packs', () async {
      final items = await repository.getGameItems('truth_or_dare', 'en');
      expect(items, isNotEmpty);
      
      // Check item structure
      for (final item in items) {
        expect(item.gameType, equals('truth_or_dare'));
        expect(item.getText(), isNotEmpty);
        expect(item.packId, isNotNull);
      }
    });

    test('should handle pack enabling/disabling', () async {
      final allPacks = await repository.getAllPacks();
      if (allPacks.isEmpty) return;
      
      final pack = allPacks.first;
      
      // Disable pack
      await repository.setPackEnabled(pack.id, false);
      expect(repository.getEnabledPackIds().contains(pack.id), isFalse);
      
      // Enable pack
      await repository.setPackEnabled(pack.id, true);
      expect(repository.getEnabledPackIds().contains(pack.id), isTrue);
    });

    test('should support multiple game types in single pack', () async {
      final allPacks = await repository.getAllPacks();
      expect(allPacks, isNotEmpty);
      
      final pack = allPacks.first;
      final gameTypes = [
        'truth_or_dare',
        'never_have_i_ever',
        'most_likely_to',
        'paranoia',
        'cards',
        'drunk_trivia',
        'forbidden_word',
        'scratch_card'
      ];
      
      int supportedGames = 0;
      for (final gameType in gameTypes) {
        final items = pack.getItemsForGame(gameType, 'en');
        if (items.isNotEmpty) {
          supportedGames++;
        }
      }
      
      // Pack should support multiple games
      expect(supportedGames, greaterThan(1));
    });

    test('should handle language fallback', () async {
      final items = await repository.getGameItems('truth_or_dare', 'unsupported_lang');
      expect(items, isNotEmpty);
      
      // Should fallback to available language
      for (final item in items) {
        expect(item.getText(), isNotEmpty);
      }
    });
  });

  group('Game Picker Tests', () {
    late GameRepository repository;
    late GamePicker picker;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      repository = await GameRepository.create();
      await repository.initializeDefaults();
      picker = await GamePicker.create(repository);
    });

    test('should pick items with anti-repetition', () async {
      final items = <GameItem>[];
      
      // Pick multiple items
      for (int i = 0; i < 5; i++) {
        final item = await picker.getNextItem('truth_or_dare', 'en');
        if (item != null) {
          items.add(item);
        }
      }
      
      expect(items, isNotEmpty);
      
      // Check that items are different (basic anti-repetition)
      final texts = items.map((item) => item.getText()).toSet();
      expect(texts.length, greaterThan(1)); // Should have some variety
    });

    test('should get multiple unique items', () async {
      final items = await picker.getMultipleItems('truth_or_dare', 'en', 3);
      expect(items.length, lessThanOrEqualTo(3));
      
      // All items should be unique
      final texts = items.map((item) => item.getText()).toSet();
      expect(texts.length, equals(items.length));
    });

    test('should track picker statistics', () async {
      // Pick some items first
      for (int i = 0; i < 3; i++) {
        await picker.getNextItem('truth_or_dare', 'en');
      }
      
      final stats = picker.getStatistics('truth_or_dare');
      expect(stats, isNotNull);
      expect(stats!.gameType, equals('truth_or_dare'));
      expect(stats.recentItemsCount, greaterThan(0));
    });

    test('should handle custom window size', () async {
      await picker.setWindowSize('truth_or_dare', 15);
      
      final stats = picker.getStatistics('truth_or_dare');
      expect(stats!.windowSize, equals(15));
    });

    test('should reset history', () async {
      // Pick some items first
      await picker.getNextItem('truth_or_dare', 'en');
      
      picker.resetHistory('truth_or_dare');
      
      final stats = picker.getStatistics('truth_or_dare');
      expect(stats!.recentItemsCount, equals(0));
    });
  });
}