import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoHandler {
  // Verifica si es una URL de YouTube
  static bool isYoutubeUrl(String? url) {
    if (url == null) return false;
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  // Abre un video de YouTube en el navegador o app de YouTube
  static Future<void> openYoutubeVideo(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Mostrar mensaje de error si no se puede abrir
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudo abrir el video de YouTube'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir el video: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Obtiene la miniatura de un video de YouTube
  static String? getYoutubeThumbnailUrl(String? url) {
    if (url == null) return null;
    
    // Extraer el ID del video de YouTube
    final RegExp regExp = RegExp(
      r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})',
    );
    final Match? match = regExp.firstMatch(url);

    if (match != null && match.groupCount >= 1) {
      final String videoId = match.group(1)!;
      return 'https://img.youtube.com/vi/$videoId/0.jpg';
    }
    
    return null;
  }
}