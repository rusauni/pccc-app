import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:flutter/material.dart' show Colors, showModalBottomSheet, Dialog, Scaffold, AppBar, Navigator, RefreshIndicator;
import 'package:go_router/go_router.dart';
import 'package:base_app/router/app_router.dart';
import 'package:base_app/utils/url_helper.dart';
import 'package:base_app/data/repositories/document_repository.dart';
import 'package:base_app/data/models/document_model.dart';
import 'package:base_app/data/api_client/base_api_client.dart';
import 'package:gtd_helper/helper/gtd_app_logger.dart';
import 'package:base_app/data/api_client/pccc_environment.dart';
import 'package:gtd_network/gtd_network.dart';

class DocumentsTab extends StatefulWidget {
  DocumentsTab({super.key});

  @override
  State<DocumentsTab> createState() => _DocumentsTabState();
}

class _DocumentsTabState extends State<DocumentsTab> {
  List<DocumentModel> documents = [];
  bool isLoading = true;
  String? errorMessage;
  late DocumentRepository _documentRepository;

  @override
  void initState() {
    super.initState();
    _documentRepository = DocumentRepositoryImpl(
      apiClient: BaseApiClient(
        environment: PcccEnvironment.development(),
      ),
      useMockData: false, // Chuyển sang API thật
    );
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    try {
      Logger.i('🔄 Starting to load documents from API...');
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Gọi API với filter category = 7 (Văn bản pháp quy) và các fields cần thiết
      Logger.i('📡 Calling API with filter category = 7');
      final response = await _documentRepository.getDocuments(
        filter: '{"category":{"_eq":7}}',
        fields: [
          'id',
          'title', 
          'file',
          'description',
          'category.name',
          'document_number',
          'sub_category',
          'agency_id',
          'document_type_id',
          'agency_id.agency_name',
          'document_type_id.document_type_name',
          'effective_date',
          'sub_category.sub_name'
        ],
        limit: 20,
        sort: ['-effective_date'],
      );

      Logger.i('📋 API Response - Success: ${response.isSuccess}, HasData: ${response.data != null}');
      
      if (response.isSuccess && response.data != null) {
        Logger.i('✅ Successfully loaded ${response.data!.data.length} documents');
        
        // Log detailed info about first document for debugging
        if (response.data!.data.isNotEmpty) {
          final firstDoc = response.data!.data.first;
          Logger.i('🔍 Sample document:');
          Logger.i('   - Title: ${firstDoc.title}');
          Logger.i('   - File: ${firstDoc.file}');
          Logger.i('   - DocumentType: ${firstDoc.documentTypeName}');
          Logger.i('   - Agency: ${firstDoc.agencyName}');
          Logger.i('   - Number: ${firstDoc.documentNumber}');
        }
        
        setState(() {
          documents = response.data!.data;
          isLoading = false;
        });
      } else {
        final errorMsg = response.error?.error.message ?? 'Có lỗi xảy ra khi tải dữ liệu';
        Logger.e('❌ API Error: $errorMsg');
        Logger.e('📊 Response details: ${response.error?.toString()}');
        setState(() {
          errorMessage = errorMsg;
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      Logger.e('💥 Exception loading documents: $e');
      Logger.e('📍 Stack trace: $stackTrace');
      setState(() {
        errorMessage = 'Không thể kết nối đến máy chủ: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              BootstrapIcons.exclamationTriangle,
              size: 48,
              color: VNLTheme.of(context).colorScheme.mutedForeground,
            ),
            Gap(16),
            Text(
              errorMessage!,
              style: TextStyle(
                color: VNLTheme.of(context).colorScheme.mutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(16),
                         VNLButton(
               style: ButtonStyle.primary(),
               onPressed: _loadDocuments,
               child: Text('Thử lại'),
             ),
          ],
        ),
      );
    }

    if (documents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              BootstrapIcons.fileText,
              size: 48,
              color: VNLTheme.of(context).colorScheme.mutedForeground,
            ),
            Gap(16),
            Text(
              'Chưa có tài liệu nào',
              style: TextStyle(
                color: VNLTheme.of(context).colorScheme.mutedForeground,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDocuments,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final document = documents[index];
          return _buildDocumentItem(
            context: context,
            document: document,
          );
        },
      ),
    );
  }

  Widget _buildDocumentItem({
    required BuildContext context,
    required DocumentModel document,
  }) {
    final theme = VNLTheme.of(context);
    final fileExtension = _getFileExtension(document.file ?? '');
    final icon = _getIconForDocType(fileExtension);
    final color = _getColorForDocType(context, fileExtension);
    
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: VNLCard(
        child: VNLButton(
          style: ButtonStyle.ghost(),
          onPressed: () {
            if (UrlHelper.isSupportedDocument(document.file ?? '')) {
              _openDocumentViewer(context, document);
            } else {
              _showUnsupportedFileDialog(context, fileExtension);
            }
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.title,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${document.documentTypeName ?? fileExtension.toUpperCase()} • ${document.documentNumber ?? 'N/A'}', 
                        style: TextStyle(
                          fontSize: 12, 
                          color: theme.colorScheme.mutedForeground
                        )
                      ),
                      if (document.agencyName != null) ...[
                        SizedBox(height: 2),
                        Text(
                          '${document.agencyName} • ${document.effectiveDate ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.mutedForeground,
                            fontStyle: FontStyle.italic,
                          )
                        ),
                      ],
                    ],
                  ),
                ),
                VNLButton(
                  style: ButtonStyle.ghost(density: ButtonDensity.icon),
                  onPressed: () {
                    _showDocumentOptions(context, document);
                  },
                  child: Icon(BootstrapIcons.threeDotsVertical),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getFileExtension(String fileName) {
    if (fileName.isEmpty) return 'PDF';
    return UrlHelper.getFileExtension(fileName).toUpperCase();
  }

  void _openDocumentViewer(BuildContext context, DocumentModel document) {
    // Fix URL using UrlHelper 
    String fileUrl = document.file ?? '';
    Logger.i('📄 Opening Document Viewer for: ${document.title}');
    Logger.i('🔗 Original file URL: $fileUrl');
    
    if (fileUrl.isNotEmpty) {
      fileUrl = UrlHelper.fixUrl(fileUrl);
      Logger.i('🔧 Fixed URL: $fileUrl');
    }
    
    // Create document model data
    final documentModelData = {
      'title': document.title,
      'file': fileUrl,
      'fileUrl': fileUrl,
      'effectiveDate': document.effectiveDate,
      'documentNumber': document.documentNumber,
      'agencyName': document.agencyName,
      'documentTypeName': document.documentTypeName,
    };
    
    Logger.i('📦 Document Model Data: $documentModelData');
    
    // Navigate to document viewer (renamed from PDF viewer to support multiple types)
    context.pushNamed(
      AppRouterPath.pdfViewer, // Keep same route for now, but supports all document types
      extra: documentModelData,
    );
  }

  void _showUnsupportedFileDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: VNLTheme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Định dạng không hỗ trợ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Gap(16),
              Text('Hiện tại chưa hỗ trợ xem trước file $type. Vui lòng tải về để xem.'),
              const Gap(24),
              VNLButton.ghost(
                onPressed: () => Navigator.pop(context),
                child: Text('Đóng'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDocumentOptions(BuildContext context, DocumentModel document) {
    final fileExtension = _getFileExtension(document.file ?? '');
    
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              document.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (document.description != null && document.description!.isNotEmpty) ...[
              Gap(8),
              Text(
                document.description!,
                style: TextStyle(
                  color: VNLTheme.of(context).colorScheme.mutedForeground,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (document.agencyName != null || document.documentTypeName != null) ...[
              Gap(8),
              Row(
                children: [
                  if (document.documentTypeName != null) ...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        document.documentTypeName!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Gap(8),
                  ],
                  if (document.agencyName != null) ...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        document.agencyName!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
            Gap(16),
            _buildOptionItem(
              context,
              icon: BootstrapIcons.eye,
              title: 'Xem trước',
              onTap: () {
                Navigator.pop(context);
                if (UrlHelper.isSupportedDocument(document.file ?? '')) {
                  _openDocumentViewer(context, document);
                } else {
                  _showUnsupportedFileDialog(context, fileExtension);
                }
              },
            ),
            _buildOptionItem(
              context,
              icon: BootstrapIcons.download,
              title: 'Tải xuống',
              onTap: () {
                Navigator.pop(context);
                // Implement download logic
              },
            ),
            _buildOptionItem(
              context,
              icon: BootstrapIcons.share,
              title: 'Chia sẻ',
              onTap: () {
                Navigator.pop(context);
                // Implement share logic
              },
            ),
            Gap(16),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return VNLButton(
      style: ButtonStyle.ghost(),
      onPressed: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20),
            Gap(16),
            Text(title, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  IconData _getIconForDocType(String type) {
    switch (type) {
      case 'PDF':
        return BootstrapIcons.filePdf;
      case 'DOCX':
        return BootstrapIcons.fileText;
      case 'XLSX':
        return BootstrapIcons.fileSpreadsheet;
      case 'PPTX':
        return BootstrapIcons.fileSlides;
      case 'JPG':
      case 'PNG':
        return BootstrapIcons.fileImage;
      default:
        return BootstrapIcons.file;
    }
  }

  Color _getColorForDocType(BuildContext context, String type) {
    switch (type) {
      case 'PDF':
        return Colors.red;
      case 'DOCX':
        return Colors.blue;
      case 'XLSX':
        return Colors.green;
      case 'PPTX':
        return Colors.orange;
      case 'JPG':
      case 'PNG':
        return Colors.purple;
      default:
        return VNLTheme.of(context).colorScheme.mutedForeground;
    }
  }
}

class DocumentPreviewDialog extends StatelessWidget {
  final String title;
  final String type;
  final String url;

  const DocumentPreviewDialog({
    super.key,
    required this.title,
    required this.type,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
          leading: VNLButton(
            style: ButtonStyle.ghost(density: ButtonDensity.icon),
            onPressed: () => Navigator.pop(context),
            child: Icon(BootstrapIcons.x),
          ),
          actions: [
            VNLButton(
              style: ButtonStyle.ghost(density: ButtonDensity.icon),
              onPressed: () {
                // Implement download logic
              },
              child: Icon(BootstrapIcons.download),
            ),
            VNLButton(
              style: ButtonStyle.ghost(density: ButtonDensity.icon),
              onPressed: () {
                // Implement share logic
              },
              child: Icon(BootstrapIcons.share),
            ),
          ],
        ),
        body: SafeArea(
          child: _buildPreviewContent(context),
        ),
      ),
    );
  }

  Widget _buildPreviewContent(BuildContext context) {
    switch (type.toUpperCase()) {
      case 'JPG':
      case 'PNG':
        return _buildImagePreview();
      case 'PDF':
        return _buildPdfPreview();
      case 'DOCX':
      case 'XLSX':
      case 'PPTX':
        return _buildOfficeDocumentPreview();
      default:
        return _buildUnsupportedPreview(context);
    }
  }

  Widget _buildImagePreview() {
    return Center(
      child: InteractiveViewer(
        panEnabled: true,
        boundaryMargin: EdgeInsets.all(20),
        minScale: 0.5,
        maxScale: 4.0,
        child: Image.network(
          url,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorView(context, 'Không thể tải hình ảnh');
          },
        ),
      ),
    );
  }

  Widget _buildPdfPreview() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            BootstrapIcons.filePdf,
            size: 64,
            color: Colors.red,
          ),
          Gap(16),
          Text(
            'Xem trước PDF',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Gap(8),
                     Text(
             'Tính năng xem trước PDF sẽ được cập nhật trong phiên bản tiếp theo',
             textAlign: TextAlign.center,
             style: TextStyle(color: Colors.grey),
           ),
          Gap(24),
          VNLButton(
            style: ButtonStyle.primary(),
            onPressed: () {
              // Open in external app or web browser
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(BootstrapIcons.boxArrowUpRight, size: 16),
                Gap(8),
                Text('Mở trong trình duyệt'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfficeDocumentPreview() {
    IconData icon;
    Color color;
    String typeName;
    
    switch (type.toUpperCase()) {
      case 'DOCX':
        icon = BootstrapIcons.fileText;
        color = Colors.blue;
        typeName = 'Word';
        break;
      case 'XLSX':
        icon = BootstrapIcons.fileSpreadsheet;
        color = Colors.green;
        typeName = 'Excel';
        break;
      case 'PPTX':
        icon = BootstrapIcons.fileSlides;
        color = Colors.orange;
        typeName = 'PowerPoint';
        break;
      default:
        icon = BootstrapIcons.file;
        color = Colors.grey;
        typeName = 'Document';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: color,
          ),
          Gap(16),
          Text(
            'Xem trước $typeName',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Gap(8),
                     Text(
             'Tính năng xem trước tài liệu Office sẽ được cập nhật trong phiên bản tiếp theo',
             textAlign: TextAlign.center,
             style: TextStyle(color: Colors.grey),
           ),
          Gap(24),
          VNLButton(
            style: ButtonStyle.primary(),
            onPressed: () {
              // Open in external app
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(BootstrapIcons.boxArrowUpRight, size: 16),
                Gap(8),
                Text('Mở bằng ứng dụng khác'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnsupportedPreview(BuildContext context) {
    return _buildErrorView(context, 'Định dạng file không được hỗ trợ xem trước');
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            BootstrapIcons.exclamationTriangle,
            size: 64,
            color: VNLTheme.of(context).colorScheme.destructive,
          ),
          Gap(16),
          Text(
            'Không thể xem trước',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Gap(8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: VNLTheme.of(context).colorScheme.mutedForeground),
          ),
        ],
      ),
    );
  }
}
