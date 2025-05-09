import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoriesData {
  static const List<Category> categories = [
    Category(
      id: 'alphabet',
      name: 'Alfabeto',
      icon: Icons.abc,
      color: Color(0xFF6A5AE0),
      itemCount: 27,
    ),
    Category(
      id: 'numbers',
      name: 'Números',
      icon: Icons.format_list_numbered,
      color: Color(0xFF61CAFF),
      itemCount: 20,
    ),
    Category(
      id: 'greetings',
      name: 'Saludos',
      icon: Icons.waving_hand,
      color: Color(0xFFFF7F5C),
      itemCount: 10,
    ),
    Category(
      id: 'colors',
      name: 'Colores',
      icon: Icons.palette,
      color: Color(0xFF8B5CF6),
      itemCount: 12,
    ),
    Category(
      id: 'family',
      name: 'Familia',
      icon: Icons.family_restroom,
      color: Color(0xFF4CAF50),
      itemCount: 15,
    ),
    Category(
      id: 'food',
      name: 'Alimentos',
      icon: Icons.restaurant,
      color: Color(0xFFFF9800),
      itemCount: 18,
    ),
  ];
}
