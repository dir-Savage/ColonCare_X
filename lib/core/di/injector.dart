import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coloncare/features/splash/presentation/splash_bloc/splash_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// BLoCs
import '../../features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import '../../features/auth/presentation/blocs/auth_form_bloc/auth_form_bloc.dart';
import '../../features/home/presentation/blocs/home_bloc/home_bloc.dart';

// Repositories
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

// Use Cases
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  await _mainInject();
  await _authInject();
}

Future<void> _mainInject() async {
  // Core Services
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);
}

Future<void> _authInject() async {
  // Data Sources
  getIt.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
      auth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => ResetPasswordUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => CheckAuthStatusUseCase(getIt<AuthRepository>()));

  // BLoCs
  getIt.registerLazySingleton<AuthBloc>(
        () => AuthBloc(
      checkAuthStatusUseCase: getIt<CheckAuthStatusUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      loginUseCase: getIt<LoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
    ),
  );

  getIt.registerFactory<AuthFormBloc>(
        () => AuthFormBloc(),
  );

  getIt.registerFactory<HomeBloc>(
        () => HomeBloc(authBloc: getIt<AuthBloc>()),
  );

  getIt.registerFactory<SplashBloc>(
        () => SplashBloc(authBloc: getIt<AuthBloc>()),
  );
}