import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../models/sign.dart';
import '../services/user_service.dart';
import '../services/video_handler.dart';
import '../services/media_services.dart';
import 'video_player_screen.dart';
import 'dart:io';

class SignDetailScreen extends StatefulWidget {
  final Sign sign;

  const SignDetailScreen({super.key, required this.sign});

  @override
  State<SignDetailScreen> createState() => _SignDetailScreenState();
}

class _SignDetailScreenState extends State<SignDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPlaying = false;
  bool _isFavorite = false;
  final MediaUtils _mediaUtils = MediaUtils();
  
  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isPlaying = false;
          });
          _controller.reset();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadFavoriteStatus() async {
    final isFav = await UserService.isFavorite(widget.sign.id);
    setState(() {
      _isFavorite = isFav;
    });
  }

  void _toggleAnimation() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.forward();
      } else {
        _controller.stop();
        _controller.reset();
      }
    });
  }

  void _playVideo() async {
    if (widget.sign.videoUrl != null) {
      if (VideoHandler.isYoutubeUrl(widget.sign.videoUrl)) {
        // Si es un video de YouTube, abrirlo en el navegador o app
        await VideoHandler.openYoutubeVideo(widget.sign.videoUrl!, context);
      } else {
        // Si es un video normal, utilizar el reproductor interno
        final videoUrl = await _mediaUtils.getVideoUrl(widget.sign.videoUrl!);
        
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                videoUrl: videoUrl,
                title: widget.sign.word,
              ),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay video disponible para esta seña'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _toggleFavorite() async {
    await UserService.toggleFavorite(widget.sign.id);
    await _loadFavoriteStatus();
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isFavorite 
            ? "¡Seña añadida a favoritos!" 
            : "Seña eliminada de favoritos"),
          duration: const Duration(seconds: 2),
          backgroundColor: _isFavorite ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sign.word),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'sign_${widget.sign.id}',
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _buildMediaContent(),
                ),
              ),
              const SizedBox(height: 20),
              if (widget.sign.videoUrl != null)
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _playVideo,
                    icon: const Icon(Icons.play_circle_outline),
                    label: Text(
                      VideoHandler.isYoutubeUrl(widget.sign.videoUrl) 
                          ? "Ver video en YouTube" 
                          : "Ver video demostrativo"
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
              const SizedBox(height: 30),
              Text(
                widget.sign.word,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
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
                    const Text(
                      "Descripción",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.sign.description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
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
                    const Text(
                      "Instrucciones",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.sign.instructions,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    if (widget.sign.steps != null && widget.sign.steps!.isNotEmpty)
                      _buildStepsList(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        "Practica esta seña regularmente para mejorar tu fluidez en el lenguaje de señas.",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.sign.difficulty > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: _buildDifficultyIndicator(),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleFavorite,
        backgroundColor: _isFavorite ? Colors.red : Theme.of(context).colorScheme.tertiary,
        icon: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Colors.white,
        ),
        label: Text(
          _isFavorite ? "Quitar de favoritos" : "Añadir a favoritos",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildMediaContent() {
    // Si hay una URL de imagen, mostrarla
    if (widget.sign.imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FutureBuilder<String>(
          future: _mediaUtils.getImageUrl(widget.sign.imageUrl!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (snapshot.hasData && snapshot.data != null) {
              final imageUrl = snapshot.data!;
              
              // Si es una URL remota
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
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return _buildIconAnimation();
                  },
                );
              }
              
              // Si es un archivo local (cacheado)
              return Image.file(
                File(imageUrl),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return _buildIconAnimation();
                },
              );
            }
            
            return _buildIconAnimation();
          },
        ),
      );
    }
    
    // Si no hay imagen, mostrar la animación de icono
    return _buildIconAnimation();
  }

  Widget _buildIconAnimation() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Círculos decorativos animados
            ...List.generate(5, (index) {
              final delay = index * 0.2;
              final size = 50.0 + (index * 20);
              final opacity = (1.0 - (index * 0.15)).clamp(0.1, 1.0);
              
              return Positioned(
                child: Transform.scale(
                  scale: _isPlaying 
                    ? 1.0 + (_controller.value * 0.5 * (1 - delay)).clamp(0.0, 1.0)
                    : 1.0,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary.withOpacity(
                        _isPlaying ? opacity * _controller.value : opacity * 0.3
                      ),
                    ),
                  ),
                ),
              );
            }),
            
            // Icono principal animado
            Transform.rotate(
              angle: _controller.value * 2 * math.pi * (widget.sign.id.hashCode % 2 == 0 ? 1 : -1),
              child: Transform.scale(
                scale: 1.0 + (_controller.value * 0.3),
                child: Icon(
                  widget.sign.icon,
                  size: 120,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            
            // Botón para iniciar la animación
            if (!_isPlaying)
              Positioned(
                bottom: 20,
                child: ElevatedButton.icon(
                  onPressed: _toggleAnimation,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Ver animación"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildStepsList() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pasos detallados",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.sign.steps!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.sign.steps![index],
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyIndicator() {
    const maxDifficulty = 5;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nivel de dificultad",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(maxDifficulty, (index) {
            final isActive = index < widget.sign.difficulty;
            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(
                Icons.star,
                color: isActive ? Colors.amber : Colors.grey[300],
                size: 24,
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          _getDifficultyDescription(widget.sign.difficulty),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  String _getDifficultyDescription(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'Muy fácil - Ideal para principiantes';
      case 2:
        return 'Fácil - Requiere poca práctica';
      case 3:
        return 'Moderado - Necesita algo de práctica';
      case 4:
        return 'Difícil - Requiere práctica constante';
      case 5:
        return 'Muy difícil - Para usuarios avanzados';
      default:
        return '';
    }
  }
}

// Añadir la clase File para importarla
