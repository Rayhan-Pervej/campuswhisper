import 'package:flutter/material.dart';
import 'package:campuswhisper/core/providers/base_provider.dart';
import 'package:campuswhisper/models/user_model.dart';
import 'package:campuswhisper/repository/user_repository.dart';

class UserProvider extends BaseProvider {
  final UserRepository _repository = UserRepository();

  UserModel? _currentUser;
  List<UserModel> _topContributors = [];

  // ═══════════════════════════════════════════════════════════════
  // GETTERS
  // ═══════════════════════════════════════════════════════════════

  UserModel? get currentUser => _currentUser;
  List<UserModel> get topContributors => _topContributors;

  bool get isAuthenticated => _currentUser != null;
  String get userName => _currentUser != null
      ? '${_currentUser!.firstName} ${_currentUser!.lastName}'
      : 'Guest';
  int get userXP => _currentUser?.xp ?? 0;
  int get userLevel => _calculateLevel(_currentUser?.xp ?? 0);
  List<String> get userBadges => _currentUser?.badges ?? [];

  // ═══════════════════════════════════════════════════════════════
  // USER OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Load current user by ID
  Future<void> loadUser(String userId) async {
    setLoading();
    try {
      _currentUser = await _repository.getById(userId);
      setLoaded();
      notifyListeners();
    } catch (e) {
      setError(e.toString());
    }
  }

  /// Update current user
  Future<void> updateUser(BuildContext context, UserModel user) async {
    await safeOperation(
      context,
      operation: () => _repository.update(user),
      successMessage: 'Profile updated successfully!',
      errorMessage: 'Failed to update profile. Please try again.',
    );

    if (_currentUser?.id == user.id) {
      _currentUser = user;
      notifyListeners();
    }
  }

  /// Set current user (for login/signup)
  void setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  /// Clear current user (for logout)
  void clearUser() {
    _currentUser = null;
    _topContributors = [];
    setInitial();
    notifyListeners();
  }

  /// Load top contributors (for leaderboard)
  Future<void> loadTopContributors() async {
    try {
      final result = await _repository.getTopContributors(limit: 10);
      _topContributors = result.items;
      notifyListeners();
    } catch (e) {
      // Silently fail for top contributors
    }
  }

  /// Add XP points to current user
  Future<void> addXP(BuildContext context, int xpAmount) async {
    if (_currentUser == null) return;

    final updatedUser = UserModel(
      uid: _currentUser!.uid,
      id: _currentUser!.id,
      firstName: _currentUser!.firstName,
      lastName: _currentUser!.lastName,
      email: _currentUser!.email,
      university: _currentUser!.university,
      department: _currentUser!.department,
      batch: _currentUser!.batch,
      xp: _currentUser!.xp + xpAmount,
      contributions: _currentUser!.contributions,
      badges: _currentUser!.badges,
      favoriteCourses: _currentUser!.favoriteCourses,
      notifyMe: _currentUser!.notifyMe,
      theme: _currentUser!.theme,
      role: _currentUser!.role,
      createdAt: _currentUser!.createdAt,
      lastLogin: _currentUser!.lastLogin,
    );

    await safeOperationQuiet(
      context,
      operation: () => _repository.update(updatedUser),
    );

    _currentUser = updatedUser;
    notifyListeners();
  }

  /// Increment contribution count
  Future<void> incrementContributions(BuildContext context) async {
    if (_currentUser == null) return;

    final updatedUser = UserModel(
      uid: _currentUser!.uid,
      id: _currentUser!.id,
      firstName: _currentUser!.firstName,
      lastName: _currentUser!.lastName,
      email: _currentUser!.email,
      university: _currentUser!.university,
      department: _currentUser!.department,
      batch: _currentUser!.batch,
      xp: _currentUser!.xp,
      contributions: _currentUser!.contributions + 1,
      badges: _currentUser!.badges,
      favoriteCourses: _currentUser!.favoriteCourses,
      notifyMe: _currentUser!.notifyMe,
      theme: _currentUser!.theme,
      role: _currentUser!.role,
      createdAt: _currentUser!.createdAt,
      lastLogin: _currentUser!.lastLogin,
    );

    await safeOperationQuiet(
      context,
      operation: () => _repository.update(updatedUser),
    );

    _currentUser = updatedUser;
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Calculate user level from XP points
  int _calculateLevel(int xp) {
    // Simple level calculation: 100 XP per level
    return (xp / 100).floor() + 1;
  }

  /// Get XP needed for next level
  int getXPForNextLevel() {
    final currentLevel = userLevel;
    final xpForCurrentLevel = (currentLevel - 1) * 100;
    final xpForNextLevel = currentLevel * 100;
    return xpForNextLevel - userXP;
  }

  /// Get progress percentage to next level
  double getLevelProgress() {
    final xpInCurrentLevel = userXP % 100; // XP within current level
    return xpInCurrentLevel / 100; // Always 100 XP per level
  }
}
