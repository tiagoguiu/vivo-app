import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:uuid/uuid.dart';

import '../../exports.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();
  static final Dio dio = Dio()
    ..interceptors.addAll([
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseBody: false, // Disable to prevent binary data logging errors
      ),
      ApiInterceptor(),
    ]);

  static Future<ApiResponse<T>> request<T>({
    required String url,
    required HttpMethod method,
    required bool isAuthenticated,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    FormData? formData,
    required T Function(dynamic value) fromJson,
    bool enqueueIfOffline = true,
  }) async {
    final connectivityService = NetworkConnectivityService();
    if (!connectivityService.isOnline && enqueueIfOffline) {
      final queuedRequest = QueuedRequest(
        id: const Uuid().v4(),
        url: url,
        method: method.name.toUpperCase(),
        queryParameters: queryParameters,
        data: data,
        headers: headers,
        isAuthenticated: isAuthenticated,
        timestamp: DateTime.now(),
      );

      await ApiRequestQueue().enqueueRequest(queuedRequest);
      throw Exception('No internet connection. Request has been queued.');
    }
    final extra = {'auth': isAuthenticated};
    final Map<String, String> baseHeaders = {'Accept': 'application/json'};

    final effectiveHeaders = {...baseHeaders, ...(headers ?? {})};

    final dynamic requestPayload = formData ?? data;

    try {
      Response response;
      switch (method) {
        case HttpMethod.get:
          response = await dio.get(
            url,
            queryParameters: queryParameters,
            options: Options(headers: effectiveHeaders, extra: extra),
          );
          break;
        case HttpMethod.post:
          response = await dio.post(
            url,
            queryParameters: queryParameters,
            data: requestPayload,
            options: Options(headers: effectiveHeaders, extra: extra),
          );
          break;
        case HttpMethod.put:
          response = await dio.put(
            url,
            queryParameters: queryParameters,
            data: requestPayload,
            options: Options(headers: effectiveHeaders, extra: extra),
          );
          break;
        case HttpMethod.delete:
          response = await dio.delete(
            url,
            queryParameters: queryParameters,
            data: requestPayload,
            options: Options(headers: effectiveHeaders, extra: extra),
          );
          break;
        case HttpMethod.patch:
          response = await dio.patch(
            url,
            queryParameters: queryParameters,
            data: requestPayload,
            options: Options(headers: effectiveHeaders, extra: extra),
          );
          break;
      }

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        T? mappedData;
        mappedData = await compute(fromJson, response.data);
        return ApiResponse<T>(data: mappedData, statusCode: response.statusCode);
      } else {
        ApiError? apiError;
        try {
          if (response.data is Map<String, dynamic>) {
            apiError = ApiError.fromJson(response.data as Map<String, dynamic>);
          } else if (response.data != null) {
            // Try to coerce to a Map
            apiError = ApiError.fromJson(Map<String, dynamic>.from(response.data));
          }
        } catch (_) {
          apiError = null;
        }

        return ApiResponse<T>(statusCode: response.statusCode, errorData: apiError);
      }
    } on DioException catch (e) {
      ApiError? apiError;
      try {
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          apiError = ApiError.fromJson(data);
        } else if (data != null) {
          apiError = ApiError.fromJson(Map<String, dynamic>.from(data));
        }
      } catch (_) {
        apiError = null;
      }

      return ApiResponse<T>(statusCode: e.response?.statusCode, errorData: apiError);
    } catch (e) {
      return ApiResponse<T>(statusCode: 500);
    }
  }

  /// Faz uma requisição GET que retorna bytes (para downloads de arquivos binários como PDFs)
  static Future<ApiResponse<List<int>>> requestBytes({
    required String url,
    required bool isAuthenticated,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final extra = {'auth': isAuthenticated};
    final Map<String, String> baseHeaders = {...(headers ?? {})};

    try {
      final response = await dio.get<List<int>>(
        url,
        queryParameters: queryParameters,
        options: Options(headers: baseHeaders, extra: extra, responseType: ResponseType.bytes),
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ApiResponse<List<int>>(data: response.data, statusCode: response.statusCode);
      } else {
        return ApiResponse<List<int>>(statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      return ApiResponse<List<int>>(statusCode: e.response?.statusCode);
    } catch (_) {
      return ApiResponse<List<int>>(statusCode: 500);
    }
  }
}

enum HttpMethod { get, post, put, delete, patch }
