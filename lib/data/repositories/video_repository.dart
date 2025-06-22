import '../models/video_model.dart';
import '../models/api_error_model.dart';
import '../api_client/base_api_client.dart';
import '../api_client/pccc_environment.dart';

abstract class VideoRepository {
  Future<ApiResponse<VideoListResponse>> getVideos({
    List<String>? fields,
    int? limit,
    String? meta,
    int? offset,
    List<String>? sort,
    String? filter,
    String? search,
  });

  Future<ApiResponse<VideoSingleResponse>> getVideo(
    int id, {
    List<String>? fields,
    String? meta,
    String? version,
  });
}

class VideoRepositoryImpl implements VideoRepository {
  final BaseApiClient _apiClient;
  final bool _useMockData;

  VideoRepositoryImpl({
    required BaseApiClient apiClient,
    bool useMockData = false,
  }) : _apiClient = apiClient,
       _useMockData = useMockData;

  @override
  Future<ApiResponse<VideoListResponse>> getVideos({
    List<String>? fields,
    int? limit,
    String? meta,
    int? offset,
    List<String>? sort,
    String? filter,
    String? search,
  }) async {
    if (_useMockData) {
      return _getMockVideos();
    }

    final queryParams = _apiClient.buildListQuery(
      fields: fields,
      limit: limit,
      meta: meta,
      offset: offset,
      sort: sort,
      filter: filter,
      search: search,
    );

    return await _apiClient.get<VideoListResponse>(
      PcccEndpoints.videos,
      queryParameters: queryParams,
      fromJson: (json) => VideoListResponse.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<VideoSingleResponse>> getVideo(
    int id, {
    List<String>? fields,
    String? meta,
    String? version,
  }) async {
    if (_useMockData) {
      return _getMockVideo(id);
    }

    final queryParams = _apiClient.buildSingleQuery(
      fields: fields,
      meta: meta,
      version: version,
    );

    return await _apiClient.get<VideoSingleResponse>(
      PcccEndpoints.videoById(id),
      queryParameters: queryParams,
      fromJson: (json) => VideoSingleResponse.fromJson(json),
    );
  }

  // Mock data methods
  ApiResponse<VideoListResponse> _getMockVideos() {
    final mockVideos = [
      VideoModel(
        id: 1,
        title: 'Hướng dẫn sử dụng bình chữa cháy',
        link: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        thumbnail: 'https://images.unsplash.com/photo-1551218808-94e220e084d2?w=800&q=80',
        description: 'Video hướng dẫn chi tiết cách sử dụng bình chữa cháy an toàn và hiệu quả',
        category: 1,
        tags: 'pccc,hướng dẫn,bình chữa cháy',
      ),
      VideoModel(
        id: 2,
        title: 'Cách thoát hiểm khi có hỏa hoạn',
        link: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        thumbnail: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80',
        description: 'Kỹ năng thoát hiểm cần thiết khi gặp tình huống hỏa hoạn',
        category: 1,
        tags: 'pccc,thoát hiểm,hỏa hoạn',
      ),
      VideoModel(
        id: 3,
        title: 'Kỹ năng sơ cứu người bị nạn',
        link: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        thumbnail: 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=800&q=80',
        description: 'Hướng dẫn sơ cứu cơ bản cho người bị nạn trong các tình huống khẩn cấp',
        category: 2,
        tags: 'sơ cứu,khẩn cấp,y tế',
      ),
      VideoModel(
        id: 4,
        title: 'Diễn tập PCCC tại khu chung cư',
        link: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        thumbnail: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
        description: 'Quy trình diễn tập phòng cháy chữa cháy tại các khu chung cư',
        category: 3,
        tags: 'diễn tập,chung cư,pccc',
      ),
      VideoModel(
        id: 5,
        title: 'Cách lắp đặt hệ thống báo cháy',
        link: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        thumbnail: 'https://images.unsplash.com/photo-1503428593586-e225b39bddfe?w=800&q=80',
        description: 'Hướng dẫn lắp đặt và bảo trì hệ thống báo cháy',
        category: 4,
        tags: 'báo cháy,lắp đặt,thiết bị',
      ),
      VideoModel(
        id: 6,
        title: 'Bảo trì thiết bị PCCC định kỳ',
        link: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        thumbnail: 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800&q=80',
        description: 'Quy trình bảo trì thiết bị PCCC định kỳ để đảm bảo hoạt động tốt',
        category: 4,
        tags: 'bảo trì,thiết bị,định kỳ',
      ),
    ];

    final response = VideoListResponse(
      data: mockVideos,
      meta: VideoMetadata(totalCount: mockVideos.length, filterCount: mockVideos.length),
    );

    return ApiResponse.success(response);
  }

  ApiResponse<VideoSingleResponse> _getMockVideo(int id) {
    final mockVideo = VideoModel(
      id: id,
      title: 'Hướng dẫn sử dụng bình chữa cháy',
      link: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      thumbnail: 'https://images.unsplash.com/photo-1551218808-94e220e084d2?w=800&q=80',
      description: 'Video hướng dẫn chi tiết cách sử dụng bình chữa cháy an toàn và hiệu quả',
      category: 1,
      tags: 'pccc,hướng dẫn,bình chữa cháy',
    );

    final response = VideoSingleResponse(data: mockVideo);
    return ApiResponse.success(response);
  }
} 