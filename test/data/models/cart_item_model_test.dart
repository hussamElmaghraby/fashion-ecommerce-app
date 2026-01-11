import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_ecommerce/data/models/cart_item_model.dart';
import 'package:fashion_ecommerce/data/models/product_model.dart';

void main() {
  group('CartItemModel', () {
    late ProductModel testProduct;
    late Map<String, dynamic> validJson;

    setUp(() {
      testProduct = ProductModel(
        id: 1,
        title: 'Test Product',
        price: 50.0,
        description: 'Test description',
        category: 'clothing',
        image: 'test.jpg',
        rating: RatingModel(rate: 4.0, count: 10),
      );

      validJson = {
        'id': 'cart_123',
        'product': {
          'id': 1,
          'title': 'Test Product',
          'price': 50.0,
          'description': 'Test description',
          'category': 'clothing',
          'image': 'test.jpg',
          'rating': {'rate': 4.0, 'count': 10},
        },
        'quantity': 2,
        'selectedSize': 'M',
        'selectedColor': 'Black',
      };
    });

    test('creates instance with required fields', () {
      final item = CartItemModel(
        id: 'cart_1',
        product: testProduct,
        quantity: 1,
      );

      expect(item.id, 'cart_1');
      expect(item.product.id, 1);
      expect(item.quantity, 1);
      expect(item.selectedSize, null);
      expect(item.selectedColor, null);
    });

    test('creates instance with optional fields', () {
      final item = CartItemModel(
        id: 'cart_1',
        product: testProduct,
        quantity: 3,
        selectedSize: 'L',
        selectedColor: 'Red',
      );

      expect(item.selectedSize, 'L');
      expect(item.selectedColor, 'Red');
    });

    test('totalPrice calculates correctly', () {
      final item = CartItemModel(
        id: 'cart_1',
        product: testProduct,
        quantity: 3,
      );

      expect(item.totalPrice, 150.0);
    });

    test('totalPrice returns zero for zero quantity', () {
      final item = CartItemModel(
        id: 'cart_1',
        product: testProduct,
        quantity: 0,
      );

      expect(item.totalPrice, 0.0);
    });

    test('fromJson parses valid JSON correctly', () {
      final item = CartItemModel.fromJson(validJson);

      expect(item.id, 'cart_123');
      expect(item.product.title, 'Test Product');
      expect(item.quantity, 2);
      expect(item.selectedSize, 'M');
      expect(item.selectedColor, 'Black');
    });

    test('fromJson handles missing optional fields', () {
      final minimalJson = {
        'id': 'cart_1',
        'product': {
          'id': 1,
          'title': 'Product',
          'price': 25.0,
          'description': '',
          'category': '',
          'image': '',
        },
        'quantity': 1,
      };

      final item = CartItemModel.fromJson(minimalJson);

      expect(item.selectedSize, null);
      expect(item.selectedColor, null);
    });

    test('toJson produces correct output', () {
      final item = CartItemModel(
        id: 'cart_1',
        product: testProduct,
        quantity: 2,
        selectedSize: 'S',
        selectedColor: 'Blue',
      );
      final json = item.toJson();

      expect(json['id'], 'cart_1');
      expect(json['quantity'], 2);
      expect(json['selectedSize'], 'S');
      expect(json['selectedColor'], 'Blue');
      expect(json['product']['id'], 1);
    });

    test('copyWith creates new instance with updates', () {
      final item = CartItemModel(
        id: 'cart_1',
        product: testProduct,
        quantity: 1,
        selectedSize: 'M',
      );

      final updated = item.copyWith(quantity: 5);

      expect(updated.quantity, 5);
      expect(updated.id, 'cart_1');
      expect(updated.selectedSize, 'M');
    });

    test('copyWith updates multiple fields', () {
      final item = CartItemModel(
        id: 'cart_1',
        product: testProduct,
        quantity: 1,
      );

      final updated = item.copyWith(
        quantity: 10,
        selectedSize: 'XL',
        selectedColor: 'Green',
      );

      expect(updated.quantity, 10);
      expect(updated.selectedSize, 'XL');
      expect(updated.selectedColor, 'Green');
    });

    test('totalPrice updates with quantity change via copyWith', () {
      final item = CartItemModel(
        id: 'cart_1',
        product: testProduct,
        quantity: 1,
      );

      expect(item.totalPrice, 50.0);

      final updated = item.copyWith(quantity: 4);
      expect(updated.totalPrice, 200.0);
    });
  });
}
