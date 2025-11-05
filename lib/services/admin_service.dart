import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user.dart';
import 'notification_service.dart';

class AdminService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Check if current user is admin
  static Future<bool> isCurrentUserAdmin() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return false;

    try {
      final userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      
      if (!userDoc.exists) return false;
      
      final userData = userDoc.data()!;
      return userData['role'] == 'admin';
    } catch (e) {
      return false;
    }
  }

  // Get all pending lawyer verification requests
  static Future<List<User>> getPendingLawyerVerifications() async {
    try {
      // Query for users with pending verification status
      // Note: Users applying to be lawyers might have role 'user' or 'lawyer'
      final querySnapshot = await _firestore
          .collection('users')
          .where('verificationStatus', isEqualTo: 'pending')
          .get();

      // Filter and sort the results in memory
      final users = querySnapshot.docs
          .map((doc) => User.fromFirestore(doc))
          .where((user) => user.verificationStatus == VerificationStatus.pending)
          .toList();
      
      // Sort by createdAt if available, otherwise by name
      users.sort((a, b) {
        if (a.createdAt != null && b.createdAt != null) {
          return b.createdAt!.compareTo(a.createdAt!); // Descending order (newest first)
        }
        return a.name.compareTo(b.name); // Fallback to name sorting
      });
      
      return users;
    } catch (e) {
      throw Exception('Failed to fetch pending verifications: $e');
    }
  }

  // Get all users with their roles
  static Future<List<User>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => User.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  // Get user by ID
  static Future<User?> getUserById(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!doc.exists) return null;
      return User.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  // Approve lawyer verification
  static Future<bool> approveLawyerVerification(String userId) async {
    try {
      // Get user data first for notification
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data() as Map<String, dynamic>;
      final userName = userData['name'] ?? 'User';
      
      await _firestore.collection('users').doc(userId).update({
        'role': UserRole.lawyer.name,
        'verificationStatus': VerificationStatus.approved.name,
        'verifiedAt': FieldValue.serverTimestamp(),
      });
      
      // Send approval notification
      await NotificationService.sendApprovalNotification(userId, userName);
      
      return true;
    } catch (e) {
      print('Error approving lawyer verification: $e');
      return false;
    }
  }

  // Reject lawyer verification
  static Future<bool> rejectLawyerVerification(String userId, String reason) async {
    try {
      // Get user data first for notification
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data() as Map<String, dynamic>;
      final userName = userData['name'] ?? 'User';
      
      await _firestore.collection('users').doc(userId).update({
        'verificationStatus': VerificationStatus.rejected.name,
        'rejectionReason': reason,
        'rejectedAt': FieldValue.serverTimestamp(),
      });
      
      // Send rejection notification
      await NotificationService.sendRejectionNotification(userId, userName, reason);
      
      return true;
    } catch (e) {
      print('Error rejecting lawyer verification: $e');
      return false;
    }
  }

  // Update user role (admin function)
  static Future<void> updateUserRole(String userId, UserRole newRole) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'role': newRole.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update user role: $e');
    }
  }



  // Submit lawyer verification request
  static Future<void> submitLawyerVerification({
    required String firmName,
    required String linkedInUrl,
    required String areaOfPractice,
    required String subcategory,
    required String state,
    required String supremeCourtNumber,
    required int yearOfCall,
    required String nin,
    required List<String> documentUrls,
    String? firstName,
    String? lastName,
    String? phone,
    Uint8List? profileImageBytes,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('User not authenticated');

    try {
      Map<String, dynamic> updateData = {
        'firmName': firmName,
        'linkedInUrl': linkedInUrl,
        'areaOfPractice': areaOfPractice,
        'subcategory': subcategory,
        'state': state,
        'supremeCourtNumber': supremeCourtNumber,
        'yearOfCall': yearOfCall,
        'nin': nin,
        'documents': documentUrls,
        'verificationStatus': 'pending',
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Upload profile image if provided
      if (profileImageBytes != null) {
        try {
          print('DEBUG: Uploading profile image for user: ${currentUser.uid}');
          print('DEBUG: User email: ${currentUser.email}');
          print('DEBUG: User email verified: ${currentUser.emailVerified}');
          print('DEBUG: Upload path: profile_images/${currentUser.uid}');
          
          final ref = _storage.ref().child('profile_images').child(currentUser.uid);
          final uploadTask = ref.putData(profileImageBytes);
          final snapshot = await uploadTask;
          final profileImageUrl = await snapshot.ref.getDownloadURL();
          updateData['profileImageUrl'] = profileImageUrl;
          
          print('DEBUG: Profile image uploaded successfully: $profileImageUrl');
        } catch (e) {
          print('DEBUG: Profile image upload failed: $e');
          throw Exception('Failed to upload profile image: $e');
        }
      }

      // Add optional fields if provided
      if (firstName != null && firstName.isNotEmpty) {
        updateData['firstName'] = firstName;
      }
      if (lastName != null && lastName.isNotEmpty) {
        updateData['lastName'] = lastName;
      }
      if (phone != null && phone.isNotEmpty) {
        updateData['phone'] = phone;
      }

      await _firestore.collection('users').doc(currentUser.uid).update(updateData);
    } catch (e) {
      throw Exception('Failed to submit verification request: $e');
    }
  }

  // Get verification statistics
  static Future<Map<String, int>> getVerificationStats() async {
    try {
      final pendingQuery = await _firestore
          .collection('users')
          .where('verificationStatus', isEqualTo: 'pending')
          .get();

      final approvedQuery = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'lawyer')
          .get();

      final rejectedQuery = await _firestore
          .collection('users')
          .where('verificationStatus', isEqualTo: 'rejected')
          .get();

      final totalUsersQuery = await _firestore
          .collection('users')
          .get();

      return {
        'pending': pendingQuery.docs.length,
        'approved': approvedQuery.docs.length,
        'rejected': rejectedQuery.docs.length,
        'totalUsers': totalUsersQuery.docs.length,
      };
    } catch (e) {
      throw Exception('Failed to fetch statistics: $e');
    }
  }

  // Search users by name or email
  static Future<List<User>> searchUsers(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .orderBy('name')
          .startAt([query])
          .endAt([query + '\uf8ff'])
          .get();

      return querySnapshot.docs
          .map((doc) => User.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }
}