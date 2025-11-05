class FilterCriteria {
  final String? location;
  final int? minRating;
  final String? practiceArea;

  FilterCriteria({
    this.location,
    this.minRating,
    this.practiceArea,
  });

  // Create a copy with updated values
  FilterCriteria copyWith({
    String? location,
    int? minRating,
    String? practiceArea,
  }) {
    return FilterCriteria(
      location: location ?? this.location,
      minRating: minRating ?? this.minRating,
      practiceArea: practiceArea ?? this.practiceArea,
    );
  }

  // Check if any filters are applied
  bool get hasFilters {
    return location != null ||
           minRating != null ||
           practiceArea != null;
  }

  // Clear all filters
  FilterCriteria clear() {
    return FilterCriteria();
  }

  @override
  String toString() {
    return 'FilterCriteria(location: $location, minRating: $minRating, practiceArea: $practiceArea)';
  }
}