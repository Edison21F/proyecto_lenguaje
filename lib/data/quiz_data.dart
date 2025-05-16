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
    const QuizQuestion(
      id: 'q_a',
      categoryId: 'alphabet',
      question: '¿Qué letra representa esta seña?',
      answers: ['A', 'B', 'C', 'D'],
      correctAnswerIndex: 0,
      icon: Icons.sign_language,
      imageUrl: 'https://previews.123rf.com/images/pchvector/pchvector2211/pchvector221101908/194247113-mano-que-muestra-la-letra-a-ilustraci%C3%B3n-de-vector-de-alfabeto-de-lenguaje-de-se%C3%B1as-dedo-en-posici%C3%B3n-.jpg',
    ),
    const QuizQuestion(
      id: 'q_b',
      categoryId: 'alphabet',
      question: '¿Qué letra representa esta seña?',
      answers: ['E', 'B', 'F', 'G'],
      correctAnswerIndex: 1,
      icon: Icons.sign_language,
      imageUrl: 'https://media.istockphoto.com/id/1441720791/es/vector/mano-mostrando-la-letra-b-ilustraci%C3%B3n-vectorial-del-alfabeto-de-lengua-de-signos-dedo-en.jpg?s=1024x1024&w=is&k=20&c=ub8WjHz3fCvsNYZAU1VkJy6vuVNxHzvwzyxB_vV2Y4w=',
    ),
    const QuizQuestion(
      id: 'q_c',
      categoryId: 'alphabet',
      question: '¿Qué letra representa esta seña?',
      answers: ['H', 'I', 'C', 'J'],
      correctAnswerIndex: 2,
      icon: Icons.sign_language,
      imageUrl: 'https://previews.123rf.com/images/pchvector/pchvector2211/pchvector221101901/194247086-mano-que-muestra-la-letra-c-lenguaje-de-se%C3%B1as-alfabeto-ilustraci%C3%B3n-vectorial-dedo-en-diferente-posic.jpg',
    ),
    const QuizQuestion(
      id: 'q_d',
      categoryId: 'alphabet',
      question: '¿Qué letra representa esta seña?',
      answers: ['D', 'K', 'L', 'M'],
      correctAnswerIndex: 0,
      icon: Icons.sign_language,
      imageUrl: 'https://previews.123rf.com/images/pchvector/pchvector2211/pchvector221101881/194247084-mano-que-muestra-la-letra-d-ilustraci%C3%B3n-de-vector-de-alfabeto-de-lenguaje-de-se%C3%B1as-dedo-en-posici%C3%B3n-.jpg',
    ),
  ];

  static final List<QuizQuestion> _numberQuestions = [
    const QuizQuestion(
      id: 'q_num1',
      categoryId: 'numbers',
      question: '¿Qué número representa esta seña?',
      answers: ['1', '2', '3', '4'],
      correctAnswerIndex: 0,
      icon: Icons.looks_one,
      imageUrl: 'https://media.istockphoto.com/id/1249204654/es/vector/mano-mostrando-uno-gesto-de-la-mano-n%C3%BAmero-1-lenguaje-de-se%C3%B1as-s%C3%ADmbolo-de-dedo-%C3%ADndice.jpg?s=612x612&w=0&k=20&c=jDzQGGilXrPIFwAyvwTgzAkjwnnTUjJQdcUILGQxGxc=',
    ),
    const QuizQuestion(
      id: 'q_num2',
      categoryId: 'numbers',
      question: '¿Qué número representa esta seña?',
      answers: ['5', '2', '7', '8'],
      correctAnswerIndex: 1,
      icon: Icons.looks_two,
      imageUrl: 'https://media.istockphoto.com/id/1249204663/es/vector/mano-mostrando-dos-gesto-de-la-mano-n%C3%BAmero-2-lenguaje-de-se%C3%B1as-s%C3%ADmbolo-de-dedo-v-muestra.jpg?s=612x612&w=0&k=20&c=dUy4ejf7nt_2nRy4vTr3YHFxHEA9u4n2Lj-K0tqVlbM=',
    ),
    const QuizQuestion(
      id: 'q_num3',
      categoryId: 'numbers',
      question: '¿Qué número representa esta seña?',
      answers: ['9', '10', '3', '11'],
      correctAnswerIndex: 2,
      icon: Icons.looks_3,
      imageUrl: 'https://media.istockphoto.com/id/1252597615/es/vector/mano-mostrando-tres-gesto-de-mano-n%C3%BAmero-3-lenguaje-de-se%C3%B1as-s%C3%ADmbolo-de-dedo-ilustraci%C3%B3n.jpg?s=612x612&w=0&k=20&c=pZb-wVXHmgkLF6kM1JXnXSAHFvlO0WqwMJHLSKzHaL0=',
    ),
  ];

  static final List<QuizQuestion> _greetingQuestions = [
    const QuizQuestion(
      id: 'q_hello',
      categoryId: 'greetings',
      question: '¿Qué saludo representa esta seña?',
      answers: ['Hola', 'Adiós', 'Buenos días', 'Buenas noches'],
      correctAnswerIndex: 0,
      icon: Icons.waving_hand,
      imageUrl: 'https://i.pinimg.com/originals/4d/22/bf/4d22bf6f00b8a029729da71990565772.png',
    ),
    const QuizQuestion(
      id: 'q_goodbye',
      categoryId: 'greetings',
      question: '¿Qué despedida representa esta seña?',
      answers: ['Hasta mañana', 'Adiós', 'Hasta luego', 'Nos vemos'],
      correctAnswerIndex: 1,
      icon: Icons.waving_hand,
      imageUrl: 'https://t3.ftcdn.net/jpg/03/25/86/82/360_F_325868290_P0iT9t7O18S0HEqLSqKLL2jFmYrxSpA5.jpg',
    ),
    const QuizQuestion(
      id: 'q_thanks',
      categoryId: 'greetings',
      question: '¿Qué expresión representa esta seña?',
      answers: ['Por favor', 'De nada', 'Gracias', 'Disculpa'],
      correctAnswerIndex: 2,
      icon: Icons.favorite,
      imageUrl: 'https://www.signbsl.com/media/imported/bsl/t/th/thank-you.mp4.jpg',
    ),
  ];

  static final List<QuizQuestion> _colorQuestions = [
    const QuizQuestion(
      id: 'q_red',
      categoryId: 'colors',
      question: '¿Qué color representa esta seña?',
      answers: ['Rojo', 'Azul', 'Verde', 'Amarillo'],
      correctAnswerIndex: 0,
      icon: Icons.circle,
      imageUrl: 'https://www.iact.ngo/assets/i18n/bsl/RED.png',
    ),
    const QuizQuestion(
      id: 'q_blue',
      categoryId: 'colors',
      question: '¿Qué color representa esta seña?',
      answers: ['Negro', 'Azul', 'Blanco', 'Morado'],
      correctAnswerIndex: 1,
      icon: Icons.circle,
      imageUrl: 'https://www.signbsl.com/media/imported/bsl/b/bl/blue.mp4.jpg',
    ),
    const QuizQuestion(
      id: 'q_yellow',
      categoryId: 'colors',
      question: '¿Qué color representa esta seña?',
      answers: ['Naranja', 'Verde', 'Amarillo', 'Café'],
      correctAnswerIndex: 2,
      icon: Icons.circle,
      imageUrl: 'https://www.signbsl.com/media/imported/bsl/y/ye/yellow.mp4.jpg',
    ),
  ];

  static final List<QuizQuestion> _familyQuestions = [
    const QuizQuestion(
      id: 'q_mother',
      categoryId: 'family',
      question: '¿Qué miembro de la familia representa esta seña?',
      answers: ['Madre', 'Hermana', 'Tía', 'Abuela'],
      correctAnswerIndex: 0,
      icon: Icons.face,
      imageUrl: 'https://www.signbsl.com/media/imported/bsl/m/mo/mother.mp4.jpg',
    ),
    const QuizQuestion(
      id: 'q_father',
      categoryId: 'family',
      question: '¿Qué miembro de la familia representa esta seña?',
      answers: ['Tío', 'Padre', 'Hermano', 'Abuelo'],
      correctAnswerIndex: 1,
      icon: Icons.face,
      imageUrl: 'https://www.signbsl.com/media/imported/bsl/f/fa/father.mp4.jpg',
    ),
    const QuizQuestion(
      id: 'q_sister',
      categoryId: 'family',
      question: '¿Qué miembro de la familia representa esta seña?',
      answers: ['Prima', 'Madre', 'Hermana', 'Hija'],
      correctAnswerIndex: 2,
      icon: Icons.face_3,
      imageUrl: 'https://www.signbsl.com/media/imported/bsl/s/si/sister.mp4.jpg',
    ),
  ];

  static final List<QuizQuestion> _foodQuestions = [
    const QuizQuestion(
      id: 'q_bread',
      categoryId: 'food',
      question: '¿Qué alimento representa esta seña?',
      answers: ['Pan', 'Arroz', 'Pasta', 'Galleta'],
      correctAnswerIndex: 0,
      icon: Icons.bakery_dining,
      imageUrl: 'https://www.signbsl.com/media/imported/bsl/b/br/bread.mp4.jpg',
    ),
    const QuizQuestion(
      id: 'q_water',
      categoryId: 'food',
      question: '¿Qué bebida representa esta seña?',
      answers: ['Jugo', 'Agua', 'Leche', 'Café'],
      correctAnswerIndex: 1,
      icon: Icons.water_drop,
      imageUrl: 'https://www.signbsl.com/media/imported/bsl/w/wa/water.mp4.jpg',
    ),
    const QuizQuestion(
      id: 'q_apple',
      categoryId: 'food',
      question: '¿Qué fruta representa esta seña?',
      answers: ['Naranja', 'Plátano', 'Manzana', 'Pera'],
      correctAnswerIndex: 2,
      icon: Icons.apple,
      imageUrl: 'https://www.signbsl.com/media/imported/bsl/a/ap/apple.mp4.jpg',
    ),
  ];
}