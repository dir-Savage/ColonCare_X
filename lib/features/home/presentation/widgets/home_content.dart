import 'package:coloncare/features/auth/domain/entities/user_en.dart';
import 'package:coloncare/features/home/presentation/blocs/home_bloc/home_event.dart';
import 'package:coloncare/features/home/presentation/widgets/home_user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/home_bloc/home_bloc.dart';

class HomeContent extends StatelessWidget {
  final User user;

  const HomeContent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(HomeDataRefreshed());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info Card
              HomeUserInfo(user: user),

              const SizedBox(height: 30),

              // Welcome Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'You are logged in!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Welcome to your secure app. Here you can manage your profile and access all the features.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Features Section
              Text(
                'Features',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 15),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _buildFeatureCard(
                    context,
                    icon: Icons.person,
                    title: 'Profile',
                    color: Colors.blue,
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.settings,
                    title: 'Settings',
                    color: Colors.green,
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.security,
                    title: 'Security',
                    color: Colors.orange,
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.help,
                    title: 'Help',
                    color: Colors.purple,
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // App Info
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Secure App v1.0.0',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Logged in as: ${user.email}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Color color,
      }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}