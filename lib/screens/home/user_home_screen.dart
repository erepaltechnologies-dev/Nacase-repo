import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/screens/home/messages_screen.dart';
import '/screens/home/drawer_chat_screen.dart';
import '/screens/home/user_profile_screen.dart';
import '/screens/home/list_lawyer_screen.dart' as list_lawyer;
import '/screens/home/lawyer_detail_screen.dart';
import '/models/lawyer.dart';
import '/models/practice_areas.dart';
import '/screens/home/home_content.dart';
import '/screens/home/messages_screen.dart';
import '/screens/home/ai_chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Filter button removed from Home; import no longer needed

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedAreaOfLaw;
  int _currentIndex = 0;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _rotationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }
  
  // Using centralized lawyer data from models/lawyer.dart

  




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0 ? AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'NACASE',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: const [],
      ) : null,
      drawer: _currentIndex == 0 ? DrawerChatScreen(
        chats: [],
        userName: (() {
          final user = FirebaseAuth.instance.currentUser;
          return user?.displayName?.trim().isNotEmpty == true
              ? user!.displayName!
              : (user?.email ?? 'User');
        })(),
        userImage: 'images/user1.jpg',
      ) : null,
      body: _currentIndex == 0 ? _buildHomeScreen() : MessagesScreen(),
      floatingActionButton: _currentIndex == 0 ? AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AIChatScreen()),
                );
              },
              backgroundColor: Colors.green,
              icon: AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value * 2 * 3.14159,
                    child: Icon(Icons.smart_toy, color: Colors.white),
                  );
                },
              ),
              label: Text(
                'Ask Nacase AI about your rights',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          );
        },
      ) : null,
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height < 600 ? 70 : 77,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                icon: FontAwesomeIcons.house,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                icon: FontAwesomeIcons.message,
                label: 'Messages',
                index: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeScreen() {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Spotlight Lawyers ⭐', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => list_lawyer.ListLawyerScreen(searchQuery: ''),
                      ),
                    );
                  },
                  child: Text('View All Lawyers', style: TextStyle(color: Colors.black54)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
                children: List.generate(spotlightLawyers.length, (index) {
                   final lawyer = spotlightLawyers[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LawyerDetailScreen(lawyer: lawyer),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundImage: AssetImage(lawyer.image),
                              radius: 22,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(lawyer.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                Text(lawyer.practiceAreasDisplay, style: TextStyle(fontSize: 12, color: Colors.black54)),
                                Row(
                                  children: [
                                    Icon(Icons.circle, color: Colors.green, size: 8),
                                    SizedBox(width: 4),
                                    Text('Online', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                    SizedBox(width: 8),
                                    Icon(Icons.location_on, color: Colors.black38, size: 10),
                                    Text(lawyer.location, style: TextStyle(fontSize: 10, color: Colors.black38)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ),
          ),


          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool isSelected = _currentIndex == index;
    bool isSmallScreen = MediaQuery.of(context).size.height < 600;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? (isSmallScreen ? 16 : 20) : (isSmallScreen ? 12 : 16),
          vertical: isSmallScreen ? 8 : 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              child: FaIcon(
                icon,
                color: isSelected ? Colors.green : Colors.grey[600],
                size: isSelected ? (isSmallScreen ? 20 : 24) : (isSmallScreen ? 18 : 22),
              ),
            ),
            SizedBox(height: isSmallScreen ? 2 : 4),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 300),
              style: TextStyle(
                color: isSelected ? Colors.green : Colors.grey[600],
                fontSize: isSelected ? (isSmallScreen ? 10 : 12) : (isSmallScreen ? 9 : 11),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
