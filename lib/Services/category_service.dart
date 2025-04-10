import 'dart:ffi';
import 'dart:io';

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

  Future<bool> createCategory({
    required String code,
    required String name,
    required String description,
    required File? photo, 
    required int parent_id,
  }) async {
    try{
      FormData formData = FormData.fromMap({
        'code': code,
        'name': name,
        'description':description,
        'parent_id': parent_id,
        if(photo !=null)
          'photo': await MultipartFile.fromFile(
            photo.path,
            filename: photo.path.split('/').last,
          ),
      });
      final response = await _dio.post('categories', data: formData);
      print('Respuesta: ${response.statusCode}');
      return response.statusCode == 200 || response.statusCode == 201;
    }catch(error){
      print("Error al crear una categoria: $error");
      return false;
    }
  }

}