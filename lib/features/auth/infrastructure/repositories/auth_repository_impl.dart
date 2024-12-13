import 'package:teslo_app/features/auth/domain/datasources/auth_datasource.dart';
import 'package:teslo_app/features/auth/domain/entities/user.dart';
import 'package:teslo_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:teslo_app/features/auth/infrastructure/datasources/auth_datasource_impl.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl([AuthDatasource? dataSource])
      : datasource = dataSource ?? AuthDatasourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return datasource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return datasource.login(email, password);
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    return datasource.register(email, password, fullName);
  }
}
