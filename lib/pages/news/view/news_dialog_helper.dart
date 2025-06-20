import 'package:flutter/material.dart' hide ButtonStyle, showDialog;
import 'package:vnl_common_ui/vnl_ui.dart';
import '../model/news_model.dart';

class NewsDialogHelper {
  static void showNewsDetail(BuildContext context, NewsModel news) {
    showDialog(
      context: context,
      builder: (context) => LayoutBuilder(
        builder: (context, constraints) => VNLAlert(
          title: const Text('Chi tiết tin tức'),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth * 0.9,
              maxHeight: constraints.maxHeight * 0.6,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  if (news.thumbnail != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          news.thumbnail!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: VNLTheme.of(context).colorScheme.muted,
                              child: const Center(
                                child: Icon(Icons.image_not_supported, size: 48),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const Gap(16),
                  ],
                  
                  // Title
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const Gap(12),
                  
                  // Author and date
                  Row(
                    children: [
                      if (news.author?.avatarUrl != null) ...[
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(news.author!.avatarUrl!),
                          onBackgroundImageError: (exception, stackTrace) {},
                          child: news.author?.avatarUrl == null 
                              ? const Icon(Icons.person, size: 16)
                              : null,
                        ),
                        const Gap(8),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              news.author?.name ?? 'Tác giả không xác định',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
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
                      ),
                    ],
                  ),
                  const Gap(16),
                  
                  // Summary
                  if (news.summary != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const Gap(16),
                  ],
                  
                  // Content
                  if (news.content != null) ...[
                    Text(
                      news.content!,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const Gap(24),
                  ],
                                 
                   // Actions
                   const Gap(16),
                   Row(
                     children: [
                       Expanded(
                         child: VNLButton.outline(
                           onPressed: () {
                             debugPrint('Sharing news: ${news.title}');
                           },
                           child: const Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Icon(Icons.share_outlined, size: 16),
                               Gap(8),
                               Text('Chia sẻ'),
                             ],
                           ),
                         ),
                       ),
                       const Gap(12),
                       Expanded(
                         child: VNLButton.primary(
                           onPressed: () => Navigator.of(context).pop(),
                           child: const Text('Đóng'),
                         ),
                       ),
                     ],
                   ),
                 ],
               ),
             ),
           ),
        ),
      ),
    );
  }

  static String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
} 