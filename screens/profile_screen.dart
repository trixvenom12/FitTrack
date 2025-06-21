import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../model/user_model.dart';
import 'goals_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?auto=format&fit=crop&w=800&q=80',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/men/1.jpg',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Member since ${DateFormat('MMMM y').format(user.joinDate)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    _buildProfileSection(
                      title: 'Personal Information',
                      children: [
                        _buildProfileItem(
                          icon: Icons.person,
                          label: 'Name',
                          value: user.name,
                        ),
                        _buildProfileItem(
                          icon: Icons.email,
                          label: 'Email',
                          value: user.email
                        ),
                        _buildProfileItem(
                          icon: Icons.cake,
                          label: 'Age',
                          value: '${user.age} years',
                        ),
                        _buildProfileItem(
                          icon: Icons.height,
                          label: 'Height',
                          value: '${user.height} cm',
                        ),
                        _buildProfileItem(
                          icon: Icons.monitor_weight,
                          label: 'Weight',
                          value: '${user.currentWeight} kg',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildProfileSection(
                      title: 'Fitness Goals',
                      children: [
                        _buildProfileItem(
                          icon: Icons.flag,
                          label: 'Primary Goal',
                          value: user.fitnessGoal,
                        ),
                        _buildProfileItem(
                          icon: Icons.trending_up,
                          label: 'Target Weight',
                          value: '${user.targetWeight} kg',
                        ),
                        _buildProfileItem(
                          icon: Icons.directions_run,
                          label: 'Activity Level',
                          value: user.activityLevel,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GoalsScreen(),
                              ),
                            );
                          },
                          child: const Text('Edit Goals'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildProfileSection(
                      title: 'Settings',
                      children: [
                        SwitchListTile(
                          title: const Text('Dark Mode'),
                          value: false,
                          onChanged: (value) {},
                        ),
                        SwitchListTile(
                          title: const Text('Enable Notifications'),
                          value: true,
                          onChanged: (value) {},
                        ),
                        ListTile(
                          leading: const Icon(Icons.lock),
                          title: const Text('Change Password'),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(Icons.help),
                          title: const Text('Help & Support'),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Log Out'),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value),
    );
  }
}
