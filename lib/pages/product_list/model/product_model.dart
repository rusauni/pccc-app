class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> images;
  final String category;
  final String subCategory;
  final double? price;
  final String priceDisplay;
  final List<String> tags;
  final int rating;
  final int reviewCount;
  final int soldCount;
  final bool hasReviews;
  final String contactInfo;
  final List<ProductSpecification> specifications;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.images,
    required this.category,
    required this.subCategory,
    this.price,
    required this.priceDisplay,
    required this.tags,
    required this.rating,
    required this.reviewCount,
    required this.soldCount,
    required this.hasReviews,
    required this.contactInfo,
    required this.specifications,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] ?? '',
      subCategory: json['subCategory'] ?? '',
      price: json['price']?.toDouble(),
      priceDisplay: json['priceDisplay'] ?? 'Liên hệ báo giá',
      tags: List<String>.from(json['tags'] ?? []),
      rating: json['rating'] ?? 0,
      reviewCount: json['reviewCount'] ?? 0,
      soldCount: json['soldCount'] ?? 0,
      hasReviews: json['hasReviews'] ?? false,
      contactInfo: json['contactInfo'] ?? '',
      specifications: (json['specifications'] as List<dynamic>?)
          ?.map((e) => ProductSpecification.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'images': images,
      'category': category,
      'subCategory': subCategory,
      'price': price,
      'priceDisplay': priceDisplay,
      'tags': tags,
      'rating': rating,
      'reviewCount': reviewCount,
      'soldCount': soldCount,
      'hasReviews': hasReviews,
      'contactInfo': contactInfo,
      'specifications': specifications.map((e) => e.toJson()).toList(),
    };
  }
}

class ProductSpecification {
  final String name;
  final String value;
  final String unit;

  ProductSpecification({
    required this.name,
    required this.value,
    required this.unit,
  });

  factory ProductSpecification.fromJson(Map<String, dynamic> json) {
    return ProductSpecification(
      name: json['name'] ?? '',
      value: json['value'] ?? '',
      unit: json['unit'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'unit': unit,
    };
  }
} 