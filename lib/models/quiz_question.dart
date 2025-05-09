import 'package:flutter/material.dart';

class QuizQuestion {
  final String id;
  final String categoryId;
  final String question;
  final List<String> answers;
  final int correctAnswerIndex;
  final IconData icon;
  final String? imageUrl;

  const QuizQuestion({
    required this.id,
    required this.categoryId,
    required this.question,
    required this.answers,
    required this.correctAnswerIndex,
    required this.icon,
    this.imageUrl,
  });
}
