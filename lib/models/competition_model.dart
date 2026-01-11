import 'package:cloud_firestore/cloud_firestore.dart';

class CompetitionModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String? imageUrl;
  final String organizerId;
  final String organizerName;
  final DateTime registrationDeadline;
  final DateTime competitionDate;
  final DateTime? competitionEndDate;
  final String location;
  final String? rules;
  final String? prizes;
  final List<String> participantIds;
  final int maxParticipants;
  final String status;  // 'Upcoming', 'Active', 'Ended'
  final bool isTeamBased;
  final int? teamSize;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const CompetitionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.imageUrl,
    required this.organizerId,
    required this.organizerName,
    required this.registrationDeadline,
    required this.competitionDate,
    this.competitionEndDate,
    required this.location,
    this.rules,
    this.prizes,
    this.participantIds = const [],
    this.maxParticipants = 50,
    this.status = 'Upcoming',
    this.isTeamBased = false,
    this.teamSize,
    required this.createdAt,
    this.updatedAt,
  });

  factory CompetitionModel.fromJson(Map<String, dynamic> json) {
    return CompetitionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String?,
      organizerId: json['organizerId'] as String,
      organizerName: json['organizerName'] as String,
      registrationDeadline: (json['registrationDeadline'] as Timestamp).toDate(),
      competitionDate: (json['competitionDate'] as Timestamp).toDate(),
      competitionEndDate: json['competitionEndDate'] != null
          ? (json['competitionEndDate'] as Timestamp).toDate()
          : null,
      location: json['location'] as String,
      rules: json['rules'] as String?,
      prizes: json['prizes'] as String?,
      participantIds: List<String>.from(json['participantIds'] ?? []),
      maxParticipants: json['maxParticipants'] as int? ?? 50,
      status: json['status'] as String? ?? 'Upcoming',
      isTeamBased: json['isTeamBased'] as bool? ?? false,
      teamSize: json['teamSize'] as int?,
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
      'imageUrl': imageUrl,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'registrationDeadline': Timestamp.fromDate(registrationDeadline),
      'competitionDate': Timestamp.fromDate(competitionDate),
      'competitionEndDate': competitionEndDate != null
          ? Timestamp.fromDate(competitionEndDate!)
          : null,
      'location': location,
      'rules': rules,
      'prizes': prizes,
      'participantIds': participantIds,
      'maxParticipants': maxParticipants,
      'status': status,
      'isTeamBased': isTeamBased,
      'teamSize': teamSize,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  CompetitionModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? imageUrl,
    String? organizerId,
    String? organizerName,
    DateTime? registrationDeadline,
    DateTime? competitionDate,
    DateTime? competitionEndDate,
    String? location,
    String? rules,
    String? prizes,
    List<String>? participantIds,
    int? maxParticipants,
    String? status,
    bool? isTeamBased,
    int? teamSize,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CompetitionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      organizerId: organizerId ?? this.organizerId,
      organizerName: organizerName ?? this.organizerName,
      registrationDeadline: registrationDeadline ?? this.registrationDeadline,
      competitionDate: competitionDate ?? this.competitionDate,
      competitionEndDate: competitionEndDate ?? this.competitionEndDate,
      location: location ?? this.location,
      rules: rules ?? this.rules,
      prizes: prizes ?? this.prizes,
      participantIds: participantIds ?? this.participantIds,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      status: status ?? this.status,
      isTeamBased: isTeamBased ?? this.isTeamBased,
      teamSize: teamSize ?? this.teamSize,
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
  bool get isRegistrationOpen => DateTime.now().isBefore(registrationDeadline);
  bool get isUpcoming => status == 'Upcoming';
  bool get isActive => status == 'Active';
  bool get isEnded => status == 'Ended';
  int get participantCount => participantIds.length;
  int get spotsLeft => maxParticipants - participantIds.length;
}
