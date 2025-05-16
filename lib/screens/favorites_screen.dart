import 'package:flutter/material.dart';
import '../models/sign.dart';
import '../services/user_service.dart';
import '../services/sign_service.dart';
import '../services/media_services.dart';
import 'sign_detail_screen.dart';
// Añadir la clase File para importarla
import 'dart:io';

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
  final MediaUtils _mediaUtils = MediaUtils();

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
    // Verificar si el widget todavía está montado
    if (!mounted) return;
    
    final userProfile = await UserService.getCurrentUser();
    final favoriteIds = userProfile.favorites;
    
    final signs = await SignService.getSignsByIds(favoriteIds);
    
    // Verificar nuevamente si el widget todavía está montado
    if (!mounted) return;
    
    setState(() {
      _favoriteSigns = signs;
      _isLoading = false;
    });
  }

  Future<void> _removeFromFavorites(String signId) async {
    // Verificar si el widget todavía está montado
    if (!mounted) return;
    
    await UserService.toggleFavorite(signId);
    
    // Recargar los favoritos
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
    return ListView.builder(
      itemCount: _favoriteSigns.length,
      itemBuilder: (context, index) {
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
            opacity: _animation,
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
                    leading: _buildLeadingImage(sign),
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
                      );
                      // Importante: No llamamos a _loadFavorites() aquí para evitar el error
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

  Widget _buildLeadingImage(Sign sign) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: sign.imageUrl != null
          ? FutureBuilder<String>(
              future: _mediaUtils.getImageUrl(sign.imageUrl!),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Icon(
                    sign.icon,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  );
                }

                final imageUrl = snapshot.data!;
                
                if (imageUrl.startsWith('http')) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          sign.icon,
                          size: 30,
                          color: Theme.of(context).colorScheme.primary,
                        );
                      },
                    ),
                  );
                } else {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(imageUrl),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          sign.icon,
                          size: 30,
                          color: Theme.of(context).colorScheme.primary,
                        );
                      },
                    ),
                  );
                }
              },
            )
          : Icon(
              sign.icon,
              size: 30,
              color: Theme.of(context).colorScheme.primary,
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
}

