import 'package:base_app/pages/base/view/base_view.dart';
import 'package:base_app/pages/pdf_viewer/view_model/pdf_viewer_view_model.dart';
import 'package:vnl_common_ui/vnl_ui.dart';
import 'package:flutter/material.dart' as material;

class PdfViewerView extends BaseView<PdfViewerViewModel> {
  const PdfViewerView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return _buildContent(context);
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    if (viewModel.isLoading || viewModel.isDownloading) {
      return _buildDownloadState(context);
    }

    if (viewModel.errorMessage != null) {
      return _buildErrorState(context);
    }

    if (viewModel.downloadCompleted && viewModel.localFilePath != null) {
      return _buildDownloadedState(context);
    }

    return _buildEmptyState(context);
  }

  Widget _buildDownloadState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: material.Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                BootstrapIcons.download,
                size: 80,
                color: material.Colors.blue,
              ),
            ),
            const Gap(24),
            Text(
              viewModel.pdfModel?.title ?? 'PDF Document',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            Text(
              viewModel.isDownloading ? 'Đang tải file PDF...' : 'Đang chuẩn bị tải...',
              style: TextStyle(
                fontSize: 16,
                color: VNLTheme.of(context).colorScheme.mutedForeground,
              ),
            ),
            const Gap(24),
            
            // Progress bar
            Container(
              width: double.infinity,
              height: 8,
              decoration: BoxDecoration(
                color: VNLTheme.of(context).colorScheme.muted,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: viewModel.downloadProgress,
                child: Container(
                  decoration: BoxDecoration(
                    color: material.Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const Gap(12),
            Text(
              '${(viewModel.downloadProgress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14,
                color: VNLTheme.of(context).colorScheme.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadedState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: material.Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                BootstrapIcons.checkCircle,
                size: 80,
                color: material.Colors.green,
              ),
            ),
            const Gap(24),
            Text(
              viewModel.pdfModel?.title ?? 'PDF Document',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            if (viewModel.pdfModel?.effectiveDate != null) ...[
              Text(
                'Ngày hiệu lực: ${viewModel.pdfModel!.effectiveDate}',
                style: TextStyle(
                  fontSize: 14,
                  color: VNLTheme.of(context).colorScheme.mutedForeground,
                ),
              ),
              const Gap(8),
            ],
            Text(
              'Tải thành công! Chọn cách mở file PDF',
              style: TextStyle(
                fontSize: 16,
                color: material.Colors.green,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(32),
            
            // Buttons
            SizedBox(
              width: double.infinity,
              child: VNLButton(
                style: ButtonStyle.primary(),
                onPressed: viewModel.openPdfFile,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(BootstrapIcons.boxArrowUpRight, size: 18),
                    const Gap(8),
                    Text('Mở trong ứng dụng PDF'),
                  ],
                ),
              ),
            ),
            const Gap(16),
            SizedBox(
              width: double.infinity,
              child: VNLButton(
                style: ButtonStyle.ghost(),
                onPressed: viewModel.openInBrowser,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(BootstrapIcons.globe, size: 18),
                    const Gap(8),
                    Text('Mở trong trình duyệt'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              BootstrapIcons.exclamationTriangle,
              size: 64,
              color: VNLTheme.of(context).colorScheme.destructive,
            ),
            const Gap(16),
            Text(
              'Lỗi khi tải PDF',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(8),
            Text(
              viewModel.errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: VNLTheme.of(context).colorScheme.mutedForeground,
              ),
            ),
            const Gap(24),
            VNLButton(
              style: ButtonStyle.primary(),
              onPressed: viewModel.retry,
              child: Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              BootstrapIcons.filePdf,
              size: 64,
              color: VNLTheme.of(context).colorScheme.mutedForeground,
            ),
            const Gap(16),
            Text(
              'Không có file PDF để tải',
              style: TextStyle(
                fontSize: 16,
                color: VNLTheme.of(context).colorScheme.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 