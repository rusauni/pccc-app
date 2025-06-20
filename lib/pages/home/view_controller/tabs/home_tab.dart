import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:gtd_helper/helper/extension/build_context_extension.dart';
import 'package:vnl_common_ui/vnl_ui.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(48),
          _buildWelcomeCard(),
          Gap(20),
          _buildStatisticsSection(),
          Gap(20),
          _buildRecentActivities(),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return VNLCard(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chào mừng đến với PCCC').base.bold,
            SizedBox(height: 8),
            Text('Trước anh linh các tiền bối của lực lượng, Ban Tổ chức và đại diện các Đoàn vận động viên đã thành tâm tưởng nhớ, tôn vinh lý tưởng cao đẹp, đóng góp to lớn của các thế hệ Công an nhân dân trong sự nghiệp đấu tranh giải phóng dân tộc, xây dựng và bảo vệ Tổ quốc; đồng thời bày tỏ quyết tâm nêu cao tinh thần "Vì nước, quên thân vì dân phục vụ"')
                .base,
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text('Xem hướng dẫn').base,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thống kê',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard('Thiết bị', '24', Icons.devices, Colors.blue),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildStatCard('Kiểm tra', '12', Icons.check_circle, Colors.green),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildStatCard('Cảnh báo', '3', Icons.warning, Colors.orange),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return VNLCard(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hoạt động gần đây',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Gap(12),
        _buildActivityItem(
          'Kiểm tra thiết bị chữa cháy tầng 1',
          'Hôm nay, 10:30',
          Icons.check_circle,
          Colors.green,
        ),
        Gap(12),
        _buildActivityItem(
          'Cập nhật quy định PCCC mới',
          'Hôm qua, 15:45',
          Icons.article,
          Colors.blue,
        ),
        Gap(12),
        _buildActivityItem(
          'Cảnh báo thiết bị hết hạn kiểm định',
          '20/05/2025, 09:15',
          Icons.warning,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return VNLCard(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title),
        subtitle: Text(time),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}
