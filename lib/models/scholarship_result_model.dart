class ScholarshipResult {
  final bool isEligible;
  final int scholarshipPercentage;
  final String scholarshipType;
  final String eligibilityReason;
  final List<String> requirementsMet;
  final List<String> requirementsUnmet;
  final MaintenanceRequirement maintenanceRequirement;
  final double currentCGPA;
  final double totalCreditsEarned;

  ScholarshipResult({
    required this.isEligible,
    required this.scholarshipPercentage,
    required this.scholarshipType,
    required this.eligibilityReason,
    required this.requirementsMet,
    required this.requirementsUnmet,
    required this.maintenanceRequirement,
    required this.currentCGPA,
    required this.totalCreditsEarned,
  });

  factory ScholarshipResult.notEligible({
    required String reason,
    required double cgpa,
    required double credits,
    required List<String> unmetRequirements,
  }) {
    return ScholarshipResult(
      isEligible: false,
      scholarshipPercentage: 0,
      scholarshipType: 'Not Eligible',
      eligibilityReason: reason,
      requirementsMet: [],
      requirementsUnmet: unmetRequirements,
      maintenanceRequirement: MaintenanceRequirement.empty(),
      currentCGPA: cgpa,
      totalCreditsEarned: credits,
    );
  }

  factory ScholarshipResult.eligible({
    required int percentage,
    required double cgpa,
    required double credits,
    required List<String> metRequirements,
  }) {
    return ScholarshipResult(
      isEligible: true,
      scholarshipPercentage: percentage,
      scholarshipType: 'IUB Merit Scholarship - Based on Semester Result',
      eligibilityReason: 'CGPA meets scholarship criteria',
      requirementsMet: metRequirements,
      requirementsUnmet: [],
      maintenanceRequirement: MaintenanceRequirement(
        minimumCGPA: _getMaintenanceCGPA(percentage),
        minimumCreditsPerSemester: 12,
        description: 'To maintain this scholarship, you must maintain minimum ${_getMaintenanceCGPA(percentage)} CGPA and take at least 12 credits per semester.',
      ),
      currentCGPA: cgpa,
      totalCreditsEarned: credits,
    );
  }

  static double _getMaintenanceCGPA(int percentage) {
    switch (percentage) {
      case 30:
        return 3.70;
      case 50:
        return 3.80;
      case 75:
        return 3.86;
      case 100:
        return 3.95;
      default:
        return 3.70;
    }
  }

  factory ScholarshipResult.fromMap(Map<String, dynamic> map) {
    return ScholarshipResult(
      isEligible: map['isEligible'] ?? false,
      scholarshipPercentage: map['scholarshipPercentage'] ?? 0,
      scholarshipType: map['scholarshipType'] ?? '',
      eligibilityReason: map['eligibilityReason'] ?? '',
      requirementsMet: List<String>.from(map['requirementsMet'] ?? []),
      requirementsUnmet: List<String>.from(map['requirementsUnmet'] ?? []),
      maintenanceRequirement: MaintenanceRequirement.fromMap(map['maintenanceRequirement'] ?? {}),
      currentCGPA: (map['currentCGPA'] ?? 0.0).toDouble(),
      totalCreditsEarned: (map['totalCreditsEarned'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isEligible': isEligible,
      'scholarshipPercentage': scholarshipPercentage,
      'scholarshipType': scholarshipType,
      'eligibilityReason': eligibilityReason,
      'requirementsMet': requirementsMet,
      'requirementsUnmet': requirementsUnmet,
      'maintenanceRequirement': maintenanceRequirement.toMap(),
      'currentCGPA': currentCGPA,
      'totalCreditsEarned': totalCreditsEarned,
    };
  }

  String get displayPercentage => isEligible ? '$scholarshipPercentage%' : 'Not Eligible';
  
  String get summaryMessage {
    if (!isEligible) {
      return 'Unfortunately, you are not currently eligible for merit scholarship. $eligibilityReason';
    }
    return 'Congratulations! You are eligible for $scholarshipPercentage% tuition fee waiver under $scholarshipType.';
  }
}

class MaintenanceRequirement {
  final double minimumCGPA;
  final int minimumCreditsPerSemester;
  final String description;

  MaintenanceRequirement({
    required this.minimumCGPA,
    required this.minimumCreditsPerSemester,
    required this.description,
  });

  factory MaintenanceRequirement.empty() {
    return MaintenanceRequirement(
      minimumCGPA: 0.0,
      minimumCreditsPerSemester: 0,
      description: '',
    );
  }

  factory MaintenanceRequirement.fromMap(Map<String, dynamic> map) {
    return MaintenanceRequirement(
      minimumCGPA: (map['minimumCGPA'] ?? 0.0).toDouble(),
      minimumCreditsPerSemester: map['minimumCreditsPerSemester'] ?? 0,
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'minimumCGPA': minimumCGPA,
      'minimumCreditsPerSemester': minimumCreditsPerSemester,
      'description': description,
    };
  }
}