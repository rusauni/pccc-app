import 'package:flutter/material.dart' hide ButtonStyle, CircularProgressIndicator, showDialog;
import 'package:vnl_common_ui/vnl_ui.dart';

import 'video_tab_view_model.dart';
import 'video_player_widget.dart';
import '../../../../data/repositories/video_repository.dart';
import '../../../../data/api_client/base_api_client.dart';
import '../../../../data/api_client/pccc_environment.dart';
import '../../../../data/models/video_model.dart';

class VideosTab extends StatefulWidget {
  const VideosTab({super.key});

  @override
  State<VideosTab> createState() => _VideosTabState();
}

class _VideosTabState extends State<VideosTab> with TickerProviderStateMixin {
  late VideoTabViewModel _viewModel;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _initializeViewModel();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
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
    _animationController.dispose();
    _searchController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  // Helper function to remove Vietnamese accents for search
  String _removeVietnameseAccents(String text) {
    const vietnameseMap = {
      'à': 'a', 'á': 'a', 'ạ': 'a', 'ả': 'a', 'ã': 'a',
      'â': 'a', 'ầ': 'a', 'ấ': 'a', 'ậ': 'a', 'ẩ': 'a', 'ẫ': 'a',
      'ă': 'a', 'ằ': 'a', 'ắ': 'a', 'ặ': 'a', 'ẳ': 'a', 'ẵ': 'a',
      'è': 'e', 'é': 'e', 'ẹ': 'e', 'ẻ': 'e', 'ẽ': 'e',
      'ê': 'e', 'ề': 'e', 'ế': 'e', 'ệ': 'e', 'ể': 'e', 'ễ': 'e',
      'ì': 'i', 'í': 'i', 'ị': 'i', 'ỉ': 'i', 'ĩ': 'i',
      'ò': 'o', 'ó': 'o', 'ọ': 'o', 'ỏ': 'o', 'õ': 'o',
      'ô': 'o', 'ồ': 'o', 'ố': 'o', 'ộ': 'o', 'ổ': 'o', 'ỗ': 'o',
      'ơ': 'o', 'ờ': 'o', 'ớ': 'o', 'ợ': 'o', 'ở': 'o', 'ỡ': 'o',
      'ù': 'u', 'ú': 'u', 'ụ': 'u', 'ủ': 'u', 'ũ': 'u',
      'ư': 'u', 'ừ': 'u', 'ứ': 'u', 'ự': 'u', 'ử': 'u', 'ữ': 'u',
      'ỳ': 'y', 'ý': 'y', 'ỵ': 'y', 'ỷ': 'y', 'ỹ': 'y',
      'đ': 'd',
      'À': 'A', 'Á': 'A', 'Ạ': 'A', 'Ả': 'A', 'Ã': 'A',
      'Â': 'A', 'Ầ': 'A', 'Ấ': 'A', 'Ậ': 'A', 'Ẩ': 'A', 'Ẫ': 'A',
      'Ă': 'A', 'Ằ': 'A', 'Ắ': 'A', 'Ặ': 'A', 'Ẳ': 'A', 'Ẵ': 'A',
      'È': 'E', 'É': 'E', 'Ẹ': 'E', 'Ẻ': 'E', 'Ẽ': 'E',
      'Ê': 'E', 'Ề': 'E', 'Ế': 'E', 'Ệ': 'E', 'Ể': 'E', 'Ễ': 'E',
      'Ì': 'I', 'Í': 'I', 'Ị': 'I', 'Ỉ': 'I', 'Ĩ': 'I',
      'Ò': 'O', 'Ó': 'O', 'Ọ': 'O', 'Ỏ': 'O', 'Õ': 'O',
      'Ô': 'O', 'Ồ': 'O', 'Ố': 'O', 'Ộ': 'O', 'Ổ': 'O', 'Ỗ': 'O',
      'Ơ': 'O', 'Ờ': 'O', 'Ớ': 'O', 'Ợ': 'O', 'Ở': 'O', 'Ỡ': 'O',
      'Ù': 'U', 'Ú': 'U', 'Ụ': 'U', 'Ủ': 'U', 'Ũ': 'U',
      'Ư': 'U', 'Ừ': 'U', 'Ứ': 'U', 'Ự': 'U', 'Ử': 'U', 'Ữ': 'U',
      'Ỳ': 'Y', 'Ý': 'Y', 'Ỵ': 'Y', 'Ỷ': 'Y', 'Ỹ': 'Y',
      'Đ': 'D',
    };

    String result = text;
    vietnameseMap.forEach((key, value) {
      result = result.replaceAll(key, value);
    });
    return result;
  }

