import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:coloncare/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:coloncare/features/auth/presentation/blocs/auth_bloc/auth_state.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthBloc authBloc;
  late StreamSubscription _authSubscription;

  SplashBloc({required this.authBloc}) : super(SplashInitial()) {
    on<SplashAuthCheckRequested>(_onSplashAuthCheckRequested);
  }

  Future<void> _onSplashAuthCheckRequested(
      SplashAuthCheckRequested event,
      Emitter<SplashState> emit,
      ) async {
    emit(SplashLoading());

    // Wait for initial splash delay
    await Future.delayed(const Duration(seconds: 2));

    // Listen to auth state changes
    _authSubscription = authBloc.stream.listen((authState) {
      if (authState is Authenticated) {
        emit(SplashAuthenticated());
      } else if (authState is Unauthenticated) {
        emit(SplashUnauthenticated());
      } else if (authState is AuthError) {
        emit(SplashError(authState.message));
      }
    });

    // If auth is already in a final state, handle it
    final currentAuthState = authBloc.state;
    if (currentAuthState is Authenticated) {
      emit(SplashAuthenticated());
    } else if (currentAuthState is Unauthenticated) {
      emit(SplashUnauthenticated());
    } else if (currentAuthState is AuthError) {
      emit(SplashError(currentAuthState.message));
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}