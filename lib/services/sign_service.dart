import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/sign.dart';

class SignService {
  // URL base para la API (reemplaza esto con tu URL real)
  static const String baseUrl = 'https://tu-api.com/api';

  // Obtener todas las señas de una categoría desde la API
  static Future<List<Sign>> getSignsByCategory(String categoryId) async {
    try {
      // En una implementación real, esta sería una llamada a tu API
      // Por ahora, usamos un retraso simulado para simular una conexión a la red
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Devuelve los datos estáticos por ahora
      return _getMockSignsByCategoryId(categoryId);
    } catch (e) {
      // Manejo de errores
      print('Error obteniendo señas: $e');
      return [];
    }
  }

  // Obtener señas por IDs
  static Future<List<Sign>> getSignsByIds(List<String> signIds) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      
      // Filtrar las señas de todas las categorías que coincidan con los IDs solicitados
      List<Sign> result = [];
      
      // Buscar en todas las categorías
      for (var id in signIds) {
        // Determinar a qué categoría pertenece cada ID
        String categoryId = _getCategoryIdFromSignId(id);
        
        if (categoryId.isNotEmpty) {
          final signs = _getMockSignsByCategoryId(categoryId);
          final sign = signs.where((s) => s.id == id).toList();
          if (sign.isNotEmpty) {
            result.add(sign.first);
          }
        }
      }
      
