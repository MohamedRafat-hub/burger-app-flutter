
import 'dart:developer';

import 'package:dio/dio.dart';
import 'api_error.dart';

class ApiExceptions {

  static ApiError apiHandler(DioException error) {

    switch (error.type) {

      case DioExceptionType.connectionTimeout:
        return ApiError(
          message: 'Connection timeout, please check your internet and try again.',
        );

      case DioExceptionType.sendTimeout:
        return ApiError(
          message: 'Request took too long to send. Please try again.',
        );

      case DioExceptionType.receiveTimeout:
        return ApiError(
          message: 'Server took too long to respond. Please try again later.',
        );

      case DioExceptionType.badCertificate:
        return ApiError(
          message: 'Security issue detected. Please try again later.',
        );

      case DioExceptionType.cancel:
        return ApiError(
          message: 'Request was cancelled.',
        );

      case DioExceptionType.connectionError:
        return ApiError(
          message: 'No internet connection. Please check your network.',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.unknown:
      default:
        return ApiError(
          message: 'Unexpected error occurred. Please try again.',
        );
    }
  }

  static ApiError _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    if (data != null) {
      log(data.toString());

      // لو فيه validation errors
      if (data['errors'] != null && data['errors'] is Map) {
        final errors = data['errors'] as Map;
        final firstError = errors.values.first;

        if (firstError is List && firstError.isNotEmpty) {
          return ApiError(
            message: firstError.first.toString(),
            statusCode: statusCode,
          );
        }
      }

      // لو فيه message
      if (data['message'] != null) {
        return ApiError(
          message: data['message'].toString(),
          statusCode: statusCode,
        );
      }
    }

    return ApiError(
      message: 'Something went wrong. Please try again.',
      statusCode: statusCode,
    );
  }
}
