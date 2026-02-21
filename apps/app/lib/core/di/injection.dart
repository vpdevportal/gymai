import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:gymai/core/network/auth_interceptor.dart';
import 'package:gymai/core/network/dio_client.dart';
import 'package:gymai/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:gymai/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:gymai/features/auth/domain/repositories/auth_repository.dart';
import 'package:gymai/features/auth/domain/usecases/login_usecase.dart';
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

  // ── Repositories ───────────────────────────────────────────────
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: getIt(),
        authInterceptor: getIt(),
      ),
    )

  // ── Use Cases ──────────────────────────────────────────────────
    ..registerLazySingleton(() => LoginUseCase(repository: getIt()));
}
