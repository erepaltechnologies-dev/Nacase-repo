import 'package:flutter/material.dart';
import 'lawyer_connections_screen.dart';
import 'lawyer_premium_screen.dart';
import '../../widgets/swipe_to_go_back.dart';
import '../home/messages_screen.dart';

class LawyerHomeScreen extends StatefulWidget {
  const LawyerHomeScreen({Key? key}) : super(key: key);

  @override
  State<LawyerHomeScreen> createState() => _LawyerHomeScreenState();
}

class _LawyerHomeScreenState extends State<LawyerHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;
  bool _isFabExpanded = false;
  bool _isFabPressed = false;

  final List<String> legalQuestions = [
    'How do I challenge unlawful detention?',
    'How do I challenge land grabbing legally?',
    'What rights do employees have if unfairly dismissed in Nigeria?',
    'What are the implications of impersonation in Nigeria?',
    'What is the penalty for cybercrime under Nigerian law?',
    'How do I file Legal Proceedings at the Supreme Courts',
    'What are the legal requirements for terminating a contract of employment?',
    'What are the legal implications of self-defense in a murder charge?',
    'What rights do women have in inheritance matters under Nigerian law?',
    'What are the procedures for registering a business in Nigeria?',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'NACASE AI',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: SwipeToGoBack(
        child: Stack(
        children: [
          _buildCurrentScreen(),
          Positioned(
            right: 16,
            bottom: 130, // Adjust this value to move the button higher (smaller number) or lower (larger number)
            child: GestureDetector(
              onTapDown: (_) {
                setState(() {
                  _isFabPressed = true;
                });
              },
              onTapUp: (_) {
                setState(() {
                  _isFabPressed = false;
                });
              },
              onTapCancel: () {
                setState(() {
                  _isFabPressed = false;
                });
              },
              onTap: () {
                if (_isFabExpanded) {
                  _showSearchDialog();
                } else {
                  setState(() {
                    _isFabExpanded = true;
                  });
                  // Auto-collapse after 3 seconds
                  Future.delayed(Duration(seconds: 3), () {
                    if (mounted) {
                      setState(() {
                        _isFabExpanded = false;
                      });
                    }
                  });
                }
              },
              child: Transform.scale(
                scale: _isFabPressed ? 0.95 : 1.0,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: 56,
                  width: _isFabExpanded ? 180 : 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[400]!, Colors.green[700]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.search_rounded,
                        color: Colors.white,
                        size: 22,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    if (_isFabExpanded) ...[
                      SizedBox(width: 12),
                      Text(
                        'Search for Lawyer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                ),
              ),
            ),
          ),
        ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildLawyerHomeContent();
      case 1:
        return LawyerConnectionsScreen();
      case 2:
        return LawyerPremiumScreen();
      default:
        return _buildLawyerHomeContent();
    }
  }

  Widget _buildLawyerHomeContent() {
    return Column(
      children: [
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header text
                Text(
                  'Get legal advice, do in-depth legal research, predict case outcomes, get instantly access to laws, cases, and legal judgements - all in one place',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Legal questions wrap
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: legalQuestions.map((question) => _buildQuestionButton(question)).toList(),
                ),
                
                const SizedBox(height: 100), // Extra space to prevent content from being hidden behind the chat input
              ],
            ),
          ),
        ),
        
        // Fixed AI chat input at bottom
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: _buildSimpleTextInput(),
        ),
      ],
    );
  }

  Widget _buildQuestionButton(String title) {
    return IntrinsicWidth(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              // Handle question tap - could navigate to AI chat or detailed view
              _handleQuestionTap(title);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
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
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 1) {
              // Navigate to Connections screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LawyerConnectionsScreen(),
                ),
              );
            } else if (index == 2) {
              // Navigate to Messages screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessagesScreen(),
                ),
              );
            } else {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          backgroundColor: Colors.white,
          selectedItemColor: Colors.green[600],
          unselectedItemColor: Colors.grey[400],
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Lawyer Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Connections',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined),
              activeIcon: Icon(Icons.message),
              label: 'Messages',
            ),
          ],
        ),
      ),
    );
  }

  void _handleQuestionTap(String question) {
    // Show a dialog or navigate to AI chat with the question
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Legal Question'),
        content: Text('You selected: $question\n\nThis would typically open the AI chat interface with this question pre-filled.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }





  Widget _buildSimpleTextInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Let NACASE AI help you with your researches',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.green[600],
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              onPressed: () {
                // Handle send action
              },
              icon: Icon(Icons.send, color: Colors.white, size: 20),
              padding: EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }



  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Search for Lawyers',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Enter lawyer name, specialization, or location',
                    prefixIcon: Icon(Icons.search, color: Colors.green[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green[600]!, width: 2),
                    ),
                  ),
                  autofocus: true,
                  onSubmitted: (value) {
                    Navigator.of(context).pop();
                    _performSearch();
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performSearch();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void _performSearch() {
    String searchQuery = _searchController.text.trim();
    if (searchQuery.isNotEmpty) {
      // Show search results or navigate to search results screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Searching for: "$searchQuery"'),
          backgroundColor: Colors.green[600],
          action: SnackBarAction(
            label: 'View Results',
            textColor: Colors.white,
            onPressed: () {
              // Navigate to search results screen
            },
          ),
        ),
      );
      _searchController.clear();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}