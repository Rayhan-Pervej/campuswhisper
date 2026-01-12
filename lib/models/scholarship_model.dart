import 'package:cloud_firestore/cloud_firestore.dart';

class ScholarshipModel {
  final String id;
  final String title;
  final String description;
  final String category;  // "merit", "need-based", "sports"
  final List<String> eligibilityRequirements;
  final List<String> requiredDocuments;
  final String amount;
  final int numberOfAwards;
  final DateTime deadline;
  final String? applicationUrl;
  final String contactEmail;
  final String? contactPhone;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ScholarshipModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.eligibilityRequirements = const [],
    this.requiredDocuments = const [],
    required this.amount,
    required this.numberOfAwards,
    required this.deadline,
    this.applicationUrl,
    required this.contactEmail,
    this.contactPhone,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory ScholarshipModel.fromJson(Map<String, dynamic> json) {
    return ScholarshipModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      eligibilityRequirements: List<String>.from(json['eligibilityRequirements'] ?? []),
      requiredDocuments: List<String>.from(json['requiredDocuments'] ?? []),
      amount: json['amount'] as String,
      numberOfAwards: json['numberOfAwards'] as int,
      deadline: (json['deadline'] as Timestamp).toDate(),
      applicationUrl: json['applicationUrl'] as String?,
      contactEmail: json['contactEmail'] as String,
      contactPhone: json['contactPhone'] as String?,
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
      'title': title,
      'description': description,
      'category': category,
      'eligibilityRequirements': eligibilityRequirements,
      'requiredDocuments': requiredDocuments,
      'amount': amount,
      'numberOfAwards': numberOfAwards,
      'deadline': Timestamp.fromDate(deadline),
      'applicationUrl': applicationUrl,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  ScholarshipModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    List<String>? eligibilityRequirements,
    List<String>? requiredDocuments,
    String? amount,
    int? numberOfAwards,
    DateTime? deadline,
    String? applicationUrl,
    String? contactEmail,
    String? contactPhone,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ScholarshipModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      eligibilityRequirements: eligibilityRequirements ?? this.eligibilityRequirements,
      requiredDocuments: requiredDocuments ?? this.requiredDocuments,
      amount: amount ?? this.amount,
      numberOfAwards: numberOfAwards ?? this.numberOfAwards,
      deadline: deadline ?? this.deadline,
      applicationUrl: applicationUrl ?? this.applicationUrl,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScholarshipModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  // Helper getters
  bool get isExpired => deadline.isBefore(DateTime.now());
  bool get isOpen => !isExpired && isActive;
  int get daysUntilDeadline => deadline.difference(DateTime.now()).inDays;
}
