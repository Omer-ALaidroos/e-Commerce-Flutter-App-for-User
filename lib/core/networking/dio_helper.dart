import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/networking/refresh_token_interceptor.dart';
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
    dio!.interceptors.add(RefreshTokenInterceptor(dio!));
    dio!.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
    ));
  }

  getRequest({
    required String endPoint,
    Map<String, dynamic>? query,
  }) async {
    try {
      Response response = await dio!.get(
        endPoint,
        queryParameters: query,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  postRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    try {
      final Response response = await dio!.post(
        endPoint,
        data: data,
        queryParameters: query,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  putRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    try {
      final Response response = await dio!.put(
        endPoint,
        data: data,
        queryParameters: query,
        options: Options(
          headers: {
          },
        ),
      );
      return response;
    } catch (e) {
    
      rethrow;
    }
  }

  deleteRequest({
    required String endPoint,
  }) async {
    try {
      final Response response = await dio!.delete(
        endPoint,
        options: Options(
          headers: {
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
