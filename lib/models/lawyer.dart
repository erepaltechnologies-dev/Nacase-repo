import 'package:flutter/material.dart';

class Lawyer {
  final String name;
  final String firm;
  final List<String> practiceAreas;
  final String image;
  final double rating;
  final bool isProbono;
  final String location;
  final String about;
  final int yearsExperience;
  
  Lawyer({
    required this.name,
    required this.firm,
    required this.practiceAreas,
    required this.image,
    required this.rating,
    required this.isProbono,
    required this.location,
    required this.about,
    required this.yearsExperience,
  });
  
  // Helper method to get practice areas as a comma-separated string for display
  String get practiceAreasDisplay => practiceAreas.join(', ');
}

// Centralized lawyer data source - used across the entire app
final List<Lawyer> allLawyers = [
  Lawyer(
    name: 'Gloria Abu Esq',
    firm: 'Dale Tax Counsel',
    practiceAreas: ['Tech', 'Financial', 'Criminal'],
    image: 'images/law1.jpeg',
    rating: 4.7,
    isProbono: true,
    location: 'Lagos',
    about: 'Expert in tax and criminal law with over 8 years of experience.',
    yearsExperience: 8,
  ),
  Lawyer(
    name: 'Tolu Abe Esq',
    firm: 'Abe Legal',
    practiceAreas: ['Tech', 'Financial'],
    image: 'images/law2.jpeg',
    rating: 4.5,
    isProbono: false,
    location: 'Abuja',
    about: 'Specialist in cyber law and tax with 5 years of experience.',
    yearsExperience: 5,
  ),
  Lawyer(
    name: 'Adewunmi O. Olagoke',
    firm: 'Christian Legal',
    practiceAreas: ['Business Law', 'Family Law'],
    image: 'images/law3.jpeg',
    rating: 4.8,
    isProbono: true,
    location: 'Abuja',
    about: 'Experienced corporate and family law attorney.',
    yearsExperience: 10,
  ),
  Lawyer(
    name: 'Adekunle O. Johnson Esq',
    firm: 'Johnson & Associates',
    practiceAreas: ['Immigration', 'Government'],
    image: 'images/law4.jpeg',
    rating: 4.6,
    isProbono: true,
    location: 'Abuja',
    about: 'Dedicated immigration and human rights lawyer.',
    yearsExperience: 7,
  ),
  Lawyer(
    name: 'Hannah Gambo Esq',
    firm: 'Chen Legal Group',
    practiceAreas: ['Intellectual Property', 'Tech'],
    image: 'images/law5.jpeg',
    rating: 4.9,
    isProbono: false,
    location: 'Abuja',
    about: 'Leading expert in intellectual property and technology law.',
    yearsExperience: 12,
  ),
  Lawyer(
    name: 'Ariyo Adodokun',
    firm: 'Adedokun Law Firm',
    practiceAreas: ['Personal Injury'],
    image: 'images/law6.jpeg',
    rating: 4.8,
    isProbono: true,
    location: 'Ilorin',
    about: 'Compassionate personal injury and medical malpractice attorney.',
    yearsExperience: 9,
  ),
  Lawyer(
    name: 'Adewale Jones Esq',
    firm: 'Jones And Jones',
    practiceAreas: ['Personal Injury', 'Criminal'],
    image: 'images/law7.jpeg',
    rating: 4.8,
    isProbono: true,
    location: 'Lagos',
    about: 'Compassionate personal injury and medical malpractice attorney.',
    yearsExperience: 9,
  ),
  Lawyer(
    name: 'Eze E. Eze',
    firm: 'Lex Imperators',
    practiceAreas: ['Personal Injury', 'Criminal', 'Employment'],
    image: 'images/law8.jpeg',
    rating: 4.8,
    isProbono: true,
    location: 'Abuja',
    about: 'Compassionate personal injury and medical malpractice attorney.',
    yearsExperience: 9,
  ),
  Lawyer(
    name: 'Ayomide Adamson',
    firm: 'Lex Imperators',
    practiceAreas: ['Employment', 'Criminal', 'Tech'],
    image: 'images/law9.jpeg',
    rating: 4.8,
    isProbono: false,
    location: 'Abuja',
    about: 'Compassionate personal injury and medical malpractice attorney.',
    yearsExperience: 9,
  ),
];

// Helper functions to get specific lawyer data
Lawyer? getLawyerByName(String name) {
  try {
    return allLawyers.firstWhere((lawyer) => lawyer.name == name);
  } catch (e) {
    return null;
  }
}

// Get spotlight lawyers (first 6 for home screen)
List<Lawyer> get spotlightLawyers => allLawyers.take(6).toList();

// Get all lawyers for list screen
List<Lawyer> get lawyers => allLawyers;