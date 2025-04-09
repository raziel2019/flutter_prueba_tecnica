import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_client.dart';

class AuthService {
final Dio _dio = ApiClient().dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> register({
    required  String name,
    required  String email,
    required  String password,
  }) async  {
    try{
      final response = await _dio.post('register', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      final token = response.data['token'];
      if (token != null) {
              await _storage.write(key: 'auth_token', value: token);
              return true;
      }
      return false;

    }catch(error){
      print("Error en el registro:  $error");
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try{
      final response = await _dio.post('login', data: {
        'email': email,
        'password': password,
      });
      final token = response.data['token'];
      if(token != null){
          await _storage.write(key: 'auth_token', value: token);
          print(token);
          return true;
      }

      return false;
    } catch(error){ 
      print("Error en el login: $error");
      return false;
    }
  }

  Future<bool> logout() async {
    try{
      final response = await _dio.post('logout');
        await _storage.delete(key: 'auth_token');

      return true;
    }catch(error){
      print("Error al cerrar la sesion: $error");
      return false;
    }



  }

}