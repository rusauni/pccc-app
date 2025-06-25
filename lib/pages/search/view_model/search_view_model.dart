import 'package:base_app/pages/base/view_model/base_view_model.dart';
import '../../../data/repositories/article_repository.dart';
import '../../../data/repositories/document_repository.dart';
import '../../../data/api_client/base_api_client.dart';
import '../../../data/api_client/pccc_environment.dart';
import '../model/search_result_model.dart';

class SearchViewModel extends BaseViewModel {
  final ArticleRepositoryImpl _articleRepository;
  final DocumentRepositoryImpl _documentRepository;
  
  SearchResult _searchResult = SearchResult.empty();
  bool _isLoading = false;
  String? _errorMessage;
  String _currentQuery = '';

  SearchResult get searchResult => _searchResult;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get currentQuery => _currentQuery;
  bool get hasResults => _searchResult.totalResults > 0;

  SearchViewModel({
    required ArticleRepositoryImpl articleRepository,
    required DocumentRepositoryImpl documentRepository,
  }) : _articleRepository = articleRepository,
       _documentRepository = documentRepository;

  factory SearchViewModel.create() {
    final apiClient = BaseApiClient(
      environment: PcccEnvironment.development(),
    );
    
    return SearchViewModel(
      articleRepository: ArticleRepositoryImpl(apiClient: apiClient),
      documentRepository: DocumentRepositoryImpl(apiClient: apiClient),
    );
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      _clearResults();
      return;
    }

    _currentQuery = query.trim();
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Search articles and documents in parallel using filter
      final results = await Future.wait([
        _searchArticles(query),
        _searchDocuments(query),
      ]);

      final articles = results[0] as List<SearchArticleItem>;
      final documents = results[1] as List<SearchDocumentItem>;

      _searchResult = SearchResult(
        articles: articles,
        documents: documents,
        query: query,
        totalResults: articles.length + documents.length,
      );

      print('Search completed: ${_searchResult.totalResults} results for "$query"');
    } catch (e) {
      _errorMessage = 'Lỗi tìm kiếm: ${e.toString()}';
      print('Search error: $e');
      _searchResult = SearchResult.empty();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<SearchArticleItem>> _searchArticles(String query) async {
    try {
      // Use filter to search articles by title and summary
      final filter = '{"_or":[{"title":{"_icontains":"$query"}},{"summary":{"_icontains":"$query"}}]}';
      
      final response = await _articleRepository.getArticles(
        filter: filter,
        limit: 20,
        fields: ['id', 'title', 'summary', 'thumbnail', 'date_created'],
      );
      
      if (response.isSuccess && response.data != null) {
        final articles = response.data!.data;
        return articles.map((article) => SearchArticleItem(
          id: article.id!,
          title: article.title ?? '',
          summary: article.summary,
          imageUrl: article.thumbnail,
          dateCreated: article.dateCreated,
          categoryName: null, // We don't have category name in this response
        )).toList();
      }
      
      return [];
    } catch (e) {
      print('Article search error: $e');
      return [];
    }
  }

  Future<List<SearchDocumentItem>> _searchDocuments(String query) async {
    try {
      // Use filter to search documents by title and description  
      final filter = '{"_or":[{"title":{"_icontains":"$query"}},{"description":{"_icontains":"$query"}}]}';
      
      final response = await _documentRepository.getDocuments(
        filter: filter,
        limit: 20,
        fields: ['id', 'title', 'description', 'file', 'effective_date', 'document_number'],
      );
      
      if (response.isSuccess && response.data != null) {
        final documents = response.data!.data;
        return documents.map((document) => SearchDocumentItem(
          id: document.id!,
          title: document.title ?? '',
          description: document.description,
          fileUrl: document.file,
          fileType: document.file?.split('.').last,
          dateCreated: document.effectiveDate,
          categoryName: null, // We don't have category name in this response
        )).toList();
      }
      
      return [];
    } catch (e) {
      print('Document search error: $e');
      return [];
    }
  }



  void clearSearch() {
    _clearResults();
  }

  void _clearResults() {
    _searchResult = SearchResult.empty();
    _currentQuery = '';
    _errorMessage = null;
    notifyListeners();
  }
} 