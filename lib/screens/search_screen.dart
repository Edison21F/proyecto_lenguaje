import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onChanged: (value) {
                // Lógica para manejar la búsqueda
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Text(
                  'Resultados de búsqueda aparecerán aquí.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}