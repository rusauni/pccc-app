import 'package:base_app/data/api_client/base_api_client.dart';
import 'package:base_app/data/api_client/pccc_environment.dart';
import 'package:base_app/data/models/file_model.dart';
import 'package:gtd_helper/helper/gtd_app_logger.dart';

class FileRepository {
  final BaseApiClient _apiClient;

  FileRepository({BaseApiClient? apiClient}) 
      : _apiClient = apiClient ?? BaseApiClient(environment: PcccEnvironment.production());

  /// Get file by ID to retrieve filename and metadata
  Future<FileModel?> getFileById(String fileId) async {
    try {
      Logger.i('🔍 Fetching file info for ID: $fileId');
      
      final endpoint = PcccEndpoints.fileById(fileId);
      Logger.i('📡 Calling API: $endpoint');
      
      final response = await _apiClient.get(
        endpoint,
        fromJson: (json) => json,
      );
      
      if (response.data != null) {
        final fileResponse = FileResponse.fromJson(response.data!);
        Logger.i('✅ File info retrieved: ${fileResponse.data.displayName}');
        Logger.i('📄 Filename: ${fileResponse.data.filenameWithExtension}');
        Logger.i('🔧 MIME Type: ${fileResponse.data.type}');
        Logger.i('📦 File Size: ${fileResponse.data.filesize} bytes');
        
        return fileResponse.data;
      } else {
        Logger.e('❌ No data in file response');
        return null;
      }
    } catch (e) {
      Logger.e('💥 Error fetching file info: $e');
      return null;
    }
  }

  /// Get file download URL by ID
  String getFileDownloadUrl(String fileId) {
    final url = 'https://dashboard.pccc40.com/${PcccEndpoints.assetById(fileId)}';
    Logger.i('🔗 File download URL: $url');
    return url;
  }
} 