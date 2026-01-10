import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fashion_ecommerce/data/repositories/cart_repository.dart';
import 'package:fashion_ecommerce/data/services/storage_service.dart';
import 'package:fashion_ecommerce/data/models/cart_item_model.dart';
import 'package:fashion_ecommerce/data/models/product_model.dart';

class MockStorageService extends Mock implements StorageService {}

void main() {
  late CartRepository repository;
  late MockStorageService mockStorage;

  setUpAll(() {
    registerFallbackValue(
      CartItemModel(
        id: 'fallback',
        product: ProductModel(
          id: 0,
          title: '',
          price: 0,
          description: '',
          category: '',
          image: '',
          rating: RatingModel(rate: 0, count: 0),
        ),
        quantity: 1,
      ),
    );
  });

  setUp(() {
    mockStorage = MockStorageService();
    repository = CartRepository(mockStorage);
  });

  ProductModel createTestProduct({int id = 1, double price = 50.0}) {
    return ProductModel(
      id: id,
      title: 'Test Product $id',
      price: price,
      description: 'Description',
      category: 'category',
      image: 'image.jpg',
      rating: RatingModel(rate: 4.0, count: 10),
    );
  }

  CartItemModel createTestCartItem({
    String id = 'item_1',
    int productId = 1,
    int quantity = 1,
    String? size,
    String? color,
  }) {
    return CartItemModel(
      id: id,
      product: createTestProduct(id: productId),
      quantity: quantity,
      selectedSize: size,
      selectedColor: color,
    );
  }

  group('addToCart', () {
    test('adds new item when cart is empty', () async {
      final item = createTestCartItem();

      when(() => mockStorage.getCartItems()).thenReturn([]);
      when(() => mockStorage.addToCart(item)).thenAnswer((_) async {});

      await repository.addToCart(item);

      verify(() => mockStorage.addToCart(item)).called(1);
    });

    test(
      'adds new item when same product with different size exists',
      () async {
        final existingItem = createTestCartItem(size: 'S');
        final newItem = createTestCartItem(id: 'item_2', size: 'L');

        when(() => mockStorage.getCartItems()).thenReturn([existingItem]);
        when(() => mockStorage.addToCart(newItem)).thenAnswer((_) async {});

        await repository.addToCart(newItem);

        verify(() => mockStorage.addToCart(newItem)).called(1);
        verifyNever(() => mockStorage.updateCartItem(any()));
      },
    );

    test(
      'updates quantity when same product with same options exists',
      () async {
        final existingItem = createTestCartItem(
          quantity: 2,
          size: 'M',
          color: 'Black',
        );
        final newItem = createTestCartItem(
          id: 'item_2',
          quantity: 3,
          size: 'M',
          color: 'Black',
        );

        when(() => mockStorage.getCartItems()).thenReturn([existingItem]);
        when(() => mockStorage.updateCartItem(any())).thenAnswer((_) async {});

        await repository.addToCart(newItem);

        verify(() => mockStorage.updateCartItem(any())).called(1);
        verifyNever(() => mockStorage.addToCart(any()));
      },
    );

    test('adds new item when product color differs', () async {
      final existingItem = createTestCartItem(color: 'Black');
      final newItem = createTestCartItem(id: 'item_2', color: 'White');

      when(() => mockStorage.getCartItems()).thenReturn([existingItem]);
      when(() => mockStorage.addToCart(newItem)).thenAnswer((_) async {});

      await repository.addToCart(newItem);

      verify(() => mockStorage.addToCart(newItem)).called(1);
    });
  });

  group('removeFromCart', () {
    test('removes item by id', () async {
      when(() => mockStorage.removeFromCart('item_1')).thenAnswer((_) async {});

      await repository.removeFromCart('item_1');

      verify(() => mockStorage.removeFromCart('item_1')).called(1);
    });
  });

  group('updateCartItemQuantity', () {
    test('updates quantity for existing item', () async {
      final item = createTestCartItem(quantity: 1);

      when(() => mockStorage.getCartItems()).thenReturn([item]);
      when(() => mockStorage.updateCartItem(any())).thenAnswer((_) async {});

      await repository.updateCartItemQuantity('item_1', 5);

      verify(() => mockStorage.updateCartItem(any())).called(1);
    });
  });

  group('clearCart', () {
    test('clears all items', () async {
      when(() => mockStorage.clearCart()).thenAnswer((_) async {});

      await repository.clearCart();

      verify(() => mockStorage.clearCart()).called(1);
    });
  });

  group('getCartItems', () {
    test('returns empty list when cart is empty', () {
      when(() => mockStorage.getCartItems()).thenReturn([]);

      final items = repository.getCartItems();

      expect(items, isEmpty);
    });

    test('returns all items from storage', () {
      final items = [
        createTestCartItem(id: 'item_1'),
        createTestCartItem(id: 'item_2', productId: 2),
      ];

      when(() => mockStorage.getCartItems()).thenReturn(items);

      final result = repository.getCartItems();

      expect(result.length, 2);
    });
  });

  group('getCartTotal', () {
    test('returns zero for empty cart', () {
      when(() => mockStorage.getCartItems()).thenReturn([]);

      final total = repository.getCartTotal();

      expect(total, 0.0);
    });

    test('calculates total for single item', () {
      final item = createTestCartItem(quantity: 2);

      when(() => mockStorage.getCartItems()).thenReturn([item]);

      final total = repository.getCartTotal();

      expect(total, 100.0);
    });

    test('calculates total for multiple items', () {
      final items = [
        CartItemModel(
          id: 'item_1',
          product: createTestProduct(price: 50.0),
          quantity: 2,
        ),
        CartItemModel(
          id: 'item_2',
          product: createTestProduct(id: 2, price: 30.0),
          quantity: 3,
        ),
      ];

      when(() => mockStorage.getCartItems()).thenReturn(items);

      final total = repository.getCartTotal();

      expect(total, 190.0);
    });
  });

  group('getCartItemCount', () {
    test('returns zero for empty cart', () {
      when(() => mockStorage.getCartItems()).thenReturn([]);

      final count = repository.getCartItemCount();

      expect(count, 0);
    });

    test('returns total quantity across all items', () {
      final items = [
        createTestCartItem(id: 'item_1', quantity: 2),
        createTestCartItem(id: 'item_2', productId: 2, quantity: 3),
      ];

      when(() => mockStorage.getCartItems()).thenReturn(items);

      final count = repository.getCartItemCount();

      expect(count, 5);
    });
  });
}
