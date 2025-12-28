import 'package:bloc/bloc.dart';
import 'package:coloncare/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:coloncare/features/auth/presentation/blocs/auth_bloc/auth_state.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthBloc authBloc;

  SplashBloc({required this.authBloc}) : super(SplashInitial()) {
    on<SplashAuthCheckRequested>(_onSplashAuthCheckRequested);
  }

  Future<void> _onSplashAuthCheckRequested(
      SplashAuthCheckRequested event,
      Emitter<SplashState> emit,
      ) async {
    emit(SplashLoading());

    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 2));

    // Check current auth state directly (safe & no subscription)
    final authState = authBloc.state;

    if (authState is Authenticated) {
      emit(SplashAuthenticated());
    } else if (authState is Unauthenticated) {
      emit(SplashUnauthenticated());
    } else if (authState is AuthError) {
      emit(SplashError(authState.message));
    } else {
      // Fallback: assume unauthenticated
      emit(SplashUnauthenticated());
    }
  }
}