import 'package:base_app/pages/base/view/base_view.dart';
import 'package:base_app/pages/search/view_model/search_view_model.dart';
import '../model/search_result_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart' hide ButtonStyle;

class SearchView extends BaseView<SearchViewModel> {
  const SearchView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search input
              _buildSearchInput(context),
              Gap(16),
              
              // Loading indicator
              if (viewModel.isLoading)
                Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Text('Đang tìm kiếm...'),
                  ),
                ),
              
              // Error message
              if (viewModel.errorMessage != null)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(
                    viewModel.errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              
              // Search results
              if (viewModel.hasResults && !viewModel.isLoading) ...[
                // Total results
                Text(
                  'Tìm thấy ${viewModel.searchResult.totalResults} kết quả cho "${viewModel.currentQuery}"',
                  style: TextStyle(
                    fontSize: 14,
                    color: VNLTheme.of(context).colorScheme.mutedForeground,
                  ),
                ),
                Gap(16),
                
                // Articles section
                if (viewModel.searchResult.articles.isNotEmpty) ...[
                  _buildSectionHeader(context, 'Bài viết (${viewModel.searchResult.articles.length})'),
                  Gap(12),
                  _buildArticlesList(context, viewModel.searchResult.articles),
                  Gap(24),
                ],
                
                // Documents section
                if (viewModel.searchResult.documents.isNotEmpty) ...[
                  _buildSectionHeader(context, 'Tài liệu (${viewModel.searchResult.documents.length})'),
                  Gap(12),
                  _buildDocumentsList(context, viewModel.searchResult.documents),
                ],
              ],
              
              // No results
              if (!viewModel.hasResults && !viewModel.isLoading && viewModel.currentQuery.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        BootstrapIcons.search,
                        size: 48,
                        color: VNLTheme.of(context).colorScheme.mutedForeground,
                      ),
                      Gap(16),
                      Text(
                        'Không tìm thấy kết quả nào',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gap(8),
                      Text(
                        'Thử tìm kiếm với từ khóa khác',
                        style: TextStyle(
                          color: VNLTheme.of(context).colorScheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchInput(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: VNLTheme.of(context).colorScheme.border),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Icon(
              BootstrapIcons.search,
              color: VNLTheme.of(context).colorScheme.mutedForeground,
            ),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm bài viết, tài liệu...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  viewModel.search(value);
                }
              },
            ),
          ),
          if (viewModel.currentQuery.isNotEmpty)
            VNLButton.ghost(
              onPressed: () => viewModel.clearSearch(),
              child: Icon(BootstrapIcons.x),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildArticlesList(BuildContext context, List<SearchArticleItem> articles) {
    return Column(
      children: articles.map((article) => 
        _buildArticleItem(context, article)
      ).toList(),
    );
  }

  Widget _buildArticleItem(BuildContext context, SearchArticleItem article) {
    // Format date
    String formattedDate = '';
    if (article.dateCreated != null) {
      try {
        final date = DateTime.parse(article.dateCreated!);
        formattedDate = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      } catch (e) {
        formattedDate = article.dateCreated!;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: VNLCard(
        child: VNLButton.ghost(
          onPressed: () {
            // Navigate to article detail from search
            context.goNamed(
              'news-detail',
              pathParameters: {'newsId': article.id.toString()},
              queryParameters: {'from': 'search', 'tab': '2'}, // From search, but assume tab 2 for search context
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                if (article.imageUrl != null)
                  Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: VNLTheme.of(context).colorScheme.muted,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        article.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: VNLTheme.of(context).colorScheme.muted,
                            child: Icon(
                              BootstrapIcons.image,
                              color: VNLTheme.of(context).colorScheme.mutedForeground,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (article.summary?.isNotEmpty == true) ...[
                        Gap(4),
                        Text(
                          article.summary!,
                          style: TextStyle(
                            fontSize: 14,
                            color: VNLTheme.of(context).colorScheme.mutedForeground,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (formattedDate.isNotEmpty) ...[
                        Gap(8),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: VNLTheme.of(context).colorScheme.mutedForeground,
                          ),
                        ),
                      ],
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

  Widget _buildDocumentsList(BuildContext context, List<SearchDocumentItem> documents) {
    return Column(
      children: documents.map((document) => 
        _buildDocumentItem(context, document)
      ).toList(),
    );
  }

  Widget _buildDocumentItem(BuildContext context, SearchDocumentItem document) {
    // Format date
    String formattedDate = '';
    if (document.dateCreated != null) {
      try {
        final date = DateTime.parse(document.dateCreated!);
        formattedDate = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      } catch (e) {
        formattedDate = document.dateCreated!;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 0),
      child: VNLCard(
        child: VNLButton.ghost(
          onPressed: () {
            // Navigate to document detail (you'll need to implement this route)
            print('Navigate to document ${document.id}');
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // File icon
                Container(
                  width: 48,
                  height: 48,
                  margin: EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: VNLTheme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getFileIcon(document.fileType),
                    color: VNLTheme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (document.description?.isNotEmpty == true) ...[
                        Gap(4),
                        Text(
                          document.description!,
                          style: TextStyle(
                            fontSize: 14,
                            color: VNLTheme.of(context).colorScheme.mutedForeground,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      Gap(8),
                      // Wrap(
                      //   spacing: 8,
                      //   runSpacing: 8,
                      //   crossAxisAlignment: WrapCrossAlignment.center,
                      //   children: [
                      //     if (document.fileType != null)
                      //       Container(
                      //         padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      //         decoration: BoxDecoration(
                      //           color: VNLTheme.of(context).colorScheme.muted,
                      //           borderRadius: BorderRadius.circular(4),
                      //         ),
                      //         child: Text(
                      //           document.fileType!.toUpperCase(),
                      //           style: TextStyle(
                      //             fontSize: 10,
                      //             fontWeight: FontWeight.w600,
                      //           ),
                      //         ),
                      //       ),
                      //     if (formattedDate.isNotEmpty)
                      //       Text(
                      //         formattedDate,
                      //         style: TextStyle(
                      //           fontSize: 12,
                      //           color: VNLTheme.of(context).colorScheme.mutedForeground,
                      //         ),
                      //       ),
                      //   ],
                      // ),
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

  IconData _getFileIcon(String? fileType) {
    switch (fileType?.toLowerCase()) {
      case 'pdf':
        return BootstrapIcons.filePdf;
      case 'doc':
      case 'docx':
        return BootstrapIcons.fileWord;
      case 'xls':
      case 'xlsx':
        return BootstrapIcons.fileExcel;
      case 'ppt':
      case 'pptx':
        return BootstrapIcons.filePpt;
      default:
        return BootstrapIcons.fileText;
    }
  }
} 