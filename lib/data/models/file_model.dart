import 'package:vnl_common_ui/vnl_ui.dart';

class FileModel {
  final String id;
  final String? storage;
  final String? filenameDisk;
  final String? filenameDownload;
  final String? title;
  final String? type;
  final String? folder;
  final int? filesize;
  final DateTime? createdOn;
  final DateTime? uploadedOn;

  FileModel({
    required this.id,
    this.storage,
    this.filenameDisk,
    this.filenameDownload,
    this.title,
    this.type,
    this.folder,
    this.filesize,
    this.createdOn,
    this.uploadedOn,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'] ?? '',
      storage: json['storage'],
      filenameDisk: json['filename_disk'],
      filenameDownload: json['filename_download'],
      title: json['title'],
      type: json['type'],
      folder: json['folder'],
      filesize: json['filesize'] != null ? int.tryParse(json['filesize'].toString()) : null,
      createdOn: json['created_on'] != null 
          ? DateTime.tryParse(json['created_on']) 
          : null,
      uploadedOn: json['uploaded_on'] != null 
          ? DateTime.tryParse(json['uploaded_on']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storage': storage,
      'filename_disk': filenameDisk,
      'filename_download': filenameDownload,
      'title': title,
      'type': type,
      'folder': folder,
      'filesize': filesize,
      'created_on': createdOn?.toIso8601String(),
      'uploaded_on': uploadedOn?.toIso8601String(),
    };
  }

  // Helper getters
  String get displayName => filenameDownload ?? title ?? filenameDisk ?? id;
  String get extension {
    final filename = filenameDownload ?? filenameDisk ?? '';
    final lastDot = filename.lastIndexOf('.');
    return lastDot != -1 ? filename.substring(lastDot) : '';
  }
  String get filenameWithExtension => filenameDownload ?? filenameDisk ?? '$id$extension';
}

class FileResponse {
  final FileModel data;

  FileResponse({required this.data});

  factory FileResponse.fromJson(Map<String, dynamic> json) {
    return FileResponse(
      data: FileModel.fromJson(json['data']),
    );
  }
} 