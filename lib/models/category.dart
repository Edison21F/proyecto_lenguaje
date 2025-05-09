import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final int itemCount;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.itemCount,
  });
}
