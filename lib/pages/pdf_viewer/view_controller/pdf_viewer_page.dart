import 'package:base_app/pages/pdf_viewer/view/pdf_viewer_view.dart';
import 'package:base_app/pages/pdf_viewer/view_model/pdf_viewer_page_view_model.dart';
import 'package:base_app/pages/pdf_viewer/model/pdf_viewer_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart' hide ButtonStyle;
import '../../base/view_controller/page_view_controller.dart';

class PdfViewerPage extends PageViewController<PdfViewerPageViewModel> {
  final Map<String, dynamic> documentData;

  const PdfViewerPage({
    super.key, 
    required super.viewModel,
    required this.documentData,
  });

  @override
  PdfViewerPageState createState() => PdfViewerPageState();
}

class PdfViewerPageState extends PageViewControllerState<PdfViewerPage> {
  @override
  void initState() {
    super.initState();
    // Initialize PDF viewer with document data
    widget.viewModel.pdfViewerViewModel.initialize(widget.documentData);
    final title = widget.documentData['title'] ?? 'Xem tài liệu';
    widget.viewModel.updateTitle(title);
  }

  @override
  List<Widget> buildHeaders(BuildContext pageContext) {
    return [
      VNLAppBar(
        leading: [
          VNLButton.ghost(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
            child: const Icon(Icons.arrow_back),
          ),
        ],
        title: Text(
          widget.viewModel.title ?? 'Xem PDF',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: [
          VNLButton.ghost(
            onPressed: () => _showDocumentInfo(),
            child: const Icon(BootstrapIcons.info),
          ),
        ],
      ),
    ];
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return PdfViewerView(viewModel: widget.viewModel.pdfViewerViewModel);
  }

  void _showDocumentInfo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildDocumentInfoSheet(),
    );
  }

  Widget _buildDocumentInfoSheet() {
    final model = widget.viewModel.pdfViewerViewModel.document;
    return Container(
      decoration: BoxDecoration(
        color: VNLTheme.of(context).colorScheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: VNLTheme.of(context).colorScheme.muted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Gap(24),
          
          // Title
          Text(
            'Thông tin tài liệu',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(20),
          
          // Document info
          if (model != null) ...[
            _buildInfoRow('Tiêu đề', model.title),
            if (model.documentNumber != null) 
              _buildInfoRow('Số văn bản', model.documentNumber!),
            if (model.effectiveDate != null)
              _buildInfoRow('Ngày hiệu lực', model.effectiveDate!),
            if (model.description != null)
              _buildInfoRow('Mô tả', model.description!),
            _buildInfoRow('URL', model.url),
          ] else
            Text('Không có thông tin tài liệu'),
          
          const Gap(24),
          
          // Close button
          SizedBox(
            width: double.infinity,
            child: VNLButton(
              style: ButtonStyle.primary(),
              onPressed: () => Navigator.pop(context),
              child: Text('Đóng'),
            ),
          ),
          
          // Safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: VNLTheme.of(context).colorScheme.mutedForeground,
            ),
          ),
          const Gap(4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
} 