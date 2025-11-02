import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple premium service that manages whether user has premium access
class PremiumService {
  static const String _premiumKey = 'has_premium_access';
  
  /// Singleton instance
  static PremiumService? _instance;
  
  /// Preferences instance
  SharedPreferences? _prefs;
  
  /// Stream controller for premium status changes
  final StreamController<bool> _premiumStatusController = StreamController<bool>.broadcast();
  
  /// Current premium status
  bool _hasPremiumAccess = false;
  
  /// Factory constructor for singleton
  factory PremiumService() {
    return _instance ??= PremiumService._internal();
  }
  
  /// Private constructor
  PremiumService._internal();
  
  /// Initialize the service
  Future<bool> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _hasPremiumAccess = _prefs?.getBool(_premiumKey) ?? false;
      debugPrint('PremiumService initialized: premium=$_hasPremiumAccess');
      return true;
    } catch (e) {
      debugPrint('Failed to initialize PremiumService: $e');
      return false;
    }
  }
  
  /// Check if user has premium access
  bool get hasPremiumAccess => _hasPremiumAccess;
  
  /// Stream of premium status changes
  Stream<bool> get premiumStatusStream => _premiumStatusController.stream;
  
  /// Set premium access status (for testing or admin purposes)
  Future<void> setPremiumAccess(bool hasPremium) async {
    _hasPremiumAccess = hasPremium;
    await _prefs?.setBool(_premiumKey, hasPremium);
    _premiumStatusController.add(hasPremium);
    debugPrint('Premium access set to: $hasPremium');
  }
  
  /// Grant premium access (simulate purchase)
  Future<void> grantPremiumAccess() async {
    await setPremiumAccess(true);
  }
  
  /// Revoke premium access
  Future<void> revokePremiumAccess() async {
    await setPremiumAccess(false);
  }
  
  /// Check if user can access premium pack
  bool canAccessPremiumContent() {
    return _hasPremiumAccess;
  }
  
  /// Get premium status for debugging
  Map<String, dynamic> getStatus() {
    return {
      'hasPremiumAccess': _hasPremiumAccess,
      'initialized': _prefs != null,
    };
  }
  
  /// Dispose resources
  void dispose() {
    _premiumStatusController.close();
  }
}