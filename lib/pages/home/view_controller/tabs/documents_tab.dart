import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:flutter/material.dart' show Colors, showModalBottomSheet, Dialog, Scaffold, AppBar, Navigator;

class DocumentsTab extends StatelessWidget {
  DocumentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _dummyDocuments.length,
      itemBuilder: (context, index) {
        final document = _dummyDocuments[index];
        return _buildDocumentItem(
          context: context,
          title: document['title']!,
          type: document['type']!,
          date: document['date']!,
          size: document['size']!,
          url: document['url']!,
          icon: _getIconForDocType(document['type']!),
          color: _getColorForDocType(context, document['type']!),
        );
      },
    );
  }

  Widget _buildDocumentItem({
    required BuildContext context,
    required String title,
    required String type,
    required String date,
    required String size,
    required String url,
    required IconData icon,
    required Color color,
  }) {
    final theme = VNLTheme.of(context);
    
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: VNLCard(
        child: VNLButton(
          style: ButtonStyle.ghost(),
          onPressed: () {
            _showDocumentPreview(context, title, type, url);
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4),
                      Text('$type • $size • $date', style: TextStyle(
                        fontSize: 12, 
                        color: theme.colorScheme.mutedForeground
                      )),
                    ],
                  ),
                ),
                VNLButton(
                  style: ButtonStyle.ghost(density: ButtonDensity.icon),
                  onPressed: () {
                    _showDocumentOptions(context, title, type, url);
                  },
                  child: Icon(BootstrapIcons.threeDotsVertical),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDocumentPreview(BuildContext context, String title, String type, String url) {
    showDialog(
      context: context,
      builder: (context) => DocumentPreviewDialog(
        title: title,
        type: type,
        url: url,
      ),
    );
  }

  void _showDocumentOptions(BuildContext context, String title, String type, String url) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Gap(16),
            _buildOptionItem(
              context,
              icon: BootstrapIcons.eye,
              title: 'Xem trước',
              onTap: () {
                Navigator.pop(context);
                _showDocumentPreview(context, title, type, url);
              },
            ),
            _buildOptionItem(
              context,
              icon: BootstrapIcons.download,
              title: 'Tải xuống',
              onTap: () {
                Navigator.pop(context);
                // Implement download logic
              },
            ),
            _buildOptionItem(
              context,
              icon: BootstrapIcons.share,
              title: 'Chia sẻ',
              onTap: () {
                Navigator.pop(context);
                // Implement share logic
              },
            ),
            Gap(16),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return VNLButton(
      style: ButtonStyle.ghost(),
      onPressed: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20),
            Gap(16),
            Text(title, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  IconData _getIconForDocType(String type) {
    switch (type) {
      case 'PDF':
        return BootstrapIcons.filePdf;
      case 'DOCX':
        return BootstrapIcons.fileText;
      case 'XLSX':
        return BootstrapIcons.fileSpreadsheet;
      case 'PPTX':
        return BootstrapIcons.fileSlides;
      case 'JPG':
      case 'PNG':
        return BootstrapIcons.fileImage;
      default:
        return BootstrapIcons.file;
    }
  }

  Color _getColorForDocType(BuildContext context, String type) {
    switch (type) {
      case 'PDF':
        return Colors.red;
      case 'DOCX':
        return Colors.blue;
      case 'XLSX':
        return Colors.green;
      case 'PPTX':
        return Colors.orange;
      case 'JPG':
      case 'PNG':
        return Colors.purple;
      default:
        return VNLTheme.of(context).colorScheme.mutedForeground;
    }
  }

  final List<Map<String, String>> _dummyDocuments = [
    {
      'title': 'Quy định PCCC cho khu dân cư',
      'type': 'PDF',
      'date': '20/05/2025',
      'size': '2.4 MB',
      'url': 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
    },
    {
      'title': 'Hướng dẫn sử dụng thiết bị báo cháy',
      'type': 'DOCX',
      'date': '15/05/2025',
      'size': '1.8 MB',
      'url': 'https://file-examples.com/storage/fe68c9fa7d66dab0a8c3b57/2017/10/file_example_DOC_10kB.doc',
    },
    {
      'title': 'Danh sách kiểm tra thiết bị PCCC',
      'type': 'XLSX',
      'date': '10/05/2025',
      'size': '3.2 MB',
      'url': 'https://file-examples.com/storage/fe68c9fa7d66dab0a8c3b57/2017/10/file_example_XLS_10.xls',
    },
    {
      'title': 'Bài trình bày về phòng cháy chữa cháy',
      'type': 'PPTX',
      'date': '05/05/2025',
      'size': '5.7 MB',
      'url': 'https://file-examples.com/storage/fe68c9fa7d66dab0a8c3b57/2017/08/file_example_PPT_1MB.ppt',
    },
    {
      'title': 'Sơ đồ thoát hiểm tòa nhà A',
      'type': 'JPG',
      'date': '01/05/2025',
      'size': '1.2 MB',
      'url': 'https://file-examples.com/storage/fe68c9fa7d66dab0a8c3b57/2017/10/file_example_JPG_100kB.jpg',
    },
    {
      'title': 'Biên bản kiểm tra PCCC định kỳ',
      'type': 'PDF',
      'date': '25/04/2025',
      'size': '1.5 MB',
      'url': 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
    },
    {
      'title': 'Kế hoạch diễn tập PCCC năm 2025',
      'type': 'DOCX',
      'date': '20/04/2025',
      'size': '2.1 MB',
      'url': 'https://file-examples.com/storage/fe68c9fa7d66dab0a8c3b57/2017/10/file_example_DOC_10kB.doc',
    },
  ];
}

class DocumentPreviewDialog extends StatelessWidget {
  final String title;
  final String type;
  final String url;

  const DocumentPreviewDialog({
    super.key,
    required this.title,
    required this.type,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
          leading: VNLButton(
            style: ButtonStyle.ghost(density: ButtonDensity.icon),
            onPressed: () => Navigator.pop(context),
            child: Icon(BootstrapIcons.x),
          ),
          actions: [
            VNLButton(
              style: ButtonStyle.ghost(density: ButtonDensity.icon),
              onPressed: () {
                // Implement download logic
              },
              child: Icon(BootstrapIcons.download),
            ),
            VNLButton(
              style: ButtonStyle.ghost(density: ButtonDensity.icon),
              onPressed: () {
                // Implement share logic
              },
              child: Icon(BootstrapIcons.share),
            ),
          ],
        ),
        body: SafeArea(
          child: _buildPreviewContent(context),
        ),
      ),
    );
  }

  Widget _buildPreviewContent(BuildContext context) {
    switch (type.toUpperCase()) {
      case 'JPG':
      case 'PNG':
        return _buildImagePreview();
      case 'PDF':
        return _buildPdfPreview();
      case 'DOCX':
      case 'XLSX':
      case 'PPTX':
        return _buildOfficeDocumentPreview();
      default:
        return _buildUnsupportedPreview(context);
    }
  }

  Widget _buildImagePreview() {
    return Center(
      child: InteractiveViewer(
        panEnabled: true,
        boundaryMargin: EdgeInsets.all(20),
        minScale: 0.5,
        maxScale: 4.0,
        child: Image.network(
          url,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorView(context, 'Không thể tải hình ảnh');
          },
        ),
      ),
    );
  }

  Widget _buildPdfPreview() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            BootstrapIcons.filePdf,
            size: 64,
            color: Colors.red,
          ),
          Gap(16),
          Text(
            'Xem trước PDF',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Gap(8),
                     Text(
             'Tính năng xem trước PDF sẽ được cập nhật trong phiên bản tiếp theo',
             textAlign: TextAlign.center,
             style: TextStyle(color: Colors.grey),
           ),
          Gap(24),
          VNLButton(
            style: ButtonStyle.primary(),
            onPressed: () {
              // Open in external app or web browser
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(BootstrapIcons.boxArrowUpRight, size: 16),
                Gap(8),
                Text('Mở trong trình duyệt'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfficeDocumentPreview() {
    IconData icon;
    Color color;
    String typeName;
    
    switch (type.toUpperCase()) {
      case 'DOCX':
        icon = BootstrapIcons.fileText;
        color = Colors.blue;
        typeName = 'Word';
        break;
      case 'XLSX':
        icon = BootstrapIcons.fileSpreadsheet;
        color = Colors.green;
        typeName = 'Excel';
        break;
      case 'PPTX':
        icon = BootstrapIcons.fileSlides;
        color = Colors.orange;
        typeName = 'PowerPoint';
        break;
      default:
        icon = BootstrapIcons.file;
        color = Colors.grey;
        typeName = 'Document';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: color,
          ),
          Gap(16),
          Text(
            'Xem trước $typeName',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Gap(8),
                     Text(
             'Tính năng xem trước tài liệu Office sẽ được cập nhật trong phiên bản tiếp theo',
             textAlign: TextAlign.center,
             style: TextStyle(color: Colors.grey),
           ),
          Gap(24),
          VNLButton(
            style: ButtonStyle.primary(),
            onPressed: () {
              // Open in external app
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(BootstrapIcons.boxArrowUpRight, size: 16),
                Gap(8),
                Text('Mở bằng ứng dụng khác'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnsupportedPreview(BuildContext context) {
    return _buildErrorView(context, 'Định dạng file không được hỗ trợ xem trước');
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            BootstrapIcons.exclamationTriangle,
            size: 64,
            color: VNLTheme.of(context).colorScheme.destructive,
          ),
          Gap(16),
          Text(
            'Không thể xem trước',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Gap(8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: VNLTheme.of(context).colorScheme.mutedForeground),
          ),
        ],
      ),
    );
  }
}
