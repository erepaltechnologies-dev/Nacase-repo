import 'package:flutter/foundation.dart';

class SubscriptionProvider with ChangeNotifier {
  bool _isSubscribed = false;
  String _subscriptionPlan = '';
  DateTime? _subscriptionDate;

  bool get isSubscribed => _isSubscribed;
  String get subscriptionPlan => _subscriptionPlan;
  DateTime? get subscriptionDate => _subscriptionDate;

  void subscribe(String plan) {
    _isSubscribed = true;
    _subscriptionPlan = plan;
    _subscriptionDate = DateTime.now();
    notifyListeners();
  }

  void unsubscribe() {
    _isSubscribed = false;
    _subscriptionPlan = '';
    _subscriptionDate = null;
    notifyListeners();
  }

  // Check if subscription is still valid (for future use)
  bool get isSubscriptionValid {
    if (!_isSubscribed || _subscriptionDate == null) return false;
    
    // For now, we'll consider all subscriptions as valid
    // In a real app, you might check expiration dates here
    return true;
  }
}