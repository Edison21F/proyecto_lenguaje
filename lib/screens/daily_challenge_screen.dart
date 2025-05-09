import 'package:flutter/material.dart';

class DailyChallengeScreen extends StatelessWidget {
  const DailyChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desafío Diario'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¡Desafío del día!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Text(
                  'Aquí aparecerá el contenido del desafío diario.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Lógica para completar el desafío
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Completar Desafío',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}