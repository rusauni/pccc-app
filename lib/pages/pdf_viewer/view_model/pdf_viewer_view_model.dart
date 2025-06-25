import 'package:base_app/pages/base/view_model/base_view_model.dart';
import 'package:base_app/pages/pdf_viewer/model/pdf_viewer_model.dart';
import 'package:base_app/utils/url_helper.dart';
import 'package:base_app/data/repositories/file_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:gtd_helper/helper/gtd_app_logger.dart';
import 'dart:io';
import 'package:vnl_common_ui/vnl_ui.dart';

enum DocumentState { downloading, downloaded, error }

class PdfViewerViewModel extends BaseViewModel {
  final FileRepository _fileRepository;
  
  DocumentState _state = DocumentState.downloading;
  double _downloadProgress = 0.0;
  String? _errorMessage;
  String? _localFilePath;
  PdfViewerModel? _document;
  String? _downloadDirectory;

  PdfViewerViewModel(this._fileRepository);

  // Getters
  DocumentState get state => _state;
  double get downloadProgress => _downloadProgress;
  String? get errorMessage => _errorMessage;
  String? get localFilePath => _localFilePath;
  PdfViewerModel? get document => _document;
  String? get downloadDirectory => _downloadDirectory;

  Future<void> initialize(Map<String, dynamic> documentData) async {
    try {
      Logger.i('📄 Initializing PDF Viewer with data: $documentData');
      
      // Parse document model
      _document = PdfViewerModel.fromDocument(documentData);
      Logger.i('📋 Document title: ${_document!.title}');
      
      // Get file ID from document data
      String? fileId = documentData['file'];
      if (fileId == null || fileId.isEmpty) {
        Logger.e('❌ No file ID found in document data');
        _setError('Không tìm thấy file ID');
        return;
      }

      // If fileId looks like a URL, extract the ID from it
      if (fileId.startsWith('http')) {
        Logger.i('🔗 File ID is URL, extracting ID: $fileId');
        String? extractedId = UrlHelper.extractFileIdFromUrl(fileId);
        if (extractedId != null) {
          fileId = extractedId;
          Logger.i('✅ Extracted file ID: $fileId');
        } else {
          Logger.e('❌ Could not extract file ID from URL: $fileId');
          _setError('Không thể trích xuất file ID từ URL');
          return;
        }
      }

      Logger.i('📁 Using file ID: $fileId');
      
      // Get file metadata from API
      final fileModel = await _fileRepository.getFileById(fileId);
      
      if (fileModel != null) {
        Logger.i('📊 File metadata: ${fileModel.filenameDownload}, ${fileModel.type}');
        
        // Download file with proper filename
        await _downloadFile(fileId, fileModel.filenameDownload ?? '${fileModel.id}${fileModel.extension}');
      } else {
        Logger.e('❌ Failed to get file metadata');
        _setError('Không thể lấy thông tin file');
      }
      
    } catch (e, stackTrace) {
      Logger.e('❌ Error initializing PDF viewer: $e');
      Logger.e('📍 Stack trace: $stackTrace');
      _setError('Lỗi khởi tạo: ${e.toString()}');
    }
  }

  Future<void> _downloadFile(String fileId, String filename) async {
    try {
      Logger.i('📥 Starting download for file ID: $fileId');
      Logger.i('📝 Filename: $filename');
      
      _setState(DocumentState.downloading);
      _setProgress(0.0);

      // Get download directory
      Directory directory;
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
        }
      }

      _downloadDirectory = directory.path;
      Logger.i('📁 Download directory: $_downloadDirectory');

      // Check if file already exists
      final filePath = '${directory.path}/$filename';
      final file = File(filePath);
      
      if (await file.exists()) {
        Logger.i('✅ File already exists: $filePath');
        _localFilePath = filePath;
        _setState(DocumentState.downloaded);
        return;
      }

      // Get download URL
      final downloadUrl = _fileRepository.getFileDownloadUrl(fileId);
      Logger.i('🔗 Download URL: $downloadUrl');

      // Start download
      final response = await http.get(Uri.parse(downloadUrl));
      
      if (response.statusCode == 200) {
        // Write file
        await file.writeAsBytes(response.bodyBytes);
        _localFilePath = filePath;
        
        Logger.i('✅ File downloaded successfully to: $filePath');
        Logger.i('📊 File size: ${response.bodyBytes.length} bytes');
        
        _setProgress(1.0);
        _setState(DocumentState.downloaded);
        
        // List files in directory for debugging
        final files = await directory.list().toList();
        Logger.i('📂 Files in download directory:');
        for (var file in files) {
          Logger.i('  - ${file.path}');
        }
        
      } else {
        Logger.e('❌ Download failed with status: ${response.statusCode}');
        _setError('Tải file thất bại. Mã lỗi: ${response.statusCode}');
      }
      
    } catch (e, stackTrace) {
      Logger.e('❌ Error downloading file: $e');
      Logger.e('📍 Stack trace: $stackTrace');
      _setError('Lỗi tải file: ${e.toString()}');
    }
  }

  Future<void> openDownloadFolder() async {
    try {
      if (_downloadDirectory == null) {
        Logger.e('❌ Download directory not set');
        return;
      }

      Logger.i('📂 Attempting to open download folder: $_downloadDirectory');

      if (Platform.isIOS) {
        // Try to open iOS Files app
        final uri = Uri.parse('shareddocuments://$_downloadDirectory');
        Logger.i('🍎 Trying iOS Files app with URI: $uri');
        
        bool launched = await launchUrl(uri);
        if (!launched) {
          Logger.w('⚠️ Could not open iOS Files app, showing path info');
          // Show path info to user
          _showPathInfo();
        }
      } else {
        // Android - open file manager
        final uri = Uri.parse('content://com.android.externalstorage.documents/root/primary:Download');
        Logger.i('🤖 Trying Android file manager with URI: $uri');
        
        bool launched = await launchUrl(uri);
        if (!launched) {
          Logger.w('⚠️ Could not open Android file manager, showing path info');
          _showPathInfo();
        }
      }
    } catch (e) {
      Logger.e('❌ Error opening download folder: $e');
      _showPathInfo();
    }
  }

  void _showPathInfo() {
    Logger.i('ℹ️ Showing download path info to user');
    // TODO: Could show a dialog or message with the download path
    // For now, we'll just log it
    Logger.i('📁 Files are stored in: $_downloadDirectory');
  }

  Future<void> retryDownload() async {
    if (_document != null) {
      _setState(DocumentState.downloading);
      _setProgress(0.0);
      _errorMessage = null;
      
      // Extract file ID again and retry
      String? fileId = _document!.url;
      if (fileId.startsWith('http')) {
        fileId = UrlHelper.extractFileIdFromUrl(fileId);
      }
      
             if (fileId != null) {
         final fileModel = await _fileRepository.getFileById(fileId);
         if (fileModel != null) {
           await _downloadFile(fileId, fileModel.filenameDownload ?? '${fileModel.id}${fileModel.extension}');
         } else {
           _setError('Không thể lấy thông tin file');
         }
       } else {
         _setError('Không thể trích xuất file ID');
       }
    }
  }

  void _setState(DocumentState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setProgress(double progress) {
    _downloadProgress = progress;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _setState(DocumentState.error);
  }

  @override
  void dispose() {
    super.dispose();
  }
} 