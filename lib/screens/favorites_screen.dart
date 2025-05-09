import 'package:flutter/material.dart';
import '../models/sign.dart';
import '../services/user_service.dart';
import '../data/signs_data.dart';
import 'sign_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with SingleTickerProviderStateMixin {
  List<Sign> _favoriteSigns = [];
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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

  Future<void> _loadFavorites() async {
    final userProfile = await UserService.getCurrentUser();
    final favoriteIds = userProfile.favorites;
    
    setState(() {
      _favoriteSigns = SignsData.getSignsByIds(favoriteIds);
      _isLoading = false;
    });
  }

  Future<void> _removeFromFavorites(String signId) async {
    await UserService.toggleFavorite(signId);
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis favoritos'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteSigns.isEmpty
              ? _buildEmptyState()
              : _buildFavoritesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No tienes señas favoritas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Añade señas a tus favoritos para acceder rápidamente a ellas',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Explorar categorías'),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    return AnimatedList(
      initialItemCount: _favoriteSigns.length,
      itemBuilder: (context, index, animation) {
        final sign = _favoriteSigns[index];
        
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _animation,
              curve: Interval(
                index * 0.05,
                1.0,
                curve: Curves.easeOut,
              ),
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Dismissible(
                key: Key(sign.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) {
                  _removeFromFavorites(sign.id);
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: sign.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                sign.imageUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              sign.icon,
                              size: 30,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                    ),
                    title: Text(
                      sign.word,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      _getCategoryName(sign.categoryId),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        _removeFromFavorites(sign.id);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignDetailScreen(sign: sign),
                        ),
                      ).then((_) => _loadFavorites());
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
}
