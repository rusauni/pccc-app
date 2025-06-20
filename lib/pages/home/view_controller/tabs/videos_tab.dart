import 'package:flutter/material.dart' hide IconButton, ButtonStyle;
import 'package:vnl_common_ui/vnl_ui.dart';

class VideosTab extends StatelessWidget {
  VideosTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _dummyVideos.length,
      itemBuilder: (context, index) {
        final video = _dummyVideos[index];
        return _buildVideoCard(
          title: video['title']!,
          duration: video['duration']!,
          date: video['date']!,
          thumbnailUrl: video['thumbnailUrl']!,
        );
      },
    );
  }

  Widget _buildVideoCard({
    required String title,
    required String duration,
    required String date,
    required String thumbnailUrl,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  thumbnailUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(Icons.video_library, size: 50, color: Colors.grey[600]),
                    );
                  },
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    duration,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                    onTap: () {},
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          RadixIcons.play,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final List<Map<String, String>> _dummyVideos = [
    {
      'title': 'Hướng dẫn sử dụng bình chữa cháy',
      'duration': '5:24',
      'date': '20/05/2025',
      'thumbnailUrl': 'https://images.unsplash.com/photo-1551218808-94e220e084d2?w=800&q=80',
    },
    {
      'title': 'Cách thoát hiểm khi có hỏa hoạn',
      'duration': '8:15',
      'date': '15/05/2025',
      'thumbnailUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80',
    },
    {
      'title': 'Kỹ năng sơ cứu người bị nạn',
      'duration': '12:40',
      'date': '10/05/2025',
      'thumbnailUrl': 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=800&q=80',
    },
    {
      'title': 'Diễn tập PCCC tại khu chung cư',
      'duration': '15:30',
      'date': '05/05/2025',
      'thumbnailUrl': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
    },
    {
      'title': 'Cách lắp đặt hệ thống báo cháy',
      'duration': '10:12',
      'date': '01/05/2025',
      'thumbnailUrl': 'https://images.unsplash.com/photo-1503428593586-e225b39bddfe?w=800&q=80',
    },
    {
      'title': 'Bảo trì thiết bị PCCC định kỳ',
      'duration': '7:45',
      'date': '25/04/2025',
      'thumbnailUrl': 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800&q=80',
    },
  ];
}
