import 'package:flutter/material.dart';
import 'package:senas_contigo/screens/daily_challenge_screen.dart';
import 'package:senas_contigo/screens/search_screen.dart';
import '../widgets/category_card.dart';
import '../models/category.dart';
import '../data/categories_data.dart';
import '../services/user_service.dart';
import 'about_screen.dart';
import 'category_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final List<Category> categories = CategoriesData.categories;
  String _userName = 'Usuario';
  double _overallProgress = 0.0;
  int _streak = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _loadUserData();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  Future<void> _loadUserData() async {
    try {
      final userProfile = await UserService.getCurrentUser();
      final progress = await UserService.getOverallProgress();

      setState(() {
        _userName = userProfile.name;
        _overallProgress = progress;
        _streak = userProfile.streak;
        _isLoading = false;
      });

      // Actualizar racha diaria
      await UserService.updateStreak();
    } catch (e) {
      // Manejo de errores
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los datos: $e')),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildDailyChallenge(),
                  const SizedBox(height: 20),
                  _buildCategorySection(),
                  const SizedBox(height: 10),
                  _buildCategoryGrid(),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateTo(const AboutScreen()),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.info_outline, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(),
          const SizedBox(height: 20),
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "¡Hola, $_userName!",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
                const SizedBox(width: 5),
                Text(
                  "$_streak días consecutivos",
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () => _navigateTo(const ProfileScreen()),
          child: Hero(
            tag: 'profile_image',
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: const Icon(Icons.person, color: Color(0xFF6A5AE0)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tu progreso",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: _overallProgress,
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                "${(_overallProgress * 100).toInt()}% completado",
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () => _navigateTo(const SearchScreen()),
        ),
      ],
    );
  }

  Widget _buildDailyChallenge() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: () => _navigateTo(const DailyChallengeScreen()),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFFFF7F5C), const Color(0xFFFF7F5C).withOpacity(0.8)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF7F5C).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Text(
            "¡Desafío diario disponible!",
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Categorías",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          TextButton(
            onPressed: () {
              // Acción para ver todas las categorías
            },
            child: const Text("Ver todas"),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Expanded(
      child: FadeTransition(
        opacity: _animation,
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return CategoryCard(
              category: categories[index],
              onTap: () => _navigateTo(CategoryScreen(category: categories[index])),
            );
          },
        ),
      ),
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    ).then((_) => _loadUserData());
  }
}