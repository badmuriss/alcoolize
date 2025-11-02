library;

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Repository for managing universal game packs
class GameRepository {
  static const String _enabledPacksKey = 'enabled_packs_v2';
  static const String _maxSpiceLevelKey = 'max_spice_level';
  static const String _premiumUnlockedKey = 'premium_unlocked';
  
  final SharedPreferences _prefs;
  final Map<String, UniversalPack> _loadedPacks = {};
  
  GameRepository(this._prefs);
  
  static Future<GameRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return GameRepository(prefs);
  }
  
  /// Load all available universal packs from assets
  Future<List<UniversalPack>> getAllPacks() async {
    if (_loadedPacks.isNotEmpty) {
      return _loadedPacks.values.toList();
    }
    
    const packFiles = [
      'drinking_pack.json',
      'party_pack.json', 
      'hot_pack.json',
    ];
    
    final packs = <UniversalPack>[];
    
    for (final file in packFiles) {
      try {
        final jsonString = await rootBundle.loadString('assets/packs/$file');
        final packData = json.decode(jsonString);
        final pack = UniversalPack.fromJson(file, packData);
        _loadedPacks[pack.id] = pack;
        packs.add(pack);
      } catch (e) {
        // Skip invalid packs
        continue;
      }
    }
    
    return packs;
  }
  
  /// Get filtered packs based on user preferences
  Future<List<UniversalPack>> getAvailablePacks() async {
    final allPacks = await getAllPacks();
    // All packs are available - no spice or premium filtering
    return allPacks;
  }
  
  /// Get enabled packs filtered by availability
  Future<List<UniversalPack>> getEnabledPacks() async {
    final availablePacks = await getAvailablePacks();
    final enabledPackIds = getEnabledPackIds();
    
    return availablePacks.where((pack) => 
      enabledPackIds.contains(pack.id)
    ).toList();
  }
  
  /// Get all items for a specific game type from enabled packs
  Future<List<GameItem>> getGameItems(String gameType, String locale) async {
    final enabledPacks = await getEnabledPacks();
    final items = <GameItem>[];
    
    for (final pack in enabledPacks) {
      final gameItems = pack.getItemsForGame(gameType, locale);
      items.addAll(gameItems);
    }
    
    return items;
  }
  
  /// Pack preferences
  Set<String> getEnabledPackIds() {
    final enabledList = _prefs.getStringList(_enabledPacksKey) ?? [];
    return Set<String>.from(enabledList);
  }
  
  Future<void> setPackEnabled(String packId, bool enabled) async {
    final enabledIds = getEnabledPackIds();
    if (enabled) {
      enabledIds.add(packId);
    } else {
      enabledIds.remove(packId);
    }
    await _prefs.setStringList(_enabledPacksKey, enabledIds.toList());
  }
  
  /// Spice level preferences (0-3)
  int getMaxSpiceLevel() {
    return _prefs.getInt(_maxSpiceLevelKey) ?? 1; // Default to medium
  }
  
  Future<void> setMaxSpiceLevel(int level) async {
    await _prefs.setInt(_maxSpiceLevelKey, level.clamp(0, 3));
  }
  
  /// user premium status
  bool isPremiumUnlocked() {
    return true; // All users have premium access for now
  }

  Future<void> setPremiumUnlocked(bool unlocked) async {
    // No-op: all users are premium
    await _prefs.setBool(_premiumUnlockedKey, true);
  }
  
  /// Initialize defaults - enable all available free packs
  Future<void> initializeDefaults() async {
    if (getEnabledPackIds().isEmpty) {
      final availablePacks = await getAvailablePacks();
      final freePacks = availablePacks.where((pack) => !pack.manifest.premium);
      
      for (final pack in freePacks) {
        await setPackEnabled(pack.id, true);
      }
    }
  }
}

/// Universal pack containing all games
class UniversalPack {
  final String id;
  final PackManifest manifest;
  final Map<String, dynamic> games;
  
  UniversalPack({
    required this.id,
    required this.manifest,
    required this.games,
  });
  
  factory UniversalPack.fromJson(String filename, Map<String, dynamic> json) {
    final manifest = PackManifest.fromJson(json['manifest']);
    final id = filename.replaceAll('.json', '');
    
    return UniversalPack(
      id: id,
      manifest: manifest,
      games: json['games'] ?? {},
    );
  }
  
  /// Get items for a specific game type and locale
  List<GameItem> getItemsForGame(String gameType, String locale) {
    if (!games.containsKey(gameType)) {
      return [];
    }
    
    final gameData = games[gameType];
    final items = <GameItem>[];
    
    // Handle different game structures
    switch (gameType) {
      case 'truth_or_dare':
        items.addAll(_getTruthOrDareItems(gameData, locale));
        break;
      case 'drunk_trivia':
        items.addAll(_getTriviaItems(gameData, locale));
        break;
      case 'cards':
        items.addAll(_getCardItems(gameData, locale));
        break;
      case 'never_have_i_ever':
      case 'most_likely_to':
      case 'paranoia':
      case 'forbidden_word':
      case 'scratch_card':
        items.addAll(_getStringItems(gameData, locale, gameType));
        break;
    }
    
    // Add pack metadata to all items
    for (final item in items) {
      item.packId = id;
      item.packName = manifest.getLocalizedName(locale);
      item.spiceLevel = manifest.spice;
    }
    
    return items;
  }
  
