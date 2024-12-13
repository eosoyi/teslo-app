import 'package:dio/dio.dart';
import 'package:teslo_app/config/const/environment.dart';

import 'package:teslo_app/features/auth/domain/datasources/auth_datasource.dart';
import 'package:teslo_app/features/auth/domain/entities/user.dart';
import 'package:teslo_app/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:teslo_app/features/auth/infrastructure/mappers/user_mapper.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final dio = Dio(BaseOptions(baseUrl: Environments.apiUrl));

  @override
  Future<User> checkAuthStatus(String token) {
    // TODO: implement checkAuthStatus
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String password) async {
    try{
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password
      });

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    }
    on DioException catch (e) {
      if(e.response?.statusCode == 401){
        throw WrongCredentials();
      }
      throw UnimplementedError();
    }
    catch(error) {
      throw Exception(error);
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
