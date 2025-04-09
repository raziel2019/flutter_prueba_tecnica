import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_client.dart';

class CategoryService {
  final Dio _dio = ApiClient().dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<dynamic>> getAll() async {
    try{
      final response = await _dio.get('categories');
      return response.data;

    }catch(error){
      print("error para obtener las categorias: $error");
      return [];
    }
  }

}