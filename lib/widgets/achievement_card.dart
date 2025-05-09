import 'package:flutter/material.dart';

class AchievementCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isUnlocked;

  const AchievementCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isUnlocked ? color.withOpacity(0.1) : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked ? color : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUnlocked ? color : Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isUnlocked ? color : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: isUnlocked ? Colors.black87 : Colors.grey,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
