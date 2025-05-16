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
    const Sign(
      id: 'a',
      categoryId: 'alphabet',
      word: 'A',
      description: 'La letra A en lenguaje de señas.',
      instructions: 'Cierra el puño con el pulgar al lado.',
      icon: Icons.sign_language,
      imageUrl: 'https://previews.123rf.com/images/pchvector/pchvector2211/pchvector221101908/194247113-mano-que-muestra-la-letra-a-ilustraci%C3%B3n-de-vector-de-alfabeto-de-lenguaje-de-se%C3%B1as-dedo-en-posici%C3%B3n-.jpg',
    ),
    const Sign(
      id: 'b',
      categoryId: 'alphabet',
      word: 'B',
      description: 'La letra B en lenguaje de señas.',
      instructions: 'Extiende los dedos hacia arriba con el pulgar doblado hacia la palma.',
      icon: Icons.sign_language,
      imageUrl: 'https://media.istockphoto.com/id/1441720791/es/vector/mano-mostrando-la-letra-b-ilustraci%C3%B3n-vectorial-del-alfabeto-de-lengua-de-signos-dedo-en.jpg?s=1024x1024&w=is&k=20&c=ub8WjHz3fCvsNYZAU1VkJy6vuVNxHzvwzyxB_vV2Y4w=',
    ),
    const Sign(
      id: 'c',
      categoryId: 'alphabet',
      word: 'C',
      description: 'La letra C en lenguaje de señas.',
      instructions: 'Forma una C con tu mano, curvando los dedos.',
      icon: Icons.sign_language,
      imageUrl: 'https://previews.123rf.com/images/pchvector/pchvector2211/pchvector221101901/194247086-mano-que-muestra-la-letra-c-lenguaje-de-se%C3%B1as-alfabeto-ilustraci%C3%B3n-vectorial-dedo-en-diferente-posic.jpg'
          ),
    const Sign(
      id: 'd',
      categoryId: 'alphabet',
      word: 'D',
      description: 'La letra D en lenguaje de señas.',
      instructions: 'Forma una D con tu mano, manteniendo el dedo índice extendido y los demás dedos cerrados.',
      icon: Icons.sign_language,
      imageUrl: 'https://previews.123rf.com/images/pchvector/pchvector2211/pchvector221101881/194247084-mano-que-muestra-la-letra-d-ilustraci%C3%B3n-de-vector-de-alfabeto-de-lenguaje-de-se%C3%B1as-dedo-en-posici%C3%B3n-.jpg'
    )
  ];

  static final List<Sign> _numberSigns = [
    const Sign(
      id: 'num1',
      categoryId: 'numbers',
      word: '1',
      description: 'El número uno en lenguaje de señas.',
      instructions: 'Extiende el dedo índice hacia arriba, manteniendo los demás dedos cerrados.',
      icon: Icons.looks_one,
      imageUrl: 'assets/images/signs/numbers/1.png',
    ),
    const Sign(
      id: 'num2',
      categoryId: 'numbers',
      word: '2',
      description: 'El número dos en lenguaje de señas.',
      instructions: 'Extiende los dedos índice y medio hacia arriba, manteniendo los demás dedos cerrados.',
      icon: Icons.looks_two,
      imageUrl: 'assets/images/signs/numbers/2.png',
    ),
    const Sign(
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
    const Sign(
      id: 'hello',
      categoryId: 'greetings',
      word: 'Hola',
      description: 'Saludo básico en lenguaje de señas.',
      instructions: 'Coloca tu mano abierta cerca de tu frente y muévela hacia adelante, como un saludo militar.',
      icon: Icons.waving_hand,
      imageUrl: 'assets/images/signs/greetings/hello.png',
      videoUrl: 'assets/videos/signs/greetings/hello.mp4',
    ),
    const Sign(
      id: 'goodbye',
      categoryId: 'greetings',
      word: 'Adiós',
      description: 'Despedida en lenguaje de señas.',
      instructions: 'Agita la mano abierta de lado a lado.',
      icon: Icons.waving_hand,
      imageUrl: 'assets/images/signs/greetings/goodbye.png',
      videoUrl: 'assets/videos/signs/greetings/goodbye.mp4',
    ),
    const Sign(
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
    const Sign(
      id: 'red',
      categoryId: 'colors',
      word: 'Rojo',
      description: 'El color rojo en lenguaje de señas.',
      instructions: 'Desliza el dedo índice hacia abajo sobre los labios.',
      icon: Icons.circle,
      imageUrl: 'assets/images/signs/colors/red.png',
    ),
    const Sign(
      id: 'blue',
      categoryId: 'colors',
      word: 'Azul',
      description: 'El color azul en lenguaje de señas.',
      instructions: 'Agita la mano con los dedos extendidos frente a ti.',
      icon: Icons.circle,
      imageUrl: 'assets/images/signs/colors/blue.png',
    ),
    const Sign(
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
    const Sign(
      id: 'mother',
      categoryId: 'family',
      word: 'Madre',
      description: 'La palabra madre en lenguaje de señas.',
      instructions: 'Extiende el pulgar de la mano derecha y colócalo en la mejilla.',
      icon: Icons.face,
      imageUrl: 'assets/images/signs/family/mother.png',
    ),
    const Sign(
      id: 'father',
      categoryId: 'family',
      word: 'Padre',
      description: 'La palabra padre en lenguaje de señas.',
      instructions: 'Extiende el pulgar de la mano derecha y colócalo en la frente.',
      icon: Icons.face,
      imageUrl: 'assets/images/signs/family/father.png',
    ),
    const Sign(
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
    const Sign(
      id: 'bread',
      categoryId: 'food',
      word: 'Pan',
      description: 'La palabra pan en lenguaje de señas.',
      instructions: 'Simula cortar una rebanada de pan con la mano derecha sobre la palma izquierda.',
      icon: Icons.bakery_dining,
      imageUrl: 'assets/images/signs/food/bread.png',
    ),
    const Sign(
      id: 'water',
      categoryId: 'food',
      word: 'Agua',
      description: 'La palabra agua en lenguaje de señas.',
      instructions: 'Toca tu mentón con el dedo índice y luego bájalo.',
      icon: Icons.water_drop,
      imageUrl: 'assets/images/signs/food/water.png',
    ),
    const Sign(
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
