import 'package:flutter/material.dart';
import '../../models/practice_areas.dart';
import '../../models/filter_criteria.dart';
import '../../widgets/custom_dropdowns.dart';

class FilterScreen extends StatefulWidget {
  final FilterCriteria? initialCriteria;
  final void Function(FilterCriteria)? onApply;
  final void Function()? onCancel;
  const FilterScreen({Key? key, this.initialCriteria, this.onApply, this.onCancel}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? _selectedLocation;
  int _selectedRating = 5;
  String? _selectedPractice;

  @override
  void initState() {
    super.initState();
    // Initialize with existing criteria or defaults
    if (widget.initialCriteria != null) {
      _selectedLocation = widget.initialCriteria!.location;
      _selectedRating = widget.initialCriteria!.minRating ?? 5;
      _selectedPractice = widget.initialCriteria!.practiceArea;
    }
  }

  void _applyFilters() {
    final criteria = FilterCriteria(
      location: _selectedLocation,
      minRating: _selectedRating,
      practiceArea: _selectedPractice,
    );
    
    if (widget.onApply != null) {
      widget.onApply!(criteria);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: widget.onCancel ?? () => Navigator.pop(context),
                      child: Text('Cancel', style: TextStyle(color: Colors.blueGrey, fontSize: 18, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Column(
                      children: [
                        Text('Filters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                        SizedBox(height: 4),
                        Container(
                          width: 48,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: _applyFilters,
                      child: Text('Apply', style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text('Location', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
              SizedBox(height: 8),
              NigerianStatesDropdown(
                selectedState: _selectedLocation,
                onChanged: (v) => setState(() => _selectedLocation = v),
                hintText: 'Select state',
              ),
              SizedBox(height: 18),
              Text('Ratings', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var rating in [5, 4, 3, 2, 1])
                    ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.black, size: 18),
                          SizedBox(width: 2),
                          Text('${rating}+'),
                        ],
                      ),
                      selected: _selectedRating == rating,
                      selectedColor: Colors.green,
                      backgroundColor: Colors.grey.shade200,
                      labelStyle: TextStyle(color: _selectedRating == rating ? Colors.white : Colors.black),
                      onSelected: (_) => setState(() => _selectedRating = rating),
                    ),
                ],
              ),
              SizedBox(height: 18),
              Text('Area of practice', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
              SizedBox(height: 8),
              PracticeAreasDropdown(
                selectedPracticeArea: _selectedPractice,
                onChanged: (v) => setState(() => _selectedPractice = v),
                hintText: 'Select area of law',
              ),
            ],
          ),
        ),
      ),
    );
  }
}