  List<GameItem> _getTruthOrDareItems(Map<String, dynamic> gameData, String locale) {
    final items = <GameItem>[];
    
    final truths = _getLocalizedList(gameData['truths'], locale);
    for (final truth in truths) {
      items.add(GameItem(
        gameType: 'truth_or_dare',
        data: {'kind': 'truth', 'text': truth},
      ));
    }
    
    final dares = _getLocalizedList(gameData['dares'], locale);
    for (final dare in dares) {
      items.add(GameItem(
        gameType: 'truth_or_dare',
        data: {'kind': 'dare', 'text': dare},
      ));
    }
    
    return items;
  }
  
  List<GameItem> _getTriviaItems(Map<String, dynamic> gameData, String locale) {
    final questions = _getLocalizedList(gameData['questions'], locale);
    return questions.map((question) => GameItem(
      gameType: 'drunk_trivia',
      data: question,
    )).toList();
  }
  
  List<GameItem> _getCardItems(Map<String, dynamic> gameData, String locale) {
    final challenges = _getLocalizedList(gameData['challenges'], locale);
    return challenges.map((challenge) => GameItem(
      gameType: 'cards',
      data: challenge,
    )).toList();
  }
  
  List<GameItem> _getStringItems(Map<String, dynamic> gameData, String locale, String gameType) {
    String key;
    switch (gameType) {
      case 'never_have_i_ever':
        key = 'statements';
        break;
      case 'most_likely_to':
      case 'paranoia':
        key = 'questions';
        break;
      case 'forbidden_word':
        key = 'words';
        break;
      case 'scratch_card':
        key = 'challenges';
        break;
      default:
        return [];
    }
    
    final items = _getLocalizedList(gameData[key], locale);
    return items.map((item) => GameItem(
      gameType: gameType,
      data: item,
    )).toList();
  }
  
  List<dynamic> _getLocalizedList(Map<String, dynamic>? localizedData, String locale) {
    if (localizedData == null) return [];
    
    // Try requested locale first
    if (localizedData.containsKey(locale)) {
      return List<dynamic>.from(localizedData[locale]);
    }
    
    // Fallback to English
    if (localizedData.containsKey('en')) {
      return List<dynamic>.from(localizedData['en']);
    }
    
    // Fallback to Portuguese
    if (localizedData.containsKey('pt')) {
      return List<dynamic>.from(localizedData['pt']);
    }
    
    return [];
  }
}

/// Pack manifest with metadata
class PackManifest {
  final Map<String, String> name;
  final String version;
  final bool premium;
  final int spice;
  final Map<String, String>? description;
  final List<String>? tags;
  final int? minAge;
  final String? author;
  
  PackManifest({
    required this.name,
    required this.version,
    required this.premium,
    required this.spice,
    this.description,
    this.tags,
    this.minAge,
    this.author,
  });
  
  factory PackManifest.fromJson(Map<String, dynamic> json) {
    return PackManifest(
      name: Map<String, String>.from(json['name']),
      version: json['version'],
      premium: json['premium'],
      spice: json['spice'],
      description: json['description'] != null
          ? Map<String, String>.from(json['description'])
          : null,
      tags: json['tags'] != null
          ? List<String>.from(json['tags'])
          : null,
      minAge: json['minAge'],
      author: json['author'],
    );
  }
  
  String getLocalizedName(String locale) {
    return name[locale] ?? name['en'] ?? name['pt'] ?? name.values.first;
  }
  
  String getLocalizedDescription(String locale) {
    if (description == null) return '';
    return description![locale] ?? description!['en'] ?? description!['pt'] ?? '';
  }
  
  String getSpiceLevelName(String locale) {
    switch (spice) {
      case 0:
        return locale == 'pt' ? 'Suave' : locale == 'es' ? 'Suave' : 'Mild';
      case 1:
        return locale == 'pt' ? 'Médio' : locale == 'es' ? 'Medio' : 'Medium';
      case 2:
        return locale == 'pt' ? 'Picante' : locale == 'es' ? 'Picante' : 'Spicy';
      case 3:
        return locale == 'pt' ? 'Quente' : locale == 'es' ? 'Caliente' : 'Hot';
      default:
        return 'Unknown';
    }
  }
}

/// Individual game item
class GameItem {
  final String gameType;
  final dynamic data;
  String? packId;
  String? packName;
  int? spiceLevel;
  
  GameItem({
    required this.gameType,
    required this.data,
    this.packId,
    this.packName,
    this.spiceLevel,
  });
  
  /// Get text representation of the item
  String getText() {
    if (data is String) {
      return data;
    } else if (data is Map) {
      final map = data as Map<String, dynamic>;
      
      if (map.containsKey('text')) {
        return map['text'];
      } else if (map.containsKey('challenge')) {
        return map['challenge'];
      } else if (map.containsKey('question')) {
        return map['question'];
      }
    }
    
    return data.toString();
  }
  
  /// Get additional metadata
  Map<String, dynamic> getMetadata() {
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return {};
  }
  
  /// Get display info for UI
  String getDisplayText() {
    final text = getText();
    final metadata = getMetadata();
    
    if (gameType == 'truth_or_dare' && metadata.containsKey('kind')) {
      final kind = metadata['kind'];
      return '$kind: $text';
    }
    
    return text;
  }
}