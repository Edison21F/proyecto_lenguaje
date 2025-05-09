import 'package:flutter/material.dart';
import '../models/sign.dart';

class SignsData {
  static List<Sign> getSigns(String categoryId) {
    switch (categoryId) {
      case 'alphabet':
        return _alphabetSigns;
      case 'numbers':
        return _numberSigns;
      case 'greetings':
        return _greetingSigns;
      case 'colors':
        return _colorSigns;
      case 'family':
        return _familySigns;
      case 'food':
        return _foodSigns;
      default:
        return [];
    }
  }

  static List<Sign> getSignsByIds(List<String> signIds) {
    List<Sign> result = [];
    
    for (var id in signIds) {
      // Buscar en todas las categorías
      for (var category in ['alphabet', 'numbers', 'greetings', 'colors', 'family', 'food']) {
        final signs = getSigns(category);
        final sign = signs.where((s) => s.id == id).toList();
        if (sign.isNotEmpty) {
          result.add(sign.first);
          break;
        }
      }
    }
    
    return result;
  }

  static final List<Sign> _alphabetSigns = [
    Sign(
      id: 'a',
      categoryId: 'alphabet',
      word: 'A',
      description: 'La letra A en lenguaje de señas.',
      instructions: 'Cierra el puño con el pulgar al lado.',
      icon: Icons.sign_language,
      imageUrl: 'assets/images/signs/alphabet/a.png',
    ),
    Sign(
      id: 'b',
      categoryId: 'alphabet',
      word: 'B',
      description: 'La letra B en lenguaje de señas.',
      instructions: 'Extiende los dedos hacia arriba con el pulgar doblado hacia la palma.',
      icon: Icons.sign_language,
      imageUrl: 'assets/images/signs/alphabet/b.png',
    ),
    Sign(
      id: 'c',
      categoryId: 'alphabet',
      word: 'C',
      description: 'La letra C en lenguaje de señas.',
      instructions: 'Forma una C con tu mano, curvando los dedos.',
      icon: Icons.sign_language,
      imageUrl: 'assets/images/signs/alphabet/c.png',
    ),
    // Más letras del alfabeto...
  ];

  static final List<Sign> _numberSigns = [
    Sign(
      id: 'num1',
      categoryId: 'numbers',
      word: '1',
      description: 'El número uno en lenguaje de señas.',
      instructions: 'Extiende el dedo índice hacia arriba, manteniendo los demás dedos cerrados.',
      icon: Icons.looks_one,
      imageUrl: 'assets/images/signs/numbers/1.png',
    ),
    Sign(
      id: 'num2',
      categoryId: 'numbers',
      word: '2',
      description: 'El número dos en lenguaje de señas.',
      instructions: 'Extiende los dedos índice y medio hacia arriba, manteniendo los demás dedos cerrados.',
      icon: Icons.looks_two,
      imageUrl: 'assets/images/signs/numbers/2.png',
    ),
    Sign(
      id: 'num3',
      categoryId: 'numbers',
      word: '3',
      description: 'El número tres en lenguaje de señas.',
      instructions: 'Extiende los dedos pulgar, índice y medio hacia arriba, manteniendo los demás dedos cerrados.',
      icon: Icons.looks_3,
      imageUrl: 'assets/images/signs/numbers/3.png',
    ),
    // Más números...
  ];

