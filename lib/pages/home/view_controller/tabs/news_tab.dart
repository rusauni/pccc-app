import 'package:flutter/material.dart' hide ButtonStyle, TextButton;
import 'package:vnl_common_ui/vnl_ui.dart';

class NewsTab extends StatelessWidget {
  NewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16),
      itemCount: _dummyNews.length,
      separatorBuilder: (context, index) => Gap(16),
      itemBuilder: (context, index) {
        final news = _dummyNews[index];
        return _buildNewsCard(
          title: news['title']!,
          description: news['description']!,
          date: news['date']!,
          imageUrl: news['imageUrl']!,
        );
      },
    );
  }

  Widget _buildNewsCard({
    required String title,
    required String description,
    required String date,
    required String imageUrl,
  }) {
    return VNLCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey[600]),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),
                VNLButton(style: ButtonStyle.ghost(), onPressed: () {}, child: Text('Đọc thêm')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final List<Map<String, String>> _dummyNews = [
    {
      'title': 'Diễn tập PCCC tại khu chung cư cao tầng',
      'description':
          'Sáng ngày 15/5/2025, Phòng Cảnh sát PCCC&CNCH Công an TP đã tổ chức buổi diễn tập phương án chữa cháy và cứu nạn cứu hộ tại khu chung cư cao tầng...',
      'date': '15/05/2025',
      'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80',
    },
    {
      'title': 'Cập nhật quy định mới về PCCC năm 2025',
      'description':
          'Bộ Công an vừa ban hành Thông tư số 25/2025/TT-BCA quy định về phòng cháy, chữa cháy đối với khu dân cư, hộ gia đình, nhà để ở kết hợp sản xuất, kinh doanh...',
      'date': '10/05/2025',
      'imageUrl': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
    },
    {
      'title': 'Hướng dẫn sử dụng bình chữa cháy đúng cách',
      'description':
          'Bình chữa cháy là thiết bị quan trọng trong công tác phòng cháy chữa cháy. Tuy nhiên, không phải ai cũng biết cách sử dụng bình chữa cháy đúng cách...',
      'date': '05/05/2025',
      'imageUrl': 'https://images.unsplash.com/photo-1551218808-94e220e084d2?w=800&q=80',
    },
    {
      'title': 'Tập huấn PCCC cho học sinh các trường THPT',
      'description':
          'Nhằm nâng cao ý thức và kỹ năng phòng cháy chữa cháy cho học sinh, Phòng Cảnh sát PCCC&CNCH đã phối hợp với Sở Giáo dục và Đào tạo tổ chức chương trình tập huấn...',
      'date': '01/05/2025',
      'imageUrl': 'https://images.unsplash.com/photo-1503428593586-e225b39bddfe?w=800&q=80',
    },
    {
      'title': 'Kiểm tra an toàn PCCC tại các khu công nghiệp',
      'description':
          'Đoàn kiểm tra liên ngành về PCCC đã tiến hành kiểm tra đột xuất tại các khu công nghiệp trên địa bàn tỉnh. Qua kiểm tra phát hiện nhiều tồn tại, thiếu sót về công tác PCCC...',
      'date': '25/04/2025',
      'imageUrl': 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800&q=80',
    },
  ];
}
