import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/user_home_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/lawyerScreens/lawyer_home_screen.dart';
import '../models/user.dart' as UserModel;

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading indicator while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
          );
        }
        
        // Check if user is logged in and email is verified
        if (snapshot.hasData && snapshot.data!.emailVerified) {
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!.uid)
                .snapshots(),
            builder: (context, userSnapshot) {
              // Show loading while listening to user doc
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                );
              }
              
              if (userSnapshot.hasError) {
                return const Scaffold(
                  body: Center(child: Text('Error loading user data')),
                );
              }
              
              // Check if user document exists and has role data
              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                final userRole = userData['role'] as String?;
                
                // Route based on user role
                if (userRole == 'admin') {
                  return const AdminDashboardScreen();
                } else if (userRole == 'lawyer') {
                  return const LawyerHomeScreen();
                }
              }
              
              // Default to regular user home screen
              return UserHomeScreen();
            },
          );

        }
        
        // User is not logged in or email not verified
        return const LoginScreen();
      },
    );
  }
}