import 'package:flutter/material.dart' hide ButtonStyle, CircularProgressIndicator;
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../data/models/video_model.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoModel video;

  const VideoPlayerWidget({
    super.key,
    required this.video,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late YoutubePlayerController _controller;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    if (widget.video.link == null || widget.video.link!.isEmpty) {
      return;
    }

    // Extract video ID from the link
    final videoId = _extractVideoId(widget.video.link!);
    if (videoId == null) {
      return;
    }

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        showLiveFullscreenButton: true,
        enableCaption: true,
        useHybridComposition: true,
      ),
    );
  }

  String? _extractVideoId(String url) {
    final RegExp youtubeRegex = RegExp(
      r'(?:youtube\.com/watch\?v=|youtu\.be/|youtube\.com/embed/)([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
    );
    final Match? match = youtubeRegex.firstMatch(url);
    return match?.group(1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.video.link == null || widget.video.link!.isEmpty) {
      return _buildErrorScreen('Video này chưa có link');
    }

    final videoId = _extractVideoId(widget.video.link!);
    if (videoId == null) {
      return _buildErrorScreen('Link video không hợp lệ');
    }

    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        setState(() {
          _isFullScreen = true;
        });
      },
      onExitFullScreen: () {
        setState(() {
          _isFullScreen = false;
        });
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: VNLTheme.of(context).colorScheme.primary,
        progressColors: ProgressBarColors(
          playedColor: VNLTheme.of(context).colorScheme.primary,
          handleColor: VNLTheme.of(context).colorScheme.primary,
          bufferedColor: VNLTheme.of(context).colorScheme.muted,
          backgroundColor: VNLTheme.of(context).colorScheme.border,
        ),
        onReady: () {
          _controller.addListener(() {
            if (mounted) {
              setState(() {});
            }
          });
        },
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: _isFullScreen ? null : AppBar(
            title: Text(
              widget.video.title,
              style: VNLTheme.of(context).typography.h4.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: const Icon(LucideIcons.arrowLeft),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Column(
            children: [
              player,
              if (!_isFullScreen) ...[
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.video.title,
                          style: VNLTheme.of(context).typography.h3.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.video.description != null && 
                            widget.video.description!.isNotEmpty) ...[
                          const Gap(16),
                          Text(
                            widget.video.description!,
                            style: VNLTheme.of(context).typography.base,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorScreen(String message) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.video.title,
          style: VNLTheme.of(context).typography.h4.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
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
              message,
              textAlign: TextAlign.center,
              style: VNLTheme.of(context).typography.p.copyWith(
                color: VNLTheme.of(context).colorScheme.mutedForeground,
              ),
            ),
            const Gap(24),
            VNLButton.primary(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Quay lại'),
            ),
          ],
        ),
      ),
    );
  }
} 