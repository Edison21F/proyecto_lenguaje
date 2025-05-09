import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../services/user_service.dart';
import '../widgets/animated_progress_bar.dart';
import '../widgets/achievement_card.dart';
import '../widgets/confetti_overlay.dart';
import 'edit_profile_screen.dart';
import 'favorites_screen.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late UserProfile _userProfile;
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _showConfetti = false;

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
    
    // Actualizar racha diaria
    await UserService.updateStreak();
    
    // Verificar si es la primera vez que se abre el perfil
    final prefs = await SharedPreferences.getInstance();
    final firstProfileVisit = prefs.getBool('first_profile_visit') ?? true;
    
    if (firstProfileVisit) {
      setState(() {
        _showConfetti = true;
      });
      
      await prefs.setBool('first_profile_visit', false);
      
      // Ocultar confeti después de 3 segundos
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showConfetti = false;
          });
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      // En una aplicación real, aquí subirías la imagen a un servidor
      // y obtendrías una URL. Para este ejemplo, solo guardamos la ruta local.
      await UserService.updateProfile(photoUrl: image.path);
      _loadUserProfile();
    }
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
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileStats(),
                      const SizedBox(height: 24),
                      _buildProgressSection(),
                      const SizedBox(height: 24),
                      _buildAchievementsSection(),
                      const SizedBox(height: 24),
                      _buildActionsSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_showConfetti) const ConfettiOverlay(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          _userProfile.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ),
            ),
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -30,
              bottom: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Hero(
                    tag: 'profile_image',
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: _userProfile.photoUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                File(_userProfile.photoUrl!),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 50,
                              color: Color(int.parse('0xFF${_userProfile.avatarColor.substring(1)}')),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditProfileScreen(),
              ),
            );
            _loadUserProfile();
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProfileStats() {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(_animation),
        child: Container(
          padding: const EdgeInsets.all(16),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.emoji_events,
                value: _userProfile.totalPoints.toString(),
                label: 'Puntos',
                color: Colors.amber,
              ),
              _buildStatItem(
                icon: Icons.local_fire_department,
                value: _userProfile.streak.toString(),
                label: 'Racha',
                color: Colors.orange,
              ),
              _buildStatItem(
                icon: Icons.check_circle,
                value: _userProfile.completedLessons.length.toString(),
                label: 'Completadas',
                color: Colors.green,
              ),
              _buildStatItem(
                icon: Icons.favorite,
                value: _userProfile.favorites.length.toString(),
                label: 'Favoritos',
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tu progreso',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            ..._userProfile.categoryProgress.entries.map((entry) {
              final categoryName = _getCategoryName(entry.key);
              final progress = entry.value;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          categoryName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AnimatedProgressBar(
                      progress: progress,
                      color: _getCategoryColor(entry.key),
                      height: 10,
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.4),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Logros',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Ver todos los logros
                  },
                  child: const Text('Ver todos'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  AchievementCard(
                    title: 'Principiante',
                    description: 'Completa tu primera lección',
                    icon: Icons.school,
                    color: Colors.blue,
                    isUnlocked: _userProfile.completedLessons.isNotEmpty,
                  ),
                  AchievementCard(
                    title: 'Constante',
                    description: 'Mantén una racha de 3 días',
                    icon: Icons.calendar_today,
                    color: Colors.orange,
                    isUnlocked: _userProfile.streak >= 3,
                  ),
                  AchievementCard(
                    title: 'Coleccionista',
                    description: 'Añade 5 señas a favoritos',
                    icon: Icons.favorite,
                    color: Colors.red,
                    isUnlocked: _userProfile.favorites.length >= 5,
                  ),
                  AchievementCard(
                    title: 'Experto',
                    description: 'Obtén 500 puntos',
                    icon: Icons.emoji_events,
                    color: Colors.amber,
                    isUnlocked: _userProfile.totalPoints >= 500,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection() {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acciones rápidas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              icon: Icons.favorite,
              label: 'Mis favoritos',
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              icon: Icons.bar_chart,
              label: 'Estadísticas',
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StatisticsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              icon: Icons.share,
              label: 'Compartir app',
              color: Colors.green,
              onTap: () {
                // Compartir la aplicación
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Compartiendo la aplicación...'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
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
}
