import 'package:base_app/pages/base/view_model/page_view_model.dart';
import 'package:base_app/pages/pdf_viewer/view_model/pdf_viewer_view_model.dart';
import 'package:base_app/data/repositories/file_repository.dart';

class PdfViewerPageViewModel extends PageViewModel {
  late final PdfViewerViewModel pdfViewerViewModel;

  PdfViewerPageViewModel({FileRepository? fileRepository}) {
    pdfViewerViewModel = PdfViewerViewModel(fileRepository ?? FileRepository());
    title = "Xem PDF";
  }

  void updateTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }
} 