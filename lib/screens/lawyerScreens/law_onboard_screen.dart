import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'information_request_screen.dart';
import 'verification_pending_screen.dart';
import 'lawyer_home_screen.dart';
import '../../models/user.dart' as UserModel;

class LawOnboardScreen extends StatefulWidget {
  const LawOnboardScreen({Key? key}) : super(key: key);

  @override
  State<LawOnboardScreen> createState() => _LawOnboardScreenState();
}

class _LawOnboardScreenState extends State<LawOnboardScreen> {
  bool _isLoading = false;

  Future<void> _checkVerificationStatusAndNavigate() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to continue')),
        );
        return;
      }

      // Get user document from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        // User document doesn't exist, allow access to application form
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InformationRequestScreen(),
          ),
        );
        return;
      }

      final userData = userDoc.data()!;
      final verificationStatus = userData['verificationStatus'] as String?;

      if (verificationStatus == 'pending') {
        // User has pending verification, redirect to pending screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationPendingScreen(),
          ),
        );
      } else if (verificationStatus == 'rejected') {
        // User application was rejected, allow access to reapply
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InformationRequestScreen(),
          ),
        );
      } else if (verificationStatus == 'approved') {
        // User is approved lawyer, redirect to lawyer home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LawyerHomeScreen(),
          ),
        );
      } else {
        // User has no verification status, allow access to application form
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InformationRequestScreen(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking verification status: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/app_icons/onboard.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          // Dark overlay
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Main content area
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Connect section
                        Text(
                          'Connect',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        Text(
                          'Get access to Millions of people\nin need of Legal Assistance world wide\nin just a click!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Action buttons
                  Column(
                    children: [
                      // Next button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _checkVerificationStatusAndNavigate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Checking...',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Next',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Go back button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green[600],
                            side: BorderSide(color: Colors.green[600]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Go back',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}