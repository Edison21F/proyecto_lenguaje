import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/quiz_question.dart';
import '../data/quiz_data.dart';
import '../services/user_service.dart';
import '../widgets/confetti_overlay.dart';
import 'dart:math';

class QuizScreen extends StatefulWidget {
  final Category category;

  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  late List<QuizQuestion> questions;
  int currentQuestionIndex = 0;
  int score = 0;
  bool answered = false;
  int? selectedAnswerIndex;
  bool quizCompleted = false;
  bool _showConfetti = false;
  
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    questions = QuizData.getQuestions(widget.category.id);
    questions.shuffle(Random());
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _checkAnswer(int index) {
    if (answered) return;
    
    setState(() {
      selectedAnswerIndex = index;
      answered = true;
      if (index == questions[currentQuestionIndex].correctAnswerIndex) {
        score++;
      }
    });
    
    Future.delayed(const Duration(seconds: 1), () {
      if (currentQuestionIndex < questions.length - 1) {
        _nextQuestion();
      } else {
        _completeQuiz();
      }
    });
  }

  void _nextQuestion() {
    _animationController.reset();
    
    setState(() {
      currentQuestionIndex++;
      answered = false;
      selectedAnswerIndex = null;
    });
    
    _animationController.forward();
  }

  Future<void> _completeQuiz() async {
    final percentage = (score / questions.length);
    
    // Actualizar progreso de la categoría
    await UserService.updateCategoryProgress(widget.category.id, percentage);
    
    // Añadir puntos basados en el rendimiento
    final points = (percentage * 100).toInt();
    await UserService.addPoints(points);
    
    setState(() {
      quizCompleted = true;
      
      // Mostrar confeti si el puntaje es bueno
      if (percentage >= 0.6) {
        _showConfetti = true;
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _showConfetti = false;
            });
          }
        });
      }
    });
  }

  void _restartQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      answered = false;
      selectedAnswerIndex = null;
      quizCompleted = false;
      questions.shuffle(Random());
    });
    
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz - ${widget.category.name}"),
        backgroundColor: widget.category.color,
      ),
      body: Stack(
        children: [
          quizCompleted ? _buildResultScreen() : _buildQuizScreen(),
          if (_showConfetti) const ConfettiOverlay(),
        ],
      ),
    );
  }

  Widget _buildQuizScreen() {
    final question = questions[currentQuestionIndex];
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: (currentQuestionIndex + 1) / questions.length,
            backgroundColor: Colors.grey[300],
            color: widget.category.color,
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pregunta ${currentQuestionIndex + 1}/${questions.length}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Puntuación: $score",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          FadeTransition(
            opacity: _animation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.category.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // Si hay una imagen para la pregunta, mostrarla
                  if (question.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        question.imageUrl!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Icon(
                      question.icon,
                      size: 80,
                      color: widget.category.color,
                    ),
                  const SizedBox(height: 20),
                  Text(
                    question.question,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: question.answers.length,
              itemBuilder: (context, index) {
                final bool isSelected = selectedAnswerIndex == index;
                final bool isCorrect = index == question.correctAnswerIndex;
                
                Color backgroundColor = Theme.of(context).cardTheme.color!;
                if (answered) {
                  if (isSelected && isCorrect) {
                    backgroundColor = Colors.green.withOpacity(0.2);
                  } else if (isSelected && !isCorrect) {
                    backgroundColor = Colors.red.withOpacity(0.2);
                  } else if (isCorrect) {
                    backgroundColor = Colors.green.withOpacity(0.2);
                  }
                }
                
                return FadeTransition(
                  opacity: _animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(
                        0.4 + (index * 0.1),
                        1.0,
                        curve: Curves.easeOut,
                      ),
                    )),
                    child: Card(
                      color: backgroundColor,
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        onTap: () => _checkAnswer(index),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: widget.category.color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(65 + index), // A, B, C, D
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: widget.category.color,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  question.answers[index],
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              if (answered)
                                Icon(
                                  isCorrect ? Icons.check_circle : Icons.cancel,
                                  color: isCorrect ? Colors.green : Colors.red,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    final percentage = (score / questions.length) * 100;
    String message;
    Color messageColor;
    IconData icon;
    
    if (percentage >= 80) {
      message = "¡Excelente!";
      messageColor = Colors.green;
      icon = Icons.emoji_events;
    } else if (percentage >= 60) {
      message = "¡Buen trabajo!";
      messageColor = Colors.blue;
      icon = Icons.thumb_up;
    } else {
      message = "Sigue practicando";
      messageColor = Colors.orange;
      icon = Icons.refresh;
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 100,
            color: messageColor,
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: messageColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Tu puntuación",
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "$score/${questions.length}",
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "${percentage.toStringAsFixed(0)}%",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Has ganado ${percentage.toInt()} puntos",
            style: TextStyle(
              fontSize: 18,
              color: widget.category.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _restartQuiz,
                icon: const Icon(Icons.refresh),
                label: const Text("Intentar de nuevo"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.category.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text("Volver a la categoría"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: widget.category.color,
                  side: BorderSide(color: widget.category.color),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
