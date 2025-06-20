import 'package:flutter/material.dart' hide ButtonStyle, IconButton, FloatingActionButton;
import 'package:vnl_common_ui/vnl_ui.dart';

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
          title: document['title']!,
          type: document['type']!,
          date: document['date']!,
          size: document['size']!,
          icon: _getIconForDocType(document['type']!),
          color: _getColorForDocType(document['type']!),
        );
      },
    );
  }

  Widget _buildDocumentItem({
    required String title,
    required String type,
    required String date,
    required String size,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text('$type • $size • $date'),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          onSelected: (value) {},
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'download',
              child: Row(
                children: [
                  Icon(Icons.download, size: 20),
                  SizedBox(width: 8),
                  Text('Tải xuống'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'share',
              child: Row(
                children: [
                  Icon(Icons.share, size: 20),
                  SizedBox(width: 8),
                  Text('Chia sẻ'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Xóa', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  IconData _getIconForDocType(String type) {
    switch (type) {
      case 'PDF':
        return Icons.picture_as_pdf;
      case 'DOCX':
        return Icons.description;
      case 'XLSX':
        return Icons.table_chart;
      case 'PPTX':
        return Icons.slideshow;
      case 'JPG':
      case 'PNG':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getColorForDocType(String type) {
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
        return Colors.grey;
    }
  }

  final List<Map<String, String>> _dummyDocuments = [
    {
      'title': 'Quy định PCCC cho khu dân cư',
      'type': 'PDF',
      'date': '20/05/2025',
      'size': '2.4 MB',
    },
    {
      'title': 'Hướng dẫn sử dụng thiết bị báo cháy',
      'type': 'DOCX',
      'date': '15/05/2025',
      'size': '1.8 MB',
    },
    {
      'title': 'Danh sách kiểm tra thiết bị PCCC',
      'type': 'XLSX',
      'date': '10/05/2025',
      'size': '3.2 MB',
    },
    {
      'title': 'Bài trình bày về phòng cháy chữa cháy',
      'type': 'PPTX',
      'date': '05/05/2025',
      'size': '5.7 MB',
    },
    {
      'title': 'Sơ đồ thoát hiểm tòa nhà A',
      'type': 'JPG',
      'date': '01/05/2025',
      'size': '1.2 MB',
    },
    {
      'title': 'Biên bản kiểm tra PCCC định kỳ',
      'type': 'PDF',
      'date': '25/04/2025',
      'size': '1.5 MB',
    },
    {
      'title': 'Kế hoạch diễn tập PCCC năm 2025',
      'type': 'DOCX',
      'date': '20/04/2025',
      'size': '2.1 MB',
    },
  ];
}
