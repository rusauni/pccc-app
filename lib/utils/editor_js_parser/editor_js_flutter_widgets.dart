import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import 'editor_js_models.dart';

/// Widget renderer cho EditorJS blocks sử dụng vnl_common_ui
class EditorJSFlutterWidgets {
  /// Render toàn bộ EditorJSData thành Column
  static Widget renderContent(
    EditorJSData data, {
    EditorJSRenderOptions? options,
  }) {
    final opts = options ?? EditorJSRenderOptions.fromContext(data as BuildContext);
    final widgets = renderBlocks(data, options: opts);

    return Column(
      crossAxisAlignment: opts.crossAxisAlignment,
      mainAxisAlignment: opts.mainAxisAlignment,
      children: widgets,
    );
  }

  /// Render danh sách blocks thành list widgets
  static List<Widget> renderBlocks(
    EditorJSData data, {
    EditorJSRenderOptions? options,
  }) {
    final opts = options ?? EditorJSRenderOptions.fromContext(data as BuildContext);
    final List<Widget> widgets = [];

    for (final block in data.blocks) {
      final widget = renderBlock(block, options: opts);
      if (widget != null) {
        widgets.add(widget);
        if (opts.blockSpacing > 0) {
          widgets.add(SizedBox(height: opts.blockSpacing));
        }
      }
    }

    // Loại bỏ spacing cuối
    if (widgets.isNotEmpty && opts.blockSpacing > 0) {
      widgets.removeLast();
    }

    return widgets;
  }

  /// Render một block thành Widget
  static Widget? renderBlock(
    EditorJSBlock block, {
    EditorJSRenderOptions? options,
  }) {
    final opts = options ?? EditorJSRenderOptions.fromContext(block as BuildContext);

    try {
      switch (block.type) {
        case 'paragraph':
          return _renderParagraph(block, opts);
        case 'header':
          return _renderHeader(block, opts);
        case 'list':
          return _renderList(block, opts);
        case 'image':
          return _renderImage(block, opts);
        case 'quote':
          return _renderQuote(block, opts);
        case 'code':
          return _renderCode(block, opts);
        case 'delimiter':
          return _renderDelimiter(block, opts);
        case 'table':
          return _renderTable(block, opts);
        case 'embed':
          return _renderEmbed(block, opts);
        case 'checklist':
          return _renderChecklist(block, opts);
        case 'warning':
          return _renderWarning(block, opts);
        case 'raw':
          return _renderRaw(block, opts);
        case 'linkTool':
          return _renderLinkTool(block, opts);
        case 'attaches':
          return _renderAttaches(block, opts);
        case 'video':
          return _renderVideo(block, opts);
        default:
          return opts.showUnknownBlocks ? _renderUnknown(block, opts) : null;
      }
    } catch (e) {
      if (opts.showErrors) {
        return _renderError(block, e.toString(), opts);
      }
      return null;
    }
  }

  // Paragraph block - sử dụng Text từ vnl_ui với extensions
  static Widget _renderParagraph(EditorJSBlock block, EditorJSRenderOptions opts) {
    final data = ParagraphBlockData.fromJson(block.data);
    final textAlign = _getTextAlign(data.alignment);

    return Padding(
      padding: opts.blockPadding,
      child: opts.customParagraphStyle != null
          ? Text(
              data.text,
              style: opts.customParagraphStyle,
              textAlign: textAlign,
            )
          : Text(data.text)
              .p
              .apply(textAlign: textAlign),
    );
  }

  // Header block - sử dụng vnl_ui typography
  static Widget _renderHeader(EditorJSBlock block, EditorJSRenderOptions opts) {
    final data = HeaderBlockData.fromJson(block.data);
    final textAlign = _getTextAlign(data.alignment);

    Widget headerWidget;
    switch (data.level) {
      case 1:
        headerWidget = Text(data.text).h1;
        break;
      case 2:
        headerWidget = Text(data.text).h2;
        break;
      case 3:
        headerWidget = Text(data.text).h3;
        break;
      case 4:
        headerWidget = Text(data.text).h4;
        break;
      default:
        headerWidget = Text(data.text).h1;
    }

    return Padding(
      padding: opts.blockPadding,
      child: textAlign != null
          ? headerWidget.apply(textAlign: textAlign)
          : headerWidget,
    );
  }

