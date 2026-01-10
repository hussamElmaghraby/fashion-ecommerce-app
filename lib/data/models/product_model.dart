import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String image;

  @HiveField(6)
  final RatingModel rating;

  @HiveField(7)
  final List<String>? images;

  @HiveField(8)
  final List<String>? sizes;

  @HiveField(9)
  final List<String>? colors;

  @HiveField(10)
  final bool inStock;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    this.images,
    this.sizes,
    this.colors,
    this.inStock = true,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      image: json['image'] ?? '',
      rating: json['rating'] != null
          ? RatingModel.fromJson(json['rating'])
          : RatingModel(rate: 0, count: 0),
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : [json['image'] ?? ''],
      sizes: json['sizes'] != null
          ? List<String>.from(json['sizes'])
          : ['S', 'M', 'L', 'XL'],
      colors: json['colors'] != null
          ? List<String>.from(json['colors'])
          : ['Black', 'White', 'Blue'],
      inStock: json['inStock'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating.toJson(),
      'images': images,
      'sizes': sizes,
      'colors': colors,
      'inStock': inStock,
    };
  }

  ProductModel copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? category,
    String? image,
    RatingModel? rating,
    List<String>? images,
    List<String>? sizes,
    List<String>? colors,
    bool? inStock,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      images: images ?? this.images,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      inStock: inStock ?? this.inStock,
    );
  }
}

@HiveType(typeId: 1)
class RatingModel {
  @HiveField(0)
  final double rate;

  @HiveField(1)
  final int count;

  RatingModel({
    required this.rate,
    required this.count,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      rate: (json['rate'] ?? 0).toDouble(),
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'count': count,
    };
  }
}
