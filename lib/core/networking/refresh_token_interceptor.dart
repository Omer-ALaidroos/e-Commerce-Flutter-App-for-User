import 'dart:developer';
import 'dart:async'; // Import for Completer
import 'package:dio/dio.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/core/utils/storage_helper.dart';
import 'package:e_commerce_app/features/auth/models/login_response_model.dart';
import 'package:e_commerce_app/features/auth/repo/auth_local_data_source.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Interceptor to handle automatic token injection and background token refresh.
class RefreshTokenInterceptor extends Interceptor {
  final Dio _dio;

  bool _isRefreshing = false;
  Completer<String?>? _refreshTokenCompleter;

  RefreshTokenInterceptor(this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Automatically inject the Bearer token into headers if it exists.
    final token = await sl<StorageHelper>().getToken();
   
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // When a 401 Unauthorized error occurs, attempt to refresh the token.
    final is401 = err.response?.statusCode == 401;
    final isRefreshPath = err.requestOptions.path.contains(ApiEndpoints.refreshToken);

    if (is401 && !isRefreshPath) {
      final storageHelper = sl<StorageHelper>();
      final refreshToken = await storageHelper.getRefreshToken();
     log('refresh token: $refreshToken');
      if (refreshToken != null && refreshToken.trim().isNotEmpty) {
        if (_isRefreshing) {
          // If a refresh is already in progress, wait for it to complete
          log("Refresh already in progress, waiting for new token...");
          final newAccessToken = await _refreshTokenCompleter?.future;
          if (newAccessToken != null) {
            // Create new options with the new token to avoid using stale headers
            final newOptions = Options(headers: {'Authorization': 'Bearer $newAccessToken'});
            final newRequestOptions = err.requestOptions.copyWith(headers: newOptions.headers);
            // Retry the original request with the new token            return handler.resolve(await _dio.fetch(newRequestOptions));
          }
        }

        _isRefreshing = true;
        _refreshTokenCompleter = Completer<String?>();

        try {
          // Create a dedicated Dio for refresh with logging
          final refreshDio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
          refreshDio.interceptors.add(PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            logPrint: (object) => log("REFRESH_DIO: $object"), // Custom log tag for refresh
          ));

          log("Attempting to refresh token with refresh token: $refreshToken");
          final response = await refreshDio.get(
            ApiEndpoints.refreshToken,
            queryParameters: {"refreshToken": refreshToken},
          );

          if (response.statusCode == 200 && response.data != null) {
            log("Token refreshed successfully. Response data: ${response.data}");
            final loginResponse = LoginResponseModel.fromJson(response.data);

            if (loginResponse.token != null && loginResponse.refreshToken != null) {
              await storageHelper.saveToken(loginResponse.token!);
              await storageHelper.saveRefreshToken(loginResponse.refreshToken!);
              if (loginResponse.userId != null) {
                await sl<AuthLocalDataSource>().saveUserId(loginResponse.userId!);
              }
              
              _refreshTokenCompleter?.complete(loginResponse.token);
              // Retry the original request with the newly obtained token
              final newOptions = Options(headers: {'Authorization': 'Bearer ${loginResponse.token}'});
              final newRequestOptions = err.requestOptions.copyWith(headers: newOptions.headers);

              return handler.resolve(await _dio.fetch(newRequestOptions));
            }
          }
          
          log("Refresh token failed or invalid response. Clearing session.");
          await storageHelper.clear();
          _refreshTokenCompleter?.complete(null);
          return handler.next(err);
        } catch (e) {
          log("Refresh token unexpected error: $e. Clearing session.");
          await storageHelper.clear();
          _refreshTokenCompleter?.complete(null);
          return handler.next(err);
        } finally {
          _isRefreshing = false;
        }
      } else {
        log("No refresh token found. Clearing session.");
        await storageHelper.clear();
        return handler.next(err);
      }
    } else if (is401 && isRefreshPath) {
      log("Refresh token endpoint returned 401. Session expired.");
      await sl<StorageHelper>().clear();
    }
    return handler.next(err);
  }
}