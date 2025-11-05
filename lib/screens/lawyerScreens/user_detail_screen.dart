import 'package:flutter/material.dart';
import '../../widgets/swipe_to_go_back.dart';
import '../home/chat_screen.dart';

class UserDetailScreen extends StatelessWidget {
  final Map<String, dynamic> userInfo;

  const UserDetailScreen({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SwipeToGoBack(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.fromLTRB(16, 60, 16, 20),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Back button and title
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                      ),
                      Expanded(
                        child: Text(
                          'Client Case Overview',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 48), // Balance the back button
                    ],
                  ),
                  SizedBox(height: 20),
                  
                  // Profile Image and Basic Info
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(userInfo['avatar']),
                      ),
                      if (userInfo['isOnline'])
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 16),
                  
                  Text(
                    userInfo['name'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        userInfo['location'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Content Section
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Reason for Contact Section
                    _buildSection(
                      'Reason for Contact',
                      userInfo['request'],
                      Icons.message,
                    ),
                    SizedBox(height: 24),
                    
                    // Contact Information Section
                    _buildSection(
                      'Contact Information',
                      userInfo['email'] ?? 'user@example.com',
                      Icons.email,
                    ),
                    SizedBox(height: 16),
                    
                    _buildSection(
                      'Phone Number',
                      userInfo['phone'] ?? '+234 123 456 7890',
                      Icons.phone,
                    ),
                    SizedBox(height: 24),
                    
                    // Case Details Section
                    _buildSection(
                      'Case Type',
                      userInfo['caseType'] ?? 'Criminal Law',
                      Icons.gavel,
                    ),
                    SizedBox(height: 16),
                    
                    //Will be added in future update
                    // _buildSection(
                    //   'Urgency Level',
                    //   userInfo['urgency'] ?? 'High',
                    //   Icons.priority_high,
                    // ),
                    // SizedBox(height: 16),
                    
                    // _buildSection(
                    //   'Preferred Meeting',
                    //   userInfo['meetingPreference'] ?? 'In-person consultation',
                    //   Icons.meeting_room,
                    // ),
                    // SizedBox(height: 32),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Open chat screen with the client after accepting
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    lawyerName: userInfo['name'],
                                    lawyerImage: userInfo['avatar'],
                                    viewerIsLawyer: true,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.check, color: Colors.white),
                            label: Text('Accept and Contact'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Return decline result to previous screen to update lists
                              Navigator.of(context).pop({
                                'action': 'decline',
                                'user': userInfo,
                              });
                            },
                            icon: Icon(Icons.close, color: Colors.white),
                            label: Text('Decline'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Removed Contact User button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.green),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _showActionDialog(BuildContext context, String action, String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$action Case'),
          content: Text('Are you sure you want to $action the case from $userName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Case ${action.toLowerCase()}ed successfully!'),
                    backgroundColor: action == 'Accept' ? Colors.green : Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: action == 'Accept' ? Colors.green : Colors.red,
              ),
              child: Text(action, style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showContactDialog(BuildContext context, String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact $userName'),
          content: Text('Choose how you would like to contact $userName:'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opening chat with $userName...'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('Chat'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Calling $userName...'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              child: Text('Call'),
            ),
          ],
        );
      },
    );
  }
}