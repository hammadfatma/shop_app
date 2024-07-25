import 'package:dio/dio.dart';

class DioHelper {
  final String _baseUrl = 'https://student.valuxapps.com/api/';
  final Dio _dio;
  DioHelper(this._dio);

  Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    _dio.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'Content-Type': 'application/json',
    };
    return await _dio.get(
      '$_baseUrl$url',
      queryParameters: query,
    );
  }

  Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    _dio.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'Content-Type': 'application/json',
    };
    return _dio.post(
      '$_baseUrl$url',
      queryParameters: query,
      data: data,
    );
  }

  Future<Response> putData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    _dio.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'Content-Type': 'application/json',
    };
    return _dio.put(
      '$_baseUrl$url',
      queryParameters: query,
      data: data,
    );
  }
}
