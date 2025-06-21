import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screens
import 'package:fittrack/screens/login_screen.dart';
import 'package:fittrack/screens/register_screen.dart';
import 'package:fittrack/screens/dashboard_screen.dart';
import 'package:fittrack/screens/activity_screen.dart';
import 'package:fittrack/screens/nutrition_screen.dart';
import 'package:fittrack/screens/workout_screen.dart';
import 'package:fittrack/screens/profile_screen.dart';
import 'package:fittrack/screens/stats_screen.dart';
import 'package:fittrack/screens/goals_screen.dart';

// Providers
import 'package:fittrack/providers/auth_provider.dart';
import 'package:fittrack/providers/activity_provider.dart';
import 'package:fittrack/providers/nutrition_provider.dart';
import 'package:fittrack/providers/workout_provider.dart';
import '../model/user_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
        ChangeNotifierProvider(create: (_) => NutritionProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => UserModel.mock()), // Provide user Model
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitTrack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return auth.isAuthenticated
            ? const MainScreen()
            : const LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main': (context) => const MainScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/nutrition': (context) => const NutritionScreen(),
        '/workout': (context) => const WorkoutScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/stats': (context) => const StatsScreen(),
        '/goals': (context) => const GoalsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = const [
    DashboardScreen(),
    ActivityScreen(),
    NutritionScreen(),
    WorkoutScreen(),
    ProfileScreen(),
    StatsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_run), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Nutrition'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workout'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
        ],
      ),
    );
  }
}
