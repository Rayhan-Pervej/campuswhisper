import 'package:cloud_firestore/cloud_firestore.dart';

class LostFoundItemModel {
  final String id;
  final String itemName;
  final String description;
  final String type;  // 'Lost' or 'Found'
  final String category;  // 'Electronics', 'Documents', 'Accessories', etc.
  final String location;  // Where it was lost/found
  final DateTime date;  // When it was lost/found
  final List<String> imageUrls;
  final String posterId;
  final String posterName;
  final String contactInfo;
  final String status;  // 'Active' or 'Resolved'
  final String? resolvedBy;
  final DateTime? resolvedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? additionalInfo;

  const LostFoundItemModel({
    required this.id,
    required this.itemName,
    required this.description,
    required this.type,
    required this.category,
    required this.location,
    required this.date,
    this.imageUrls = const [],
    required this.posterId,
    required this.posterName,
    required this.contactInfo,
    this.status = 'Active',
    this.resolvedBy,
    this.resolvedAt,
    required this.createdAt,
    this.updatedAt,
    this.additionalInfo,
  });

  factory LostFoundItemModel.fromJson(Map<String, dynamic> json) {
    return LostFoundItemModel(
      id: json['id'] as String,
      itemName: json['itemName'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      category: json['category'] as String,
      location: json['location'] as String,
      date: (json['date'] as Timestamp).toDate(),
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      posterId: json['posterId'] as String,
      posterName: json['posterName'] as String,
      contactInfo: json['contactInfo'] as String,
      status: json['status'] as String? ?? 'Active',
      resolvedBy: json['resolvedBy'] as String?,
      resolvedAt: json['resolvedAt'] != null
          ? (json['resolvedAt'] as Timestamp).toDate()
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
      'itemName': itemName,
      'description': description,
      'type': type,
      'category': category,
      'location': location,
      'date': Timestamp.fromDate(date),
      'imageUrls': imageUrls,
      'posterId': posterId,
      'posterName': posterName,
      'contactInfo': contactInfo,
      'status': status,
      'resolvedBy': resolvedBy,
      'resolvedAt': resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'additionalInfo': additionalInfo,
    };
  }

  LostFoundItemModel copyWith({
    String? id,
    String? itemName,
    String? description,
    String? type,
    String? category,
    String? location,
    DateTime? date,
    List<String>? imageUrls,
    String? posterId,
    String? posterName,
    String? contactInfo,
    String? status,
    String? resolvedBy,
    DateTime? resolvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? additionalInfo,
  }) {
    return LostFoundItemModel(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      description: description ?? this.description,
      type: type ?? this.type,
      category: category ?? this.category,
      location: location ?? this.location,
      date: date ?? this.date,
      imageUrls: imageUrls ?? this.imageUrls,
      posterId: posterId ?? this.posterId,
      posterName: posterName ?? this.posterName,
      contactInfo: contactInfo ?? this.contactInfo,
      status: status ?? this.status,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LostFoundItemModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  // Helper getters
  bool get isLost => type == 'Lost';
  bool get isFound => type == 'Found';
  bool get isResolved => status == 'Resolved';
  bool get isActive => status == 'Active';
  bool get hasImages => imageUrls.isNotEmpty;
}
