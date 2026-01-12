import 'package:cloud_firestore/cloud_firestore.dart';

class CompetitionModel {
  final String id;
  final String title;
  final String description;
  final String category;  // "coding", "design", "business"
  final DateTime registrationStartDate;
  final DateTime registrationEndDate;
  final DateTime competitionStartDate;
  final DateTime competitionEndDate;
  final String location;
  final String? imageUrl;
  final String? rules;
  final String organizerId;
  final String organizerName;
  final List<String> participantIds;
  final int maxParticipants;
  final int teamSize;  // 1 for individual
  final Map<String, String>? prizes;  // {"first": "Rs. 10,000", "second": "Rs. 5,000", "third": "Rs. 2,000"}
  final String status;  // "upcoming", "ongoing", "completed"
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const CompetitionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.registrationStartDate,
    required this.registrationEndDate,
    required this.competitionStartDate,
    required this.competitionEndDate,
    required this.location,
    this.imageUrl,
    this.rules,
    required this.organizerId,
    required this.organizerName,
    this.participantIds = const [],
    this.maxParticipants = 100,
    this.teamSize = 1,
    this.prizes,
    this.status = 'upcoming',
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory CompetitionModel.fromJson(Map<String, dynamic> json) {
    return CompetitionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      registrationStartDate: (json['registrationStartDate'] as Timestamp).toDate(),
      registrationEndDate: (json['registrationEndDate'] as Timestamp).toDate(),
      competitionStartDate: (json['competitionStartDate'] as Timestamp).toDate(),
      competitionEndDate: (json['competitionEndDate'] as Timestamp).toDate(),
      location: json['location'] as String,
      imageUrl: json['imageUrl'] as String?,
      rules: json['rules'] as String?,
      organizerId: json['organizerId'] as String,
      organizerName: json['organizerName'] as String,
      participantIds: List<String>.from(json['participantIds'] ?? []),
      maxParticipants: json['maxParticipants'] as int? ?? 100,
      teamSize: json['teamSize'] as int? ?? 1,
      prizes: json['prizes'] != null
          ? Map<String, String>.from(json['prizes'])
          : null,
      status: json['status'] as String? ?? 'upcoming',
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
      'registrationStartDate': Timestamp.fromDate(registrationStartDate),
      'registrationEndDate': Timestamp.fromDate(registrationEndDate),
      'competitionStartDate': Timestamp.fromDate(competitionStartDate),
      'competitionEndDate': Timestamp.fromDate(competitionEndDate),
      'location': location,
      'imageUrl': imageUrl,
      'rules': rules,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'participantIds': participantIds,
      'maxParticipants': maxParticipants,
      'teamSize': teamSize,
      'prizes': prizes,
      'status': status,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  CompetitionModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? registrationStartDate,
    DateTime? registrationEndDate,
    DateTime? competitionStartDate,
    DateTime? competitionEndDate,
    String? location,
    String? imageUrl,
    String? rules,
    String? organizerId,
    String? organizerName,
    List<String>? participantIds,
    int? maxParticipants,
    int? teamSize,
    Map<String, String>? prizes,
    String? status,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CompetitionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      registrationStartDate: registrationStartDate ?? this.registrationStartDate,
      registrationEndDate: registrationEndDate ?? this.registrationEndDate,
      competitionStartDate: competitionStartDate ?? this.competitionStartDate,
      competitionEndDate: competitionEndDate ?? this.competitionEndDate,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      rules: rules ?? this.rules,
      organizerId: organizerId ?? this.organizerId,
      organizerName: organizerName ?? this.organizerName,
      participantIds: participantIds ?? this.participantIds,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      teamSize: teamSize ?? this.teamSize,
      prizes: prizes ?? this.prizes,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CompetitionModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  // Helper getters
  bool get isFull => participantIds.length >= maxParticipants;
  bool get isRegistrationOpen =>
      DateTime.now().isAfter(registrationStartDate) &&
      DateTime.now().isBefore(registrationEndDate);
  bool get isUpcoming => status == 'upcoming';
  bool get isOngoing => status == 'ongoing';
  bool get isCompleted => status == 'completed';
  int get participantCount => participantIds.length;
  int get spotsLeft => maxParticipants - participantIds.length;
  bool get isTeamBased => teamSize > 1;
}
