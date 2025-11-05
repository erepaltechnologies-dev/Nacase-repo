import 'package:flutter/material.dart';
import '/screens/home/chat_screen.dart';
import '/widgets/lawyer_card.dart';
import '/screens/home/lawyer_detail_screen.dart';
import '/models/lawyer.dart';
import '/models/practice_areas.dart';
import '/models/filter_criteria.dart';
import '/screens/home/filter_screen.dart';

class ListLawyerScreen extends StatefulWidget {
  final String searchQuery;

  ListLawyerScreen({required this.searchQuery});

  @override
  _ListLawyerScreenState createState() => _ListLawyerScreenState();
}

// Removed local Lawyer class - using the main Lawyer model from models/lawyer.dart

class _ListLawyerScreenState extends State<ListLawyerScreen> {
  // Using centralized lawyer data from models/lawyer.dart
  List<Lawyer> allLawyers = lawyers;
  List<Lawyer> filteredLawyers = [];
  FilterCriteria? currentFilter;

  @override
  void initState() {
    super.initState();
    filteredLawyers = List.from(allLawyers);
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => FilterScreen(
        initialCriteria: currentFilter,
        onApply: (FilterCriteria criteria) {
          setState(() {
            currentFilter = criteria;
            _applyFilters();
          });
        },
      ),
    );
  }

  void _applyFilters() {
    if (currentFilter == null || !currentFilter!.hasFilters) {
      filteredLawyers = List.from(allLawyers);
      return;
    }

    filteredLawyers = allLawyers.where((lawyer) {
      // Filter by practice area
      if (currentFilter!.practiceArea != null && 
          currentFilter!.practiceArea!.isNotEmpty) {
        bool hasMatchingArea = lawyer.practiceAreas.any((area) => 
          area.toLowerCase().contains(currentFilter!.practiceArea!.toLowerCase()));
        if (!hasMatchingArea) return false;
      }

      // Filter by rating
      if (currentFilter!.minRating != null) {
        if (lawyer.rating < currentFilter!.minRating!) return false;
      }

      // Filter by location
      if (currentFilter!.location != null && 
          currentFilter!.location!.isNotEmpty) {
        if (!lawyer.location.toLowerCase().contains(currentFilter!.location!.toLowerCase())) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'NACASE',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.green),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with filter status
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentFilter = null;
                      filteredLawyers = List.from(allLawyers);
                    });
                  },
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  currentFilter != null && currentFilter!.hasFilters
                      ? 'Showing ${filteredLawyers.length} Filtered Lawyers'
                      : 'Showing All Lawyers',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Lawyers Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: filteredLawyers.length,
                itemBuilder: (context, index) {
                   final lawyer = filteredLawyers[index];
                   return GestureDetector(
                     onTap: () {
                       // Navigate directly with the lawyer object
                       // since we're now using the same Lawyer model
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
                         boxShadow: [
                           BoxShadow(
                             color: Colors.black.withOpacity(0.1),
                             blurRadius: 8,
                             offset: const Offset(0, 2),
                           ),
                         ],
                       ),
                       child: Padding(
                         padding: const EdgeInsets.all(12),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             // Lawyer Image
                             // Container(
                             //   width: 80,
                             //   height: 80,
                             //   decoration: BoxDecoration(
                             //     borderRadius: BorderRadius.circular(8),
                             //     image: DecorationImage(
                             //       image: AssetImage(lawyer.image),
                             //       fit: BoxFit.cover,
                             //     ),
                             //   ),
                             // ),
                             CircleAvatar(
                               radius: 40,
                               backgroundImage: AssetImage(lawyer.image),
                             ),
                             const SizedBox(height: 12),
                             // Lawyer Name
                             Text(
                               lawyer.name,
                               style: const TextStyle(
                                 fontSize: 16,
                                 fontWeight: FontWeight.bold,
                                 color: Colors.black,
                               ),
                               maxLines: 1,
                               overflow: TextOverflow.ellipsis,
                               textAlign: TextAlign.center,
                             ),
                             const SizedBox(height: 4),
                             // Practice Areas
                             Text(
                               lawyer.practiceAreasDisplay,
                               style: const TextStyle(
                                 fontSize: 12,
                                 color: Colors.black54,
                               ),
                               maxLines: 1,
                               overflow: TextOverflow.ellipsis,
                               textAlign: TextAlign.center,
                             ),
                             const SizedBox(height: 8),
                             // Status and Location
                             Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 // Online Status
                                 Container(
                                 width: 8,
                                 height: 8,
                                 decoration: BoxDecoration(
                                   color: Colors.green, // Always show as online for now
                                   shape: BoxShape.circle,
                                 ),
                               ),
                               const SizedBox(width: 4),
                               Text(
                                 'Online', // Always show as online for now
                                   style: TextStyle(
                                     fontSize: 10,
                                     color: Colors.green,
                                   ),
                                 ),
                                 const SizedBox(width: 8),
                                 // Location
                                 const Icon(
                                   Icons.location_on,
                                   size: 10,
                                   color: Colors.black38,
                                 ),
                                 const SizedBox(width: 2),
                                 Flexible(
                                   child: Text(
                                     lawyer.location,
                                     style: const TextStyle(
                                       fontSize: 10,
                                       color: Colors.black38,
                                     ),
                                     maxLines: 1,
                                     overflow: TextOverflow.ellipsis,
                                   ),
                                 ),
                               ],
                             ),
                           ],
                         ),
                       ),
                     ),
                   );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}