  // List block
  static Widget _renderList(EditorJSBlock block, EditorJSRenderOptions opts) {
    final data = ListBlockData.fromJson(block.data);
    
    return Padding(
      padding: opts.blockPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data.items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final prefix = data.style == 'ordered' ? '${index + 1}. ' : '• ';
          
          return Padding(
            padding: EdgeInsets.only(bottom: opts.listItemSpacing),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(prefix).textMuted,
                Expanded(
                  child: Text(item),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // Image block
  static Widget _renderImage(EditorJSBlock block, EditorJSRenderOptions opts) {
    final data = ImageBlockData.fromJson(block.data);
    // Ưu tiên url, nếu không có thì dùng fileURL
    final originalUrl = data.file.url ?? data.file.fileURL;
    final processedUrl = _processUrl(originalUrl);
    
    if (processedUrl.isEmpty) {
      return Padding(
        padding: opts.blockPadding,
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: VNLTheme.of(opts.context).colorScheme.muted,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  size: 48,
                  color: VNLTheme.of(opts.context).colorScheme.mutedForeground,
                ),
                const SizedBox(height: 8),
                Text('Không có hình ảnh').textMuted,
              ],
            ),
          ),
        ),
      );
    }

    Widget imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        processedUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: VNLTheme.of(context).colorScheme.muted,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image_outlined,
                    size: 48,
                    color: VNLTheme.of(context).colorScheme.mutedForeground,
                  ),
                  const SizedBox(height: 8),
                  Text('Không thể tải hình ảnh').textMuted,
                ],
              ),
            ),
          );
        },
      ),
    );

    // Apply styling options với OutlinedContainer
    if (data.withBorder == true) {
      imageWidget = OutlinedContainer(
        borderRadius: BorderRadius.circular(8),
        child: imageWidget,
      );
    }

    if (data.withBackground == true) {
      imageWidget = VNLCard(
        padding: const EdgeInsets.all(16),
        child: imageWidget,
      );
    }

    Widget result = Padding(
      padding: opts.blockPadding,
      child: imageWidget,
    );

    // Add caption if exists
    if (data.caption != null && data.caption!.isNotEmpty) {
      result = Padding(
        padding: opts.blockPadding,
        child: Column(
          children: [
            imageWidget,
            const SizedBox(height: 8),
            Text(data.caption!).textMuted.textCenter,
          ],
        ),
      );
    }

    return result;
  }

  // Quote block - sử dụng blockQuote từ vnl_ui
  static Widget _renderQuote(EditorJSBlock block, EditorJSRenderOptions opts) {
    final data = QuoteBlockData.fromJson(block.data);
    final textAlign = _getTextAlign(data.alignment);

    Widget quoteWidget = Text(data.text).blockQuote;
    
    if (textAlign != null) {
      quoteWidget = quoteWidget.apply(textAlign: textAlign);
    }

    return Padding(
      padding: opts.blockPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          quoteWidget,
          if (data.caption != null && data.caption!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('— ${data.caption}').textMuted.textSmall,
          ],
        ],
      ),
    );
  }

  // Code block - sử dụng CodeSnippet
  static Widget _renderCode(EditorJSBlock block, EditorJSRenderOptions opts) {
    final data = CodeBlockData.fromJson(block.data);
    
    return Padding(
      padding: opts.blockPadding,
      child: CodeSnippet(
        code: data.code,
        mode: 'text', // Default language
      ),
    );
  }

  // Delimiter block - sử dụng VNLDivider
  static Widget _renderDelimiter(EditorJSBlock block, EditorJSRenderOptions opts) {
    return Padding(
      padding: opts.blockPadding,
      child: const VNLDivider(),
    );
  }

  // Table block - sử dụng VNLTable
  static Widget _renderTable(EditorJSBlock block, EditorJSRenderOptions opts) {
    final data = TableBlockData.fromJson(block.data);
    
    if (data.content.isEmpty) return const SizedBox.shrink();

    // Convert data to VNLTable format
    final List<VNLTableRow> rows = data.content.asMap().entries.map((entry) {
      final index = entry.key;
      final row = entry.value;
      final isHeader = data.withHeadings == true && index == 0;
      
      final cells = row.map((cellText) {
        return VNLTableCell(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: isHeader
                ? Text(cellText).semiBold
                : Text(cellText),
          ),
        );
      }).toList();

      return isHeader 
          ? VNLTableHeader(cells: cells)
          : VNLTableRow(cells: cells);
    }).toList();

    return Padding(
      padding: opts.blockPadding,
      child: VNLTable(
        rows: rows,
      ),
    );
  }

  // Embed block
  static Widget _renderEmbed(EditorJSBlock block, EditorJSRenderOptions opts) {
    final data = EmbedBlockData.fromJson(block.data);
    final processedSource = _processUrl(data.source);
    
    // Kiểm tra xem có phải YouTube URL không
    final RegExp youtubeRegex = RegExp(
      r'(?:youtube\.com/watch\?v=|youtu\.be/|youtube\.com/embed/)([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
    );
    final Match? match = youtubeRegex.firstMatch(processedSource);
    
    if (match != null) {
      final String videoId = match.group(1)!;
      final String thumbnailUrl = 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
      
      // Render YouTube thumbnail với play button
      return Padding(
        padding: opts.blockPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                final Uri youtubeUri = Uri.parse(processedSource);
                if (await canLaunchUrl(youtubeUri)) {
                  await launchUrl(youtubeUri, mode: LaunchMode.externalApplication);
                }
              },
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(thumbnailUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF0000), // YouTube red color
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: VNLTheme.of(opts.context).colorScheme.muted.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      LucideIcons.play,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
            if (data.caption != null && data.caption!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(data.caption!).textMuted.textSmall,
            ],
          ],
        ),
      );
    } else {
      // Fallback cho embed khác
      return Padding(
        padding: opts.blockPadding,
        child: VNLButton.outline(
          onPressed: () => _launchUrl(processedSource),
          child: SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getEmbedIcon(data.service),
                  size: 48,
                ),
                const SizedBox(height: 8),
                Text('Nội dung nhúng ${data.service}').semiBold,
                const SizedBox(height: 4),
                Text('Nhấn để mở').textMuted.textSmall,
                if (data.caption != null && data.caption!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(data.caption!).textMuted.textCenter,
                ],
              ],
            ),
          ),
        ),
      );
    }
  }

  // Checklist block
  static Widget _renderChecklist(EditorJSBlock block, EditorJSRenderOptions opts) {
    final data = ChecklistBlockData.fromJson(block.data);
    
    return Padding(
      padding: opts.blockPadding,
      child: Column(
        children: data.items.map((item) {
          return Padding(
            padding: EdgeInsets.only(bottom: opts.listItemSpacing),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 12, top: 2),
                  child: VNLCheckbox(
                    state: item.checked ? CheckboxState.checked : CheckboxState.unchecked,
                    onChanged: (_) {}, // Read-only
                  ),
                ),
                Expanded(
                  child: item.checked
                      ? Text(item.text).muted.apply(
                          style: const TextStyle(decoration: TextDecoration.lineThrough),
                        )
                      : Text(item.text),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // Warning block - sử dụng VNLAlert
  static Widget _renderWarning(EditorJSBlock block, EditorJSRenderOptions opts) {
    final data = WarningBlockData.fromJson(block.data);
    
    return Padding(
      padding: opts.blockPadding,
      child: VNLAlert(
        leading: Icon(Icons.warning_outlined),
        title: data.title.isNotEmpty ? Text(data.title) : null,
        content: Text(data.message),
      ),
    );
  }

  // Raw HTML block
  static Widget _renderRaw(EditorJSBlock block, EditorJSRenderOptions opts) {
    final data = RawBlockData.fromJson(block.data);
    
    return Padding(
      padding: opts.blockPadding,
      child: VNLCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.code,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text('HTML Content').semiBold,
              ],
            ),
            const SizedBox(height: 8),
            CodeSnippet(
              code: data.html,
              mode: 'html',
            ),
          ],
        ),
      ),
    );
  }

  // LinkTool block - sử dụng VNLCard
  static Widget _renderLinkTool(EditorJSBlock block, EditorJSRenderOptions opts) {
    final data = LinkToolBlockData.fromJson(block.data);
    final processedImageUrl = _processUrl(data.meta.image);
    
    return Padding(
      padding: opts.blockPadding,
      child: VNLButton.ghost(
        onPressed: () => _launchUrl(data.link),
        child: VNLCard(
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: processedImageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          processedImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.link);
                          },
                        ),
                      )
                    : Icon(Icons.link),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.meta.title ?? 'Link').semiBold.singleLine.ellipsis,
                    if (data.meta.description != null && data.meta.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(data.meta.description!).textMuted.textSmall.singleLine.ellipsis,
                    ],
                    const SizedBox(height: 4),
                    Text(data.link).textSmall.singleLine.ellipsis.apply(
                      style: TextStyle(color: VNLTheme.of(opts.context).colorScheme.primary),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.open_in_new,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Attaches block
  static Widget _renderAttaches(EditorJSBlock block, EditorJSRenderOptions opts) {
    final data = AttachesBlockData.fromJson(block.data);
    // Ưu tiên url, nếu không có thì dùng fileURL
    final originalFileUrl = data.file.url ?? data.file.fileURL;
    final processedFileUrl = _processUrl(originalFileUrl);
    
    return Padding(
      padding: opts.blockPadding,
      child: VNLButton.outline(
        onPressed: () => _launchUrl(processedFileUrl),
        child: Row(
          children: [
            Icon(
              _getFileIcon(data.file.extension),
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.title ?? data.file.name ?? 'File đính kèm').semiBold,
                  if (data.file.size != null) ...[
                    const SizedBox(height: 4),
                    Text(_formatFileSize(data.file.size!)).textMuted.textSmall,
                  ],
                ],
              ),
            ),
            Icon(
              Icons.download,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // Video block
  static Widget _renderVideo(EditorJSBlock block, EditorJSRenderOptions opts) {
    final data = VideoBlockData.fromJson(block.data);
    final processedUrl = _processUrl(data.url);
    
    // Kiểm tra xem có phải YouTube URL không
    final RegExp youtubeRegex = RegExp(
      r'(?:youtube\.com/watch\?v=|youtu\.be/|youtube\.com/embed/)([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
    );
    final Match? match = youtubeRegex.firstMatch(processedUrl);
    
    if (match != null) {
      final String videoId = match.group(1)!;
      final String thumbnailUrl = 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
      
      // Render YouTube thumbnail với play button
      return Padding(
        padding: opts.blockPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                final Uri youtubeUri = Uri.parse(processedUrl);
                if (await canLaunchUrl(youtubeUri)) {
                  await launchUrl(youtubeUri, mode: LaunchMode.externalApplication);
                }
              },
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(thumbnailUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF0000), // YouTube red color
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: VNLTheme.of(opts.context).colorScheme.muted.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      LucideIcons.play,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
            if (data.caption != null && data.caption!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(data.caption!).textMuted.textSmall,
            ],
          ],
        ),
      );
    } else {
      // Fallback cho video khác (không phải YouTube)
      return Padding(
        padding: opts.blockPadding,
        child: VNLButton.outline(
          onPressed: () => _launchUrl(processedUrl),
          child: SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_circle_outline,
                  size: 64,
                ),
                const SizedBox(height: 8),
                Text('Video').semiBold,
                const SizedBox(height: 4),
                Text('Nhấn để phát').textMuted.textSmall,
                if (data.caption != null && data.caption!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(data.caption!).textMuted.textCenter.singleLine.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }
  }

  // Unknown block
  static Widget _renderUnknown(EditorJSBlock block, EditorJSRenderOptions opts) {
    return Padding(
      padding: opts.blockPadding,
      child: VNLAlert(
        leading: Icon(Icons.help_outline),
        title: Text('Block không được hỗ trợ'),
        content: Text('Loại block: ${block.type}'),
      ),
    );
  }

  // Error block
  static Widget _renderError(EditorJSBlock block, String error, EditorJSRenderOptions opts) {
    return Padding(
      padding: opts.blockPadding,
      child: VNLAlert.destructive(
        leading: Icon(Icons.error_outline),
        title: Text('Lỗi render block: ${block.type}'),
        content: Text(error),
      ),
    );
  }

  // Helper methods
  static TextAlign? _getTextAlign(String? alignment) {
    switch (alignment) {
      case 'left':
        return TextAlign.left;
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      case 'justify':
        return TextAlign.justify;
      default:
        return null;
    }
  }

  /// Xử lý URL để thêm domain nếu cần thiết
  static String _processUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    
    // Kiểm tra xem URL đã là URL hợp lệ chưa (có scheme như http/https)
    final Uri? uri = Uri.tryParse(url);
    
    // Nếu là URL hợp lệ (có scheme) thì trả về nguyên văn
    if (uri != null && uri.hasScheme) {
      return url;
    }
    
    // Nếu không phải URL hợp lệ thì thêm domain
    const String baseDomain = 'https://dashboard.pccc40.com';
    
    // Nếu URL đã bắt đầu bằng / thì thêm domain trực tiếp
    // Ví dụ: "/assets/file-id" → "https://dashboard.pccc40.com/assets/file-id"
    if (url.startsWith('/')) {
      return '$baseDomain$url';
    }
    
    // Nếu không có / đầu thì thêm vào assets folder
    // Ví dụ: "file.jpg" → "https://dashboard.pccc40.com/assets/file.jpg" 
    return '$baseDomain/assets/$url';
  }

  static IconData _getEmbedIcon(String service) {
    switch (service.toLowerCase()) {
      case 'youtube':
        return Icons.play_circle_outline;
      case 'vimeo':
        return Icons.videocam_outlined;
      case 'twitter':
        return Icons.comment_outlined;
      case 'instagram':
        return Icons.photo_camera_outlined;
      default:
        return Icons.web_outlined;
    }
  }

  static IconData _getFileIcon(String? extension) {
    if (extension == null) return Icons.attachment_outlined;
    
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'doc':
      case 'docx':
        return Icons.description_outlined;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart_outlined;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow_outlined;
      case 'zip':
      case 'rar':
        return Icons.archive_outlined;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image_outlined;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Icons.video_file_outlined;
      case 'mp3':
      case 'wav':
        return Icons.audio_file_outlined;
      default:
        return Icons.attachment_outlined;
    }
  }

  static String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  static Future<void> _launchUrl(String url) async {
    if (url.isNotEmpty) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }
}

