import 'dart:convert';
import 'package:flutter/services.dart';
import '../pages/product_list/model/product_model.dart';

class ProductDataLoader {
  static ProductDataLoader? _instance;
  Map<String, dynamic>? _cachedData;

  ProductDataLoader._internal();

  factory ProductDataLoader() {
    _instance ??= ProductDataLoader._internal();
    return _instance!;
  }

  Future<Map<String, dynamic>> loadJsonData() async {
    if (_cachedData != null) return _cachedData!;

    try {
      final String jsonString = await rootBundle.loadString('assets/data/pccc_products_data.json');
      _cachedData = jsonDecode(jsonString);
      return _cachedData!;
    } catch (e) {
      print('Error loading product data: $e');
      return {};
    }
  }

  Future<List<Product>> getProductsByCategory(String categoryId) async {
    final data = await loadJsonData();
    final categories = data['categories'] as List<dynamic>? ?? [];
    
    // Tìm category theo ID
    final category = categories.firstWhere(
      (cat) => cat['id'] == categoryId,
      orElse: () => null,
    );

    if (category == null) return [];

    final products = category['products'] as List<dynamic>? ?? [];
    
    return products.map<Product>((productJson) => _mapJsonToProduct(productJson)).toList();
  }

  Future<String> getCategoryName(String categoryId) async {
    final data = await loadJsonData();
    final categories = data['categories'] as List<dynamic>? ?? [];
    
    final category = categories.firstWhere(
      (cat) => cat['id'] == categoryId,
      orElse: () => null,
    );

    return category?['name'] ?? 'Sản phẩm';
  }

  Product _mapJsonToProduct(Map<String, dynamic> json) {
    // Map specifications từ JSON object thành List<ProductSpecification>
    final specs = json['specifications'] as Map<String, dynamic>? ?? {};
    final specifications = specs.entries.map((entry) => 
      ProductSpecification(
        name: entry.key,
        value: entry.value.toString(),
        unit: '',
      )
    ).toList();

    // Lấy contact info
    final contactInfo = json['contact_info'] as Map<String, dynamic>? ?? {};
    final phone = contactInfo['phone'] ?? '0901234567';

    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image'] ?? '',
      images: [json['image'] ?? ''], // Chỉ có 1 ảnh chính
      category: json['category_id'] ?? '',
      subCategory: json['type'] ?? '',
      priceDisplay: _formatPrice(json['price']),
      tags: ['Mall', 'Hỗ trợ 24/7', 'Hoàn tiền'],
      rating: 0,
      reviewCount: 0,
      soldCount: 0,
      hasReviews: false,
      contactInfo: phone,
      specifications: specifications,
    );
  }

  String _formatPrice(dynamic price) {
    if (price == null) return 'Liên hệ báo giá';
    
    if (price is String) {
      final priceInt = int.tryParse(price);
      if (priceInt != null) {
        return '${priceInt.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'), 
          (Match m) => '${m[1]}.',
        )} đ';
      }
    }
    
    if (price is int) {
      return '${price.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), 
        (Match m) => '${m[1]}.',
      )} đ';
    }

    return 'Liên hệ báo giá';
  }

  // Map category ID để tương thích với routing hiện tại
  static String mapCategoryIdToDataId(String categoryId) {
    switch (categoryId) {
      case 'fire_extinguisher':
        return 'fe_001';
      case 'fire_alarm':
        return 'fd_001';
      case 'fire_hose':
        return 'hr_001';
      case 'emergency_light':
        return 'el_001';
      case 'fire_pump':
        return 'pw_001';
      default:
        return categoryId;
    }
  }
} 