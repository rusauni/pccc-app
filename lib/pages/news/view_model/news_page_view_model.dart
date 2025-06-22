import 'package:base_app/pages/base/view_model/page_view_model.dart';
import '../../../data/repositories/article_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/featured_articles_repository.dart';
import '../../../data/api_client/base_api_client.dart';
import '../../../data/api_client/pccc_environment.dart';
import 'news_view_model.dart';

class NewsPageViewModel extends PageViewModel {
  late final NewsViewModel newsViewModel;

  NewsPageViewModel() {
    title = "Tin tức nổi bật";
    _initializeRepositories();
  }

  void _initializeRepositories() {
    // Create API client with development environment
    final apiClient = BaseApiClient(
      environment: PcccEnvironment.development(),
      // TODO: Add access token if needed
    );

    // Create repository instances
    final articleRepository = ArticleRepositoryImpl(
      apiClient: apiClient,
      useMockData: false, // Use real API as per cursor rules - real mode
    );

    final categoryRepository = CategoryRepositoryImpl(
      apiClient: apiClient,
      useMockData: false, // Use real API as per cursor rules - real mode
    );

    final featuredArticlesRepository = FeaturedArticlesRepositoryImpl(
      apiClient: apiClient,
      useMockData: false, // Use real API as per cursor rules - real mode
    );

    // Initialize news view model with repositories
    newsViewModel = NewsViewModel(
      articleRepository: articleRepository,
      categoryRepository: categoryRepository,
      featuredArticlesRepository: featuredArticlesRepository,
    );
  }
} 