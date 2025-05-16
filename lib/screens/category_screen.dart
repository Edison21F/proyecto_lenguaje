import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/sign.dart';
import '../services/sign_service.dart'; // Usando nuestro nuevo servicio
import '../services/user_service.dart';
import '../services/media_services.dart'; // Agregando nuestro servicio de medios
import 'sign_detail_screen.dart';
import 'quiz_screen.dart';
import 'dart:io';

class CategoryScreen extends StatefulWidget {
  final Category category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with SingleTickerProviderStateMixin {
  late List<Sign> signs = [];
  bool _isLoading = true;
  late AnimationController _controller;
  late Animation<double> _animation;
  double _categoryProgress = 0.0;
  final MediaUtils _mediaUtils = MediaUtils();

  @override
  void initState() {
    super.initState();
    _loadData();
    
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

  Future<void> _loadData() async {
    // Simular carga de datos
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Verificar si el widget todavía está montado antes de continuar
    if (!mounted) return;
    
    // Cargar señas usando el nuevo servicio
    final loadedSigns = await SignService.getSignsByCategory(widget.category.id);
    
    // Cargar progreso de la categoría
    final userProfile = await UserService.getCurrentUser();
    final progress = userProfile.categoryProgress[widget.category.id] ?? 0.0;
    
    // Verificar nuevamente si el widget todavía está montado antes de actualizar el estado
    if (!mounted) return;
    
    // Pre-cachear imágenes para uso sin conexión
    List<String> imageUrls = [];
    List<String> videoUrls = [];
    
    for (var sign in loadedSigns) {
      if (sign.imageUrl != null && sign.imageUrl!.startsWith('http')) {
        imageUrls.add(sign.imageUrl!);
      }
      if (sign.videoUrl != null && sign.videoUrl!.startsWith('http')) {
        videoUrls.add(sign.videoUrl!);
      }
    }
    
    // Realizar cacheo en segundo plano
    _mediaUtils.preCacheMedia(imageUrls, videoUrls);
    
    // Verificar nuevamente si el widget todavía está montado antes de actualizar el estado
    if (!mounted) return;
    
    setState(() {
      signs = loadedSigns;
      _categoryProgress = progress;
      _isLoading = false;
    });
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
          : CustomScrollView(
              slivers: [
                _buildAppBar(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProgressSection(),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Señas (${signs.length})",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizScreen(category: widget.category),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.quiz),
                              label: const Text("Iniciar quiz"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return FadeTransition(
                        opacity: _animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: _controller,
                              curve: Interval(
                                index * 0.05,
                                1.0,
                                curve: Curves.easeOut,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: _buildSignCard(signs[index]),
                          ),
                        ),
                      );
                    },
                    childCount: signs.length,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
              ],
            ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      backgroundColor: widget.category.color,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.category.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Fondo con degradado
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    widget.category.color,
                    widget.category.color.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Patrón decorativo
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
            // Icono de la categoría
            Align(
              alignment: Alignment.center,
              child: Icon(
                widget.category.icon,
                size: 80,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.quiz, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizScreen(category: widget.category),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tu progreso",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                "${(_categoryProgress * 100).toInt()}%",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.category.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: _categoryProgress,
            backgroundColor: Colors.grey[300],
            color: widget.category.color,
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 10),
          Text(
            _getProgressMessage(_categoryProgress),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignCard(Sign sign) {
    return Hero(
      tag: 'sign_${sign.id}',
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => 
                  SignDetailScreen(sign: sign),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
            // Importante: eliminamos la llamada a _loadData() aquí para prevenir el error
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: widget.category.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: sign.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _buildNetworkImage(sign.imageUrl!),
                        )
                      : Icon(
                          sign.icon,
                          size: 40,
                          color: widget.category.color,
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sign.word,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Toca para ver la seña',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      if (sign.videoUrl != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.videocam,
                                size: 16,
                                color: widget.category.color,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Video disponible',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: widget.category.color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: widget.category.color,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkImage(String url) {
    return FutureBuilder<String>(
      future: _mediaUtils.getImageUrl(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (!snapshot.hasData || snapshot.data == null) {
          return Icon(
            Icons.image_not_supported,
            size: 40,
            color: widget.category.color,
          );
        }
        
        final imageUrl = snapshot.data!;
        
        // Si la imagen es remota, usar Image.network
        if (imageUrl.startsWith('http')) {
          return Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                  color: widget.category.color,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.image_not_supported,
                size: 40,
                color: widget.category.color,
              );
            },
          );
        }
        
        // Si la imagen es local (cacheada), usar Image.file
        return Image.file(
          File(imageUrl),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.image_not_supported,
              size: 40,
              color: widget.category.color,
            );
          },
        );
      },
    );
  }

  String _getProgressMessage(double progress) {
    if (progress < 0.2) {
      return 'Estás comenzando. ¡Sigue aprendiendo!';
    } else if (progress < 0.5) {
      return 'Buen progreso. Continúa practicando.';
    } else if (progress < 0.8) {
      return '¡Excelente trabajo! Ya dominas varias señas.';
    } else {
      return '¡Casi completo! Eres un experto en esta categoría.';
    }
  }
}

// Añadir la clase File para importarla
