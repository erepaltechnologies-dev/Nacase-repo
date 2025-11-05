import 'package:flutter/material.dart';
import 'dart:ui';
import '../../widgets/modals/paywall_modal.dart';

class LawyerPremiumScreen extends StatefulWidget {
  const LawyerPremiumScreen({Key? key}) : super(key: key);

  @override
  State<LawyerPremiumScreen> createState() => _LawyerPremiumScreenState();
}

class _LawyerPremiumScreenState extends State<LawyerPremiumScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Implement slide to back functionality
          if (details.primaryVelocity! > 300) {
            // Swipe right to go back
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              
              // Header section
              _buildHeaderSection(),
              
              const SizedBox(height: 20),
              
              // Three pricing cards
              _buildPricingCards(),
              
              const SizedBox(height: 30), // Add some bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Premium',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'See who Contacted you',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "People want to meet you",
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(111, 146, 140, 140),
            ),
          ),
          const SizedBox(height: 12),
          
          // Blurred profile images
          Row(
            children: [
              _buildBlurredProfile('images/law1.jpeg'),
              const SizedBox(width: 8),
              _buildBlurredProfile('images/law2.jpeg'),
              const SizedBox(width: 8),
              _buildBlurredProfile('images/law3.jpeg'),
              const SizedBox(width: 8),
              _buildBlurredProfile('images/law4.jpeg'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBlurredProfile(String imagePath) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  Widget _buildPricingCards() {
    return Container(
      height: 600,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Basic Plan
            _buildPricingCard(
              title: 'Basic',
              price: '₦4500',
              features: [
                'Unlimited Contacts',
                'Hide years of experience',
                '5 Weekly Hires',
                '//Unlimited listings',
                '//AI researcher',
                '//Travel Mode',
                '//Plus hours Spotlight boosts',
                '//Super Contacts',
                '//International Visibility',
                '//Additional Areas of law',
                '//Case Manager +',
                //'//Custom Webpage url',
              ],
              isPopular: false,
            ),
            
            const SizedBox(width: 16),
            
            // Premium Plan
            _buildPricingCard(
              title: 'Premium',
              price: '₦7500',
              features: [
                'Unlimited Contacts',
                'Hide years of experience',
                '5 Hires',
                '5 listings',
                'AI researcher',
                '5 location Spots',
                '10 hours Spotlight boosts',
                '//Super Contacts',
                '//International Visibility',
                '//Additional Areas of law',
                '//Case Manager +',
                //'//Custom Webpage url',
              ],
              isPopular: true,
            ),
            
            const SizedBox(width: 16),
            
            // Premium+ Plan
            _buildPricingCard(
              title: 'Premium+',
              price: '₦45,000',
              features: [
                'Unlimited Contacts',
                'Hide years of experience',
                'Unlimited Hires',
                'Unlimited Listings',
                'Unlimited AI researcher',
                'Travel Mode',
                '48 hours Spotlight boosts',
                'Super Contacts',
                'International Visibility',
                'Additional Areas of law',
                'Case Manager +',
                //'Custom Web page url',
                'Retainer Firm',
              ],
              isPopular: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingCard({
    required String title,
    required String price,
    required List<String> features,
    required bool isPopular,
  }) {
    return Container(
      width: 280, // Fixed width to make cards bigger
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 3,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          // Features list
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: features.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                  size: 10,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  features[index].startsWith('//') 
                                    ? features[index].substring(2) 
                                    : features[index],
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              // Status icon (available/locked)
                              Icon(
                                features[index].startsWith('//')
                                  ? Icons.lock
                                  : Icons.check_circle,
                                color: features[index].startsWith('//')
                                  ? Colors.grey
                                  : Colors.green,
                                size: 16,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Price button
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            child: ElevatedButton(
              onPressed: () {
                _handleSubscription(title, price);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Starting at $price/Month',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Future<void> _handleSubscription(String plan, String price) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaywallModal(plan: plan),
    );
    if (result == true) {
      // Navigate back to the connections screen; provider will unblur UI
      Navigator.of(context).pop();
    }
  }
}