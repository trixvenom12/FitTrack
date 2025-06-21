class User {
  final String username;
  final String email;
  final int age;
  final double weight;
  final double height;
  final String fitnessGoal;
  final String? profilePicture;

  User({
    required this.username,
    required this.email,
    required this.age,
    required this.weight,
    required this.height,
    required this.fitnessGoal,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json['username'],
        email: json['email'],
        age: json['age'],
        weight: json['weight'].toDouble(),
        height: json['height'].toDouble(),
        fitnessGoal: json['fitness_goal'],
        profilePicture: json['profile_picture'],
      );
}