/// Tùy chọn render cho EditorJS Flutter widgets
class EditorJSRenderOptions {
  final double blockSpacing;
  final EdgeInsets blockPadding;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final bool showUnknownBlocks;
  final bool showErrors;

  // Custom styles (fallback cho khi vnl_ui không đủ)
  final TextStyle? customParagraphStyle;
  
  // Context cần thiết cho VNLTheme
  final BuildContext context;

  // Spacing
  final double listItemSpacing;

  EditorJSRenderOptions({
    required this.context,
    this.blockSpacing = 16.0,
    this.blockPadding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.showUnknownBlocks = false,
    this.showErrors = true,
    this.customParagraphStyle,
    this.listItemSpacing = 8.0,
  });

  /// Tạo options với context
  factory EditorJSRenderOptions.fromContext(BuildContext context) {
    return EditorJSRenderOptions(
      context: context,
    );
  }
}

// Extension helper cho Text styling
extension TextStyleHelper on Widget {
  Widget apply({
    TextStyle? style,
    TextAlign? textAlign,
  }) {
    if (this is Text) {
      final text = this as Text;
      return Text(
        text.data ?? '',
        style: style != null 
            ? (text.style ?? const TextStyle()).merge(style)
            : text.style,
        textAlign: textAlign ?? text.textAlign,
        overflow: text.overflow,
        maxLines: text.maxLines,
        softWrap: text.softWrap,
      );
    }
    return this;
  }
} 