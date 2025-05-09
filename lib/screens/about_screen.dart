import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Acerca de"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.sign_language,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "Señas Contigo",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Versión 1.0.0",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildInfoSection(
              context,
              "Objetivo",
              "Diseñar y desarrollar una aplicación móvil interactiva que facilite el aprendizaje del vocabulario básico del lenguaje de señas, mediante el uso de recursos visuales y categorías temáticas, dirigida a personas oyentes interesadas en mejorar la comunicación con personas sordas.",
            ),
            _buildInfoSection(
              context,
              "Justificación",
              "El aprendizaje del lenguaje de señas por parte de personas oyentes es un paso fundamental hacia una sociedad más inclusiva. Esta aplicación responde a una necesidad social y educativa mediante un medio accesible y ampliamente utilizado: el teléfono móvil. Además, fomenta valores como la empatía, el respeto a la diversidad y la inclusión.",
            ),
            _buildInfoSection(
              context,
              "Datos",
              "En Ecuador, la población con discapacidad auditiva supera las 100.000 personas, y muchas de ellas encuentran dificultades para acceder a servicios, educación o incluso mantener conversaciones básicas debido a la falta de conocimiento de la lengua de señas ecuatoriana por parte de la mayoría de la sociedad (CONADIS, 2021).",
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "Desarrollado por",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Pamela Moposita",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 5),
            const Center(
              child: Text(
                "Instituto Superior Tecnológico de Turismo y Patrimonio Yavirac",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
