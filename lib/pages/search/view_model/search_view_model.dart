import 'package:base_app/pages/base/view_model/base_view_model.dart';
import '../../../data/repositories/article_repository.dart';
import '../../../data/repositories/document_repository.dart';
import '../../../data/api_client/base_api_client.dart';
import '../../../data/api_client/pccc_environment.dart';
import '../model/search_result_model.dart';
import 'dart:async';

class SearchViewModel extends BaseViewModel {
  final ArticleRepositoryImpl _articleRepository;
  final DocumentRepositoryImpl _documentRepository;
  Timer? _debounceTimer;
  
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

  String _removeDiacritics(String str) {
    var diacriticsMap = {
      'à': 'a', 'á': 'a', 'ạ': 'a', 'ả': 'a', 'ã': 'a', 'â': 'a', 'ầ': 'a', 'ấ': 'a', 'ậ': 'a', 'ẩ': 'a', 'ẫ': 'a', 'ă': 'a', 'ằ': 'a', 'ắ': 'a', 'ặ': 'a', 'ẳ': 'a', 'ẵ': 'a',
      'è': 'e', 'é': 'e', 'ẹ': 'e', 'ẻ': 'e', 'ẽ': 'e', 'ê': 'e', 'ề': 'e', 'ế': 'e', 'ệ': 'e', 'ể': 'e', 'ễ': 'e',
      'ì': 'i', 'í': 'i', 'ị': 'i', 'ỉ': 'i', 'ĩ': 'i',
      'ò': 'o', 'ó': 'o', 'ọ': 'o', 'ỏ': 'o', 'õ': 'o', 'ô': 'o', 'ồ': 'o', 'ố': 'o', 'ộ': 'o', 'ổ': 'o', 'ỗ': 'o', 'ơ': 'o', 'ờ': 'o', 'ớ': 'o', 'ợ': 'o', 'ở': 'o', 'ỡ': 'o',
      'ù': 'u', 'ú': 'u', 'ụ': 'u', 'ủ': 'u', 'ũ': 'u', 'ư': 'u', 'ừ': 'u', 'ứ': 'u', 'ự': 'u', 'ử': 'u', 'ữ': 'u',
      'ỳ': 'y', 'ý': 'y', 'ỵ': 'y', 'ỷ': 'y', 'ỹ': 'y',
      'đ': 'd',
    };

    return str.toLowerCase().split('').map((char) => diacriticsMap[char] ?? char).join('');
  }

  void searchWithDebounce(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 800), () {
      search(query);
    });
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
      // Search articles and documents in parallel using filter with diacritics removed
      final normalizedQuery = _removeDiacritics(query);
      final results = await Future.wait([
        _searchArticles(normalizedQuery),
        _searchDocuments(normalizedQuery),
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
      // Use filter to search articles by title and summary with diacritics removed
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
          categoryName: null,
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
      // Use filter to search documents by title and description with diacritics removed
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
          categoryName: null,
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
    _debounceTimer?.cancel();
  }

  void _clearResults() {
    _searchResult = SearchResult.empty();
    _currentQuery = '';
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
} 