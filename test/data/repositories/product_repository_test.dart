import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fashion_ecommerce/data/repositories/product_repository.dart';
import 'package:fashion_ecommerce/data/services/api_service.dart';
import 'package:fashion_ecommerce/data/models/product_model.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late ProductRepository repository;
  late MockApiService mockApi;

  setUp(() {
    mockApi = MockApiService();
    repository = ProductRepository(mockApi);
  });

  List<ProductModel> createTestProducts() {
    return [
      ProductModel(
        id: 1,
        title: 'T-Shirt',
        price: 29.99,
        description: 'Cotton t-shirt',
        category: 'clothing',
        image: 'tshirt.jpg',
        rating: RatingModel(rate: 4.5, count: 100),
      ),
      ProductModel(
        id: 2,
        title: 'Laptop',
        price: 999.99,
        description: 'High performance laptop',
        category: 'electronics',
        image: 'laptop.jpg',
        rating: RatingModel(rate: 4.8, count: 250),
      ),
      ProductModel(
        id: 3,
        title: 'Jeans',
        price: 59.99,
        description: 'Slim fit jeans',
        category: 'clothing',
        image: 'jeans.jpg',
        rating: RatingModel(rate: 4.2, count: 80),
      ),
    ];
  }

  group('getProducts', () {
    test('returns list of products', () async {
      final products = createTestProducts();
      when(() => mockApi.getProducts()).thenAnswer((_) async => products);

      final result = await repository.getProducts();

      expect(result.length, 3);
      verify(() => mockApi.getProducts()).called(1);
    });

    test('returns empty list when no products', () async {
      when(() => mockApi.getProducts()).thenAnswer((_) async => []);

      final result = await repository.getProducts();

      expect(result, isEmpty);
    });
  });

  group('getProductById', () {
    test('returns correct product', () async {
      final product = createTestProducts().first;
      when(() => mockApi.getProductById(1)).thenAnswer((_) async => product);

      final result = await repository.getProductById(1);

      expect(result.id, 1);
      expect(result.title, 'T-Shirt');
    });
  });

  group('getProductsByCategory', () {
    test('returns products in category', () async {
      final clothingProducts = createTestProducts()
          .where((p) => p.category == 'clothing')
          .toList();

      when(
        () => mockApi.getProductsByCategory('clothing'),
      ).thenAnswer((_) async => clothingProducts);

      final result = await repository.getProductsByCategory('clothing');

      expect(result.length, 2);
      expect(result.every((p) => p.category == 'clothing'), true);
    });

    test('returns empty list for non-existent category', () async {
      when(
        () => mockApi.getProductsByCategory('nonexistent'),
      ).thenAnswer((_) async => []);

      final result = await repository.getProductsByCategory('nonexistent');

      expect(result, isEmpty);
    });
  });

  group('getCategories', () {
    test('returns list of categories', () async {
      final categories = ['electronics', 'jewelery', 'clothing', 'women'];
      when(() => mockApi.getCategories()).thenAnswer((_) async => categories);

      final result = await repository.getCategories();

      expect(result.length, 4);
      expect(result.contains('electronics'), true);
    });

    test('returns empty list when no categories', () async {
      when(() => mockApi.getCategories()).thenAnswer((_) async => []);

      final result = await repository.getCategories();

      expect(result, isEmpty);
    });
  });

  group('searchProducts', () {
    test('finds products by title', () async {
      final products = createTestProducts();
      when(() => mockApi.getProducts()).thenAnswer((_) async => products);

      final result = await repository.searchProducts('shirt');

      expect(result.length, 1);
      expect(result.first.title, 'T-Shirt');
    });

    test('finds products by description', () async {
      final products = createTestProducts();
      when(() => mockApi.getProducts()).thenAnswer((_) async => products);

      final result = await repository.searchProducts('cotton');

      expect(result.length, 1);
      expect(result.first.title, 'T-Shirt');
    });

    test('finds products by category', () async {
      final products = createTestProducts();
      when(() => mockApi.getProducts()).thenAnswer((_) async => products);

      final result = await repository.searchProducts('clothing');

      expect(result.length, 2);
    });

    test('search is case insensitive', () async {
      final products = createTestProducts();
      when(() => mockApi.getProducts()).thenAnswer((_) async => products);

      final result = await repository.searchProducts('LAPTOP');

      expect(result.length, 1);
      expect(result.first.title, 'Laptop');
    });

    test('returns empty for no matches', () async {
      final products = createTestProducts();
      when(() => mockApi.getProducts()).thenAnswer((_) async => products);

      final result = await repository.searchProducts('xyz123');

      expect(result, isEmpty);
    });

    test('returns multiple matches', () async {
      final products = createTestProducts();
      when(() => mockApi.getProducts()).thenAnswer((_) async => products);

      final result = await repository.searchProducts('fit');

      expect(result.length, 1);
    });
  });
}
