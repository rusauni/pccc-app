import 'package:base_app/pages/base/view_model/base_view_model.dart';
import 'package:gtd_helper/helper/gtd_app_logger.dart';
import '../../../data/repositories/featured_articles_repository.dart';
import '../../../data/api_client/base_api_client.dart';
import '../../../data/api_client/pccc_environment.dart';
import '../../news/model/news_model.dart';
import '../../news/model/news_category_model.dart';

class HomeViewModel extends BaseViewModel {
  final FeaturedArticlesRepository _featuredArticlesRepository;
  
  List<NewsModel> _featuredNewsList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<NewsModel> get featuredNewsList => _featuredNewsList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  HomeViewModel({
    required FeaturedArticlesRepository featuredArticlesRepository,
  }) : _featuredArticlesRepository = featuredArticlesRepository {
    _loadFeaturedNews();
  }

  Future<void> _loadFeaturedNews() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      Logger.i('Loading featured articles for Home page...');
      
      final featuredResponse = await _featuredArticlesRepository.getFeaturedArticles(
        fields: [
          'id',
          'title',
          'articles.articles_id.id',
          'articles.articles_id.title',
          'articles.articles_id.slug',
          'articles.articles_id.thumbnail',
          'articles.articles_id.date_created',
          'articles.articles_id.summary',
          'articles.articles_id.category.name',
          'articles.articles_id.category.slug',
          'articles.articles_id.category.id'
        ],
        limit: 2, // Chỉ lấy 2 bài viết mới nhất cho Home
        sort: ['-articles.articles_id.date_created'], // Sắp xếp theo ngày tạo mới nhất
      );
      
      Logger.i('Featured articles response: ${featuredResponse.isSuccess}');
      
      if (featuredResponse.isSuccess && featuredResponse.data != null && featuredResponse.data!.data.isNotEmpty) {
        final featuredCollections = featuredResponse.data!.data;
        
        // Parse featured articles from all collections
        List<NewsModel> allFeaturedNews = [];
        for (final featuredCollection in featuredCollections) {
          if (featuredCollection.articles != null && featuredCollection.articles!.isNotEmpty) {
            final collectionNews = featuredCollection.articles!
                .where((item) => item.articlesId != null)
                .map((item) {
                  final articleData = item.articlesId!;
                  return NewsModel(
                    id: articleData.id,
                    title: articleData.title ?? '',
                    summary: '', // Summary có thể được thêm vào fields nếu cần
                    content: '', // Content không cần thiết cho Home preview
                    thumbnail: articleData.thumbnail,
                    dateCreated: articleData.dateCreated,
                    slug: articleData.slug,
                    categoryId: articleData.category?.id,
                    isFeatured: true,
                    // Create category info if available
                    category: articleData.category != null 
                        ? NewsCategoryModel(
                            id: articleData.category!.id.toString(),
                            name: articleData.category!.name ?? '',
                            slug: articleData.category!.slug ?? '',
                          )
                        : null,
                  );
                })
                .toList();
            allFeaturedNews.addAll(collectionNews);
          }
        }
        
        // Remove duplicates by ID and take only 2 latest
        final Map<int, NewsModel> uniqueFeatured = {};
        for (final news in allFeaturedNews) {
          if (news.id != null && !uniqueFeatured.containsKey(news.id)) {
            uniqueFeatured[news.id!] = news;
          }
        }
        
        // Sort by date created (newest first) and take 2
        _featuredNewsList = uniqueFeatured.values.toList()
          ..sort((a, b) {
            if (a.dateCreated == null && b.dateCreated == null) return 0;
            if (a.dateCreated == null) return 1;
            if (b.dateCreated == null) return -1;
            return b.dateCreated!.compareTo(a.dateCreated!);
          });
        _featuredNewsList = _featuredNewsList.take(2).toList();
        
        Logger.i('Successfully loaded ${_featuredNewsList.length} featured articles for Home');
      } else {
        Logger.e('Failed to load featured articles from API: ${featuredResponse.error?.error.message}');
        _errorMessage = 'Không thể tải tin tức nổi bật';
        
        // Fallback to dummy data
        _featuredNewsList = _getDummyFeaturedNews();
        Logger.i('Using dummy featured news data for Home');
      }
    } catch (e, stackTrace) {
      Logger.e('Error loading featured news for Home: $e');
      Logger.e('Stack trace: $stackTrace');
      _errorMessage = 'Có lỗi xảy ra khi tải tin tức';
      
      // Fallback to dummy data
      _featuredNewsList = _getDummyFeaturedNews();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<NewsModel> _getDummyFeaturedNews() {
    return [
      NewsModel(
        id: 1,
        title: 'Diễn tập PCCC tại khu chung cư cao tầng',
        summary: 'Sáng ngày 15/12/2024, Phòng Cảnh sát PCCC&CNCH Công an TP đã tổ chức buổi diễn tập phòng cháy chữa cháy tại khu chung cư cao tầng...',
        content: '',
        dateCreated: '2024-12-15T08:00:00Z',
        slug: 'dien-tap-pccc-chung-cu-cao-tang',
        isFeatured: true,
      ),
      NewsModel(
        id: 2,
        title: 'Cập nhật quy định mới về PCCC năm 2024',
        summary: 'Bộ Công an vừa ban hành Thông tư số 25/2024/TT-BCA quy định về phòng cháy chữa cháy trong các khu vực dân cư và công trình...',
        content: '',
        dateCreated: '2024-12-10T09:00:00Z',
        slug: 'cap-nhat-quy-dinh-pccc-2024',
        isFeatured: true,
      ),
    ];
  }

  Future<void> refreshFeaturedNews() async {
    await _loadFeaturedNews();
  }

  static HomeViewModel create() {
    // Create API client with development environment
    final apiClient = BaseApiClient(
      environment: PcccEnvironment.development(),
    );

    // Create repository instance
    final featuredArticlesRepository = FeaturedArticlesRepositoryImpl(
      apiClient: apiClient,
      useMockData: false, // Use real API as per cursor rules - real mode
    );

    return HomeViewModel(
      featuredArticlesRepository: featuredArticlesRepository,
    );
  }
} 