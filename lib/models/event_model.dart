import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String location;
  final DateTime eventDate;
  final DateTime? eventEndDate;  // For multi-day events
  final String? imageUrl;
  final String organizerId;
  final String organizerName;
  final List<String> attendeeIds;
  final int maxAttendees;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? additionalInfo;  // Flexible field for extra data

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.eventDate,
    this.eventEndDate,
    this.imageUrl,
    required this.organizerId,
    required this.organizerName,
    this.attendeeIds = const [],
    this.maxAttendees = 100,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    this.additionalInfo,
  });

  // fromJson
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      location: json['location'] as String,
      eventDate: (json['eventDate'] as Timestamp).toDate(),
      eventEndDate: json['eventEndDate'] != null
          ? (json['eventEndDate'] as Timestamp).toDate()
          : null,
      imageUrl: json['imageUrl'] as String?,
      organizerId: json['organizerId'] as String,
      organizerName: json['organizerName'] as String,
      attendeeIds: List<String>.from(json['attendeeIds'] ?? []),
      maxAttendees: json['maxAttendees'] as int? ?? 100,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'eventDate': Timestamp.fromDate(eventDate),
      'eventEndDate': eventEndDate != null ? Timestamp.fromDate(eventEndDate!) : null,
      'imageUrl': imageUrl,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'attendeeIds': attendeeIds,
      'maxAttendees': maxAttendees,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'additionalInfo': additionalInfo,
    };
  }

  // copyWith
  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? location,
    DateTime? eventDate,
    DateTime? eventEndDate,
    String? imageUrl,
    String? organizerId,
    String? organizerName,
    List<String>? attendeeIds,
    int? maxAttendees,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? additionalInfo,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      location: location ?? this.location,
      eventDate: eventDate ?? this.eventDate,
      eventEndDate: eventEndDate ?? this.eventEndDate,
      imageUrl: imageUrl ?? this.imageUrl,
      organizerId: organizerId ?? this.organizerId,
      organizerName: organizerName ?? this.organizerName,
      attendeeIds: attendeeIds ?? this.attendeeIds,
      maxAttendees: maxAttendees ?? this.maxAttendees,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  // Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  // Helper getters
  bool get isFull => attendeeIds.length >= maxAttendees;
  bool get isPast => eventDate.isBefore(DateTime.now());
  bool get isUpcoming => eventDate.isAfter(DateTime.now());
  int get attendeeCount => attendeeIds.length;
  int get spotsLeft => maxAttendees - attendeeIds.length;
}
