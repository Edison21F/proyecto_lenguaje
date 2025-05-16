import 'package:flutter/material.dart';

class Sign {
  final String id;
  final String categoryId;
  final String word;
  final String description;
  final String instructions;
  final IconData icon;
  final String? imageUrl; // URL de la imagen
  final List<String>? steps; // Pasos detallados 
  final String? videoUrl; // URL para video
  final int difficulty;

  const Sign({
    required this.id,
    required this.categoryId,
    required this.word,
    required this.description,
    required this.instructions,
    required this.icon,
    this.imageUrl,
    this.steps,
    this.videoUrl,
    this.difficulty = 1,
  });
}
