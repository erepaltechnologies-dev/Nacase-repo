import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'verification_pending_screen.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import '../../widgets/custom_dropdowns.dart';
import '../../services/admin_service.dart';

class InformationRequestScreen extends StatefulWidget {
  const InformationRequestScreen({Key? key}) : super(key: key);

  @override
  State<InformationRequestScreen> createState() => _InformationRequestScreenState();
}

class _InformationRequestScreenState extends State<InformationRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  final _supremeCourtController = TextEditingController();
  final _ninController = TextEditingController();
  final _firmCodeController = TextEditingController();
  final _linkedInController = TextEditingController();
  Uint8List? _avatarBytes;
  
  String? selectedState;
  String? selectedYearOfCall;
  String? selectedAreaOfPractice;
  String? selectedSubcategory;
  
  



  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      final parts = displayName.split(RegExp(r"\s+"));
      _firstNameController.text = parts.isNotEmpty ? parts.first : '';
      _lastNameController.text = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    } else {
      // Fallback: use email local part as first name if available
      final emailLocal = user?.email?.split('@').first ?? '';
      _firstNameController.text = emailLocal;
      _lastNameController.text = '';
    }
    
    // Load existing profile image
    _loadExistingProfileImage();
  }

  Future<void> _loadExistingProfileImage() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('DEBUG: No authenticated user found for loading profile image');
        return;
      }

      print('DEBUG: Loading existing profile image for user: ${user.uid}');
      
      final storageRef = FirebaseStorage.instance.ref().child('profile_images/${user.uid}');
      final imageBytes = await storageRef.getData();
      
      if (imageBytes != null) {
        if (!mounted) {
          print('DEBUG: Widget unmounted before setting avatar bytes; skipping.');
          return;
        }
        setState(() {
          _avatarBytes = imageBytes;
        });
        print('DEBUG: Successfully loaded existing profile image (${imageBytes.length} bytes)');
      } else {
        print('DEBUG: No existing profile image found');
      }
    } catch (e) {
      print('DEBUG: Error loading existing profile image: $e');
      // Don't show error to user, just log it - it's normal if no image exists yet
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    
    _supremeCourtController.dispose();
    _ninController.dispose();
    _firmCodeController.dispose();
    _linkedInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Back',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        titleSpacing: -8,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Verification',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'This should only take a few minutes',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              
              const SizedBox(height: 32),
              // Avatar Picker
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Builder(
                      builder: (context) {
                        print('DEBUG: Building avatar - _avatarBytes is ${_avatarBytes != null ? "not null (${_avatarBytes!.length} bytes)" : "null"}');
                        return CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: _avatarBytes != null ? MemoryImage(_avatarBytes!) : null,
                          child: _avatarBytes == null
                              ? Icon(
                                  Icons.person,
                                  size: 48,
                                  color: Colors.grey[500],
                                )
                              : null,
                        );
                      }
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: _pickAvatar,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green[600],
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // First Name
              _buildTextField(
                controller: _firstNameController,
                label: 'First Name',
                hint: 'Enter your first name',
              ),
              
              const SizedBox(height: 20),
              
              // Last Name
              _buildTextField(
                controller: _lastNameController,
                label: 'Last Name',
                hint: 'Enter your last name',
              ),
              
              const SizedBox(height: 20),
              
              // Phone Number
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                hint: 'Enter your phone number',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                isRequired: true,
              ),
              
              const SizedBox(height: 20),

              // LinkedIn
              _buildTextField(
                controller: _linkedInController,
                label: 'LinkedIn',
                hint: 'Enter your LinkedIn profile URL',
                keyboardType: TextInputType.url,
                isRequired: true,
              ),

              const SizedBox(height: 20),

              // Area of Practice
              _buildAreaOfPracticeDropdown(),

              const SizedBox(height: 20),

              // State Dropdown
              _buildStateDropdown(),
              
              const SizedBox(height: 20),
              
              // Removed Local Government Area per request
              
              const SizedBox(height: 20),
              
              // Supreme Court Number
              _buildTextField(
                controller: _supremeCourtController,
                label: 'Supreme Court Number',
                hint: 'Enter supreme court number',
              ),
              
              const SizedBox(height: 20),

              // Year of Call
              _buildYearOfCallDropdown(),
              
              const SizedBox(height: 20),

              // National Identification Number
              _buildTextField(
                controller: _ninController,
                label: 'National Identification Number',
                hint: 'Enter your NIN',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                isRequired: true,
              ),

              const SizedBox(height: 20),
              
              // Removed NBA Branch per request
              
              const SizedBox(height: 20),
              
              // Firm Code (Optional)
              _buildTextField(
                controller: _firmCodeController,
                label: 'Firm Code (Optional)',
                hint: 'Enter firm code if applicable',
                isRequired: false,
              ),
              
              const SizedBox(height: 24),
              
              // Note text
              Text(
                'Please note that the information you are about to provide will be used to verify your identity as a legal practitioner.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Removed Call to Bar certificate upload per request
              
              const SizedBox(height: 20),
              
              // Removed LLB certificate upload per request
              
              const SizedBox(height: 40),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    _normalizeLinkedInUrl();
                    if (_formKey.currentState!.validate()) {
                      // Validate image upload requirement
                      final isImageValid = await _validateImageUpload();
                      if (!isImageValid) {
                        return; // Stop submission if image validation fails
                      }

                      // Show loading indicator
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );

                      try {
                         // Submit lawyer verification data
                          await AdminService.submitLawyerVerification(
                            firmName: _firmCodeController.text.trim(),
                            linkedInUrl: _linkedInController.text.trim(),
                            areaOfPractice: selectedAreaOfPractice ?? '',
                            subcategory: selectedSubcategory ?? '',
                            state: selectedState ?? '',
                            supremeCourtNumber: _supremeCourtController.text.trim(),
                            yearOfCall: int.tryParse(selectedYearOfCall ?? '0') ?? 0,
                            nin: _ninController.text.trim(),
                            documentUrls: [], // TODO: Add document upload functionality
                            firstName: _firstNameController.text.trim(),
                            lastName: _lastNameController.text.trim(),
                            phone: _phoneController.text.trim(),
                            profileImageBytes: _avatarBytes,
                          );

                        // Close loading dialog
                        Navigator.of(context).pop();

                        // Navigate to verification pending screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerificationPendingScreen(),
                          ),
                        );
                      } catch (e) {
                        // Close loading dialog
                        Navigator.of(context).pop();

                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error submitting application: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Submit Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _normalizeLinkedInUrl() {
    final text = _linkedInController.text.trim();
    if (text.isEmpty) return;
    final lower = text.toLowerCase();
    if (!lower.startsWith('http://') && !lower.startsWith('https://')) {
      _linkedInController.text = 'https://$text';
    }
  }

  Widget _buildStateDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        NigerianStatesDropdown(
          selectedState: selectedState,
          onChanged: (String? newValue) {
            setState(() {
              selectedState = newValue;
            });
          },
          hintText: 'Select your State',
          isRequired: true,
        ),
      ],
    );
  }

  Widget _buildYearOfCallDropdown() {
    final currentYear = DateTime.now().year;
    final startYear = currentYear - 50;
    final years = List.generate(51, (index) => (startYear + index).toString()).reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Year of Call',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedYearOfCall,
              hint: Text(
                'Select year of call to the bar',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              isExpanded: true,
              items: years.map((String year) {
                return DropdownMenuItem<String>(
                  value: year,
                  child: Text(year),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedYearOfCall = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: isRequired ? (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          } : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.green[600]!),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildAreaOfPracticeDropdown() {
    final practiceAreas = {
      'Criminal Litigation': [
        'General Criminal Defence',
        'Arrest & Police Matters',
        'Bail Applications & Surety Advice',
        'Criminal Trial Representation',
        'Appeals & Post-Conviction Review',
        'Theft, Robbery & Fraud',
        'Financial & Economic Crimes (EFCC, Money Laundering)',
        'Drug-Related Offences',
        'Sexual Offences & Harassment',
        'Domestic Violence & Assault',
        'Cybercrime & Digital Fraud',
        'Homicide & Manslaughter',
        'Public Order & Riot Offences',
        'Juvenile & Youth Offences',
        'Human Trafficking & Smuggling',
        'Terrorism & National Security Matters',
        'Environmental & Wildlife Crimes',
        'Corporate & White-Collar Crimes',
        'Anti-Corruption Investigations',
        'Victim Representation & Restorative Justice',
      ],
      'Civil Litigation': [
        'Breach of Contract',
        'Debt Recovery & Loan Enforcement',
        'Sale of Goods & Supply Agreements',
        'Consumer Protection & Product Liability',
        'Insurance Disputes',
        'Personal Injury & Negligence',
        'Defamation (Libel & Slander)',
        'Family & Matrimonial Disputes',
        'Child Custody & Maintenance',
        'Inheritance & Succession',
        'Wrongful Termination',
        'Employment Contracts & Benefits',
        'Workplace Harassment',
        'Labour Union & Collective Disputes',
        'Landlord & Tenant Matters',
        'Boundary & Possession Disputes',
        'Trespass & Nuisance Claims',
        'Enforcement of Judgments',
        'Mediation & Conciliation',
        'Arbitration & Settlement Agreements',
        'Small Claims & Out-of-Court Settlements',
      ],
      'Corporate Law & Practice': [
        'Business & Company Registration',
        'Corporate Governance & Compliance',
        'Shareholder Agreements',
        'Mergers & Acquisitions (M&A)',
        'Contracts & Negotiations',
        'Startups & Venture Advisory',
        'Tax Compliance & Advisory',
        'Regulatory Licensing & Approvals',
        'Entertainment & Media Law',
        'Music Law',
        'Sports Law',
        'Film & Television Law',
        'Tech Law',
        'Fintech Law',
        'Data Protection & Privacy Law',
        'AI & Automation Law',
        'Cybersecurity & Digital Crimes',
        'Intellectual Property Law',
        'Corporate Social Responsibility (CSR) Compliance',
        'ESG & Sustainability Law',
        'NGO & Non-Profit Registration and Governance',
      ],
      'Property Law': [
        'Land Acquisition & Sale',
        'Title Verification & Searches',
        'Lease & Tenancy Agreements',
        'Land Transfer & Conveyancing',
        'Property Sales & Management',
        'Building & Construction Law',
        'Real Estate Investment & Development',
        'Land Use & Zoning Compliance',
        'Land Disputes & Boundary Conflicts',
        'Compulsory Acquisition & Compensation',
        'Mortgage, Foreclosure & Security Interests',
        'Easements & Right-of-Way Issues',
        'Environmental Compliance & Regulations',
        'Community Land Rights',
        'Estate Planning & Wills',
        'Housing Authority & Government Property Matters',
      ],
      'Constitutional & Human Rights Law': [
        'Right to Fair Hearing',
        'Right to Life & Human Dignity',
        'Freedom of Expression & Assembly',
        'Freedom from Discrimination',
        'Right to Privacy & Personal Liberty',
        'Civil Society & NGO Advocacy',
        'Gender Equality & Women\'s Rights',
        'Children\'s Rights',
        'Rights of Persons with Disabilities',
        'Access to Justice Initiatives',
        'Judicial Review & Constitutional Interpretation',
        'Electoral Rights & Political Participation',
        'Administrative Law & Government Accountability',
        'Freedom of Information (FOI) Requests',
        'Treaty Obligations & Compliance',
        'Regional Human Rights Mechanisms (ECOWAS, AU)',
        'Asylum, Refugee & Migration Rights',
      ],
      'Commercial & Financial Law': [
        'Loan & Credit Agreements',
        'Banking Compliance & Regulation',
        'Microfinance & Digital Banking',
        'Collateral & Security Documentation',
        'Investment Agreements & Due Diligence',
        'Private Equity & Venture Capital',
        'Stock Market & Securities Law',
        'Crowdfunding & Tokenized Assets',
        'Import & Export Agreements',
        'Customs & Tariff Regulations',
        'Maritime & Shipping Law',
        'Trade Dispute Resolution',
        'Corporate Tax Planning',
        'VAT & Customs Duties',
        'Tax Dispute Resolution',
        'Cross-Border Taxation',
        'Debt Restructuring',
        'Receivership & Liquidation',
        'Corporate Recovery & Insolvency Proceedings',
      ],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Area of Practice',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        // Main Category Dropdown
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedAreaOfPractice,
              hint: Text(
                'Select your primary area of practice',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              isExpanded: true,
              items: practiceAreas.keys.map((String area) {
                return DropdownMenuItem<String>(
                  value: area,
                  child: Text(area),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedAreaOfPractice = newValue;
                  selectedSubcategory = null; // Reset subcategory when main category changes
                });
              },
            ),
          ),
        ),
        // Subcategory Dropdown (only show if main category is selected)
        if (selectedAreaOfPractice != null) ...[
          const SizedBox(height: 12),
          Text(
            'Subcategory',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedSubcategory,
                hint: Text(
                  'Select a specific area',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                isExpanded: true,
                items: practiceAreas[selectedAreaOfPractice]!.map((String subcategory) {
                  return DropdownMenuItem<String>(
                    value: subcategory,
                    child: Text(subcategory),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSubcategory = newValue;
                  });
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDropdownField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: controller.text.isEmpty ? null : controller.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.green[600]!),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              controller.text = newValue ?? '';
            });
          },
        ),
      ],
    );
  }

  Future<void> _pickAvatar() async {
    try {
      print('DEBUG: Starting image picker...');
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        print('DEBUG: File picked - name: ${file.name}, size: ${file.size}');
        if (file.bytes != null) {
          print('DEBUG: File bytes available, length: ${file.bytes!.length}');
          if (!mounted) {
            print('DEBUG: Widget unmounted before setting avatar bytes; skipping.');
            return;
          }
          setState(() {
            _avatarBytes = file.bytes;
          });
          print('DEBUG: Avatar bytes set successfully');
        } else {
          print('DEBUG: File bytes are null');
        }
      } else {
        print('DEBUG: No file selected or result is null');
      }
    } catch (e) {
      print('DEBUG: Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<bool> _hasDefaultProfileImage() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return true;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) return true;

      final userData = userDoc.data() as Map<String, dynamic>;
      final profileImageUrl = userData['profileImageUrl'] as String?;

      // User has default profile image if profileImageUrl is null or empty
      return profileImageUrl == null || profileImageUrl.isEmpty;
    } catch (e) {
      // If there's an error checking, assume default image for safety
      return true;
    }
  }

  Future<bool> _validateImageUpload() async {
    final hasDefaultImage = await _hasDefaultProfileImage();
    
    // If user has default image and hasn't selected a new one, show error
    if (hasDefaultImage && _avatarBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload a profile image to continue with application'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }
    
    return true;
  }

}