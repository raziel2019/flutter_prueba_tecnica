import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  
  late final Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: dotenv.env['API_URL']!,
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options,handler) async {
        try {
          final token = await _storage.read(key: 'auth_token');
          if(token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }catch(error){
          print("Error al leer el token: $error");
        }
        return handler.next(options);
      },
        onError: (DioException error, handler) {
          print('Error en la petición: ${error.message}');
          return handler.next(error);
        },
    ));
  }

}