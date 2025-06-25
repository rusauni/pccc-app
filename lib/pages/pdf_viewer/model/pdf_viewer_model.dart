import 'package:vnl_common_ui/vnl_ui.dart';

class PdfViewerModel {
  final String title;
  final String url;
  final String? documentNumber;
  final String? effectiveDate;
  final String? issuingAgency;
  final String? description;
  final DateTime? publishedDate;

  PdfViewerModel({
    required this.title,
    required this.url,
    this.documentNumber,
    this.effectiveDate,
    this.issuingAgency,
    this.description,
    this.publishedDate,
  });

  factory PdfViewerModel.fromJson(Map<String, dynamic> json) {
    return PdfViewerModel(
      title: json['title'] ?? 'PDF Document',
      url: json['file'] ?? json['fileUrl'] ?? json['url'] ?? '',
      documentNumber: json['documentNumber'],
      effectiveDate: json['effectiveDate'],
      issuingAgency: json['issuingAgency'],
      description: json['description'],
      publishedDate: json['publishedDate'] != null ? DateTime.tryParse(json['publishedDate']) : null,
    );
  }

  factory PdfViewerModel.fromDocument(Map<String, dynamic> documentData) {
    // Parsing from documents_tab format
    return PdfViewerModel(
      title: documentData['title'] ?? 'PDF Document',
      url: documentData['file'] ?? documentData['fileUrl'] ?? documentData['url'] ?? '',
      documentNumber: documentData['documentNumber'],
      effectiveDate: documentData['effectiveDate'] ?? documentData['date'],
      issuingAgency: documentData['issuingAgency'],
      description: documentData['description'] ?? documentData['summary'],
      publishedDate: documentData['date'] != null ? DateTime.tryParse(documentData['date']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'file': url,
      'documentNumber': documentNumber,
      'effectiveDate': effectiveDate,
      'issuingAgency': issuingAgency,
      'description': description,
      'publishedDate': publishedDate?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'PdfViewerModel(title: $title, url: $url)';
  }
} 