      return result;
    } catch (e) {
      print('Error obteniendo señas por IDs: $e');
      return [];
    }
  }

  // Función auxiliar para determinar a qué categoría pertenece una seña por su ID
  static String _getCategoryIdFromSignId(String signId) {
    if (signId.startsWith('a') || signId.startsWith('b') || signId.startsWith('c') || signId.startsWith('d')) {
      return 'alphabet';
    } else if (signId.startsWith('num')) {
      return 'numbers';
    } else if (signId == 'hello' || signId == 'goodbye' || signId == 'thanks') {
      return 'greetings';
    } else if (signId == 'red' || signId == 'blue' || signId == 'yellow') {
      return 'colors';
    } else if (signId == 'mother' || signId == 'father' || signId == 'sister') {
      return 'family';
    } else if (signId == 'bread' || signId == 'water' || signId == 'apple') {
      return 'food';
    }
    return '';
  }

  // Datos simulados para uso mientras se implementa la API real
  static List<Sign> _getMockSignsByCategoryId(String categoryId) {
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

  // Datos simulados - alfabeto
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
      imageUrl: 'https://previews.123rf.com/images/pchvector/pchvector2211/pchvector221101901/194247086-mano-que-muestra-la-letra-c-lenguaje-de-se%C3%B1as-alfabeto-ilustraci%C3%B3n-vectorial-dedo-en-diferente-posic.jpg',
    ),
    const Sign(
      id: 'd',
      categoryId: 'alphabet',
      word: 'D',
      description: 'La letra D en lenguaje de señas.',
      instructions: 'Forma una D con tu mano, manteniendo el dedo índice extendido y los demás dedos cerrados.',
      icon: Icons.sign_language,
      imageUrl: 'https://previews.123rf.com/images/pchvector/pchvector2211/pchvector221101881/194247084-mano-que-muestra-la-letra-d-ilustraci%C3%B3n-de-vector-de-alfabeto-de-lenguaje-de-se%C3%B1as-dedo-en-posici%C3%B3n-.jpg',
    ),
  ];

  // Datos simulados - números
  static final List<Sign> _numberSigns = [
    const Sign(
      id: 'num1',
      categoryId: 'numbers',
      word: '1',
      description: 'El número uno en lenguaje de señas.',
      instructions: 'Extiende el dedo índice hacia arriba, manteniendo los demás dedos cerrados.',
      icon: Icons.looks_one,
      imageUrl: 'https://media.istockphoto.com/id/1249204654/es/vector/mano-mostrando-uno-gesto-de-la-mano-n%C3%BAmero-1-lenguaje-de-se%C3%B1as-s%C3%ADmbolo-de-dedo-%C3%ADndice.jpg?s=612x612&w=0&k=20&c=jDzQGGilXrPIFwAyvwTgzAkjwnnTUjJQdcUILGQxGxc=',
    ),
    const Sign(
      id: 'num2',
      categoryId: 'numbers',
      word: '2',
      description: 'El número dos en lenguaje de señas.',
      instructions: 'Extiende los dedos índice y medio hacia arriba, manteniendo los demás dedos cerrados.',
      icon: Icons.looks_two,
      imageUrl: 'https://media.istockphoto.com/id/1249204663/es/vector/mano-mostrando-dos-gesto-de-la-mano-n%C3%BAmero-2-lenguaje-de-se%C3%B1as-s%C3%ADmbolo-de-dedo-v-muestra.jpg?s=612x612&w=0&k=20&c=dUy4ejf7nt_2nRy4vTr3YHFxHEA9u4n2Lj-K0tqVlbM=',
    ),
    const Sign(
      id: 'num3',
      categoryId: 'numbers',
      word: '3',
      description: 'El número tres en lenguaje de señas.',
      instructions: 'Extiende los dedos pulgar, índice y medio hacia arriba, manteniendo los demás dedos cerrados.',
      icon: Icons.looks_3,
      imageUrl: 'https://www.istockphoto.com/es/vector/mano-mostrando-tres-gesto-de-mano-n%C3%BAmero-3-lenguaje-de-se%C3%B1as-s%C3%ADmbolo-de-dedo-ilustraci%C3%B3n-gm1252597615-365694553',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
  ];

  // Datos simulados - saludos
  static final List<Sign> _greetingSigns = [
    const Sign(
      id: 'hello',
      categoryId: 'greetings',
      word: 'Hola',
      description: 'Saludo básico en lenguaje de señas.',
      instructions: 'Coloca tu mano abierta cerca de tu frente y muévela hacia adelante, como un saludo militar.',
      icon: Icons.waving_hand,
      imageUrl: 'https://i.pinimg.com/originals/4d/22/bf/4d22bf6f00b8a029729da71990565772.png',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
    const Sign(
      id: 'goodbye',
      categoryId: 'greetings',
      word: 'Adiós',
      description: 'Despedida en lenguaje de señas.',
      instructions: 'Agita la mano abierta de lado a lado.',
      icon: Icons.waving_hand,
      imageUrl: 'https://t3.ftcdn.net/jpg/03/25/86/82/360_F_325868290_P0iT9t7O18S0HEqLSqKLL2jFmYrxSpA5.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
    const Sign(
      id: 'thanks',
      categoryId: 'greetings',
      word: 'Gracias',
      description: 'Agradecimiento en lenguaje de señas.',
      instructions: 'Toca tus labios con las puntas de los dedos y luego mueve la mano hacia adelante.',
      icon: Icons.favorite,
      imageUrl: 'https://www.signbsl.com/media/imported/bsl/t/th/thank-you.mp4.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
  ];

  // Datos simulados - colores
  static final List<Sign> _colorSigns = [
    const Sign(
      id: 'red',
      categoryId: 'colors',
      word: 'Rojo',
      description: 'El color rojo en lenguaje de señas.',
      instructions: 'Desliza el dedo índice hacia abajo sobre los labios.',
      icon: Icons.circle,
      imageUrl: 'https://www.iact.ngo/assets/i18n/bsl/RED.png',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
    const Sign(
      id: 'blue',
      categoryId: 'colors',
      word: 'Azul',
      description: 'El color azul en lenguaje de señas.',
      instructions: 'Agita la mano con los dedos extendidos frente a ti.',
      icon: Icons.circle,
      imageUrl: 'https://www.signbsl.com/media/imported/bsl/b/bl/blue.mp4.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
    const Sign(
      id: 'yellow',
      categoryId: 'colors',
      word: 'Amarillo',
      description: 'El color amarillo en lenguaje de señas.',
      instructions: 'Agita la mano en forma de Y cerca del hombro.',
      icon: Icons.circle,
      imageUrl: 'https://www.signbsl.com/media/imported/bsl/y/ye/yellow.mp4.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
  ];

  // Datos simulados - familia
  static final List<Sign> _familySigns = [
    const Sign(
      id: 'mother',
      categoryId: 'family',
      word: 'Madre',
      description: 'La palabra madre en lenguaje de señas.',
      instructions: 'Extiende el pulgar de la mano derecha y colócalo en la mejilla.',
      icon: Icons.face,
      imageUrl: 'https://www.signbsl.com/media/imported/bsl/m/mo/mother.mp4.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
    const Sign(
      id: 'father',
      categoryId: 'family',
      word: 'Padre',
      description: 'La palabra padre en lenguaje de señas.',
      instructions: 'Extiende el pulgar de la mano derecha y colócalo en la frente.',
      icon: Icons.face,
      imageUrl: 'https://www.signbsl.com/media/imported/bsl/f/fa/father.mp4.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
    const Sign(
      id: 'sister',
      categoryId: 'family',
      word: 'Hermana',
      description: 'La palabra hermana en lenguaje de señas.',
      instructions: 'Haz la seña de mujer y luego la seña de igual.',
      icon: Icons.face_3,
      imageUrl: 'https://www.signbsl.com/media/imported/bsl/s/si/sister.mp4.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
  ];

  // Datos simulados - alimentos
  static final List<Sign> _foodSigns = [
    const Sign(
      id: 'bread',
      categoryId: 'food',
      word: 'Pan',
      description: 'La palabra pan en lenguaje de señas.',
      instructions: 'Simula cortar una rebanada de pan con la mano derecha sobre la palma izquierda.',
      icon: Icons.bakery_dining,
      imageUrl: 'https://www.signbsl.com/media/imported/bsl/b/br/bread.mp4.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
    const Sign(
      id: 'water',
      categoryId: 'food',
      word: 'Agua',
      description: 'La palabra agua en lenguaje de señas.',
      instructions: 'Toca tu mentón con el dedo índice y luego bájalo.',
      icon: Icons.water_drop,
      imageUrl: 'https://www.signbsl.com/media/imported/bsl/w/wa/water.mp4.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
    const Sign(
      id: 'apple',
      categoryId: 'food',
      word: 'Manzana',
      description: 'La palabra manzana en lenguaje de señas.',
      instructions: 'Gira el puño cerrado en la mejilla.',
      icon: Icons.apple,
      imageUrl: 'https://www.signbsl.com/media/imported/bsl/a/ap/apple.mp4.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
  ];
}