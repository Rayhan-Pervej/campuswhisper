import 'package:campuswhisper/models/study_plan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class StudyPlanRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'study_plan';

  // POST: Create a new study plan
  Future<String> createStudyPlan(StudyPlanModel studyPlan) async {
    try {
      // Generate a new document ID first
      DocumentReference docRef = _firestore.collection(_collectionName).doc();
      String generatedId = docRef.id;

      // Create new study plan with the generated ID
      StudyPlanModel studyPlanWithId = StudyPlanModel(
        id: generatedId,
        year: studyPlan.year,
        semester: studyPlan.semester,
        courses: studyPlan.courses,
      );

      // Store data in the document with the generated ID
      await docRef.set(studyPlanWithId.toMap());

      return generatedId;
    } catch (e) {
      throw Exception('Failed to create study plan: $e');
    }
  }

  // POST: Update existing study plan
  Future<void> updateStudyPlan(StudyPlanModel studyPlan) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(studyPlan.id)
          .update(studyPlan.toMap());
    } catch (e) {
      throw Exception('Failed to update study plan: $e');
    }
  }

  // FETCH: Get study plan by ID
  Future<StudyPlanModel?> getStudyPlanById(String studyPlanId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_collectionName)
          .doc(studyPlanId)
          .get();

      if (doc.exists) {
        return StudyPlanModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get study plan by ID: $e');
    }
  }

  // FETCH: Get all study plans
  Future<List<StudyPlanModel>> getAllStudyPlans() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('year')
          .orderBy('semester')
          .get();

      return querySnapshot.docs
          .map(
            (doc) => StudyPlanModel.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get all study plans: $e');
    }
  }

  // FETCH: Get study plan by year and semester
  Future<StudyPlanModel?> getStudyPlanByYearAndSemester(
    int year,
    int semester,
  ) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .where('year', isEqualTo: year)
          .where('semester', isEqualTo: semester)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return StudyPlanModel.fromMap(
          querySnapshot.docs.first.data() as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get study plan by year and semester: $e');
    }
  }

  // FETCH: Get study plans by year
  Future<List<StudyPlanModel>> getStudyPlansByYear(int year) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .where('year', isEqualTo: year)
          .orderBy('semester')
          .get();

      return querySnapshot.docs
          .map(
            (doc) => StudyPlanModel.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get study plans by year: $e');
    }
  }

  // FETCH: Get courses by year and semester
  Future<List<String>> getCoursesByYearAndSemester(
    int year,
    int semester,
  ) async {
    try {
      StudyPlanModel? studyPlan = await getStudyPlanByYearAndSemester(
        year,
        semester,
      );
      return studyPlan?.courses ?? [];
    } catch (e) {
      throw Exception('Failed to get courses by year and semester: $e');
    }
  }

  // FETCH: Get all years available in study plans
  Future<List<int>> getAllYears() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .get();

      Set<int> years = {};
      for (var doc in querySnapshot.docs) {
        StudyPlanModel studyPlan = StudyPlanModel.fromMap(
          doc.data() as Map<String, dynamic>,
        );
        years.add(studyPlan.year);
      }

      return years.toList()..sort();
    } catch (e) {
      throw Exception('Failed to get all years: $e');
    }
  }

  // FETCH: Get complete 4-year curriculum
  Future<Map<int, List<StudyPlanModel>>> getCompleteCurriculum() async {
    try {
      List<StudyPlanModel> allPlans = await getAllStudyPlans();

      Map<int, List<StudyPlanModel>> curriculum = {};
      for (StudyPlanModel plan in allPlans) {
        if (!curriculum.containsKey(plan.year)) {
          curriculum[plan.year] = [];
        }
        curriculum[plan.year]!.add(plan);
      }

      // Sort semesters within each year
      curriculum.forEach((year, plans) {
        plans.sort((a, b) => a.semester.compareTo(b.semester));
      });

      return curriculum;
    } catch (e) {
      throw Exception('Failed to get complete curriculum: $e');
    }
  }
}
