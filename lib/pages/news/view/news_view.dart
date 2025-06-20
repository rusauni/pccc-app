import 'package:flutter/material.dart' hide ButtonStyle, CircularProgressIndicator;
import 'package:base_app/pages/base/view/base_view.dart';
import 'package:base_app/pages/news/view_model/news_view_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:go_router/go_router.dart';
import '../model/news_model.dart';
import '../../../router/app_router.dart';

class NewsView extends BaseView<NewsViewModel> {
  const NewsView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (viewModel.errorMessage != null) {
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
                  viewModel.errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: VNLTheme.of(context).colorScheme.destructive,
                  ),
                ),
                const Gap(16),
                VNLButton.primary(
                  onPressed: viewModel.refreshNews,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        return VNLRefreshTrigger(
          onRefresh: viewModel.refreshNews,
          child: CustomScrollView(
            slivers: [
              // Breaking News Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Breaking News',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: VNLTheme.of(context).colorScheme.foreground,
                    ),
                  ),
                ),
              ),

              // Featured News
              if (viewModel.newsList.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildFeaturedNews(context, viewModel.newsList.first),
                ),

              // Category Tabs
              SliverToBoxAdapter(
                child: _buildCategoryTabs(context),
              ),

              // News List
              _buildNewsListSliver(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeaturedNews(BuildContext context, NewsModel news) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: VNLButton.ghost(
        onPressed: () => _navigateToDetail(context, news.id!),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Background Image
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Image.network(
                    news.thumbnail ?? 'https://via.placeholder.com/400x250',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: VNLTheme.of(context).colorScheme.muted,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: VNLTheme.of(context).colorScheme.mutedForeground,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ),

                // Content
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        news.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(6),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundImage: news.author?.avatarUrl != null
                                ? NetworkImage(news.author!.avatarUrl!)
                                : null,
                            child: news.author?.avatarUrl == null
                                ? const Icon(Icons.person, size: 16)
                                : null,
                          ),
                          const Gap(8),
                          Text(
                            news.author?.name ?? 'Tác giả không xác định',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _formatDate(news.dateCreated),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: viewModel.categories.asMap().entries.map((entry) {
            final index = entry.key;
            final category = entry.value;
            final isSelected = category.id == viewModel.selectedCategoryId;
            
            return Padding(
              padding: EdgeInsets.only(right: index < viewModel.categories.length - 1 ? 12 : 0),
              child: GestureDetector(
                onTap: () => viewModel.selectCategory(category.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? VNLTheme.of(context).colorScheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected 
                          ? VNLTheme.of(context).colorScheme.primary
                          : VNLTheme.of(context).colorScheme.border,
                    ),
                  ),
                  child: Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected 
                          ? Colors.white
                          : VNLTheme.of(context).colorScheme.foreground,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNewsListSliver(BuildContext context) {
    if (viewModel.newsList.length <= 1) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 64,
                  color: VNLTheme.of(context).colorScheme.mutedForeground,
                ),
                const Gap(16),
                Text(
                  'Không có tin tức nào khác',
                  style: TextStyle(
                    color: VNLTheme.of(context).colorScheme.mutedForeground,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Skip first news (featured news)
    final remainingNews = viewModel.newsList.skip(1).toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final news = remainingNews[index];
          return _buildNewsListItem(context, news);
        },
        childCount: remainingNews.length,
      ),
    );
  }

  Widget _buildNewsListItem(BuildContext context, NewsModel news) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: VNLButton.ghost(
        onPressed: () => _navigateToDetail(context, news.id!),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: VNLTheme.of(context).colorScheme.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: VNLTheme.of(context).colorScheme.border.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: Image.network(
                    news.thumbnail ?? 'https://via.placeholder.com/70x70',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: VNLTheme.of(context).colorScheme.muted,
                        child: Icon(
                          Icons.image_not_supported,
                          size: 24,
                          color: VNLTheme.of(context).colorScheme.mutedForeground,
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              const Gap(12),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const Gap(6),
                    
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: VNLTheme.of(context).colorScheme.mutedForeground,
                        ),
                        const Gap(4),
                        Text(
                          _formatDate(news.dateCreated),
                          style: TextStyle(
                            fontSize: 12,
                            color: VNLTheme.of(context).colorScheme.mutedForeground,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.visibility_outlined,
                          size: 14,
                          color: VNLTheme.of(context).colorScheme.mutedForeground,
                        ),
                        const Gap(4),
                        Text(
                          '${news.viewCount ?? 0}',
                          style: TextStyle(
                            fontSize: 12,
                            color: VNLTheme.of(context).colorScheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _navigateToDetail(BuildContext context, int newsId) {
    context.goNamed(
      AppRouterPath.newsDetail,
      pathParameters: {'newsId': newsId.toString()},
    );
  }
} 