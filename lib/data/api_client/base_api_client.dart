import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:gtd_network/gtd_network.dart';
import '../models/api_error_model.dart';

class BaseApiClient {
  final GtdNetworkService _networkService;
  final BaseEnvironment _environment;
  final String? accessToken;

  BaseApiClient({
    required BaseEnvironment environment,
    this.accessToken,
    GtdNetworkService? networkService,
  }) : _environment = environment,
       _networkService = networkService ?? GtdNetworkService.shared;

  /// Common headers for all API requests
  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    return headers;
  }

  /// Perform GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final gtdEndpoint = GtdEndpoint(
        env: _environment,
        path: endpoint,
      );

      final request = GTDNetworkRequest(
        type: GtdMethod.get,
        enpoint: gtdEndpoint,
        headers: _headers,
        queryParams: _addAccessTokenToQuery(queryParameters),
      );

      _networkService.request = request;
      final response = await _networkService.execute();

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Perform POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final gtdEndpoint = GtdEndpoint(
        env: _environment,
        path: endpoint,
      );

      final request = GTDNetworkRequest(
        type: GtdMethod.post,
        enpoint: gtdEndpoint,
        data: data,
        headers: _headers,
        queryParams: _addAccessTokenToQuery(queryParameters),
      );

      _networkService.request = request;
      final response = await _networkService.execute();

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Perform PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final gtdEndpoint = GtdEndpoint(
        env: _environment,
        path: endpoint,
      );

      final request = GTDNetworkRequest(
        type: GtdMethod.put,
        enpoint: gtdEndpoint,
        data: data,
        headers: _headers,
        queryParams: _addAccessTokenToQuery(queryParameters),
      );

      _networkService.request = request;
      final response = await _networkService.execute();

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Perform DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final gtdEndpoint = GtdEndpoint(
        env: _environment,
        path: endpoint,
      );

      final request = GTDNetworkRequest(
        type: GtdMethod.delete,
        enpoint: gtdEndpoint,
        headers: _headers,
        queryParams: _addAccessTokenToQuery(queryParameters),
      );

      _networkService.request = request;
      final response = await _networkService.execute();

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Add access token to query parameters if provided
  Map<String, dynamic>? _addAccessTokenToQuery(Map<String, dynamic>? queryParams) {
    if (accessToken != null) {
      final params = queryParams ?? <String, dynamic>{};
      params['access_token'] = accessToken!;
      return params;
    }
    return queryParams;
  }

  /// Handle successful response
  ApiResponse<T> _handleResponse<T>(
    dynamic response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final statusCode = response.statusCode ?? 200;
    
    if (statusCode >= 200 && statusCode < 300) {
      final data = response.data as Map<String, dynamic>;
      return ApiResponse.success(fromJson(data), statusCode: statusCode);
    } else {
      final errorData = response.data as Map<String, dynamic>;
      final error = ApiErrorModel.fromJson(errorData);
      return ApiResponse.error(error, statusCode: statusCode);
    }
  }

  /// Handle request errors
  ApiResponse<T> _handleError<T>(dynamic error) {
    if (error is GtdError) {
      final apiError = ApiErrorModel(
        error: ApiError(
          code: error.statusCode ?? 0,
          message: error.message,
        ),
      );
      return ApiResponse.error(apiError, statusCode: error.statusCode ?? 500);
    } else {
      final apiError = ApiErrorModel(
        error: ApiError(
          code: 0,
          message: error.toString(),
        ),
      );
      return ApiResponse.error(apiError, statusCode: 500);
    }
  }

  /// Build query string for list endpoints
  Map<String, dynamic> buildListQuery({
    List<String>? fields,
    int? limit,
    String? meta,
    int? offset,
    List<String>? sort,
    String? filter,
    String? search,
  }) {
    final query = <String, dynamic>{};

    if (fields != null && fields.isNotEmpty) {
      query['fields'] = fields.join(',');
    }
    if (limit != null) query['limit'] = limit;
    if (meta != null) query['meta'] = meta;
    if (offset != null) query['offset'] = offset;
    if (sort != null && sort.isNotEmpty) {
      query['sort'] = sort.join(',');
    }
    if (filter != null) query['filter'] = filter;
    if (search != null) query['search'] = search;

    return query;
  }

  /// Build query string for single item endpoints
  Map<String, dynamic> buildSingleQuery({
    List<String>? fields,
    String? meta,
    String? version,
  }) {
    final query = <String, dynamic>{};

    if (fields != null && fields.isNotEmpty) {
      query['fields'] = fields.join(',');
    }
    if (meta != null) query['meta'] = meta;
    if (version != null) query['version'] = version;

    return query;
  }
} 