import 'package:base_app/pages/base/view_model/page_view_model.dart';
import 'package:base_app/pages/pdf_viewer/view_model/pdf_viewer_view_model.dart';

class PdfViewerPageViewModel extends PageViewModel {
  final PdfViewerViewModel pdfViewerViewModel = PdfViewerViewModel();

  PdfViewerPageViewModel() {
    title = "Xem PDF";
  }

  void updateTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }
} 