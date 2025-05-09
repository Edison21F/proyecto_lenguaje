import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/user_profile.dart';
import '../services/user_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with SingleTickerProviderStateMixin {
  late UserProfile _userProfile;
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final profile = await UserService.getCurrentUser();
    
    setState(() {
      _userProfile = profile;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverallProgress(),
            const SizedBox(height: 24),
            _buildCategoryChart(),
            const SizedBox(height: 24),
            _buildActivityStats(),
            const SizedBox(height: 24),
            _buildAchievementProgress(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallProgress() {
    final overallProgress = _calculateOverallProgress();
    
    return FadeTransition(
      opacity: _animation,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              'Progreso general',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              width: 150,
              child: Stack(
                children: [
                  Center(
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: CircularProgressIndicator(
                        value: overallProgress,
                        strokeWidth: 12,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${(overallProgress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _getProgressMessage(overallProgress),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChart() {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progreso por categoría',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 1,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.blueGrey,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          String categoryName = _getCategoryName(
                            _userProfile.categoryProgress.keys.elementAt(groupIndex),
                          );
                          return BarTooltipItem(
                            '$categoryName\n${(rod.toY * 100).toInt()}%',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            String text = '';
                            switch (value.toInt()) {
                              case 0:
                                text = 'A';
                                break;
                              case 1:
                                text = 'N';
                                break;
                              case 2:
                                text = 'S';
                                break;
                              case 3:
                                text = 'C';
                                break;
                              case 4:
                                text = 'F';
                                break;
                              case 5:
                                text = 'Al';
                                break;
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                text,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${(value * 100).toInt()}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
                          },
                          reservedSize: 40,
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: _getBarGroups(),
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: 0.2,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withOpacity(0.2),
                          strokeWidth: 1,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityStats() {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Actividad',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard(
                    title: 'Racha actual',
                    value: _userProfile.streak.toString(),
                    icon: Icons.local_fire_department,
                    color: Colors.orange,
                  ),
                  _buildStatCard(
                    title: 'Lecciones',
                    value: _userProfile.completedLessons.length.toString(),
                    icon: Icons.school,
                    color: Colors.blue,
                  ),
                  _buildStatCard(
                    title: 'Puntos',
                    value: _userProfile.totalPoints.toString(),
                    icon: Icons.emoji_events,
                    color: Colors.amber,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementProgress() {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.4),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Logros desbloqueados',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: _calculateAchievementProgress(),
                backgroundColor: Colors.grey[300],
                color: Theme.of(context).colorScheme.primary,
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
              ),
              const SizedBox(height: 10),
              Text(
                '${_getUnlockedAchievementsCount()} de 10 logros desbloqueados',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 30,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  double _calculateOverallProgress() {
    if (_userProfile.categoryProgress.isEmpty) return 0.0;
    
    double totalProgress = 0;
    _userProfile.categoryProgress.forEach((_, progress) {
      totalProgress += progress;
    });
    
    return totalProgress / _userProfile.categoryProgress.length;
  }

  String _getProgressMessage(double progress) {
    if (progress < 0.2) {
      return '¡Estás comenzando! Sigue aprendiendo.';
    } else if (progress < 0.5) {
      return '¡Buen progreso! Vas por buen camino.';
    } else if (progress < 0.8) {
      return '¡Excelente trabajo! Estás dominando las señas.';
    } else {
      return '¡Increíble! Eres casi un experto en lenguaje de señas.';
    }
  }

  List<BarChartGroupData> _getBarGroups() {
    int index = 0;
    return _userProfile.categoryProgress.entries.map((entry) {
      final color = _getCategoryColor(entry.key);
      return BarChartGroupData(
        x: index++,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: color,
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
      );
    }).toList();
  }

  String _getCategoryName(String categoryId) {
    switch (categoryId) {
      case 'alphabet':
        return 'Alfabeto';
      case 'numbers':
        return 'Números';
      case 'greetings':
        return 'Saludos';
      case 'colors':
        return 'Colores';
      case 'family':
        return 'Familia';
      case 'food':
        return 'Alimentos';
      default:
        return categoryId;
    }
  }

  Color _getCategoryColor(String categoryId) {
    switch (categoryId) {
      case 'alphabet':
        return const Color(0xFF6A5AE0);
      case 'numbers':
        return const Color(0xFF61CAFF);
      case 'greetings':
        return const Color(0xFFFF7F5C);
      case 'colors':
        return const Color(0xFF8B5CF6);
      case 'family':
        return const Color(0xFF4CAF50);
      case 'food':
        return const Color(0xFFFF9800);
      default:
        return Colors.grey;
    }
  }

  int _getUnlockedAchievementsCount() {
    int count = 0;
    
    // Logro: Principiante
    if (_userProfile.completedLessons.isNotEmpty) count++;
    
    // Logro: Constante
    if (_userProfile.streak >= 3) count++;
    
    // Logro: Coleccionista
    if (_userProfile.favorites.length >= 5) count++;
    
    // Logro: Experto
    if (_userProfile.totalPoints >= 500) count++;
    
    // Otros logros ficticios para el ejemplo
    if (_calculateOverallProgress() >= 0.3) count++;
    if (_userProfile.categoryProgress.containsKey('alphabet') && 
        _userProfile.categoryProgress['alphabet']! >= 0.5) count++;
    
    return count;
  }

  double _calculateAchievementProgress() {
    return _getUnlockedAchievementsCount() / 10;
  }
}
