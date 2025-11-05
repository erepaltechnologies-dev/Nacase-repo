import 'package:flutter/material.dart';
import '/models/lawyer.dart';
import '/widgets/lawyer_card.dart';
import '/widgets/question_bubble.dart';
import '/screens/home/list_lawyer_screen.dart';

class HomeContent extends StatelessWidget {
  final List<String> commonQuestions;
  final TextEditingController searchController;
  final VoidCallback onMenuPressed;
  
  const HomeContent({
    Key? key,
    required this.commonQuestions,
    required this.searchController,
    required this.onMenuPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Builder(
            builder: (context) => Row(
              children: [
                IconButton(
                  icon: Icon(Icons.menu, size: 28),
                  onPressed: onMenuPressed,
                ),
                Spacer(),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.green, size: 26),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Search for lawyers',
                      hintStyle: TextStyle(fontSize: 15, color: Colors.grey[600]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Icon(Icons.tune, color: Colors.green, size: 22),
              ],
            ),
          ),
          SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lawyers on Probono',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListLawyerScreen(searchQuery: 'Probono'),
                    ),
                  );
                },
                child: Text('View all', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: lawyers.length,
              itemBuilder: (context, index) {
                return LawyerCard(lawyer: lawyers[index]);
              },
            ),
          ),
          SizedBox(height: 18),
          Container(
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.13),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...commonQuestions.map((q) => QuestionBubble(question: q)).toList(),
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 1.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Not sure what you need a lawyer for? Ask @dlaw',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}