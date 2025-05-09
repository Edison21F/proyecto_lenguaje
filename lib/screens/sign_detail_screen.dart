import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math' as math;
import '../models/sign.dart';
import '../services/user_service.dart';

class SignDetailScreen extends StatefulWidget {
  final Sign sign;

  const SignDetailScreen({super.key, required this.sign});

  @override
  State<SignDetailScreen> createState() => _SignDetailScreenState();
}

class _SignDetailScreenState extends State<SignDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPlaying = false;
  bool _isFavorite = false;
  VideoPlayerController? _videoController;
  bool _isVideoLoaded = false;
  File? _customImage;

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
    
    if (widget.sign.videoUrl != null) {
      _videoController = VideoPlayerController.asset(widget.sign.videoUrl!)
        ..initialize().then((_) {
          setState(() {
            _isVideoLoaded = true;
          });
        });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _videoController?.dispose();
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

  void _toggleVideo() {
    if (_videoController != null) {
      setState(() {
        if (_videoController!.value.isPlaying) {
          _videoController!.pause();
        } else {
          _videoController!.play();
        }
      });
    }
  }

  Future<void> _toggleFavorite() async {
    await UserService.toggleFavorite(widget.sign.id);
    await _loadFavoriteStatus();
    
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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _customImage = File(image.path);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Imagen personalizada añadida"),
          backgroundColor: Colors.green,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.add_photo_alternate),
                    label: const Text("Añadir imagen"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
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
    // Si hay una imagen personalizada, mostrarla primero
    if (_customImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.file(
          _customImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    
    // Si hay un video y está cargado, mostrar el video
    if (_videoController != null && _isVideoLoaded) {
      return Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
          ),
          IconButton(
            icon: Icon(
              _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              size: 60,
              color: Colors.white.withOpacity(0.8),
            ),
            onPressed: _toggleVideo,
          ),
        ],
      );
    }
    
    // Si hay una imagen, mostrarla
    if (widget.sign.imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          widget.sign.imageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            // Si hay un error al cargar la imagen, mostrar la animación de icono
            return _buildIconAnimation();
          },
        ),
      );
    }
    
    // Si no hay imagen ni video, mostrar la animación de icono
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
}
