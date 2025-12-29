import 'package:coloncare/core/constants/assets_manager.dart';
import 'package:coloncare/features/home/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:coloncare/features/home/presentation/blocs/home_bloc/home_event.dart';
import 'package:coloncare/features/home/presentation/blocs/home_bloc/home_state.dart';
import 'package:coloncare/features/home/presentation/widgets/home_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Image(image: const AssetImage(AssetsManager.appLogo), fit: BoxFit.contain, height: 50),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: ClipOval(
                  child: SvgPicture.network(
                    AssetsManager.avatarUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HomeError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded, size: 80, color: Colors.red[400]),
                    const SizedBox(height: 24),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      onPressed: () {
                        context.read<HomeBloc>().add(HomeDataRefreshed());
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is HomeLoaded) {
            return HomeContent(user: state.user);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}