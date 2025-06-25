import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:base_app/router/app_router.dart';
import '../../view_model/home_view_model.dart';
import '../../../news/model/news_model.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late HomeViewModel _homeViewModel;

  @override
  void initState() {
    super.initState();
    _homeViewModel = HomeViewModel.create();
  }

  @override
  void dispose() {
    _homeViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeroSection(context),
          _buildServicesSection(context),
          _buildProductCategoriesSection(context),
          _buildNewsSection(context),
          _buildContactSection(context),
          Gap(20),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            VNLTheme.of(context).colorScheme.primary,
            VNLTheme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20),
              Text(
                'PHÒNG CHÁY CHỮA CHÁY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(8),
              Text(
                'Hệ thống quản lý toàn diện các thiết bị và quy trình phòng cháy chữa cháy',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 16,
                ),
              ),
              Gap(20),
              Row(
                children: [
                  Expanded(
                    child: VNLButton(
                      style: ButtonStyle.secondary(),
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(BootstrapIcons.telephoneFill, size: 16),
                          Gap(8),
                          Text('Hotline 24/7'),
                        ],
                      ),
                    ),
                  ),
                  Gap(12),
                  Expanded(
                    child: VNLButton(
                      style: ButtonStyle.outline(),
                      onPressed: () => context.pushNamed(AppRouterPath.pcccCheck),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(BootstrapIcons.shieldCheck, size: 16, color: Colors.white),
                          Gap(8),
                          Text('Kiểm tra', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dịch vụ nổi bật',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Gap(16),
          Row(
            children: [
              Expanded(
                child: _buildServiceCard(
                  context,
                  'Thi công PCCC',
                  'Thiết kế & lắp đặt hệ thống',
                  BootstrapIcons.tools,
                  VNLTheme.of(context).colorScheme.primary,
                ),
              ),
              Gap(12),
              Expanded(
                child: _buildServiceCard(
                  context,
                  'Bảo trì',
                  'Bảo trì định kỳ thiết bị',
                  BootstrapIcons.gearFill,
                  Colors.blue,
                ),
              ),
            ],
          ),
          Gap(12),
          Row(
            children: [
              Expanded(
                child: _buildServiceCard(
                  context,
                  'Kiểm định',
                  'Kiểm định chất lượng PCCC',
                  BootstrapIcons.clipboardCheck,
                  Colors.orange,
                ),
              ),
              Gap(12),
              Expanded(
                child: _buildServiceCard(
                  context,
                  'Tư vấn',
                  'Tư vấn giải pháp PCCC',
                  BootstrapIcons.chatDots,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, String title, String subtitle, IconData icon, Color color) {
    return VNLCard(
      child: VNLButton(
        style: ButtonStyle.ghost(),
        onPressed: () {},
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Gap(12),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              Gap(4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: VNLTheme.of(context).colorScheme.mutedForeground,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCategoriesSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danh mục thiết bị',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Gap(16),
          _buildCategoryItem(context, 'Bình chữa cháy', 'Các loại bình chữa cháy ABC, CO2, bột khô', BootstrapIcons.dropletFill, Colors.red, 'fire_extinguisher'),
          Gap(8),
          _buildCategoryItem(context, 'Thiết bị báo cháy', 'Đầu báo khói, nhiệt, nút nhấn báo cháy', BootstrapIcons.bellFill, Colors.orange, 'fire_alarm'),
          Gap(8),
          _buildCategoryItem(context, 'Vòi chữa cháy', 'Vòi chữa cháy, cuộn vòi, lăng phun', BootstrapIcons.water, Colors.blue, 'water_sprinkler'),
          Gap(8),
          _buildCategoryItem(context, 'Đèn thoát hiểm', 'Đèn Exit, đèn sự cố, đèn chiếu sáng', BootstrapIcons.lightbulbFill, Colors.yellow.shade700, 'emergency_light'),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String title, String description, IconData icon, Color color, String categoryId) {
    return VNLCard(
      child: VNLButton(
        style: ButtonStyle.ghost(),
        onPressed: () => context.go('/equipment-products/$categoryId'),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Gap(4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: VNLTheme.of(context).colorScheme.mutedForeground,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(BootstrapIcons.chevronRight, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tin tức nổi bật',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Gap(16),
          ListenableBuilder(
            listenable: _homeViewModel,
            builder: (context, child) {
                            if (_homeViewModel.isLoading) {
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Text('Đang tải...'),
                );
              }

              if (_homeViewModel.errorMessage != null) {
                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(
                    _homeViewModel.errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }

              final newsList = _homeViewModel.featuredNewsList;
              if (newsList.isEmpty) {
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Chưa có tin tức nổi bật',
                    style: TextStyle(
                      color: VNLTheme.of(context).colorScheme.mutedForeground,
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  for (int i = 0; i < newsList.length; i++) ...[
                    if (i > 0) Gap(12),
                    _buildNewsItemFromModel(context, newsList[i]),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItemFromModel(BuildContext context, NewsModel news) {
    // Format date
    String formattedDate = '';
    if (news.dateCreated != null) {
      try {
        final date = DateTime.parse(news.dateCreated!);
        formattedDate = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      } catch (e) {
        formattedDate = news.dateCreated!;
      }
    }

    return VNLCard(
      child: VNLButton(
        style: ButtonStyle.ghost(),
        onPressed: () {
          if (news.id != null) {
            // Navigate to news detail page
            context.go('/news-detail/${news.id}');
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news.title ?? 'Tiêu đề tin tức',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(8),
              if (news.summary?.isNotEmpty == true)
                Text(
                  news.summary!,
                  style: TextStyle(
                    fontSize: 14,
                    color: VNLTheme.of(context).colorScheme.mutedForeground,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              Gap(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: VNLTheme.of(context).colorScheme.mutedForeground,
                    ),
                  ),
                  Icon(BootstrapIcons.chevronRight, size: 14),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsItem(BuildContext context, String title, String description, String date) {
    return VNLCard(
      child: VNLButton(
        style: ButtonStyle.ghost(),
        onPressed: () {},
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: VNLTheme.of(context).colorScheme.mutedForeground,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: VNLTheme.of(context).colorScheme.mutedForeground,
                    ),
                  ),
                  Icon(BootstrapIcons.chevronRight, size: 14),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VNLTheme.of(context).colorScheme.muted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              BootstrapIcons.telephoneFill,
              size: 32,
              color: VNLTheme.of(context).colorScheme.primary,
            ),
            Gap(12),
            Text(
              'Hỗ trợ 24/7',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Gap(8),
            Text(
              'Liên hệ ngay để được tư vấn miễn phí',
              style: TextStyle(color: VNLTheme.of(context).colorScheme.mutedForeground),
              textAlign: TextAlign.center,
            ),
            Gap(16),
            Row(
              children: [
                Expanded(
                  child: VNLButton(
                    style: ButtonStyle.primary(),
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(BootstrapIcons.telephone, size: 16),
                        Gap(8),
                        Text('Gọi ngay'),
                      ],
                    ),
                  ),
                ),
                Gap(12),
                Expanded(
                  child: VNLButton(
                    style: ButtonStyle.outline(),
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(BootstrapIcons.chatDots, size: 16),
                        Gap(8),
                        Text('Chat Zalo'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
