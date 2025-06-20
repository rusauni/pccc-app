class NewsCategoryModel {
  final String id;
  final String name;
  final String slug;
  final bool isActive;

  NewsCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.isActive = true,
  });

  factory NewsCategoryModel.fromJson(Map<String, dynamic> json) {
    return NewsCategoryModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'is_active': isActive,
    };
  }

  static List<NewsCategoryModel> getDummyCategories() {
    return [
      NewsCategoryModel(id: 'all', name: 'Tất cả', slug: 'all'),
      NewsCategoryModel(id: 'pccc', name: 'PCCC', slug: 'pccc'),
      NewsCategoryModel(id: 'training', name: 'Đào tạo', slug: 'training'),
      NewsCategoryModel(id: 'equipment', name: 'Thiết bị', slug: 'equipment'),
      NewsCategoryModel(id: 'regulation', name: 'Quy định', slug: 'regulation'),
    ];
  }
} 