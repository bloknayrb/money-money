import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/error/app_error.dart';

/// Interceptor to strictly map DioExceptions into domain AppErrors.
class AppErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppError mappedError;

    if (err.type == DioExceptionType.connectionTimeout || 
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      mappedError = NetworkError.timeout();
    } else if (err.error is SocketException || err.type == DioExceptionType.connectionError) {
      mappedError = NetworkError.noConnection();
    } else if (err.response != null) {
      final statusCode = err.response?.statusCode;
      // Handle known SimpleFIN / Backend errors
      if (statusCode == 402) {
        mappedError = BankSyncError.paymentRequired();
      } else if (statusCode == 403) {
        mappedError = BankSyncError.tokenCompromised();
      } else if (statusCode == 429) {
        mappedError = BankSyncError.rateLimited();
      } else {
        mappedError = NetworkError.serverError(statusCode);
      }
    } else {
      mappedError = NetworkError(
        message: 'An unexpected network error occurred.',
        originalError: err,
      );
    }

    // Pass the mapped error up
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: mappedError, // Embed AppError in the error property
      ),
    );
  }
}

/// Interceptor that redacts Authorization headers from debug logs.
///
/// Prevents API keys from appearing in debug output even when
/// LogInterceptor is enabled.
class _RedactingLogInterceptor extends LogInterceptor {
  _RedactingLogInterceptor()
      : super(requestBody: true, responseBody: true);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final redacted = options.copyWith(
      headers: Map.of(options.headers)
        ..updateAll((k, v) =>
            (k.toLowerCase() == 'authorization' ||
                    k.toLowerCase() == 'x-api-key')
                ? '[REDACTED]'
                : v),
    );
    super.onRequest(redacted, handler);
  }
}

/// Creates a configured Dio instance for HTTP requests.
///
/// Default 5s receive timeout is fine for most requests (token claims,
/// balance-only fetches). Use [createSimplefinDioClient] for transaction
/// pulls that may take longer.
///
/// No retry interceptor — retries are dangerous with 24 req/day limit.
Dio createDioClient() {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  dio.interceptors.add(AppErrorInterceptor());

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  return dio;
}

/// Creates a Dio instance for LLM API calls.
///
/// 120s receive timeout for long streaming completions (especially Ollama).
/// Streaming response type is set per-request, not globally. Uses a redacting
/// log interceptor so API keys are never written to debug output.
Dio createLlmDioClient() {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 120),
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(_RedactingLogInterceptor());
  }

  return dio;
}

/// Creates a Dio instance for SimpleFIN transaction syncs.
///
/// Longer 60s receive timeout for initial 90-day transaction pulls
/// which can return large payloads from slow bank aggregators.
Dio createSimplefinDioClient() {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  dio.interceptors.add(AppErrorInterceptor());

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  return dio;
}