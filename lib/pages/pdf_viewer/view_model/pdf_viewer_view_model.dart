import 'package:base_app/pages/base/view_model/base_view_model.dart';
import 'package:base_app/pages/pdf_viewer/model/pdf_viewer_model.dart';
import 'package:base_app/utils/url_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:gtd_helper/helper/gtd_app_logger.dart';
import 'dart:io';

class PdfViewerViewModel extends BaseViewModel {
  PdfViewerModel? _pdfModel;
  bool _isLoading = false;
  bool _isDownloading = false;
  String? _errorMessage;
  String? _localFilePath;
  double _downloadProgress = 0.0;
  bool _downloadCompleted = false;

  // Getters
  PdfViewerModel? get pdfModel => _pdfModel;
  bool get isLoading => _isLoading;
  bool get isDownloading => _isDownloading;
  String? get errorMessage => _errorMessage;
  String? get localFilePath => _localFilePath;
  double get downloadProgress => _downloadProgress;
  bool get downloadCompleted => _downloadCompleted;

  String get fixedUrl => _pdfModel?.url != null 
      ? UrlHelper.fixUrl(_pdfModel!.url) 
      : '';

  void setPdfModel(PdfViewerModel model) {
    Logger.i('📄 Setting PDF model: ${model.title}');
    Logger.i('🔗 PDF URL: ${model.url}');
    _pdfModel = model;
    _clearError();
    notifyListeners();
    _startDownload();
  }

  Future<void> _startDownload() async {
    if (_pdfModel == null) {
      Logger.e('❌ PDF model is null, cannot start download');
      return;
    }

    Logger.i('⬇️ Starting PDF download...');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = fixedUrl;
      Logger.i('🔧 Fixed URL: $url');
      
      if (url.isEmpty) {
        throw Exception('URL không hợp lệ');
      }

      // Kiểm tra xem có phải là file PDF không
      if (!UrlHelper.isPdfFile(url)) {
        Logger.e('❌ File is not PDF: $url');
        throw Exception('File không phải là PDF');
      }

      Logger.i('✅ URL is valid PDF, starting download...');
      // Download PDF file
      await _downloadPdfFile(url);

    } catch (e) {
      Logger.e('💥 PDF download error: $e');
      _errorMessage = 'Không thể tải file PDF: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _downloadPdfFile(String url) async {
    _isDownloading = true;
    _downloadProgress = 0.0;
    _downloadCompleted = false;
    notifyListeners();

    try {
      // Tạo local file path
              final fileName = UrlHelper.getFileName(url);
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/$fileName';
      final file = File(filePath);

      // Kiểm tra file đã tồn tại chưa
      if (await file.exists()) {
        _localFilePath = filePath;
        _downloadCompleted = true;
        _isDownloading = false;
        notifyListeners();
        return;
      }

      // Download file
      final request = http.Request('GET', Uri.parse(url));
      final response = await request.send();

      if (response.statusCode == 200) {
        final bytes = <int>[];
        final contentLength = response.contentLength ?? 0;
        int downloadedBytes = 0;

        await for (final chunk in response.stream) {
          bytes.addAll(chunk);
          downloadedBytes += chunk.length;
          
          if (contentLength > 0) {
            _downloadProgress = downloadedBytes / contentLength;
            notifyListeners();
          }
        }

        await file.writeAsBytes(bytes);
        _localFilePath = filePath;
        _downloadCompleted = true;
      } else {
        throw Exception('Không thể download file: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = 'Lỗi download: ${e.toString()}';
      debugPrint('Download error: $e');
    } finally {
      _isDownloading = false;
      notifyListeners();
    }
  }

  Future<void> openPdfFile() async {
    if (_localFilePath == null) {
      _errorMessage = 'File chưa được download';
      notifyListeners();
      return;
    }

    try {
      final file = File(_localFilePath!);
      if (await file.exists()) {
        final uri = Uri.file(_localFilePath!);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          throw Exception('Không thể mở file PDF');
        }
      } else {
        throw Exception('File không tồn tại');
      }
    } catch (e) {
      _errorMessage = 'Lỗi mở file: ${e.toString()}';
      debugPrint('Open file error: $e');
      notifyListeners();
    }
  }

  Future<void> openInBrowser() async {
    final url = fixedUrl;
    if (url.isNotEmpty) {
      try {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(
            Uri.parse(url),
            mode: LaunchMode.externalNonBrowserApplication,
          );
        } else {
          throw Exception('Không thể mở URL');
        }
      } catch (e) {
        _errorMessage = 'Lỗi mở trình duyệt: ${e.toString()}';
        debugPrint('Open browser error: $e');
        notifyListeners();
      }
    } else {
      _errorMessage = 'URL không hợp lệ';
      notifyListeners();
    }
  }

  Future<void> retry() async {
    _clearError();
    await _startDownload();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
} 