import 'package:flutter/material.dart';
import '../models/nigerian_states.dart';
import '../models/practice_areas.dart';

class CustomDropdowns {
  // Standard decoration for all dropdowns
  static InputDecoration _getDropdownDecoration({
    required String hintText,
    String? labelText,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
  }

  // Standard text style for dropdown items
  static const TextStyle _dropdownTextStyle = TextStyle(
    fontSize: 16.0,
    color: Colors.black87,
  );

  // Standard text style for hint text
  static TextStyle _hintTextStyle = TextStyle(
    fontSize: 16.0,
    color: Colors.grey.shade600,
  );
}

/// Reusable Nigerian States Dropdown Widget
class NigerianStatesDropdown extends StatelessWidget {
  final String? selectedState;
  final ValueChanged<String?> onChanged;
  final String hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final bool isRequired;

  const NigerianStatesDropdown({
    Key? key,
    required this.selectedState,
    required this.onChanged,
    this.hintText = 'Select State',
    this.labelText,
    this.validator,
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedState,
      decoration: CustomDropdowns._getDropdownDecoration(
        hintText: hintText,
        labelText: labelText,
      ),
      style: CustomDropdowns._dropdownTextStyle,
      hint: Text(
        hintText,
        style: CustomDropdowns._hintTextStyle,
      ),
      validator: validator ?? (isRequired ? (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a state';
        }
        return null;
      } : null),
      items: NigerianStates.states.map((String state) {
        return DropdownMenuItem<String>(
          value: state,
          child: Text(
            state,
            style: CustomDropdowns._dropdownTextStyle,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
      iconSize: 24,
      dropdownColor: Colors.white,
      menuMaxHeight: 300,
    );
  }
}

/// Reusable Practice Areas Dropdown Widget
class PracticeAreasDropdown extends StatelessWidget {
  final String? selectedPracticeArea;
  final ValueChanged<String?> onChanged;
  final String hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final bool isRequired;

  const PracticeAreasDropdown({
    Key? key,
    required this.selectedPracticeArea,
    required this.onChanged,
    this.hintText = 'Select Practice Area',
    this.labelText,
    this.validator,
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedPracticeArea,
      decoration: CustomDropdowns._getDropdownDecoration(
        hintText: hintText,
        labelText: labelText,
      ),
      style: CustomDropdowns._dropdownTextStyle,
      hint: Text(
        hintText,
        style: CustomDropdowns._hintTextStyle,
      ),
      validator: validator ?? (isRequired ? (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a practice area';
        }
        return null;
      } : null),
      items: PracticeAreas.names.map((String practiceArea) {
        return DropdownMenuItem<String>(
          value: practiceArea,
          child: Text(
            practiceArea,
            style: CustomDropdowns._dropdownTextStyle,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
      iconSize: 24,
      dropdownColor: Colors.white,
      menuMaxHeight: 300,
    );
  }
}

/// Reusable Local Government Areas Dropdown Widget
class LocalGovernmentAreasDropdown extends StatelessWidget {
  final String? selectedState;
  final String? selectedLGA;
  final ValueChanged<String?> onChanged;
  final String hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final bool isRequired;

  const LocalGovernmentAreasDropdown({
    Key? key,
    required this.selectedState,
    required this.selectedLGA,
    required this.onChanged,
    this.hintText = 'Select Local Government Area',
    this.labelText,
    this.validator,
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lgas = selectedState != null 
        ? NigerianStates.getLGAsForState(selectedState!)
        : <String>[];

    return DropdownButtonFormField<String>(
      value: selectedLGA,
      decoration: CustomDropdowns._getDropdownDecoration(
        hintText: hintText,
        labelText: labelText,
      ),
      style: CustomDropdowns._dropdownTextStyle,
      hint: Text(
        selectedState == null ? 'Select a state first' : hintText,
        style: CustomDropdowns._hintTextStyle,
      ),
      validator: validator ?? (isRequired ? (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a local government area';
        }
        return null;
      } : null),
      items: lgas.map((String lga) {
        return DropdownMenuItem<String>(
          value: lga,
          child: Text(
            lga,
            style: CustomDropdowns._dropdownTextStyle,
          ),
        );
      }).toList(),
      onChanged: selectedState == null ? null : onChanged,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
      iconSize: 24,
      dropdownColor: Colors.white,
      menuMaxHeight: 300,
    );
  }
}