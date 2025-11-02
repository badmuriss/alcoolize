library;

import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_repository.dart';

/// Simple picker with anti-repetition for game items
class GamePicker {
  static const int _defaultWindowSize = 10;
  static const String _historyPrefix = 'picker_history_';
  
  final GameRepository _repository;
  final SharedPreferences _prefs;
  final Map<String, List<String>> _recentItems = {};
  final Random _random = Random();
  
  GamePicker(this._repository, this._prefs);
  
  static Future<GamePicker> create(GameRepository repository) async {
    final prefs = await SharedPreferences.getInstance();
    return GamePicker(repository, prefs);
  }
  
  /// Get next item for a game type with anti-repetition
  Future<GameItem?> getNextItem(String gameType, String locale) async {
    final items = await _repository.getGameItems(gameType, locale);
    if (items.isEmpty) return null;
    
    // Load recent history
    _loadRecentHistory(gameType);
    final recentItems = _recentItems[gameType] ?? [];
    
    // Filter out recent items if we have enough alternatives
    final availableItems = items.where((item) {
      final itemKey = _getItemKey(item);
      return !recentItems.contains(itemKey);
    }).toList();
    
    final itemsToPickFrom = availableItems.isNotEmpty ? availableItems : items;
    final selectedItem = itemsToPickFrom[_random.nextInt(itemsToPickFrom.length)];
    
    // Update history
    _addToHistory(gameType, selectedItem);
    
    return selectedItem;
  }
  
  /// Get multiple unique items
  Future<List<GameItem>> getMultipleItems(String gameType, String locale, int count) async {
    final items = await _repository.getGameItems(gameType, locale);
    if (items.isEmpty) return [];
    
    final selectedItems = <GameItem>[];
    final usedKeys = <String>{};
    
    // Load recent history
    _loadRecentHistory(gameType);
    final recentItems = _recentItems[gameType] ?? [];
    
    // Try to avoid recent items first
    final availableItems = items.where((item) {
      final itemKey = _getItemKey(item);
      return !recentItems.contains(itemKey);
    }).toList();
    
    final itemPool = List<GameItem>.from(availableItems.isNotEmpty ? availableItems : items);
    itemPool.shuffle(_random);
    
    for (final item in itemPool) {
      if (selectedItems.length >= count) break;
      
      final itemKey = _getItemKey(item);
      if (!usedKeys.contains(itemKey)) {
        selectedItems.add(item);
        usedKeys.add(itemKey);
        _addToHistory(gameType, item);
      }
    }
    
    return selectedItems;
  }
  
  /// Reset picker history for a game type
  void resetHistory(String gameType) {
    _recentItems[gameType] = [];
    _saveRecentHistory(gameType);
  }
  
  /// Reset all picker histories
  void resetAllHistories() {
    _recentItems.clear();
    // Clear all history keys from preferences
    final keys = _prefs.getKeys().where((key) => key.startsWith(_historyPrefix));
    for (final key in keys) {
      _prefs.remove(key);
    }
  }
  
  /// Get picker statistics
  PickerStatistics? getStatistics(String gameType) {
    _loadRecentHistory(gameType);
    final recentItems = _recentItems[gameType] ?? [];
    
    return PickerStatistics(
      gameType: gameType,
      recentItemsCount: recentItems.length,
      windowSize: _getWindowSize(gameType),
    );
  }
  
  /// Set custom window size for anti-repetition
  Future<void> setWindowSize(String gameType, int windowSize) async {
    await _prefs.setInt('${_historyPrefix}window_$gameType', windowSize.clamp(5, 50));
  }
  
  int _getWindowSize(String gameType) {
    return _prefs.getInt('${_historyPrefix}window_$gameType') ?? _defaultWindowSize;
  }
  
  String _getItemKey(GameItem item) {
    // Create a unique key for the item
    final text = item.getText();
    final pack = item.packId ?? 'unknown';
    return '${pack}_${text.hashCode}';
  }
  
  void _addToHistory(String gameType, GameItem item) {
    final itemKey = _getItemKey(item);
    final history = _recentItems[gameType] ?? [];
    
    // Remove if already exists (move to front)
    history.remove(itemKey);
    
    // Add to front
    history.insert(0, itemKey);
    
    // Keep only recent items within window
    final windowSize = _getWindowSize(gameType);
    if (history.length > windowSize) {
      history.removeRange(windowSize, history.length);
    }
    
    _recentItems[gameType] = history;
    _saveRecentHistory(gameType);
  }
  
  void _loadRecentHistory(String gameType) {
    if (!_recentItems.containsKey(gameType)) {
      final historyKey = _historyPrefix + gameType;
      final historyList = _prefs.getStringList(historyKey) ?? [];
      _recentItems[gameType] = historyList;
    }
  }
  
  void _saveRecentHistory(String gameType) {
    final historyKey = _historyPrefix + gameType;
    final history = _recentItems[gameType] ?? [];
    _prefs.setStringList(historyKey, history);
  }
}

/// Statistics about picker performance
class PickerStatistics {
  final String gameType;
  final int recentItemsCount;
  final int windowSize;
  
  PickerStatistics({
    required this.gameType,
    required this.recentItemsCount,
    required this.windowSize,
  });
  
  double get avoidanceRate {
    if (windowSize == 0) return 0.0;
    return (recentItemsCount / windowSize).clamp(0.0, 1.0);
  }
  
  bool get isEffective => avoidanceRate > 0.3;
}