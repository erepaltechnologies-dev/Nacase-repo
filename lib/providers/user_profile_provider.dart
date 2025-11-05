import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';

class UserProfileProvider extends ChangeNotifier {
  String _userName = '';
  String _userEmail = '';
  String _userPhone = '+234 800 000 0000';
  String _userBio = 'Legal enthusiast using Nacase for quick advice.';
  Uint8List? _profileImageBytes;
  String _defaultImagePath = 'images/app_icons/user.png';
  String? _profileImageUrl;
  bool _notificationsEnabled = true;
  bool _isLoading = false;

  // Firebase instances
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getters
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  String get userBio => _userBio;
  Uint8List? get profileImageBytes => _profileImageBytes;
  String get defaultImagePath => _defaultImagePath;
  String? get profileImageUrl => _profileImageUrl;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get isLoading => _isLoading;

  // Check if user has a custom profile image
  bool get hasCustomImage => _profileImageBytes != null;

  UserProfileProvider() {
    _initializeUserData();
  }

  void _initializeUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userName = (user.displayName ?? '').trim();
      _userEmail = (user.email ?? '').trim();
      
      // Load additional profile data from Firestore
      await _loadProfileFromFirestore(user.uid);
      notifyListeners();
    }
  }

  Future<void> _loadProfileFromFirestore(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data()!;
        // Update name and email from Firestore if available
        _userName = data['name'] ?? _userName;
        _userEmail = data['email'] ?? _userEmail;
        _userPhone = data['phone'] ?? _userPhone;
        _userBio = data['bio'] ?? _userBio;
        _profileImageUrl = data['profileImageUrl'];
        _notificationsEnabled = data['notificationsEnabled'] ?? true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading profile from Firestore: $e');
      }
    }
  }

  // Upload profile image to Firebase Storage
  Future<String?> _uploadProfileImage(Uint8List imageBytes, String userId) async {
    try {
      final ref = _storage.ref().child('profile_images').child(userId);
      final uploadTask = ref.putData(imageBytes);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading profile image: $e');
      }
      return null;
    }
  }

  // Update profile image
  void updateProfileImage(Uint8List? imageBytes) {
    _profileImageBytes = imageBytes;
    notifyListeners();
  }

  // Update user name
  void updateUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  // Update user email
  void updateUserEmail(String email) {
    _userEmail = email;
    notifyListeners();
  }

  // Update user phone
  void updateUserPhone(String phone) {
    _userPhone = phone;
    notifyListeners();
  }

  // Update user bio
  void updateUserBio(String bio) {
    _userBio = bio;
    notifyListeners();
  }

  // Update notifications setting
  void updateNotifications(bool enabled) {
    _notificationsEnabled = enabled;
    notifyListeners();
  }

  // Save all profile data to Firebase
  Future<bool> saveProfile({
    String? name,
    String? phone,
    String? bio,
    bool? notifications,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      // Update local state
      if (name != null) _userName = name;
      // Email is not updatable after registration
      if (phone != null) _userPhone = phone;
      if (bio != null) _userBio = bio;
      if (notifications != null) _notificationsEnabled = notifications;

      // Upload profile image if there's a new one
      String? imageUrl = _profileImageUrl;
      if (_profileImageBytes != null) {
        imageUrl = await _uploadProfileImage(_profileImageBytes!, user.uid);
        if (imageUrl != null) {
          _profileImageUrl = imageUrl;
          _profileImageBytes = null; // Clear bytes after successful upload
        }
      }

      // Save to Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'name': _userName,
        'email': _userEmail,
        'phone': _userPhone,
        'bio': _userBio,
        'profileImageUrl': imageUrl,
        'notificationsEnabled': _notificationsEnabled,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving profile: $e');
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear profile image
  void clearProfileImage() {
    _profileImageBytes = null;
    notifyListeners();
  }

  // Refresh user data from Firebase
  Future<void> refreshUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userName = (user.displayName ?? '').trim();
      _userEmail = (user.email ?? '').trim();
      
      // Load additional profile data from Firestore
      await _loadProfileFromFirestore(user.uid);
      notifyListeners();
    }
  }

  // Reset to default values
  void resetProfile() {
    final user = FirebaseAuth.instance.currentUser;
    _userName = (user?.displayName ?? '').trim();
    _userEmail = (user?.email ?? '').trim();
    _userPhone = '08000000000';
    _userBio = 'Legal enthusiast using Nacase for quick advice.';
    _profileImageBytes = null;
    _notificationsEnabled = true;
    notifyListeners();
  }
}