  Future<void> _handleVideoTap(BuildContext context, VideoModel video) async {
    try {
      if (video.link != null && video.link!.isNotEmpty) {
        // Navigate to video player page
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VideoPlayerWidget(video: video),
          ),
        );
      } else {
        // Show message that video has no link
        if (mounted) {
          _showErrorSnackBar('Video này chưa có link');
        }
      }
    } catch (e) {
      // Handle any errors during navigation
      if (mounted) {
        _showErrorSnackBar('Lỗi khi mở video: ${e.toString()}');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: VNLTheme.of(context).colorScheme.destructive,
        ),
      );
    }
  }

  List<VideoModel> _getFilteredVideos() {
    if (_searchQuery.isEmpty) {
      return _viewModel.videos;
    }
    
    // Remove accents from search query for better matching
    final normalizedQuery = _removeVietnameseAccents(_searchQuery.toLowerCase());
    
    return _viewModel.videos.where((video) {
      final normalizedTitle = _removeVietnameseAccents(video.title.toLowerCase());
      final normalizedDescription = _removeVietnameseAccents(
        (video.description ?? '').toLowerCase()
      );
      
      return normalizedTitle.contains(normalizedQuery) ||
             normalizedDescription.contains(normalizedQuery) ||
             video.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             (video.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _viewModel.refreshVideos();
      },
      child: CustomScrollView(
        slivers: [
          // Search Bar
          SliverToBoxAdapter(
            child: _buildSearchSection(),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                if (_viewModel.isLoading) {
                  return _buildShimmerLoading();
                }

                if (_viewModel.errorMessage != null) {
                  return _buildErrorState();
                }

                final filteredVideos = _getFilteredVideos();
                
                if (filteredVideos.isEmpty) {
                  return _buildEmptyState();
                }

                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildVideoGrid(filteredVideos),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8), // Reduced bottom padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.video,
                size: 24,
                color: VNLTheme.of(context).colorScheme.primary,
              ),
              const Gap(8),
              Text(
                'Video Hướng Dẫn',
                style: VNLTheme.of(context).typography.h3.copyWith(
                  fontWeight: FontWeight.bold,
                  color: VNLTheme.of(context).colorScheme.foreground,
                ),
              ),
            ],
          ),
          const Gap(12), // Reduced gap
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm video ...',
              prefixIcon: Icon(LucideIcons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: VNLTheme.of(context).colorScheme.border,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: VNLTheme.of(context).colorScheme.border,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: VNLTheme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: VNLTheme.of(context).colorScheme.background,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: _searchQuery.isNotEmpty 
                  ? IconButton(
                      icon: Icon(LucideIcons.x, size: 16),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildShimmerGrid(),
          const Gap(16),
        ],
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _buildShimmerCard();
      },
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      decoration: BoxDecoration(
        color: VNLTheme.of(context).colorScheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: VNLTheme.of(context).colorScheme.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: VNLTheme.of(context).colorScheme.muted.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail shimmer
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: VNLTheme.of(context).colorScheme.muted.withValues(alpha: 0.3),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
          ),
          // Content shimmer
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: VNLTheme.of(context).colorScheme.muted.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Gap(8),
                  Container(
                    height: 12,
                    width: 80,
                    decoration: BoxDecoration(
                      color: VNLTheme.of(context).colorScheme.muted.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: VNLTheme.of(context).colorScheme.destructive.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.triangleAlert,
                size: 48,
                color: VNLTheme.of(context).colorScheme.destructive,
              ),
            ),
            const Gap(24),
            Text(
              'Đã xảy ra lỗi',
              style: VNLTheme.of(context).typography.h3.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            Text(
              _viewModel.errorMessage ?? 'Không thể tải video',
              textAlign: TextAlign.center,
              style: VNLTheme.of(context).typography.p.copyWith(
                color: VNLTheme.of(context).colorScheme.mutedForeground,
              ),
            ),
            const Gap(24),
            VNLButton.primary(
              onPressed: _viewModel.refreshVideos,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.refreshCw, size: 16),
                  const Gap(8),
                  const Text('Thử lại'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: VNLTheme.of(context).colorScheme.muted.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.video,
                size: 64,
                color: VNLTheme.of(context).colorScheme.mutedForeground,
              ),
            ),
            const Gap(24),
            Text(
              _searchQuery.isNotEmpty ? 'Không tìm thấy video' : 'Chưa có video nào',
              style: VNLTheme.of(context).typography.h3.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            Text(
              _searchQuery.isNotEmpty 
                  ? 'Thử tìm kiếm với từ khóa khác'
                  : 'Các video hướng dẫn sẽ xuất hiện ở đây',
              textAlign: TextAlign.center,
              style: VNLTheme.of(context).typography.p.copyWith(
                color: VNLTheme.of(context).colorScheme.mutedForeground,
              ),
            ),
            if (_searchQuery.isNotEmpty) ...[
              const Gap(24),
              VNLButton.outline(
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
                child: const Text('Xóa bộ lọc'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVideoGrid(List<VideoModel> videos) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_searchQuery.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Tìm thấy ${videos.length} video',
                style: VNLTheme.of(context).typography.textSmall.copyWith(
                  color: VNLTheme.of(context).colorScheme.mutedForeground,
                ),
              ),
            ),
          ],
          GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return _buildModernVideoCard(
                video: video,
                onTap: () => _handleVideoTap(context, video),
              );
            },
          ),
          const Gap(16),
        ],
      ),
    );
  }

  Widget _buildModernVideoCard({
    required VideoModel video,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: VNLTheme.of(context).colorScheme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: VNLTheme.of(context).colorScheme.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: VNLTheme.of(context).colorScheme.muted.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with play button
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                      child: Image.network(
                        _viewModel.getVideoThumbnail(video),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  VNLTheme.of(context).colorScheme.muted.withValues(alpha: 0.3),
                                  VNLTheme.of(context).colorScheme.muted.withValues(alpha: 0.1),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                LucideIcons.video,
                                size: 32,
                                color: VNLTheme.of(context).colorScheme.mutedForeground,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  // Play button overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.center,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: VNLTheme.of(context).colorScheme.primary.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            LucideIcons.play,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Duration badge
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _viewModel.getVideoDuration(video),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      style: VNLTheme.of(context).typography.base.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.calendar,
                          size: 12,
                          color: VNLTheme.of(context).colorScheme.mutedForeground,
                        ),
                        const Gap(4),
                        Expanded(
                          child: Text(
                            _viewModel.getVideoDate(video),
                            style: VNLTheme.of(context).typography.textSmall.copyWith(
                              color: VNLTheme.of(context).colorScheme.mutedForeground,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
