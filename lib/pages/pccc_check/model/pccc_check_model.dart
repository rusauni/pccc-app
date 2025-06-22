// Model cho PCCC Check Tool
class PCCCCheckResult {
  final String category;
  final String result;
  final String status; // 'required', 'consider', 'not_required'
  final String reference;

  PCCCCheckResult({
    required this.category,
    required this.result,
    required this.status,
    required this.reference,
  });
}

// Enum cho các loại nhà
enum LoaiNha {
  nhaDan('Nhà dân'),
  chungCu('Chung cư'),
  vanPhong('Văn phòng'),
  thuongMai('Thương mại'),
  sanXuat('Sản xuất'),
  khoThap('Kho tháp'),
  benhVien('Bệnh viện'),
  truongHoc('Trường học'),
  khachSan('Khách sạn'),
  khac('Khác');

  const LoaiNha(this.displayName);
  final String displayName;
}

// Enum cho hạng nguy hiểm cháy
enum HangNguyHiemChay {
  a('A - Ít nguy hiểm'),
  b('B - Trung bình'),
  c('C - Nguy hiểm'),
  d('D - Rất nguy hiểm'),
  e('E - Đặc biệt nguy hiểm');

  const HangNguyHiemChay(this.displayName);
  final String displayName;
}

// Enum cho kết quả phân tích
enum AnalysisStatus {
  required('Bắt buộc', 'required'),
  consider('Cân nhắc', 'consider'), 
  notRequired('Không bắt buộc', 'not_required');

  const AnalysisStatus(this.displayName, this.value);
  final String displayName;
  final String value;
}

// Model cho từng hệ thống kiểm tra
class PCCCSystemCheck {
  final String id;
  final String name;
  final Map<String, dynamic> parameters;
  final PCCCCheckResult? result;

  PCCCSystemCheck({
    required this.id,
    required this.name,
    required this.parameters,
    this.result,
  });

  PCCCSystemCheck copyWith({
    String? id,
    String? name,
    Map<String, dynamic>? parameters,
    PCCCCheckResult? result,
  }) {
    return PCCCSystemCheck(
      id: id ?? this.id,
      name: name ?? this.name,
      parameters: parameters ?? this.parameters,
      result: result ?? this.result,
    );
  }
} 