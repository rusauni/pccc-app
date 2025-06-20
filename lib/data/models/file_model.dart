import 'package:vnl_common_ui/vnl_ui.dart';

class FileModel {
  final String? id;
  final String? storage;
  final String? filenameDisk;
  final String? filenameDownload;
  final String? title;
  final String? type;
  final String? folder;
  final String? uploadedBy;
  final String? createdOn;
  final String? modifiedBy;
  final String? modifiedOn;
  final String? charset;
  final int? filesize;
  final int? width;
  final int? height;
  final int? duration;
  final String? embed;
  final String? description;
  final String? location;
  final List<String>? tags;
  final Map<String, dynamic>? metadata;
  final int? focalPointX;
  final int? focalPointY;
  final String? tusId;
  final dynamic tusData;
  final String? uploadedOn;

  FileModel({
    this.id,
    this.storage,
    this.filenameDisk,
    this.filenameDownload,
    this.title,
    this.type,
    this.folder,
    this.uploadedBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
    this.charset,
    this.filesize,
    this.width,
    this.height,
    this.duration,
    this.embed,
    this.description,
    this.location,
    this.tags,
    this.metadata,
    this.focalPointX,
    this.focalPointY,
    this.tusId,
    this.tusData,
    this.uploadedOn,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'],
      storage: json['storage'],
      filenameDisk: json['filename_disk'],
      filenameDownload: json['filename_download'],
      title: json['title'],
      type: json['type'],
      folder: json['folder'],
      uploadedBy: json['uploaded_by'],
      createdOn: json['created_on'],
      modifiedBy: json['modified_by'],
      modifiedOn: json['modified_on'],
      charset: json['charset'],
      filesize: json['filesize'],
      width: json['width'],
      height: json['height'],
      duration: json['duration'],
      embed: json['embed'],
      description: json['description'],
      location: json['location'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      metadata: json['metadata'],
      focalPointX: json['focal_point_x'],
      focalPointY: json['focal_point_y'],
      tusId: json['tus_id'],
      tusData: json['tus_data'],
      uploadedOn: json['uploaded_on'],
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
      'uploaded_by': uploadedBy,
      'created_on': createdOn,
      'modified_by': modifiedBy,
      'modified_on': modifiedOn,
      'charset': charset,
      'filesize': filesize,
      'width': width,
      'height': height,
      'duration': duration,
      'embed': embed,
      'description': description,
      'location': location,
      'tags': tags,
      'metadata': metadata,
      'focal_point_x': focalPointX,
      'focal_point_y': focalPointY,
      'tus_id': tusId,
      'tus_data': tusData,
      'uploaded_on': uploadedOn,
    };
  }

  FileModel copyWith({
    String? id,
    String? storage,
    String? filenameDisk,
    String? filenameDownload,
    String? title,
    String? type,
    String? folder,
    String? uploadedBy,
    String? createdOn,
    String? modifiedBy,
    String? modifiedOn,
    String? charset,
    int? filesize,
    int? width,
    int? height,
    int? duration,
    String? embed,
    String? description,
    String? location,
    List<String>? tags,
    Map<String, dynamic>? metadata,
    int? focalPointX,
    int? focalPointY,
    String? tusId,
    dynamic tusData,
    String? uploadedOn,
  }) {
    return FileModel(
      id: id ?? this.id,
      storage: storage ?? this.storage,
      filenameDisk: filenameDisk ?? this.filenameDisk,
      filenameDownload: filenameDownload ?? this.filenameDownload,
      title: title ?? this.title,
      type: type ?? this.type,
      folder: folder ?? this.folder,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      createdOn: createdOn ?? this.createdOn,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      modifiedOn: modifiedOn ?? this.modifiedOn,
      charset: charset ?? this.charset,
      filesize: filesize ?? this.filesize,
      width: width ?? this.width,
      height: height ?? this.height,
      duration: duration ?? this.duration,
      embed: embed ?? this.embed,
      description: description ?? this.description,
      location: location ?? this.location,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
      focalPointX: focalPointX ?? this.focalPointX,
      focalPointY: focalPointY ?? this.focalPointY,
      tusId: tusId ?? this.tusId,
      tusData: tusData ?? this.tusData,
      uploadedOn: uploadedOn ?? this.uploadedOn,
    );
  }
} 