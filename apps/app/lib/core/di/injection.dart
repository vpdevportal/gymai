import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gymai/core/network/auth_interceptor.dart';
import 'package:gymai/core/network/dio_client.dart';
import 'package:gymai/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:gymai/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:gymai/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:gymai/features/auth/domain/repositories/auth_repository.dart';
import 'package:gymai/features/auth/domain/usecases/login_usecase.dart';
import 'package:gymai/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // ── External ───────────────────────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  getIt
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerSingleton<FlutterSecureStorage>(
      const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      ),
    )

  // ── Firebase ───────────────────────────────────────────────────
    ..registerSingleton<firebase.FirebaseAuth>(firebase.FirebaseAuth.instance)
    ..registerSingleton<GoogleSignIn>(
      GoogleSignIn(scopes: ['email', 'profile']),
    )

  // ── Network ────────────────────────────────────────────────────
    ..registerSingleton<AuthInterceptor>(
      AuthInterceptor(secureStorage: getIt()),
    )
    ..registerSingleton<DioClient>(
      DioClient(authInterceptor: getIt()),
    )

  // ── Data Sources ───────────────────────────────────────────────
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(dio: getIt<DioClient>().dio),
    )
    ..registerLazySingleton<FirebaseAuthDataSource>(
      () => FirebaseAuthDataSourceImpl(
        firebaseAuth: getIt(),
        googleSignIn: getIt(),
      ),
    )

  // ── Repositories ───────────────────────────────────────────────
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: getIt(),
        firebaseDataSource: getIt(),
      ),
    )

  // ── Use Cases ──────────────────────────────────────────────────
    ..registerLazySingleton(() => LoginUseCase(repository: getIt()))
    ..registerLazySingleton(
      () => SignInWithGoogleUseCase(repository: getIt()),
    );
}
