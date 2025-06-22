import 'package:base_app/pages/base/view_model/base_view_model.dart';
import 'package:gtd_helper/helper/gtd_app_logger.dart';
import '../../../../data/repositories/video_repository.dart';
import '../../../../data/models/video_model.dart';

class VideoTabViewModel extends BaseViewModel {
  final VideoRepository _videoRepository;
  
  List<VideoModel> _videos = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<VideoModel> get videos => _videos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  VideoTabViewModel({
    required VideoRepository videoRepository,
  }) : _videoRepository = videoRepository {
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final videosResponse = await _videoRepository.getVideos(
        limit: 50,
        sort: ['-id'], // Sort by newest first
      );
      
      Logger.i('Videos response: ${videosResponse.isSuccess}');
      Logger.i('Videos data count: ${videosResponse.data?.data.length ?? 0}');
      
      if (videosResponse.isSuccess && videosResponse.data != null) {
        _videos = videosResponse.data!.data;
        Logger.i('Successfully loaded ${_videos.length} videos from API');
      } else {
        Logger.e('Failed to load videos from API: ${videosResponse.error?.error.message}');
        _errorMessage = 'Không thể tải video từ máy chủ';
        _videos = []; // Empty list instead of dummy data
      }
    } catch (e, stackTrace) {
      Logger.e('Error loading videos data: $e\nStackTrace: $stackTrace');
      _errorMessage = 'Lỗi kết nối: ${e.toString()}';
      _videos = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshVideos() async {
    Logger.i('Refreshing videos data...');
    await _loadVideos();
  }

  VideoModel? getVideoById(int id) {
    try {
      return _videos.firstWhere((video) => video.id == id);
    } catch (e) {
      return null;
    }
  }

  // Helper method to extract video duration from link/description if available
  String getVideoDuration(VideoModel video) {
    // Since API doesn't provide duration, we'll use a placeholder
    // In real implementation, you might want to extract this from video metadata
    return '5:24'; // Default duration
  }

  // Helper method to format video upload date
  String getVideoDate(VideoModel video) {
    // Since API doesn't provide date, we'll use current date
    // In real implementation, you might want to add date field to API
    return DateTime.now().toString().split(' ')[0];
  }

  // Helper method to get video thumbnail URL
  String getVideoThumbnail(VideoModel video) {
    if (video.thumbnail != null && video.thumbnail!.isNotEmpty) {
      return video.thumbnail!;
    }
    
    // Try to extract YouTube thumbnail if it's a YouTube link
    if (video.link != null) {
      final RegExp youtubeRegex = RegExp(
        r'(?:youtube\.com/watch\?v=|youtu\.be/|youtube\.com/embed/)([a-zA-Z0-9_-]{11})',
        caseSensitive: false,
      );
      final Match? match = youtubeRegex.firstMatch(video.link!);
      
      if (match != null) {
        final String videoId = match.group(1)!;
        return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
      }
    }
    
    // Default placeholder image
    return 'https://images.unsplash.com/photo-1551218808-94e220e084d2?w=800&q=80';
  }
} 