  static final List<Sign> _greetingSigns = [
    Sign(
      id: 'hello',
      categoryId: 'greetings',
      word: 'Hola',
      description: 'Saludo básico en lenguaje de señas.',
      instructions: 'Coloca tu mano abierta cerca de tu frente y muévela hacia adelante, como un saludo militar.',
      icon: Icons.waving_hand,
      imageUrl: 'assets/images/signs/greetings/hello.png',
      videoUrl: 'assets/videos/signs/greetings/hello.mp4',
    ),
    Sign(
      id: 'goodbye',
      categoryId: 'greetings',
      word: 'Adiós',
      description: 'Despedida en lenguaje de señas.',
      instructions: 'Agita la mano abierta de lado a lado.',
      icon: Icons.waving_hand,
      imageUrl: 'assets/images/signs/greetings/goodbye.png',
      videoUrl: 'assets/videos/signs/greetings/goodbye.mp4',
    ),
    Sign(
      id: 'thanks',
      categoryId: 'greetings',
      word: 'Gracias',
      description: 'Agradecimiento en lenguaje de señas.',
      instructions: 'Toca tus labios con las puntas de los dedos y luego mueve la mano hacia adelante.',
      icon: Icons.favorite,
      imageUrl: 'assets/images/signs/greetings/thanks.png',
      videoUrl: 'assets/videos/signs/greetings/thanks.mp4',
    ),
    // Más saludos...
  ];

  static final List<Sign> _colorSigns = [
    Sign(
      id: 'red',
      categoryId: 'colors',
      word: 'Rojo',
      description: 'El color rojo en lenguaje de señas.',
      instructions: 'Desliza el dedo índice hacia abajo sobre los labios.',
      icon: Icons.circle,
      imageUrl: 'assets/images/signs/colors/red.png',
    ),
    Sign(
      id: 'blue',
      categoryId: 'colors',
      word: 'Azul',
      description: 'El color azul en lenguaje de señas.',
      instructions: 'Agita la mano con los dedos extendidos frente a ti.',
      icon: Icons.circle,
      imageUrl: 'assets/images/signs/colors/blue.png',
    ),
    Sign(
      id: 'yellow',
      categoryId: 'colors',
      word: 'Amarillo',
      description: 'El color amarillo en lenguaje de señas.',
      instructions: 'Agita la mano en forma de Y cerca del hombro.',
      icon: Icons.circle,
      imageUrl: 'assets/images/signs/colors/yellow.png',
    ),
    // Más colores...
  ];

  static final List<Sign> _familySigns = [
    Sign(
      id: 'mother',
      categoryId: 'family',
      word: 'Madre',
      description: 'La palabra madre en lenguaje de señas.',
      instructions: 'Extiende el pulgar de la mano derecha y colócalo en la mejilla.',
      icon: Icons.face,
      imageUrl: 'assets/images/signs/family/mother.png',
    ),
    Sign(
      id: 'father',
      categoryId: 'family',
      word: 'Padre',
      description: 'La palabra padre en lenguaje de señas.',
      instructions: 'Extiende el pulgar de la mano derecha y colócalo en la frente.',
      icon: Icons.face,
      imageUrl: 'assets/images/signs/family/father.png',
    ),
    Sign(
      id: 'sister',
      categoryId: 'family',
      word: 'Hermana',
      description: 'La palabra hermana en lenguaje de señas.',
      instructions: 'Haz la seña de mujer y luego la seña de igual.',
      icon: Icons.face_3,
      imageUrl: 'assets/images/signs/family/sister.png',
    ),
    // Más miembros de la familia...
  ];

  static final List<Sign> _foodSigns = [
    Sign(
      id: 'bread',
      categoryId: 'food',
      word: 'Pan',
      description: 'La palabra pan en lenguaje de señas.',
      instructions: 'Simula cortar una rebanada de pan con la mano derecha sobre la palma izquierda.',
      icon: Icons.bakery_dining,
      imageUrl: 'assets/images/signs/food/bread.png',
    ),
    Sign(
      id: 'water',
      categoryId: 'food',
      word: 'Agua',
      description: 'La palabra agua en lenguaje de señas.',
      instructions: 'Toca tu mentón con el dedo índice y luego bájalo.',
      icon: Icons.water_drop,
      imageUrl: 'assets/images/signs/food/water.png',
    ),
    Sign(
      id: 'apple',
      categoryId: 'food',
      word: 'Manzana',
      description: 'La palabra manzana en lenguaje de señas.',
      instructions: 'Gira el puño cerrado en la mejilla.',
      icon: Icons.apple,
      imageUrl: 'assets/images/signs/food/apple.png',
    ),
    // Más alimentos...
  ];
}
