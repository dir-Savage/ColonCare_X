import 'package:coloncare/features/auth/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_form_bloc/auth_form_bloc.dart';
import '../widgets/register_form.dart';
import '../../../../core/navigation/app_router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Only navigate when fully authenticated
        if (state is Authenticated) {
          // Navigate to home and clear the navigation stack
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouter.navbar,
                (route) => false,
          );
        }
        // Show error snackbar if any
        else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: const _RegisterContent(),
      ),
    );
  }
}

class _RegisterContent extends StatelessWidget {
  const _RegisterContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(
            Icons.person_add,
            size: 80,
            color: Colors.blue,
          ),
          const SizedBox(height: 20),
          Text(
            'Create Account',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Sign up to get started',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: MultiBlocListener(
              listeners: [
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ],
              child: const RegisterForm(),
            ),
          ),
        ],
      ),
    );
  }
}