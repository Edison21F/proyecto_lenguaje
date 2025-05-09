import 'package:flutter/material.dart';

class Sign {
  final String id;
  final String categoryId;
  final String word;
  final String description;
  final String instructions;
  final IconData icon;
  final String? imageUrl; // Nueva propiedad para imágenes reales
  final List<String>? steps; // Pasos detallados para realizar la seña
  final String? videoUrl; // URL opcional para video demostrativo
  final int difficulty; // Nivel de dificultad (1-5)

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
