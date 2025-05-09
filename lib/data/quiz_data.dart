import 'package:flutter/material.dart';
import '../models/quiz_question.dart';

class QuizData {
  static List<QuizQuestion> getQuestions(String categoryId) {
    switch (categoryId) {
      case 'alphabet':
        return _alphabetQuestions;
      case 'numbers':
        return _numberQuestions;
      case 'greetings':
        return _greetingQuestions;
      case 'colors':
        return _colorQuestions;
      case 'family':
        return _familyQuestions;
      case 'food':
        return _foodQuestions;
      default:
        return [];
    }
  }

  static final List<QuizQuestion> _alphabetQuestions = [
    QuizQuestion(
      id: 'q_a',
      categoryId: 'alphabet',
      question: '¿Qué letra representa esta seña?',
      answers: ['A', 'B', 'C', 'D'],
      correctAnswerIndex: 0,
      icon: Icons.sign_language,
      imageUrl: 'assets/images/alphabet/a.png',
    ),
    QuizQuestion(
      id: 'q_b',
      categoryId: 'alphabet',
      question: '¿Qué letra representa esta seña?',
      answers: ['E', 'B', 'F', 'G'],
      correctAnswerIndex: 1,
      icon: Icons.sign_language,
      imageUrl: 'assets/images/alphabet/b.png',
    ),
    QuizQuestion(
      id: 'q_c',
      categoryId: 'alphabet',
      question: '¿Qué letra representa esta seña?',
      answers: ['H', 'I', 'C', 'J'],
      correctAnswerIndex: 2,
      icon: Icons.sign_language,
      imageUrl: 'assets/images/alphabet/c.png',
    ),
    // Más preguntas de alfabeto...
  ];

  static final List<QuizQuestion> _numberQuestions = [
    QuizQuestion(
      id: 'q_num1',
      categoryId: 'numbers',
      question: '¿Qué número representa esta seña?',
      answers: ['1', '2', '3', '4'],
      correctAnswerIndex: 0,
      icon: Icons.looks_one,
      imageUrl: 'assets/images/numbers/1.png',
    ),
    QuizQuestion(
      id: 'q_num2',
      categoryId: 'numbers',
      question: '¿Qué número representa esta seña?',
      answers: ['5', '2', '7', '8'],
      correctAnswerIndex: 1,
      icon: Icons.looks_two,
      imageUrl: 'assets/images/numbers/2.png',
    ),
    QuizQuestion(
      id: 'q_num3',
      categoryId: 'numbers',
      question: '¿Qué número representa esta seña?',
      answers: ['9', '10', '3', '11'],
      correctAnswerIndex: 2,
      icon: Icons.looks_3,
      imageUrl: 'assets/images/numbers/3.png',
    ),
    // Más preguntas de números...
  ];

  static final List<QuizQuestion> _greetingQuestions = [
    QuizQuestion(
      id: 'q_hello',
      categoryId: 'greetings',
      question: '¿Qué saludo representa esta seña?',
      answers: ['Hola', 'Adiós', 'Buenos días', 'Buenas noches'],
      correctAnswerIndex: 0,
      icon: Icons.waving_hand,
      imageUrl: 'assets/images/greetings/hello.png',
    ),
    QuizQuestion(
      id: 'q_goodbye',
      categoryId: 'greetings',
      question: '¿Qué despedida representa esta seña?',
      answers: ['Hasta mañana', 'Adiós', 'Hasta luego', 'Nos vemos'],
      correctAnswerIndex: 1,
      icon: Icons.waving_hand,
      imageUrl: 'assets/images/greetings/goodbye.png',
    ),
    QuizQuestion(
      id: 'q_thanks',
      categoryId: 'greetings',
      question: '¿Qué expresión representa esta seña?',
      answers: ['Por favor', 'De nada', 'Gracias', 'Disculpa'],
      correctAnswerIndex: 2,
      icon: Icons.favorite,
      imageUrl: 'assets/images/greetings/thanks.png',
    ),
    // Más preguntas de saludos...
  ];

  static final List<QuizQuestion> _colorQuestions = [
    QuizQuestion(
      id: 'q_red',
      categoryId: 'colors',
      question: '¿Qué color representa esta seña?',
      answers: ['Rojo', 'Azul', 'Verde', 'Amarillo'],
      correctAnswerIndex: 0,
      icon: Icons.circle,
      imageUrl: 'assets/images/colors/red.png',
    ),
    QuizQuestion(
      id: 'q_blue',
      categoryId: 'colors',
      question: '¿Qué color representa esta seña?',
      answers: ['Negro', 'Azul', 'Blanco', 'Morado'],
      correctAnswerIndex: 1,
      icon: Icons.circle,
      imageUrl: 'assets/images/colors/blue.png',
    ),
    QuizQuestion(
      id: 'q_yellow',
      categoryId: 'colors',
      question: '¿Qué color representa esta seña?',
      answers: ['Naranja', 'Verde', 'Amarillo', 'Café'],
      correctAnswerIndex: 2,
      icon: Icons.circle,
      imageUrl: 'assets/images/colors/yellow.png',
    ),
    // Más preguntas de colores...
  ];

  static final List<QuizQuestion> _familyQuestions = [
    QuizQuestion(
      id: 'q_mother',
      categoryId: 'family',
      question: '¿Qué miembro de la familia representa esta seña?',
      answers: ['Madre', 'Hermana', 'Tía', 'Abuela'],
      correctAnswerIndex: 0,
      icon: Icons.face,
      imageUrl: 'assets/images/family/mother.png',
    ),
    QuizQuestion(
      id: 'q_father',
      categoryId: 'family',
      question: '¿Qué miembro de la familia representa esta seña?',
      answers: ['Tío', 'Padre', 'Hermano', 'Abuelo'],
      correctAnswerIndex: 1,
      icon: Icons.face,
      imageUrl: 'assets/images/family/father.png',
    ),
    QuizQuestion(
      id: 'q_sister',
      categoryId: 'family',
      question: '¿Qué miembro de la familia representa esta seña?',
      answers: ['Prima', 'Madre', 'Hermana', 'Hija'],
      correctAnswerIndex: 2,
      icon: Icons.face_3,
      imageUrl: 'assets/images/family/sister.png',
    ),
    // Más preguntas de familia...
  ];

  static final List<QuizQuestion> _foodQuestions = [
    QuizQuestion(
      id: 'q_bread',
      categoryId: 'food',
      question: '¿Qué alimento representa esta seña?',
      answers: ['Pan', 'Arroz', 'Pasta', 'Galleta'],
      correctAnswerIndex: 0,
      icon: Icons.bakery_dining,
      imageUrl: 'assets/images/food/bread.png',
    ),
    QuizQuestion(
      id: 'q_water',
      categoryId: 'food',
      question: '¿Qué bebida representa esta seña?',
      answers: ['Jugo', 'Agua', 'Leche', 'Café'],
      correctAnswerIndex: 1,
      icon: Icons.water_drop,
      imageUrl: 'assets/images/food/water.png',
    ),
    QuizQuestion(
      id: 'q_apple',
      categoryId: 'food',
      question: '¿Qué fruta representa esta seña?',
      answers: ['Naranja', 'Plátano', 'Manzana', 'Pera'],
      correctAnswerIndex: 2,
      icon: Icons.apple,
      imageUrl: 'assets/images/food/apple.png',
    ),
    // Más preguntas de alimentos...
  ];
}
