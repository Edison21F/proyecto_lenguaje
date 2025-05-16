import 'package:flutter/material.dart';
import 'dart:io';
import '../services/media_services.dart';
import '../services/video_handler.dart';

class CachedSignImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final IconData placeholderIcon;
  final Color iconColor;
  final double iconSize;
  final bool forceRemote;

  const CachedSignImage({
    super.key,
    required this.imageUrl,
    this.width = double.infinity,
    this.height = double.infinity,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.placeholderIcon = Icons.sign_language,
    this.iconColor = Colors.black54,
    this.iconSize = 40,
    this.forceRemote = false,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return _buildPlaceholder();
    }

    return FutureBuilder<String>(
      future: MediaUtils().getImageUrl(imageUrl!, forceRemote: forceRemote),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return _buildPlaceholder();
        }

        final resolvedUrl = snapshot.data!;

        // Si es una URL remota
        if (resolvedUrl.startsWith('http')) {
          return ClipRRect(
            borderRadius: borderRadius,
            child: Image.network(
              resolvedUrl,
              width: width,
              height: height,
              fit: fit,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _buildLoadingIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholder();
              },
            ),
          );
        }

        // Si es un archivo local (cacheado)
        return ClipRRect(
          borderRadius: borderRadius,
          child: Image.file(
            File(resolvedUrl),
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholder();
            },
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator({double? value}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: borderRadius,
      ),
      child: Center(
        child: CircularProgressIndicator(
          value: value,
          strokeWidth: 2,
          color: iconColor,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Icon(
          placeholderIcon,
          size: iconSize,
          color: iconColor,
        ),
      ),
    );
  }
}

// Widget similar para videos con previsualización
class VideoThumbnail extends StatelessWidget {
  final String? videoUrl;
  final VoidCallback onTap;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final IconData placeholderIcon;
  final Color iconColor;
  final double iconSize;

  const VideoThumbnail({
    super.key,
    required this.videoUrl,
    required this.onTap,
    this.width = double.infinity,
    this.height = double.infinity,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.placeholderIcon = Icons.video_library,
    this.iconColor = Colors.black54,
    this.iconSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (videoUrl != null && VideoHandler.isYoutubeUrl(videoUrl))
            _buildYouTubeThumbnail()
          else
            _buildDefaultThumbnail(),
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: borderRadius,
            ),
          ),
          Icon(
            Icons.play_circle_outline,
            size: iconSize * 1.5,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildYouTubeThumbnail() {
    final thumbnailUrl = VideoHandler.getYoutubeThumbnailUrl(videoUrl);
    
    if (thumbnailUrl != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.network(
          thumbnailUrl,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultThumbnail();
          },
        ),
      );
    }

    return _buildDefaultThumbnail();
  }

  Widget _buildDefaultThumbnail() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Icon(
          placeholderIcon,
          size: iconSize,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}