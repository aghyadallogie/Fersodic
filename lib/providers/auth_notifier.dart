import 'package:fersodict/core/jwt.dart';
import 'package:fersodict/core/secure_storage.dart';
import 'package:fersodict/providers/auth_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';

import '../data/auth_repository.dart';

/// Provider exposing the current authentication token state.
///
/// The state is an `AsyncValue<String?>` where the value is either a
/// JWT token (when authenticated) or `null` (when not authenticated).
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<String?>>(
      (ref) => AuthNotifier(ref.read(authRepositoryProvider)),
    );

/// Manages authentication state and token lifecycle.
///
/// Responsibilities:
/// - Restore a previously stored token on construction.
/// - Provide `login` to fetch/store a token via `AuthRepository`.
/// - Provide `logout` to remove the token and clear state.
class AuthNotifier extends StateNotifier<AsyncValue<String?>> {
  /// Creates an [AuthNotifier] with the given repository.
  /// Automatically attempts to restore a saved token.
  AuthNotifier(this._repo) : super(const AsyncData(null)) {
    _restore();
  }

  final AuthRepository _repo;

  /// Restore token from secure storage if present and valid.
  ///
  /// If a stored token is valid, the state becomes `AsyncData(token)`.
  /// If no token is found or it is invalid/expired, the token is removed
  /// from storage and state remains unauthenticated (`null`).
  Future<void> _restore() async {
    final token = await getToken();
    if (token != null && isTokenValid(token)) {
      state = AsyncData(token);
    } else {
      await deleteToken();
    }
  }

  /// Attempt to log in using [email] and [plainPassword].
  ///
  /// While the request is in flight the state is set to `AsyncLoading()`;
  /// on success the state becomes `AsyncData(token)`, on error the state
  /// contains the error inside an `AsyncError` (handled by `AsyncValue.guard`).
  Future<void> login(String email, String plainPassword) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.login(email: email, plainPassword: plainPassword),
    );
  }

  /// Log out the current user: delete stored token and clear state.
  Future<void> logout() async {
    await deleteToken();
    state = const AsyncData(null);
  }
}
