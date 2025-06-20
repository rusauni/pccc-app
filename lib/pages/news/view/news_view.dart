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

        return RefreshIndicator(
          onRefresh: viewModel.refreshNews,
          child: Column(
            children: [
              _buildCategoryTabs(context),
              Expanded(
                child: _buildNewsList(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryTabs(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: viewModel.categories.map((category) {
            final isSelected = category.id == viewModel.selectedCategoryId;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: isSelected
                  ? VNLButton.primary(
                      onPressed: () => viewModel.selectCategory(category.id),
                      child: Text(category.name),
                    )
                  : VNLButton.outline(
                      onPressed: () => viewModel.selectCategory(category.id),
                      child: Text(category.name),
                    ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNewsList(BuildContext context) {
    if (viewModel.newsList.isEmpty) {
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
              'Không có tin tức nào',
              style: TextStyle(
                color: VNLTheme.of(context).colorScheme.mutedForeground,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.newsList.length,
      separatorBuilder: (context, index) => const Gap(16),
      itemBuilder: (context, index) {
        final news = viewModel.newsList[index];
        return _buildNewsCard(context, news);
      },
    );
  }

  Widget _buildNewsCard(BuildContext context, NewsModel news) {
    return VNLCard(
      child: VNLButton.ghost(
        onPressed: () => _navigateToDetail(context, news.id!),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // News image
            if (news.thumbnail != null) ...[
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    news.thumbnail!,
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
              ),
            ],
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author and date
                  Row(
                    children: [
                      if (news.author?.avatarUrl != null) ...[
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(news.author!.avatarUrl!),
                          onBackgroundImageError: (exception, stackTrace) {},
                          child: news.author?.avatarUrl == null 
                              ? const Icon(Icons.person, size: 16)
                              : null,
                        ),
                        const Gap(8),
                      ],
                      Expanded(
                        child: Text(
                          news.author?.name ?? 'Tác giả không xác định',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        _formatDate(news.dateCreated),
                        style: TextStyle(
                          fontSize: 12,
                          color: VNLTheme.of(context).colorScheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  
                  const Gap(12),
                  
                  // Title
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const Gap(8),
                  
                  // Summary
                  if (news.summary != null) ...[
                    Text(
                      news.summary!,
                      style: TextStyle(
                        fontSize: 14,
                        color: VNLTheme.of(context).colorScheme.mutedForeground,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(12),
                  ],
                  
                  // Footer with view count and category
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (news.category != null)
                        VNLChip(
                          child: Text(
                            news.category!.name,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      const Spacer(),
                      if (news.viewCount != null) ...[
                        Icon(
                          Icons.visibility_outlined,
                          size: 14,
                          color: VNLTheme.of(context).colorScheme.mutedForeground,
                        ),
                        const Gap(4),
                        Text(
                          '${news.viewCount}',
                          style: TextStyle(
                            fontSize: 12,
                            color: VNLTheme.of(context).colorScheme.mutedForeground,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
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