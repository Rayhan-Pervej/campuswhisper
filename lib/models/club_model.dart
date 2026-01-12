import 'package:cloud_firestore/cloud_firestore.dart';

class ClubModel {
  final String id;
  final String name;
  final String description;
  final String category;  // "academic", "cultural", "sports"
  final String? logoUrl;
  final String presidentId;
  final String presidentName;
  final List<String> memberIds;
  final int maxMembers;
  final String contactEmail;
  final String? contactPhone;
  final String? meetingLocation;
  final String? meetingSchedule;
  final Map<String, String>? socialLinks;  // {"facebook": "url", "instagram": "url", "website": "url"}
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ClubModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.logoUrl,
    required this.presidentId,
    required this.presidentName,
    this.memberIds = const [],
    this.maxMembers = 50,
    required this.contactEmail,
    this.contactPhone,
    this.meetingLocation,
    this.meetingSchedule,
    this.socialLinks,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory ClubModel.fromJson(Map<String, dynamic> json) {
    return ClubModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      logoUrl: json['logoUrl'] as String?,
      presidentId: json['presidentId'] as String,
      presidentName: json['presidentName'] as String,
      memberIds: List<String>.from(json['memberIds'] ?? []),
      maxMembers: json['maxMembers'] as int? ?? 50,
      contactEmail: json['contactEmail'] as String,
      contactPhone: json['contactPhone'] as String?,
      meetingLocation: json['meetingLocation'] as String?,
      meetingSchedule: json['meetingSchedule'] as String?,
      socialLinks: json['socialLinks'] != null
          ? Map<String, String>.from(json['socialLinks'])
          : null,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'logoUrl': logoUrl,
      'presidentId': presidentId,
      'presidentName': presidentName,
      'memberIds': memberIds,
      'maxMembers': maxMembers,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'meetingLocation': meetingLocation,
      'meetingSchedule': meetingSchedule,
      'socialLinks': socialLinks,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  ClubModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? logoUrl,
    String? presidentId,
    String? presidentName,
    List<String>? memberIds,
    int? maxMembers,
    String? contactEmail,
    String? contactPhone,
    String? meetingLocation,
    String? meetingSchedule,
    Map<String, String>? socialLinks,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClubModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      logoUrl: logoUrl ?? this.logoUrl,
      presidentId: presidentId ?? this.presidentId,
      presidentName: presidentName ?? this.presidentName,
      memberIds: memberIds ?? this.memberIds,
      maxMembers: maxMembers ?? this.maxMembers,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      meetingLocation: meetingLocation ?? this.meetingLocation,
      meetingSchedule: meetingSchedule ?? this.meetingSchedule,
      socialLinks: socialLinks ?? this.socialLinks,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
  bool get isFull => memberIds.length >= maxMembers;
  int get spotsLeft => maxMembers - memberIds.length;
  bool get hasSocialLinks => socialLinks != null && socialLinks!.isNotEmpty;
}
