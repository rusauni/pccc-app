import '../../../data/models/article_model.dart';
import '../../../utils/url_helper.dart';
import 'news_author_model.dart';
import 'news_category_model.dart';

class NewsModel extends ArticleModel {
  final NewsAuthorModel? author;
  final NewsCategoryModel? category;
  final int? viewCount;
  final bool? isFeatured;

  NewsModel({
    super.id,
    super.status,
    super.sort,
    super.userCreated,
    super.dateCreated,
    super.userUpdated,
    super.dateUpdated,
    required super.title,
    super.thumbnail,
    super.content,
    super.categoryId,
    super.slug,
    super.summary,
    super.files,
    super.tags,
    this.author,
    this.category,
    this.viewCount,
    this.isFeatured,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      status: json['status'],
      sort: json['sort'],
      userCreated: json['user_created'],
      dateCreated: json['date_created'],
      userUpdated: json['user_updated'],
      dateUpdated: json['date_updated'],
      title: json['title'] ?? '',
      thumbnail: UrlHelper.formatThumbnailUrl(json['thumbnail']?.toString()),
      content: json['content'],
      categoryId: json['category'],
      slug: json['slug'],
      summary: json['summary'],
      files: json['files'],
      tags: json['tags'],
      author: json['author'] != null
          ? NewsAuthorModel.fromJson(json['author'])
          : null,
      category: json['category_info'] != null
          ? NewsCategoryModel.fromJson(json['category_info'])
          : null,
      viewCount: json['view_count'],
      isFeatured: json['is_featured'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'author': author?.toJson(),
      'category_info': category?.toJson(),
      'view_count': viewCount,
      'is_featured': isFeatured,
    });
    return json;
  }

  static List<NewsModel> getDummyNews() {
    final authors = NewsAuthorModel.getDummyAuthors();
    final categories = NewsCategoryModel.getDummyCategories();

    return [
      NewsModel(
        id: 1,
        title: 'Liên lạc bị mất với máy bay Boeing 737-500 của Sriwijaya Air sau khi cất cánh',
        summary: 'Một máy bay chở khách Indonesia chở 62 người đã mất liên lạc với bộ điều khiển không lưu ngay sau khi cất cánh từ thủ đô Jakarta vào thứ Bảy, theo các quan chức giao thông vận tải của nhà nước.',
        thumbnail: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&q=80',
        dateCreated: '2025-01-10',
        author: authors[0],
        category: categories[1],
        viewCount: 1523,
        isFeatured: true,
        content: '''
Một máy bay chở khách Indonesia chở 62 người đã mất liên lạc với bộ điều khiển không lưu ngay sau khi cất cánh từ thủ đô Jakarta vào thứ Bảy, theo các quan chức giao thông vận tải của nhà nước.

Bộ Giao thông Vận tải xác nhận rằng các cơ quan chức năng sân bay đã mất liên lạc với máy bay, chuyến bay Sriwijaya Air 182, vào khoảng 2:40 chiều theo giờ địa phương. Máy bay, một Boeing 737-500, đã cất cánh từ Jakarta chưa đầy một giờ trước đó.

Các quan chức Indonesia cho biết máy bay đang di chuyển về phía Pontianak ở Borneo. Chuyến bay dự kiến kéo dài 90 phút.

Thông tin mà chúng tôi có được là có khoảng một giờ và 30 phút trước khi chúng tôi mất liên lạc, vì vậy chúng tôi ước tính rằng [nhiên liệu] đã cạn kiệt.
        ''',
      ),
      NewsModel(
        id: 2,
        title: 'Một thị trấn Illinois chiến đấu để cứu nhà máy điện của mình',
        summary: 'Hội đồng thành phố đã thông qua một nghị quyết để nghiên cứu việc mua lại cơ sở này sau khi chủ sở hữu hiện tại thông báo kế hoạch đóng cửa vào tháng 6.',
        thumbnail: 'https://images.unsplash.com/photo-1581090464777-f3220bbe1b8b?w=800&q=80',
        dateCreated: '2025-01-10',
        author: authors[1],
        category: categories[2],
        viewCount: 892,
        isFeatured: false,
        content: '''
Hội đồng thành phố đã thông qua một nghị quyết để nghiên cứu việc mua lại cơ sở này sau khi chủ sở hữu hiện tại thông báo kế hoạch đóng cửa vào tháng 6.

Nhà máy điện than được xây dựng vào những năm 1950 và đã cung cấp điện cho khu vực này trong nhiều thập kỷ. Tuy nhiên, với việc chuyển đổi sang năng lượng tái tạo và chi phí vận hành tăng cao, công ty mẹ đã quyết định đóng cửa cơ sở này.

Việc đóng cửa nhà máy sẽ ảnh hưởng đến khoảng 150 công nhân và có thể dẫn đến tăng giá điện trong khu vực.
        ''',
      ),
      NewsModel(
        id: 3,
        title: '14 hành khách bị cấm bay bởi Nona Airlines sau hành vi tồi tệ',
        summary: 'Hãng hàng không đã thực hiện hành động kỷ luật sau một loạt sự cố liên quan đến hành vi của hành khách trên các chuyến bay gần đây.',
        thumbnail: 'https://images.unsplash.com/photo-1544144433-d50aff500b91?w=800&q=80',
        dateCreated: '2025-01-09',
        author: authors[2],
        category: categories[3],
        viewCount: 445,
        isFeatured: false,
        content: '''
Hãng hàng không đã thực hiện hành động kỷ luật sau một loạt sự cố liên quan đến hành vi của hành khách trên các chuyến bay gần đây.

Các sự cố bao gồm việc từ chối tuân thủ quy định về khẩu trang, hành vi gây rối và không tuân theo hướng dẫn của phi hành đoàn. Hãng hàng không cho biết an toàn của hành khách và phi hành đoàn là ưu tiên hàng đầu.

Các hành khách bị cấm sẽ không được phép bay với hãng này trong thời gian từ 6 tháng đến 2 năm, tùy thuộc vào mức độ nghiêm trọng của hành vi.
        ''',
      ),
    ];
  }
} 