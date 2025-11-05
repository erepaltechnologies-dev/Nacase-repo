import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {
  user,
  lawyer,
  admin,
}

enum VerificationStatus {
  pending,
  approved,
  rejected,
}

class User {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String bio;
  final String? profileImageUrl;
  final UserRole role;
  final VerificationStatus? verificationStatus;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool notificationsEnabled;
  
  // Lawyer-specific fields
  final String? firmName;
  final String? linkedInUrl;
  final String? areaOfPractice;
  final String? subcategory;
  final String? state;
  final String? supremeCourtNumber;
  final int? yearOfCall;
  final String? nin;
  final List<String>? documents; // URLs to uploaded documents
  final String? rejectionReason;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phone = '',
    this.bio = '',
    this.profileImageUrl,
    this.role = UserRole.user,
    this.verificationStatus,
    required this.createdAt,
    this.updatedAt,
    this.notificationsEnabled = true,
    this.firmName,
    this.linkedInUrl,
    this.areaOfPractice,
    this.subcategory,
    this.state,
    this.supremeCourtNumber,
    this.yearOfCall,
    this.nin,
    this.documents,
    this.rejectionReason,
  });

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'role': role.name,
      'verificationStatus': verificationStatus?.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'notificationsEnabled': notificationsEnabled,
      'firmName': firmName,
      'linkedInUrl': linkedInUrl,
      'areaOfPractice': areaOfPractice,
      'subcategory': subcategory,
      'state': state,
      'supremeCourtNumber': supremeCourtNumber,
      'yearOfCall': yearOfCall,
      'nin': nin,
      'documents': documents,
      'rejectionReason': rejectionReason,
    };
  }

  // Create from Firestore document
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return User(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      bio: data['bio'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      role: UserRole.values.firstWhere(
        (role) => role.name == data['role'],
        orElse: () => UserRole.user,
      ),
      verificationStatus: data['verificationStatus'] != null
          ? VerificationStatus.values.firstWhere(
              (status) => status.name == data['verificationStatus'],
              orElse: () => VerificationStatus.pending,
            )
          : null,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      notificationsEnabled: data['notificationsEnabled'] ?? true,
      firmName: data['firmName'],
      linkedInUrl: data['linkedInUrl'],
      areaOfPractice: data['areaOfPractice'],
      subcategory: data['subcategory'],
      state: data['state'],
      supremeCourtNumber: data['supremeCourtNumber'],
      yearOfCall: data['yearOfCall'],
      nin: data['nin'],
      documents: data['documents'] != null 
          ? List<String>.from(data['documents'])
          : null,
      rejectionReason: data['rejectionReason'],
    );
  }

  // Copy with method for updates
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? bio,
    String? profileImageUrl,
    UserRole? role,
    VerificationStatus? verificationStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? notificationsEnabled,
    String? firmName,
    String? linkedInUrl,
    String? areaOfPractice,
    String? subcategory,
    String? state,
    String? supremeCourtNumber,
    int? yearOfCall,
    String? nin,
    List<String>? documents,
    String? rejectionReason,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      firmName: firmName ?? this.firmName,
      linkedInUrl: linkedInUrl ?? this.linkedInUrl,
      areaOfPractice: areaOfPractice ?? this.areaOfPractice,
      subcategory: subcategory ?? this.subcategory,
      state: state ?? this.state,
      supremeCourtNumber: supremeCourtNumber ?? this.supremeCourtNumber,
      yearOfCall: yearOfCall ?? this.yearOfCall,
      nin: nin ?? this.nin,
      documents: documents ?? this.documents,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  // Helper methods
  bool get isAdmin => role == UserRole.admin;
  bool get isLawyer => role == UserRole.lawyer;
  bool get isUser => role == UserRole.user;
  bool get isPendingVerification => verificationStatus == VerificationStatus.pending;
  bool get isVerified => verificationStatus == VerificationStatus.approved;
  bool get isRejected => verificationStatus == VerificationStatus.rejected;
}