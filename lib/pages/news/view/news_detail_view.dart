import 'package:flutter/material.dart' hide ButtonStyle, CircularProgressIndicator;
import 'package:base_app/pages/base/view/base_view.dart';
import 'package:base_app/pages/news/view_model/news_detail_view_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import '../model/news_model.dart';
import '../../../utils/editor_js_parser/editor_js_parser.dart';
import '../../../utils/editor_js_parser/editor_js_flutter_widgets.dart';
import '../../../utils/editor_js_parser/editor_js_models.dart';

class NewsDetailView extends BaseView<NewsDetailViewModel> {
  const NewsDetailView({super.key, required super.viewModel});

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
              ],
            ),
          );
        }

        final news = viewModel.newsDetail;
        if (news == null) {
          return const Center(
            child: Text('Không tìm thấy tin tức'),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNewsHeader(context, news),
              _buildNewsContent(context, news),
              _buildNewsFooter(context, news),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNewsHeader(BuildContext context, NewsModel news) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero image
        if (news.thumbnail != null) ...[
          AspectRatio(
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
                      size: 64,
                      color: VNLTheme.of(context).colorScheme.mutedForeground,
                    ),
                  ),
                );
              },
            ),
          ),
          const Gap(16),
        ],

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category badge
              if (news.category != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: VNLTheme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    news.category!.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: VNLTheme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Gap(12),
              ],

              // Title
              Text(
                news.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),

              const Gap(16),

              // Author and meta info
              Row(
                children: [
                  if (news.author?.avatarUrl != null) ...[
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(news.author!.avatarUrl!),
                      onBackgroundImageError: (exception, stackTrace) {},
                      child: news.author?.avatarUrl == null 
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    const Gap(12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (news.author?.name != null)
                        Text(
                          news.author?.name ?? 'Tác giả không xác định',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        if (news.author?.title != null)
                          Text(
                            news.author!.title!,
                            style: TextStyle(
                              fontSize: 14,
                              color: VNLTheme.of(context).colorScheme.mutedForeground,
                            ),
                          ),
                      ],
                    ),
                  ),
                  VNLButton.ghost(
                    onPressed: () => _shareNews(news),
                    child: const Icon(Icons.share_outlined),
                  ),
                ],
              ),

              const Gap(8),

              // Date and view count
              Row(
                children: [
                  Text(
                    _formatDate(news.dateCreated),
                    style: TextStyle(
                      fontSize: 14,
                      color: VNLTheme.of(context).colorScheme.mutedForeground,
                    ),
                  ),
                  if (news.viewCount != null) ...[
                    const Gap(16),
                    Icon(
                      Icons.visibility_outlined,
                      size: 16,
                      color: VNLTheme.of(context).colorScheme.mutedForeground,
                    ),
                    const Gap(4),
                    Text(
                      '${news.viewCount} lượt xem',
                      style: TextStyle(
                        fontSize: 14,
                        color: VNLTheme.of(context).colorScheme.mutedForeground,
                      ),
                    ),
                  ],
                ],
              ),

              const Gap(16),
              const VNLDivider(),
              const Gap(16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewsContent(BuildContext context, NewsModel news) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary/Lead
          if (news.summary != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: VNLTheme.of(context).colorScheme.muted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: VNLTheme.of(context).colorScheme.border,
                ),
              ),
              child: Text(
                news.summary!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ),
            const Gap(24),
          ],

          // Content - Parse EditorJS blocks
          if (news.content != null) ...[
            _buildEditorJSContent(context, news.content!),
            const Gap(24),
          ],
        ],
      ),
    );
  }

  Widget _buildEditorJSContent(BuildContext context, dynamic content) {
    try {
      EditorJSData editorData;
      
      if (content is Map<String, dynamic>) {
        // Content đã là Map object từ API response
        editorData = EditorJSParser.parseFromMap(content);
      } else if (content is String) {
        // Content là JSON string
        if (content.trim().startsWith('{') && content.trim().endsWith('}')) {
          editorData = EditorJSParser.parseFromString(content);
        } else {
          // Fallback: Hiển thị như text thường nếu không phải EditorJS JSON
          return Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
            ),
          );
        }
      } else {
        // Unsupported content type
        return Text(
          'Định dạng nội dung không được hỗ trợ',
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            color: VNLTheme.of(context).colorScheme.mutedForeground,
          ),
        );
      }
      
      // Render với custom options
      final widgets = EditorJSFlutterWidgets.renderBlocks(
        editorData,
        options: EditorJSRenderOptions(
          context: context,
          blockSpacing: 16.0,
          blockPadding: EdgeInsets.zero,
          showErrors: true,
          showUnknownBlocks: false,
        ),
      );
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      );
    } catch (e) {
      // Nếu parse lỗi, hiển thị như text thường và log error
      debugPrint('Error parsing EditorJS content: $e');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: VNLTheme.of(context).colorScheme.destructive.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: VNLTheme.of(context).colorScheme.destructive.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  size: 16,
                  color: VNLTheme.of(context).colorScheme.destructive,
                ),
                const Gap(8),
                Expanded(
                  child: Text(
                    'Lỗi hiển thị nội dung. Vui lòng thử lại sau.',
                    style: TextStyle(
                      fontSize: 12,
                      color: VNLTheme.of(context).colorScheme.destructive,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),
          Text(
            content.toString(),
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildNewsFooter(BuildContext context, NewsModel news) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VNLDivider(),
          const Gap(16),

          // Tags
          if (news.tags != null && news.tags!.isNotEmpty) ...[
            const Text(
              'Thẻ:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const Gap(8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: news.tags!.split(',').map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: VNLTheme.of(context).colorScheme.muted,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tag.trim(),
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              }).toList(),
            ),
            const Gap(16),
          ],

          // Action buttons
          Row(
            children: [
              Expanded(
                child: VNLButton.outline(
                  onPressed: () => _shareNews(news),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share_outlined, size: 18),
                      Gap(8),
                      Text('Chia sẻ'),
                    ],
                  ),
                ),
              ),
              const Gap(12),
              Expanded(
                child: VNLButton.outline(
                  onPressed: () => _bookmarkNews(news),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark_border_outlined, size: 18),
                      Gap(8),
                      Text('Lưu'),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const Gap(32),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Hôm nay, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays == 1) {
        return 'Hôm qua, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} ngày trước';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }

  void _shareNews(NewsModel news) {
    debugPrint('Sharing news: ${news.title}');
  }

  void _bookmarkNews(NewsModel news) {
    debugPrint('Bookmarking news: ${news.title}');
  }
} 