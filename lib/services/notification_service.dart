import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a notification for a user
  static Future<bool> createNotification({
    required String userId,
    required String title,
    required String message,
    required String type, // 'approval', 'rejection', 'info', etc.
    Map<String, dynamic>? data,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': userId,
        'title': title,
        'message': message,
        'type': type,
        'data': data ?? {},
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error creating notification: $e');
      return false;
    }
  }

  // Send lawyer verification approval notification
  static Future<bool> sendApprovalNotification(String userId, String userName) async {
    return await createNotification(
      userId: userId,
      title: 'Verification Approved! 🎉',
      message: 'Congratulations $userName! Your lawyer verification has been approved. You can now access all lawyer features.',
      type: 'approval',
      data: {
        'action': 'lawyer_verification_approved',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // Send lawyer verification rejection notification
  static Future<bool> sendRejectionNotification(
    String userId, 
    String userName, 
    String reason,
  ) async {
    return await createNotification(
      userId: userId,
      title: 'Verification Update',
      message: 'Hi $userName, your lawyer verification application needs attention. Reason: $reason. Please review and resubmit if necessary.',
      type: 'rejection',
      data: {
        'action': 'lawyer_verification_rejected',
        'reason': reason,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // Send role change notification
  static Future<bool> sendRoleChangeNotification(
    String userId, 
    String userName, 
    String newRole,
  ) async {
    return await createNotification(
      userId: userId,
      title: 'Account Role Updated',
      message: 'Hi $userName, your account role has been updated to $newRole.',
      type: 'info',
      data: {
        'action': 'role_changed',
        'newRole': newRole,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // Get notifications for a user
  static Stream<QuerySnapshot> getUserNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Mark notification as read
  static Future<bool> markAsRead(String notificationId) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
      return true;
    } catch (e) {
      print('Error marking notification as read: $e');
      return false;
    }
  }

  // Mark all notifications as read for a user
  static Future<bool> markAllAsRead(String userId) async {
    try {
      final batch = _firestore.batch();
      final notifications = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      for (final doc in notifications.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
      return true;
    } catch (e) {
      print('Error marking all notifications as read: $e');
      return false;
    }
  }

  // Delete a notification
  static Future<bool> deleteNotification(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).delete();
      return true;
    } catch (e) {
      print('Error deleting notification: $e');
      return false;
    }
  }

  // Get unread notification count for a user
  static Stream<int> getUnreadCount(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Clean up old notifications (older than 30 days)
  static Future<bool> cleanupOldNotifications() async {
    try {
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      final oldNotifications = await _firestore
          .collection('notifications')
          .where('createdAt', isLessThan: Timestamp.fromDate(thirtyDaysAgo))
          .get();

      final batch = _firestore.batch();
      for (final doc in oldNotifications.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      return true;
    } catch (e) {
      print('Error cleaning up old notifications: $e');
      return false;
    }
  }
}