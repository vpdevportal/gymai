import 'package:gymai/core/di/injection.dart';
import 'package:gymai/features/auth/domain/entities/user.dart';
import 'package:gymai/features/auth/domain/repositories/auth_repository.dart';
import 'package:gymai/features/auth/domain/usecases/login_usecase.dart';
import 'package:gymai/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthState {
  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.user,
    this.errorMessage,
  });

  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    // Check for existing Firebase session
    final repo = getIt<AuthRepository>();
    repo.getCurrentUser().then((result) {
      result.fold(
        (_) {},
        (user) {
          if (user != null) {
            state = AuthState(status: AuthStatus.authenticated, user: user);
          }
        },
      );
    });
    return const AuthState();
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await getIt<LoginUseCase>()(email: email, password: password);
    result.fold(
      (failure) => state = AuthState(errorMessage: failure.message),
      (user) => state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await getIt<SignInWithGoogleUseCase>()();
    result.fold(
      (failure) => state = AuthState(errorMessage: failure.message),
      (user) => state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
  }

  Future<void> logout() async {
    await getIt<AuthRepository>().logout();
    state = const AuthState();
  }
}
