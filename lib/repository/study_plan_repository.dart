import 'package:campuswhisper/core/repositories/base_repository.dart';
import 'package:campuswhisper/models/study_plan_model.dart';
import 'package:campuswhisper/core/database/query_builder.dart';
import 'package:campuswhisper/core/database/paginated_result.dart';

class StudyPlanRepository extends BaseRepository<StudyPlanModel> {
  @override
  String get collectionName => 'study_plans';

  @override
  StudyPlanModel fromJson(Map<String, dynamic> json) => StudyPlanModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(StudyPlanModel model) => model.toJson();

  @override
  String getId(StudyPlanModel model) => model.id;

  // ═══════════════════════════════════════════════════════════════
  // SPECIALIZED QUERIES
  // ═══════════════════════════════════════════════════════════════

  /// Get study plans by year (with pagination)
  Future<PaginatedResult<StudyPlanModel>> getByYear(
    int year, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [QueryFilter.equals('year', year)],
      sorts: [QuerySort.ascending('semester')],
      limit: limit,
      startAfter: startAfter,
    );
  }

  /// Get study plans by year and semester
  Future<PaginatedResult<StudyPlanModel>> getByYearAndSemester(
    int year,
    int semester, {
    int limit = 20,
    dynamic startAfter,
  }) async {
    return query(
      filters: [
        QueryFilter.equals('year', year),
        QueryFilter.equals('semester', semester),
      ],
      limit: limit,
      startAfter: startAfter,
    );
  }
}
