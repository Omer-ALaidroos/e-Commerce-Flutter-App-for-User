import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioHelper {
  Dio? dio;

  DioHelper() {
    dio ??= Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );
dio?.interceptors.add(LogInterceptor(
  request: true,
  requestBody: true,
  responseBody: true,
));
    dio!.interceptors.add(PrettyDioLogger());
  }

  getRequest({
    required String endPoint,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    try {
     //log(token.toString());
      dio!.options.headers['Authorization'] = 'Bearer $token';
      Response response = await dio!.get(endPoint, queryParameters: query);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  postRequest({
    required String endPoint,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    try {
      if (token != null) {
        dio!.options.headers['Authorization'] = 'Bearer $token';
         dio!.options.headers['Content-Type'] = 'application/json';
      }
      final Response response = await dio!.post(endPoint, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  putRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    try {
      if (token != null) {
        dio!.options.headers['Authorization'] = 'Bearer $token';
       
      }
      final Response response =
          await dio!.put(endPoint, data: data, queryParameters: query);

      return response;
    } catch (e) {
    
      rethrow;
    }
  }

  deleteRequest({
    required String endPoint,
    String? token,
  }) async {
    try {
      if (token != null) {
        dio!.options.headers['Authorization'] = 'Bearer $token';
      }
      final Response response = await dio!.delete(endPoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
