import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/features/auth/domain/entities/user.dart';
import 'package:teslo_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:teslo_app/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:teslo_app/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:teslo_app/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

import '../../../shared/infrastructure/services/key_values_storage_services.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessage = ''});

  AuthState copyWith(
          {AuthStatus? authStatus, User? user, String? errorMessage}) =>
      AuthState(
          authStatus: authStatus ?? this.authStatus,
          user: user ?? this.user,
          errorMessage: errorMessage ?? this.errorMessage);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValuesStorageServices keyValuesStorageServices;

  AuthNotifier(
      {required this.authRepository, required this.keyValuesStorageServices})
      : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final user = await authRepository.login(email, password);
      _settLoggedUser(user);
    } on CustomError catch (e) {
      logout(errorMessage: e.message);
    } catch (e) {
      logout(errorMessage: 'Error no controlado');
    }
  }

  void registerUser(String email, String password) async {}

  void checkAuthStatus() async {
    final token = await keyValuesStorageServices.getValue<String>('token');

    if (token == null) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _settLoggedUser(user);
    } catch (error) {
      logout();
    }
  }

  Future<void> logout({String? errorMessage}) async {
    await keyValuesStorageServices.removeKey('token');
    state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage);
  }

  _settLoggedUser(User user) async {
    await keyValuesStorageServices.setKeyValues('token', user.token);
    state = state.copyWith(
      user: user,
      errorMessage: '',
      authStatus: AuthStatus.authenticated,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();
  return AuthNotifier(
      authRepository: authRepository,
      keyValuesStorageServices: keyValueStorageService);
});
