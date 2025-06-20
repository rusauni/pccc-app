import 'package:vnl_common_ui/vnl_ui.dart';

class ApiErrorModel {
  final ApiError error;

  ApiErrorModel({required this.error});

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) {
    return ApiErrorModel(
      error: ApiError.fromJson(json['error']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error.toJson(),
    };
  }
}

class ApiError {
  final int code;
  final String message;

  ApiError({
    required this.code,
    required this.message,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }

  ApiError copyWith({
    int? code,
    String? message,
  }) {
    return ApiError(
      code: code ?? this.code,
      message: message ?? this.message,
    );
  }
}

// Common HTTP status codes for PCCC API
class HttpStatusCodes {
  static const int ok = 200;
  static const int unauthorized = 401;
  static const int notFound = 404;
  static const int internalServerError = 500;
}

// API response wrapper for handling both success and error states
class ApiResponse<T> {
  final T? data;
  final ApiErrorModel? error;
  final bool isSuccess;
  final int statusCode;

  ApiResponse({
    this.data,
    this.error,
    required this.isSuccess,
    required this.statusCode,
  });

  factory ApiResponse.success(T data, {int statusCode = 200}) {
    return ApiResponse<T>(
      data: data,
      isSuccess: true,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(ApiErrorModel error, {int statusCode = 500}) {
    return ApiResponse<T>(
      error: error,
      isSuccess: false,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
    int statusCode,
  ) {
    if (statusCode >= 200 && statusCode < 300) {
      return ApiResponse.success(fromJsonT(json), statusCode: statusCode);
    } else {
      return ApiResponse.error(
        ApiErrorModel.fromJson(json),
        statusCode: statusCode,
      );
    }
  }
} 