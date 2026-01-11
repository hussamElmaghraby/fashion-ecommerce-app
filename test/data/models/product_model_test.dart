import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_ecommerce/data/models/product_model.dart';

void main() {
  group('ProductModel', () {
    late Map<String, dynamic> validJson;

    setUp(() {
      validJson = {
        'id': 1,
        'title': 'Test Product',
        'price': 99.99,
        'description': 'Test description',
        'category': 'electronics',
        'image': 'https://example.com/image.jpg',
        'rating': {'rate': 4.5, 'count': 100},
        'images': ['image1.jpg', 'image2.jpg'],
        'sizes': ['S', 'M', 'L'],
        'colors': ['Red', 'Blue'],
        'inStock': true,
      };
    });

    test('creates instance with required fields', () {
      final rating = RatingModel(rate: 4.5, count: 100);
      final product = ProductModel(
        id: 1,
        title: 'Test',
        price: 50.0,
        description: 'Desc',
        category: 'Category',
        image: 'img.jpg',
        rating: rating,
      );

      expect(product.id, 1);
      expect(product.title, 'Test');
      expect(product.price, 50.0);
      expect(product.inStock, true);
    });

    test('fromJson parses valid JSON correctly', () {
      final product = ProductModel.fromJson(validJson);

      expect(product.id, 1);
      expect(product.title, 'Test Product');
      expect(product.price, 99.99);
      expect(product.category, 'electronics');
      expect(product.rating.rate, 4.5);
      expect(product.rating.count, 100);
      expect(product.sizes?.length, 3);
      expect(product.colors?.length, 2);
    });

    test('fromJson handles missing optional fields', () {
      final minimalJson = {
        'id': 1,
        'title': 'Product',
        'price': 10.0,
        'description': 'Desc',
        'category': 'cat',
        'image': 'img.jpg',
      };

      final product = ProductModel.fromJson(minimalJson);

      expect(product.id, 1);
      expect(product.rating.rate, 0);
      expect(product.rating.count, 0);
      expect(product.sizes, ['S', 'M', 'L', 'XL']);
      expect(product.colors, ['Black', 'White', 'Blue']);
      expect(product.inStock, true);
    });

    test('fromJson handles null values gracefully', () {
      final nullJson = <String, dynamic>{};

      final product = ProductModel.fromJson(nullJson);

      expect(product.id, 0);
      expect(product.title, '');
      expect(product.price, 0.0);
      expect(product.description, '');
    });

    test('toJson produces correct output', () {
      final product = ProductModel.fromJson(validJson);
      final json = product.toJson();

      expect(json['id'], 1);
      expect(json['title'], 'Test Product');
      expect(json['price'], 99.99);
      expect(json['rating']['rate'], 4.5);
    });

    test('copyWith creates new instance with updated fields', () {
      final product = ProductModel.fromJson(validJson);
      final updated = product.copyWith(title: 'Updated Title', price: 149.99);

      expect(updated.title, 'Updated Title');
      expect(updated.price, 149.99);
      expect(updated.id, product.id);
      expect(updated.category, product.category);
    });

    test('copyWith preserves original when no changes', () {
      final product = ProductModel.fromJson(validJson);
      final copy = product.copyWith();

      expect(copy.id, product.id);
      expect(copy.title, product.title);
      expect(copy.price, product.price);
    });

    test('price conversion handles int to double', () {
      final json = {...validJson, 'price': 100};
      final product = ProductModel.fromJson(json);

      expect(product.price, 100.0);
      expect(product.price is double, true);
    });
  });

  group('RatingModel', () {
    test('creates instance with required fields', () {
      final rating = RatingModel(rate: 4.5, count: 50);

      expect(rating.rate, 4.5);
      expect(rating.count, 50);
    });

    test('fromJson parses correctly', () {
      final json = {'rate': 3.8, 'count': 200};
      final rating = RatingModel.fromJson(json);

      expect(rating.rate, 3.8);
      expect(rating.count, 200);
    });

    test('fromJson handles null values', () {
      final rating = RatingModel.fromJson({});

      expect(rating.rate, 0.0);
      expect(rating.count, 0);
    });

    test('toJson produces correct output', () {
      final rating = RatingModel(rate: 4.2, count: 75);
      final json = rating.toJson();

      expect(json['rate'], 4.2);
      expect(json['count'], 75);
    });

    test('rate conversion handles int to double', () {
      final json = {'rate': 4, 'count': 10};
      final rating = RatingModel.fromJson(json);

      expect(rating.rate, 4.0);
      expect(rating.rate is double, true);
    });
  });
}
