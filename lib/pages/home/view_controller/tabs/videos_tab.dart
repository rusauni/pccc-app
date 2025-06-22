import 'package:flutter/material.dart' hide IconButton, ButtonStyle, CircularProgressIndicator, showDialog;
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'video_tab_view_model.dart';
import '../../../../data/repositories/video_repository.dart';
import '../../../../data/api_client/base_api_client.dart';
import '../../../../data/api_client/pccc_environment.dart';
import '../../../../data/models/video_model.dart';

class VideosTab extends StatefulWidget {
  const VideosTab({super.key});

  @override
  State<VideosTab> createState() => _VideosTabState();
}

class _VideosTabState extends State<VideosTab> {
  late VideoTabViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _initializeViewModel();
  }

  void _initializeViewModel() {
    // Create API client with development environment
    final apiClient = BaseApiClient(
      environment: PcccEnvironment.development(),
      // TODO: Add access token if needed
    );

    // Create repository instance
    final videoRepository = VideoRepositoryImpl(
      apiClient: apiClient,
      useMockData: false, // Use real API as per cursor rules - real mode
    );

    // Initialize view model
    _viewModel = VideoTabViewModel(
      videoRepository: videoRepository,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _handleVideoTap(BuildContext context, VideoModel video) async {
    try {
      if (video.link != null && video.link!.isNotEmpty) {
        final Uri url = Uri.parse(video.link!);
        
        // Check if it's a valid URL
        if (await canLaunchUrl(url)) {
          await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );
        } else {
          // Show error using mounted check for proper context
          if (mounted) {
            _showErrorMessage('Không thể mở link video');
          }
        }
      } else {
        // Show message that video has no link
        if (mounted) {
          _showErrorMessage('Video này chưa có link');
        }
      }
    } catch (e) {
      // Handle any errors during URL launching
      if (mounted) {
        _showErrorMessage('Lỗi khi mở video: ${e.toString()}');
      }
    }
  }

  void _showErrorMessage(String message) {
    // Simple logging for now - could be enhanced later with proper toast/dialog
    debugPrint('Video error: $message');
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _viewModel.refreshVideos();
      },
      child: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: VNLTheme.of(context).colorScheme.destructive,
                  ),
                  const Gap(16),
                  Text(
                    _viewModel.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: VNLTheme.of(context).colorScheme.destructive,
                    ),
                  ),
                  const Gap(16),
                  VNLButton.primary(
                    onPressed: _viewModel.refreshVideos,
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (_viewModel.videos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.video_library,
                    size: 64,
                    color: VNLTheme.of(context).colorScheme.mutedForeground,
                  ),
                  const Gap(16),
                  Text(
                    'Chưa có video nào',
                    style: TextStyle(
                      color: VNLTheme.of(context).colorScheme.mutedForeground,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: _viewModel.videos.length,
            itemBuilder: (context, index) {
              final video = _viewModel.videos[index];
              return _buildVideoCard(
                title: video.title,
                duration: _viewModel.getVideoDuration(video),
                date: _viewModel.getVideoDate(video),
                thumbnailUrl: _viewModel.getVideoThumbnail(video),
                                 onTap: () => _handleVideoTap(context, video),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildVideoCard({
    required String title,
    required String duration,
    required String date,
    required String thumbnailUrl,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  thumbnailUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(Icons.video_library, size: 50, color: Colors.grey[600]),
                    );
                  },
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    duration,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                    onTap: onTap,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          RadixIcons.play,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
