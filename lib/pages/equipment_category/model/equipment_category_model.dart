class EquipmentCategory {
  final String id;
  final String name;
  final String description;
  final String iconData;
  final String color;
  final List<EquipmentSubCategory> subCategories;

  EquipmentCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.iconData,
    required this.color,
    required this.subCategories,
  });

  factory EquipmentCategory.fromJson(Map<String, dynamic> json) {
    return EquipmentCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      iconData: json['iconData'] ?? '',
      color: json['color'] ?? '',
      subCategories: (json['subCategories'] as List<dynamic>?)
          ?.map((e) => EquipmentSubCategory.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconData': iconData,
      'color': color,
      'subCategories': subCategories.map((e) => e.toJson()).toList(),
    };
  }
}

class EquipmentSubCategory {
  final String id;
  final String name;
  final String description;
  final int productCount;

  EquipmentSubCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.productCount,
  });

  factory EquipmentSubCategory.fromJson(Map<String, dynamic> json) {
    return EquipmentSubCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      productCount: json['productCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'productCount': productCount,
    };
  }
} 