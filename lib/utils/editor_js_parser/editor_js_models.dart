

/// Mô hình chính cho dữ liệu EditorJS
class EditorJSData {
  final int? time;
  final List<EditorJSBlock> blocks;
  final String? version;

  EditorJSData({
    this.time,
    required this.blocks,
    this.version,
  });

  factory EditorJSData.fromJson(Map<String, dynamic> json) {
    return EditorJSData(
      time: json['time'],
      blocks: (json['blocks'] as List<dynamic>?)
              ?.map((block) => EditorJSBlock.fromJson(block))
              .toList() ??
          [],
      version: json['version'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'blocks': blocks.map((block) => block.toJson()).toList(),
      'version': version,
    };
  }

  EditorJSData copyWith({
    int? time,
    List<EditorJSBlock>? blocks,
    String? version,
  }) {
    return EditorJSData(
      time: time ?? this.time,
      blocks: blocks ?? this.blocks,
      version: version ?? this.version,
    );
  }
}

/// Mô hình cho từng block trong EditorJS
class EditorJSBlock {
  final String? id;
  final String type;
  final Map<String, dynamic> data;
  final Map<String, dynamic>? tunes;

  EditorJSBlock({
    this.id,
    required this.type,
    required this.data,
    this.tunes,
  });

  factory EditorJSBlock.fromJson(Map<String, dynamic> json) {
    return EditorJSBlock(
      id: json['id'],
      type: json['type'] ?? '',
      data: json['data'] ?? {},
      tunes: json['tunes'],
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'type': type,
      'data': data,
    };
    
    if (id != null) result['id'] = id!;
    if (tunes != null) result['tunes'] = tunes!;
    
    return result;
  }

  EditorJSBlock copyWith({
    String? id,
    String? type,
    Map<String, dynamic>? data,
    Map<String, dynamic>? tunes,
  }) {
    return EditorJSBlock(
      id: id ?? this.id,
      type: type ?? this.type,
      data: data ?? this.data,
      tunes: tunes ?? this.tunes,
    );
  }
}

/// Mô hình cho block Paragraph
class ParagraphBlockData {
  final String text;
  final String? alignment;

  ParagraphBlockData({
    required this.text,
    this.alignment,
  });

  factory ParagraphBlockData.fromJson(Map<String, dynamic> json) {
    return ParagraphBlockData(
      text: json['text'] ?? '',
      alignment: json['alignment'],
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{'text': text};
    if (alignment != null) result['alignment'] = alignment!;
    return result;
  }
}

/// Mô hình cho block Header
class HeaderBlockData {
  final String text;
  final int level;
  final String? alignment;

  HeaderBlockData({
    required this.text,
    required this.level,
    this.alignment,
  });

  factory HeaderBlockData.fromJson(Map<String, dynamic> json) {
    return HeaderBlockData(
      text: json['text'] ?? '',
      level: json['level'] ?? 1,
      alignment: json['alignment'],
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'text': text,
      'level': level,
    };
    if (alignment != null) result['alignment'] = alignment!;
    return result;
  }
}

/// Mô hình cho block List
class ListBlockData {
  final String style; // ordered hoặc unordered
  final List<String> items;

  ListBlockData({
    required this.style,
    required this.items,
  });

  factory ListBlockData.fromJson(Map<String, dynamic> json) {
    return ListBlockData(
      style: json['style'] ?? 'unordered',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'style': style,
      'items': items,
    };
  }
}

/// Mô hình cho block Image
class ImageBlockData {
  final FileData file;
  final String? caption;
  final bool? withBorder;
  final bool? withBackground;
  final bool? stretched;

  ImageBlockData({
    required this.file,
    this.caption,
    this.withBorder,
    this.withBackground,
    this.stretched,
  });

  factory ImageBlockData.fromJson(Map<String, dynamic> json) {
    return ImageBlockData(
      file: FileData.fromJson(json['file'] ?? {}),
      caption: json['caption'],
      withBorder: json['withBorder'],
      withBackground: json['withBackground'],
      stretched: json['stretched'],
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{'file': file.toJson()};
    if (caption != null) result['caption'] = caption!;
    if (withBorder != null) result['withBorder'] = withBorder!;
    if (withBackground != null) result['withBackground'] = withBackground!;
    if (stretched != null) result['stretched'] = stretched!;
    return result;
  }
}

/// Mô hình cho block Quote
class QuoteBlockData {
  final String text;
  final String? caption;
  final String? alignment;

  QuoteBlockData({
    required this.text,
    this.caption,
    this.alignment,
  });

  factory QuoteBlockData.fromJson(Map<String, dynamic> json) {
    return QuoteBlockData(
      text: json['text'] ?? '',
      caption: json['caption'],
      alignment: json['alignment'],
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{'text': text};
    if (caption != null) result['caption'] = caption!;
    if (alignment != null) result['alignment'] = alignment!;
    return result;
  }
}

/// Mô hình cho block Code
class CodeBlockData {
  final String code;

  CodeBlockData({required this.code});

  factory CodeBlockData.fromJson(Map<String, dynamic> json) {
    return CodeBlockData(code: json['code'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'code': code};
  }
}

/// Mô hình cho block Delimiter
class DelimiterBlockData {
  DelimiterBlockData();

