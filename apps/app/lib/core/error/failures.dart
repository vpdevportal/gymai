import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.serverFailure({
    required String message,
    int? statusCode,
  }) = ServerFailure;

  const factory Failure.networkFailure({
    @Default('No internet connection. Please check your network.') String message,
  }) = NetworkFailure;

  const factory Failure.cacheFailure({
    @Default('Local cache error occurred.') String message,
  }) = CacheFailure;

  const factory Failure.authFailure({
    @Default('Authentication failed. Please log in again.') String message,
  }) = AuthFailure;

  const factory Failure.unknownFailure({
    @Default('An unknown error occurred.') String message,
  }) = UnknownFailure;
}
