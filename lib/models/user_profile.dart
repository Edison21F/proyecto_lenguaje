class UserProfile {
  String id;
  String name;
  String email;
  String? photoUrl;
  Map<String, double> categoryProgress;
  List<String> completedLessons;
  List<String> favorites;
  String avatarColor;
  int totalPoints;
  int streak;
  DateTime lastActive;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.categoryProgress,
    required this.completedLessons,
    required this.favorites,
    required this.avatarColor,
    required this.totalPoints,
    required this.streak,
    required this.lastActive,
  });

  factory UserProfile.createDefault() {
    return UserProfile(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Usuario',
      email: 'usuario@ejemplo.com',
      photoUrl: null,
      categoryProgress: {
        'alphabet': 0.0,
        'numbers': 0.0,
        'greetings': 0.0,
        'colors': 0.0,
        'family': 0.0,
        'food': 0.0,
      },
      completedLessons: [],
      favorites: [],
      avatarColor: '#6A5AE0',
      totalPoints: 0,
      streak: 0,
      lastActive: DateTime.now(),
    );
  }

  void updateProgress(String categoryId, double progress) {
    categoryProgress[categoryId] = progress;
  }

  void addCompletedLesson(String lessonId) {
    if (!completedLessons.contains(lessonId)) {
      completedLessons.add(lessonId);
    }
  }

  void toggleFavorite(String signId) {
    if (favorites.contains(signId)) {
      favorites.remove(signId);
    } else {
      favorites.add(signId);
    }
  }

  void addPoints(int points) {
    totalPoints += points;
  }

  void updateStreak() {
    final now = DateTime.now();
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    
    if (lastActive.day == yesterday.day && 
        lastActive.month == yesterday.month && 
        lastActive.year == yesterday.year) {
      streak += 1;
    } else if (lastActive.day != now.day || 
               lastActive.month != now.month || 
               lastActive.year != now.year) {
      streak = 1;
    }
    
    lastActive = now;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'categoryProgress': categoryProgress,
      'completedLessons': completedLessons,
      'favorites': favorites,
      'avatarColor': avatarColor,
      'totalPoints': totalPoints,
      'streak': streak,
      'lastActive': lastActive.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      categoryProgress: Map<String, double>.from(json['categoryProgress']),
      completedLessons: List<String>.from(json['completedLessons']),
      favorites: List<String>.from(json['favorites']),
      avatarColor: json['avatarColor'],
      totalPoints: json['totalPoints'],
      streak: json['streak'],
      lastActive: DateTime.parse(json['lastActive']),
    );
  }
}
