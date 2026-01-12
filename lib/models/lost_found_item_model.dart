import 'package:cloud_firestore/cloud_firestore.dart';

class LostFoundItemModel {
  final String id;
  final String title;
  final String description;
  final String type;  // "lost" or "found"
  final String category;  // "electronics", "accessories", "documents"
  final String location;
  final DateTime date;
  final String? imageUrl;
  final String posterId;
  final String posterName;
  final String posterContact;
  final String? posterPhone;
  final String status;  // "open", "claimed", "returned", "closed"
  final bool isActive;
  final String? claimedById;
  final DateTime? claimedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const LostFoundItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.location,
    required this.date,
    this.imageUrl,
    required this.posterId,
    required this.posterName,
    required this.posterContact,
    this.posterPhone,
    this.status = 'open',
    this.isActive = true,
    this.claimedById,
    this.claimedAt,
    required this.createdAt,
    this.updatedAt,
  });

  factory LostFoundItemModel.fromJson(Map<String, dynamic> json) {
    return LostFoundItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      category: json['category'] as String,
      location: json['location'] as String,
      date: (json['date'] as Timestamp).toDate(),
      imageUrl: json['imageUrl'] as String?,
      posterId: json['posterId'] as String,
      posterName: json['posterName'] as String,
      posterContact: json['posterContact'] as String,
      posterPhone: json['posterPhone'] as String?,
      status: json['status'] as String? ?? 'open',
      isActive: json['isActive'] as bool? ?? true,
      claimedById: json['claimedById'] as String?,
      claimedAt: json['claimedAt'] != null
          ? (json['claimedAt'] as Timestamp).toDate()
          : null,
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
      'type': type,
      'category': category,
      'location': location,
      'date': Timestamp.fromDate(date),
      'imageUrl': imageUrl,
      'posterId': posterId,
      'posterName': posterName,
      'posterContact': posterContact,
      'posterPhone': posterPhone,
      'status': status,
      'isActive': isActive,
      'claimedById': claimedById,
      'claimedAt': claimedAt != null ? Timestamp.fromDate(claimedAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  LostFoundItemModel copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? category,
    String? location,
    DateTime? date,
    String? imageUrl,
    String? posterId,
    String? posterName,
    String? posterContact,
    String? posterPhone,
    String? status,
    bool? isActive,
    String? claimedById,
    DateTime? claimedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LostFoundItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      category: category ?? this.category,
      location: location ?? this.location,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      posterId: posterId ?? this.posterId,
      posterName: posterName ?? this.posterName,
      posterContact: posterContact ?? this.posterContact,
      posterPhone: posterPhone ?? this.posterPhone,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      claimedById: claimedById ?? this.claimedById,
      claimedAt: claimedAt ?? this.claimedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
  bool get isLost => type == 'lost';
  bool get isFound => type == 'found';
  bool get isOpen => status == 'open';
  bool get isClaimed => status == 'claimed';
  bool get isReturned => status == 'returned';
  bool get isClosed => status == 'closed';
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
}
