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
          context: context,
          title: document['title']!,
          type: document['type']!,
          date: document['date']!,
          size: document['size']!,
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
    required IconData icon,
    required Color color,
  }) {
    final theme = VNLTheme.of(context);
    
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: VNLCard(
        child: VNLButton(
          style: ButtonStyle.ghost(),
          onPressed: () {},
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
                    // Show options menu
                  },
                  child: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
        ),
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

  Color _getColorForDocType(BuildContext context, String type) {
    final theme = VNLTheme.of(context);
    switch (type) {
      case 'PDF':
        return theme.colorScheme.destructive;
      case 'DOCX':
        return theme.colorScheme.primary;
      case 'XLSX':
        return theme.colorScheme.secondary;
      case 'PPTX':
        return Color(0xFFFF9500); // Orange
      case 'JPG':
      case 'PNG':
        return Color(0xFF9C27B0); // Purple
      default:
        return theme.colorScheme.mutedForeground;
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
