import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:coloncare/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:coloncare/features/auth/domain/usecases/login_usecase.dart';
import 'package:coloncare/features/auth/domain/usecases/logout_usecase.dart';
import 'package:coloncare/features/auth/domain/usecases/register_usecase.dart';
import 'package:coloncare/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  AuthBloc({
    required this.checkAuthStatusUseCase,
    required this.registerUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.resetPasswordUseCase,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<AuthErrorCleared>(_onAuthErrorCleared);

    // Trigger initial auth check when bloc is created
    add(AuthCheckRequested());
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final user = await checkAuthStatusUseCase();
      if (user != null && user.isNotEmpty) {
        emit(Authenticated(user));
      } else {
        emit(const Unauthenticated());
      }
    } catch (error) {
      emit(AuthError('Failed to check authentication status'));
    }
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final user = await registerUseCase(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      );

      // Give Firebase time to update auth state
      await Future.delayed(const Duration(milliseconds: 500));

      // Verify user exists
      final verifiedUser = await checkAuthStatusUseCase();
      if (verifiedUser != null && verifiedUser.isNotEmpty) {
        emit(Authenticated(verifiedUser));
      } else {
        emit(Authenticated(user));
      }
    } catch (error) {
      if (error is FirebaseAuthException) {
        emit(AuthError(_getFirebaseErrorMessage(error)));
      } else {
        emit(AuthError('Registration failed: ${error.toString()}'));
      }
    }
  }

  Future<void> _onLoginRequested(
      LoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(
        email: event.email,
        password: event.password,
      );
      emit(Authenticated(user));
    } catch (error) {
      if (error is FirebaseAuthException) {
        emit(AuthError(_getFirebaseErrorMessage(error)));
      } else {
        emit(AuthError('Login failed: ${error.toString()}'));
      }
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await logoutUseCase();
      emit(const Unauthenticated());
    } catch (error) {
      emit(AuthError('Logout failed: ${error.toString()}'));
    }
  }

  Future<void> _onResetPasswordRequested(
      ResetPasswordRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await resetPasswordUseCase(event.email);
      emit(PasswordResetSent(event.email));
    } catch (error) {
      if (error is FirebaseAuthException) {
        emit(AuthError(_getFirebaseErrorMessage(error)));
      } else {
        emit(AuthError('Failed to reset password: ${error.toString()}'));
      }
    }
  }

  void _onAuthErrorCleared(
      AuthErrorCleared event,
      Emitter<AuthState> emit,
      ) {
    emit(const Unauthenticated());
  }

  String _getFirebaseErrorMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'Email is already in use';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password is too weak (minimum 6 characters)';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      default:
        return error.message ?? 'An authentication error occurred';
    }
  }
}