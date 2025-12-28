import 'package:coloncare/features/auth/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:coloncare/features/auth/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:coloncare/features/auth/presentation/blocs/auth_form_bloc/auth_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_form_bloc/auth_form_bloc.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final fullNameController = TextEditingController();

    return BlocBuilder<AuthFormBloc, AuthFormState>(
      builder: (context, formState) {
        return SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                AppTextField(
                  controller: fullNameController,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  validator: Validators.validateFullName,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: passwordController,
                  label: 'Password',
                  hint: 'Enter your password (min. 6 characters)',
                  obscureText: true,
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 30),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    return AppButton(
                      text: 'Create Account',
                      onPressed: () {
                        if (emailController.text.isEmpty ||
                            passwordController.text.isEmpty ||
                            fullNameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields'),
                            ),
                          );
                          return;
                        }

                        context.read<AuthBloc>().add(
                          RegisterRequested(
                            email: emailController.text,
                            password: passwordController.text,
                            fullName: fullNameController.text,
                          ),
                        );
                      },
                      isLoading: authState is AuthLoading,
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}