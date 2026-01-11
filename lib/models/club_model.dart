import 'package:cloud_firestore/cloud_firestore.dart';

class ClubModel {
  final String id;
  final String name;
  final String description;
  final String category;  // 'Academic', 'Cultural', 'Sports', 'Social', etc.
  final String? logoUrl;
  final String? coverImageUrl;
  final String presidentId;
  final String presidentName;
  final List<String> memberIds;
  final List<String> adminIds;
  final String contactEmail;
  final String? contactPhone;
  final String? facebookUrl;
  final String? instagramUrl;
  final String? websiteUrl;
  final bool isActive;
  final DateTime? establishedDate;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? additionalInfo;

  const ClubModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.logoUrl,
    this.coverImageUrl,
    required this.presidentId,
    required this.presidentName,
    this.memberIds = const [],
    this.adminIds = const [],
    required this.contactEmail,
    this.contactPhone,
    this.facebookUrl,
    this.instagramUrl,
    this.websiteUrl,
    this.isActive = true,
    this.establishedDate,
    required this.createdAt,
    this.updatedAt,
    this.additionalInfo,
  });

  factory ClubModel.fromJson(Map<String, dynamic> json) {
    return ClubModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      logoUrl: json['logoUrl'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      presidentId: json['presidentId'] as String,
      presidentName: json['presidentName'] as String,
      memberIds: List<String>.from(json['memberIds'] ?? []),
      adminIds: List<String>.from(json['adminIds'] ?? []),
      contactEmail: json['contactEmail'] as String,
      contactPhone: json['contactPhone'] as String?,
      facebookUrl: json['facebookUrl'] as String?,
      instagramUrl: json['instagramUrl'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      establishedDate: json['establishedDate'] != null
          ? (json['establishedDate'] as Timestamp).toDate()
          : null,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'logoUrl': logoUrl,
      'coverImageUrl': coverImageUrl,
      'presidentId': presidentId,
      'presidentName': presidentName,
      'memberIds': memberIds,
      'adminIds': adminIds,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'facebookUrl': facebookUrl,
      'instagramUrl': instagramUrl,
      'websiteUrl': websiteUrl,
      'isActive': isActive,
      'establishedDate': establishedDate != null
          ? Timestamp.fromDate(establishedDate!)
          : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'additionalInfo': additionalInfo,
    };
  }

  ClubModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? logoUrl,
    String? coverImageUrl,
    String? presidentId,
    String? presidentName,
    List<String>? memberIds,
    List<String>? adminIds,
    String? contactEmail,
    String? contactPhone,
    String? facebookUrl,
    String? instagramUrl,
    String? websiteUrl,
    bool? isActive,
    DateTime? establishedDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? additionalInfo,
  }) {
    return ClubModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      logoUrl: logoUrl ?? this.logoUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      presidentId: presidentId ?? this.presidentId,
      presidentName: presidentName ?? this.presidentName,
      memberIds: memberIds ?? this.memberIds,
      adminIds: adminIds ?? this.adminIds,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      facebookUrl: facebookUrl ?? this.facebookUrl,
      instagramUrl: instagramUrl ?? this.instagramUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      isActive: isActive ?? this.isActive,
      establishedDate: establishedDate ?? this.establishedDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClubModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  // Helper getters
  int get memberCount => memberIds.length;
  int get adminCount => adminIds.length;
  bool get hasSocialLinks => facebookUrl != null || instagramUrl != null || websiteUrl != null;
}
