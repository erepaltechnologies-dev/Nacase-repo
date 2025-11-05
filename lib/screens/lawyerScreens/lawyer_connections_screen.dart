import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../../widgets/swipe_to_go_back.dart';
import '../../providers/subscription_provider.dart';
import 'lawyer_premium_screen.dart';
import 'user_detail_screen.dart';
import '../home/chat_screen.dart';

class LawyerConnectionsScreen extends StatefulWidget {
  @override
  _LawyerConnectionsScreenState createState() => _LawyerConnectionsScreenState();
}

class _LawyerConnectionsScreenState extends State<LawyerConnectionsScreen> {
  String selectedFilter = 'All';
  final List<Map<String, dynamic>> declinedRequests = [];
  
  final List<Map<String, dynamic>> connectionRequests = [
    {
      'name': 'Olamide Quoyum',
      'location': 'Abuja, Nigeria',
      'isOnline': true,
      'avatar': 'images/user4_quoyum.jpeg',
      'request': 'I just got arrested for murder and need immediate legal representation.',
    },
    {
      'name': 'Aderomu Gladys',
      'location': 'Agege, Nigeria',
      'isOnline': true,
      'avatar': 'images/user1.jpg',
      'request': 'My landlord is trying to evict me illegally, need help with tenant rights',
    },
    {
      'name': 'Malemi Joy',
      'location': 'Ontairo, Canada',
      'isOnline': true,
      'avatar': 'images/user2.jpg',
      'request': 'Need assistance with immigration papers and work permit application',
    },
    {
      'name': 'Mark Kingsley',
      'location': 'Accra, Ghana',
      'isOnline': true,
      'avatar': 'images/user3.jpg',
      'request': 'Divorce proceedings and child custody dispute, need family law expert',
    },
  ];

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back icon left, title centered
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const Text(
                        'Connections',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  
                  // Filter Buttons
                  Row(
                    children: [
                      _buildFilterButton('${connectionRequests.length} All', 'All'),
                      SizedBox(width: 8),
                      _buildFilterButton('8 New', 'New'),
                      //leave for future updates
                      // SizedBox(width: 8),
                      // _buildFilterButton('15 Nearby', 'Nearby'),
                      SizedBox(width: 8),
                      _buildFilterButton('${declinedRequests.length} Declined', 'Declined'),
                    ],
                  ),
                ],
              ),
            ),
            
            // Connections List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: (selectedFilter == 'Declined' ? declinedRequests : connectionRequests).length,
                itemBuilder: (context, index) {
                  final displayList = selectedFilter == 'Declined' ? declinedRequests : connectionRequests;
                  final connection = displayList[index];
                  return _buildConnectionCard(connection);
                },
              ),
            ),
            
            // Bottom Button (hidden when subscribed)
            Consumer<SubscriptionProvider>(
              builder: (context, subscriptionProvider, child) {
                if (subscriptionProvider.isSubscribed) {
                  return SizedBox.shrink();
                }
                return Container(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LawyerPremiumScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'See who contacted you',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String text, String filter) {
    bool isSelected = selectedFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = filter;
        });
        final isSubscribed = Provider.of<SubscriptionProvider>(context, listen: false).isSubscribed;
        if (!isSubscribed) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LawyerPremiumScreen(),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey[300]!,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
//Cards
  Widget _buildConnectionCard(Map<String, dynamic> connection) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, child) {
        bool isSubscribed = subscriptionProvider.isSubscribed;
        
        return GestureDetector(
          onTap: () {
            if (isSubscribed) {
              // Navigate to user detail screen if subscribed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetailScreen(userInfo: connection),
                ),
              ).then((result) {
                if (result is Map && result['action'] == 'decline') {
                  setState(() {
                    connectionRequests.removeWhere((u) => u['name'] == result['user']['name'] && u['avatar'] == result['user']['avatar']);
                    declinedRequests.add(result['user']);
                  });
                }
              });
            } else {
              // Show premium screen if not subscribed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LawyerPremiumScreen(),
                ),
              );
            }
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Profile Image (Blurred)
                Stack(
                  children: [
                    ClipOval(
                      child: isSubscribed
                          ? CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(connection['avatar']),
                            )
                          : ImageFiltered(
                              imageFilter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(connection['avatar']),
                              ),
                            ),
                    ),
                    if (connection['isOnline'])
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 16),
                
                // Name and Location
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Blurred Name
                          isSubscribed
                              ? Text(
                                  connection['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                )
                              : ImageFiltered(
                                  imageFilter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                                  child: Text(
                                    connection['name'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                          SizedBox(width: 8),
                        ],
                      ),
                      SizedBox(height: 4),
                      // Blurred Request Message
                      isSubscribed
                          ? Text(
                              connection['request'],
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                          : ImageFiltered(
                              imageFilter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                              child: Text(
                                connection['request'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Text(
                            connection['location'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Removed card-level action buttons (Accept/Decline)
              ],
            ),
          ),
        );
      },
    );
  }
}