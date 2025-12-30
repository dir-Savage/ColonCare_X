import 'package:coloncare/core/constants/assets_manager.dart';
import 'package:coloncare/core/navigation/app_router.dart';
import 'package:coloncare/core/utils/app_animations.dart';
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
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInAnimation(
                  child: HomeUserInfo(
                      user: user,
                  ),
              ),
              const SizedBox(height: 30),
              FadeInAnimation(
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, AppRouter.bmiCalculator);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeInAnimation(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.blue.shade400,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Select",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          const FadeInText(
                            'your condition for personalized diagnosis.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              FadeInText(
                'Features',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade500,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  _buildFeatureCard(
                    onTap: (){
                      Navigator.pushNamed(context, AppRouter.prediction);
                    },
                    context,
                    imagePath: AssetsManager.colonImage,
                    description: 'Scan your colon images for early detection \nwith advanced AI.',
                    icon: Icons.security,
                    title: 'COLON SCAN PREDICTION',
                    color: Colors.black,
                  ),
                  SizedBox(height: 10),
                  _buildFeatureCard(
                    onTap: (){
                      Navigator.pushNamed(context, AppRouter.chatbot);
                    },
                    context,
                    imagePath: AssetsManager.chatbotCover,
                    description: 'Get instant answers and support from our AI-powered chatbot assistant.',
                    icon: Icons.security,
                    title: 'START CHATBOT ASSISTANT',
                    color: Colors.black,
                  )
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    const FadeInText(
                      'Secure App v1.0.0',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    FadeInText(
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
        required String description,
        required String imagePath,
        required Color color,
        final VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: FadeInAnimation(
        child: Container(
          width: double.infinity,
          height: 150,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(color.withOpacity(0.26), BlendMode.darken),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}