  factory DelimiterBlockData.fromJson(Map<String, dynamic> json) {
    return DelimiterBlockData();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

/// Mô hình cho block Table
class TableBlockData {
  final bool? withHeadings;
  final List<List<String>> content;

  TableBlockData({
    this.withHeadings,
    required this.content,
  });

  factory TableBlockData.fromJson(Map<String, dynamic> json) {
    return TableBlockData(
      withHeadings: json['withHeadings'],
      content: (json['content'] as List<dynamic>?)
              ?.map((row) => (row as List<dynamic>)
                  .map((cell) => cell.toString())
                  .toList())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{'content': content};
    if (withHeadings != null) result['withHeadings'] = withHeadings!;
    return result;
  }
}

/// Mô hình cho block Embed
class EmbedBlockData {
  final String service; // youtube, vimeo, etc.
  final String source; // URL
  final String embed; // embed code
  final int? width;
  final int? height;
  final String? caption;

  EmbedBlockData({
    required this.service,
    required this.source,
    required this.embed,
    this.width,
    this.height,
    this.caption,
  });

  factory EmbedBlockData.fromJson(Map<String, dynamic> json) {
    return EmbedBlockData(
      service: json['service'] ?? '',
      source: json['source'] ?? '',
      embed: json['embed'] ?? '',
      width: json['width'],
      height: json['height'],
      caption: json['caption'],
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'service': service,
      'source': source,
      'embed': embed,
    };
    if (width != null) result['width'] = width!;
    if (height != null) result['height'] = height!;
    if (caption != null) result['caption'] = caption!;
    return result;
  }
}

/// Mô hình cho block Checklist
class ChecklistBlockData {
  final List<ChecklistItem> items;

  ChecklistBlockData({required this.items});

  factory ChecklistBlockData.fromJson(Map<String, dynamic> json) {
    return ChecklistBlockData(
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => ChecklistItem.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class ChecklistItem {
  final String text;
  final bool checked;

  ChecklistItem({required this.text, required this.checked});

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      text: json['text'] ?? '',
      checked: json['checked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'checked': checked,
    };
  }
}

/// Mô hình cho block Warning
class WarningBlockData {
  final String title;
  final String message;

  WarningBlockData({
    required this.title,
    required this.message,
  });

  factory WarningBlockData.fromJson(Map<String, dynamic> json) {
    return WarningBlockData(
      title: json['title'] ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
    };
  }
}

/// Mô hình cho block Raw (HTML)
class RawBlockData {
  final String html;

  RawBlockData({required this.html});

  factory RawBlockData.fromJson(Map<String, dynamic> json) {
    return RawBlockData(html: json['html'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'html': html};
  }
}

/// Mô hình cho block LinkTool
class LinkToolBlockData {
  final String link;
  final LinkMeta meta;

  LinkToolBlockData({
    required this.link,
    required this.meta,
  });

  factory LinkToolBlockData.fromJson(Map<String, dynamic> json) {
    return LinkToolBlockData(
      link: json['link'] ?? '',
      meta: LinkMeta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'link': link,
      'meta': meta.toJson(),
    };
  }
}

class LinkMeta {
  final String? title;
  final String? description;
  final String? image;

  LinkMeta({
    this.title,
    this.description,
    this.image,
  });

  factory LinkMeta.fromJson(Map<String, dynamic> json) {
    return LinkMeta(
      title: json['title'],
      description: json['description'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    if (title != null) result['title'] = title!;
    if (description != null) result['description'] = description!;
    if (image != null) result['image'] = image!;
    return result;
  }
}

/// Mô hình cho block Attaches
class AttachesBlockData {
  final FileData file;
  final String? title;

  AttachesBlockData({
    required this.file,
    this.title,
  });

  factory AttachesBlockData.fromJson(Map<String, dynamic> json) {
    return AttachesBlockData(
      file: FileData.fromJson(json['file'] ?? {}),
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{'file': file.toJson()};
    if (title != null) result['title'] = title!;
    return result;
  }
}

/// Mô hình cho block Video
class VideoBlockData {
  final String url;
  final String? caption;

  VideoBlockData({
    required this.url,
    this.caption,
  });

  factory VideoBlockData.fromJson(Map<String, dynamic> json) {
    return VideoBlockData(
      url: json['url'] ?? '',
      caption: json['caption'],
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{'url': url};
    if (caption != null) result['caption'] = caption!;
    return result;
  }
}

/// Mô hình cho file data
class FileData {
  final String? url;
  final int? size;
  final String? name;
  final String? extension;
  final int? width;
  final int? height;
  final String? title;
  final String? fileId;
  final String? fileURL;

  FileData({
    this.url,
    this.size,
    this.name,
    this.extension,
    this.width,
    this.height,
    this.title,
    this.fileId,
    this.fileURL,
  });

  factory FileData.fromJson(Map<String, dynamic> json) {
    return FileData(
      url: json['url'],
      size: json['size'] is String ? int.tryParse(json['size']) : json['size'],
      name: json['name'],
      extension: json['extension'],
      width: json['width'],
      height: json['height'],
      title: json['title'],
      fileId: json['fileId'],
      fileURL: json['fileURL'],
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    if (url != null) result['url'] = url!;
    if (size != null) result['size'] = size!;
    if (name != null) result['name'] = name!;
    if (extension != null) result['extension'] = extension!;
    if (width != null) result['width'] = width!;
    if (height != null) result['height'] = height!;
    if (title != null) result['title'] = title!;
    if (fileId != null) result['fileId'] = fileId!;
    if (fileURL != null) result['fileURL'] = fileURL!;
    return result;
  }
}

/// Enum cho các loại block được hỗ trợ
enum EditorJSBlockType {
  paragraph('paragraph'),
  header('header'),
  list('list'),
  image('image'),
  quote('quote'),
  code('code'),
  delimiter('delimiter'),
  table('table'),
  embed('embed'),
  linkTool('linkTool'),
  checklist('checklist'),
  warning('warning'),
  raw('raw'),
  attaches('attaches'),
  video('video');

  const EditorJSBlockType(this.value);
  final String value;

  static EditorJSBlockType? fromString(String value) {
    for (EditorJSBlockType type in EditorJSBlockType.values) {
      if (type.value == value) return type;
    }
    return null;
  }
} 