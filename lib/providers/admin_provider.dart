import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/admin_service.dart';

class AdminProvider extends ChangeNotifier {
  List<User> _pendingVerifications = [];
  List<User> _allUsers = [];
  Map<String, int> _stats = {};
  bool _isLoading = false;
  String? _error;
  bool _isAdmin = false;

  // Getters
  List<User> get pendingVerifications => _pendingVerifications;
  List<User> get allUsers => _allUsers;
  Map<String, int> get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAdmin => _isAdmin;

  // Check if current user is admin
  Future<void> checkAdminStatus() async {
    try {
      _isAdmin = await AdminService.isCurrentUserAdmin();
      notifyListeners();
    } catch (e) {
      _isAdmin = false;
      notifyListeners();
    }
  }

  // Load pending lawyer verifications
  Future<void> loadPendingVerifications() async {
    _setLoading(true);
    try {
      _pendingVerifications = await AdminService.getPendingLawyerVerifications();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _pendingVerifications = [];
    } finally {
      _setLoading(false);
    }
  }

  // Load all users
  Future<void> loadAllUsers() async {
    _setLoading(true);
    try {
      _allUsers = await AdminService.getAllUsers();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _allUsers = [];
    } finally {
      _setLoading(false);
    }
  }

  // Load statistics
  Future<void> loadStats() async {
    try {
      _stats = await AdminService.getVerificationStats();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _stats = {};
      notifyListeners();
    }
  }

  // Approve lawyer verification
  Future<bool> approveLawyerVerification(String userId) async {
    try {
      await AdminService.approveLawyerVerification(userId);
      
      // Remove from pending list and update stats
      _pendingVerifications.removeWhere((user) => user.id == userId);
      await loadStats();
      
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Reject lawyer verification
  Future<bool> rejectLawyerVerification(String userId, String reason) async {
    try {
      await AdminService.rejectLawyerVerification(userId, reason);
      
      // Remove from pending list and update stats
      _pendingVerifications.removeWhere((user) => user.id == userId);
      await loadStats();
      
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update user role
  Future<bool> updateUserRole(String userId, UserRole newRole) async {
    try {
      await AdminService.updateUserRole(userId, newRole);
      
      // Update local user list
      final userIndex = _allUsers.indexWhere((user) => user.id == userId);
      if (userIndex != -1) {
        _allUsers[userIndex] = _allUsers[userIndex].copyWith(
          role: newRole,
          updatedAt: DateTime.now(),
        );
      }
      
      await loadStats();
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Get user by ID
  Future<User?> getUserById(String userId) async {
    try {
      return await AdminService.getUserById(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Search users
  Future<List<User>> searchUsers(String query) async {
    try {
      return await AdminService.searchUsers(query);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  // Refresh all data
  Future<void> refreshData() async {
    await Future.wait([
      loadPendingVerifications(),
      loadAllUsers(),
      loadStats(),
    ]);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Filter methods for different user types
  List<User> get verifiedLawyers => _allUsers.where((user) => user.isLawyer).toList();
  List<User> get regularUsers => _allUsers.where((user) => user.isUser).toList();
  List<User> get adminUsers => _allUsers.where((user) => user.isAdmin).toList();
  List<User> get rejectedApplications => _allUsers.where((user) => user.isRejected).toList();
}