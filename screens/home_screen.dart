import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String userName = "Aditya"; // You can fetch from user profile later
    final DateTime now = DateTime.now();
    final String greeting = now.hour < 12
        ? "Good Morning"
        : now.hour < 17
            ? "Good Afternoon"
            : "Good Evening";

    return Scaffold(
      appBar: AppBar(
        title: Text("$greeting, $userName 👋"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(
              title: "Today's Workout",
              subtitle: "Upper Body - 45 mins",
              icon: Icons.fitness_center,
              color: Colors.orangeAccent,
              onTap: () {
                Navigator.pushNamed(context, '/workout');
              },
            ),
            const SizedBox(height: 16),
            _buildCard(
              title: "Track Your Meal",
              subtitle: "Breakfast, Lunch & Dinner",
              icon: Icons.restaurant_menu,
              color: Colors.greenAccent,
              onTap: () {
                Navigator.pushNamed(context, '/nutrition');
              },
            ),
            const SizedBox(height: 16),
            _buildCard(
              title: "Calories Burned",
              subtitle: "523 kcal today 🔥",
              icon: Icons.local_fire_department,
              color: Colors.redAccent,
              onTap: () {
                Navigator.pushNamed(context, '/stats');
              },
            ),
            const SizedBox(height: 24),
            Text(
              "💡 Fitness Tip",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "\"Discipline is the bridge between goals and accomplishment.\"",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        ),
      ),
    );
  }
}
