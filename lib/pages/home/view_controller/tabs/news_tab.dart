import 'package:flutter/material.dart' hide ButtonStyle, TextButton, CircularProgressIndicator;
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:gtd_helper/helper/gtd_app_logger.dart';
import 'package:go_router/go_router.dart';
import '../../../../data/repositories/article_repository.dart';
import '../../../../data/api_client/base_api_client.dart';
import '../../../../data/api_client/pccc_environment.dart';
import '../../../../data/models/article_model.dart';

class NewsTab extends StatefulWidget {
  const NewsTab({super.key});

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  late final ArticleRepository _articleRepository;
  List<ArticleModel> _articles = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeRepository();
    _loadArticles();
  }

  void _initializeRepository() {
    final apiClient = BaseApiClient(
      environment: PcccEnvironment.development(),
    );
    _articleRepository = ArticleRepositoryImpl(
      apiClient: apiClient,
      useMockData: false, // Use real API as per cursor rules - real mode
    );
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _articleRepository.getArticles(
        limit: 10,
        sort: ['-date_created'], // Sort by newest first
      );

      if (response.isSuccess && response.data != null) {
        setState(() {
          _articles = response.data!.data;
          _isLoading = false;
        });
      } else {
        Logger.e('Failed to load articles from API: ${response.error?.error.message}');
        setState(() {
          _errorMessage = 'Không thể tải tin tức từ máy chủ';
          _isLoading = false;
        });
      }
    } catch (e) {
      Logger.e('Exception loading articles: $e');
      setState(() {
        _errorMessage = 'Lỗi kết nối: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
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
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: VNLTheme.of(context).colorScheme.destructive,
              ),
            ),
            const Gap(16),
            VNLButton.primary(
              onPressed: _loadArticles,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: VNLTheme.of(context).colorScheme.mutedForeground,
            ),
            const Gap(16),
            Text(
              'Chưa có tin tức nào',
              style: TextStyle(
                color: VNLTheme.of(context).colorScheme.mutedForeground,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadArticles,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _articles.length,
        separatorBuilder: (context, index) => const Gap(16),
        itemBuilder: (context, index) {
          final article = _articles[index];
          return _buildNewsCard(article);
        },
      ),
    );
  }

  Widget _buildNewsCard(ArticleModel article) {
    return VNLCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (article.thumbnail != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                article.thumbnail!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: VNLTheme.of(context).colorScheme.muted,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: VNLTheme.of(context).colorScheme.mutedForeground,
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(8),
                if (article.dateCreated != null)
                  Text(
                    _formatDate(article.dateCreated!),
                    style: TextStyle(
                      color: VNLTheme.of(context).colorScheme.mutedForeground,
                      fontSize: 12,
                    ),
                  ),
                const Gap(8),
                if (article.summary != null)
                  Text(
                    article.summary!,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                const Gap(12),
                VNLButton.ghost(
                  onPressed: () {
                    if (article.id != null) {
                      context.push('/news/${article.id}');
                    }
                  },
                  child: const Text('Đọc thêm'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
