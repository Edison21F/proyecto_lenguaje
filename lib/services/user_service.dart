import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class UserService {
  static const String _userKey = 'user_profile';
  static UserProfile? _currentUser;

  // Obtener el perfil del usuario
  static Future<UserProfile> getCurrentUser() async {
    if (_currentUser != null) {
      return _currentUser!;
    }

    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);

    if (userJson != null) {
      _currentUser = UserProfile.fromJson(json.decode(userJson));
      return _currentUser!;
    }

    // Si no existe un perfil, crear uno por defecto
    _currentUser = UserProfile.createDefault();
    await saveUser(_currentUser!);
    return _currentUser!;
  }

  // Guardar el perfil del usuario
  static Future<void> saveUser(UserProfile user) async {
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }

  // Actualizar el progreso de una categoría
  static Future<void> updateCategoryProgress(String categoryId, double progress) async {
    final user = await getCurrentUser();
    user.updateProgress(categoryId, progress);
    await saveUser(user);
  }

  // Marcar una lección como completada
  static Future<void> completeLesson(String lessonId) async {
    final user = await getCurrentUser();
    user.addCompletedLesson(lessonId);
    await saveUser(user);
  }

  // Alternar una seña como favorita
  static Future<void> toggleFavorite(String signId) async {
    final user = await getCurrentUser();
    user.toggleFavorite(signId);
    await saveUser(user);
  }

  // Verificar si una seña es favorita
  static Future<bool> isFavorite(String signId) async {
    final user = await getCurrentUser();
    return user.favorites.contains(signId);
  }

  // Añadir puntos al usuario
  static Future<void> addPoints(int points) async {
    final user = await getCurrentUser();
    user.addPoints(points);
    await saveUser(user);
  }

  // Actualizar la racha de días consecutivos
  static Future<void> updateStreak() async {
    final user = await getCurrentUser();
    user.updateStreak();
    await saveUser(user);
  }

  // Actualizar el perfil del usuario
  static Future<void> updateProfile({
    String? name,
    String? email,
    String? photoUrl,
    String? avatarColor,
  }) async {
    final user = await getCurrentUser();
    
    if (name != null) user.name = name;
    if (email != null) user.email = email;
    if (photoUrl != null) user.photoUrl = photoUrl;
    if (avatarColor != null) user.avatarColor = avatarColor;
    
    await saveUser(user);
  }

  // Obtener el progreso general del usuario
  static Future<double> getOverallProgress() async {
    final user = await getCurrentUser();
    
    if (user.categoryProgress.isEmpty) return 0.0;
    
    double totalProgress = 0;
    user.categoryProgress.forEach((_, progress) {
      totalProgress += progress;
    });
    
    return totalProgress / user.categoryProgress.length;
  }
}
